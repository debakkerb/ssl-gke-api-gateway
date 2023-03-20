/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_service_account" "cluster_one_operator" {
  project     = module.project.project_id
  account_id  = "cluster-one-operator"
  description = "Service account attached to the first GKE cluster."
}

resource "google_service_account" "cluster_two_operator" {
  project     = module.project.project_id
  account_id  = "cluster-two-operator"
  description = "Service account attached to the second GKE cluster"
}

resource "google_service_account" "consumer_app_identity" {
  project     = module.project.project_id
  account_id  = "consumer-app-id"
  description = "Service account used by the Consumer deployments on GKE, via Workload Identity"
}

resource "google_service_account" "accounting_app_identity" {
  project     = module.project.project_id
  account_id  = "accounting-app-id"
  description = "Service account used by the Accounting deployments on GKE, via Workload Identity"
}

module "gke_cluster_one" {
  source = "./modules/gke-cluster"

  project_id                       = module.project.project_id
  name                             = var.cluster_one_name
  network_selflink                 = google_compute_network.default.self_link
  subnetwork_selflink              = google_compute_subnetwork.subnet_region_one.self_link
  pod_ip_range                     = var.pod_ip_range_name
  svc_ip_range                     = var.service_ip_range_name
  cluster_operator_service_account = google_service_account.cluster_one_operator.email
  location                         = var.cluster_one_location
  enable_gateway_api               = true
  enable_sandbox                   = false
}

module "gke_cluster_one_nodepool" {
  source       = "./modules/gke-nodepool"
  project_id   = module.project.project_id
  cluster_name = module.gke_cluster_one.name
  gke_version  = module.gke_cluster_one.gke_version
  location     = var.cluster_one_location
  name         = "${var.cluster_one_name}-nodes"

  node_config = {
    service_account = google_service_account.cluster_one_operator.email
    machine_type    = "n2-standard-8"
    enable_sandbox  = false
  }
}

module "gke_cluster_two" {
  source = "./modules/gke-cluster"

  project_id                       = module.project.project_id
  name                             = var.cluster_two_name
  network_selflink                 = google_compute_network.default.self_link
  subnetwork_selflink              = google_compute_subnetwork.subnet_region_two.self_link
  pod_ip_range                     = var.pod_ip_range_name
  svc_ip_range                     = var.service_ip_range_name
  cluster_operator_service_account = google_service_account.cluster_two_operator.email
  location                         = var.cluster_two_location
  enable_gateway_api               = true
  enable_sandbox                   = false

  private_cluster_config = {
    master_ipv4_cidr_block = "10.255.1.0/28"
  }
}

module "gke_cluster_two_node_pool" {
  source = "./modules/gke-nodepool"

  project_id   = module.project.project_id
  name         = "${module.gke_cluster_two.name}-nodes"
  cluster_name = module.gke_cluster_two.name
  gke_version  = module.gke_cluster_two.gke_version
  location     = var.cluster_two_location

  node_config = {
    service_account = google_service_account.cluster_two_operator.email
    machine_type    = "n2-standard-8"
    enable_sandbox  = false
  }
}