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

locals {
  cluster_version = (
    var.cluster_version == null ?
    data.google_container_engine_versions.default.0.release_channel_default_version[var.release_channel] :
    var.cluster_version
  )
}

data "google_container_engine_versions" "default" {
  count          = var.cluster_version == null ? 1 : 0
  provider       = google-beta
  project        = var.project_id
  location       = var.location
  version_prefix = var.version_prefix
}

resource "google_container_cluster" "default" {
  provider                 = google-beta
  project                  = var.project_id
  name                     = var.name
  description              = var.description
  location                 = var.location
  network                  = var.network_selflink
  subnetwork               = var.subnetwork_selflink
  remove_default_node_pool = true
  initial_node_count       = 1
  min_master_version       = local.cluster_version

  release_channel {
    channel = var.release_channel
  }

  dynamic "gateway_api_config" {
    for_each = var.enable_gateway_api ? [""] : []
    content {
      channel = "CHANNEL_STANDARD"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_ip_range
    services_secondary_range_name = var.svc_ip_range
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.private_cluster_config.enable_private_endpoint ? [""] : []
    content {
      gcp_public_cidrs_access_enabled = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = var.private_cluster_config.enable_private_nodes
    enable_private_endpoint = var.private_cluster_config.enable_private_endpoint
    master_ipv4_cidr_block  = var.private_cluster_config.master_ipv4_cidr_block
  }

  node_config {
    service_account = var.cluster_operator_service_account
    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring"
    ]
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  timeouts {
    create = "45m"
    update = "45m"
  }

}

resource "google_container_node_pool" "non_sandbox_pool" {
  count      = var.enable_sandbox ? 1 : 0
  provider   = google-beta
  project    = var.project_id
  name       = "non-sandboxed-nodes"
  cluster    = google_container_cluster.default.name
  location   = var.location
  node_count = 1
  version    = google_container_cluster.default.master_version

  node_config {
    image_type      = "cos_containerd"
    machine_type    = "e2-standard-4"
    disk_size_gb    = 50
    disk_type       = "pd-ssd"
    service_account = var.cluster_operator_service_account
    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring"
    ]
  }

  timeouts {
    create = "45m"
    update = "45m"
  }
}
