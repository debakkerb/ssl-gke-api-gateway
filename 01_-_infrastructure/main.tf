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

module "project" {
  source = "./modules/project"

  billing_account_id = var.billing_account_id
  parent             = var.parent_id
  project_name       = var.project_name
  create_project     = var.create_project

  project_services = [
    "anthos.googleapis.com",
    "artifactregistry.googleapis.com",
    "certificatemanager.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "gkehub.googleapis.com",
    "multiclusteringress.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "trafficdirector.googleapis.com",
  ]
}

resource "local_file" "environment_variables" {
  filename = "../env.sh"
  content = templatefile("${path.module}/templates/env.sh.tpl", {
    PROJECT_ID              = module.project.project_id
    CLUSTER_ONE_NAME        = module.gke_cluster_one.name
    CLUSTER_TWO_NAME        = module.gke_cluster_two.name
    LOCATION_ONE            = var.cluster_one_location
    LOCATION_TWO            = var.cluster_two_location
    IMAGE_NAME              = local.image_name
    CONSUMER_APP_IDENTITY   = google_service_account.consumer_app_identity.email
    ACCOUNTING_APP_IDENTITY = google_service_account.accounting_app_identity.email
    DOMAIN                  = var.domain
    CNAME_RECORD            = google_certificate_manager_dns_authorization.default.dns_resource_record[0].data
  })
}