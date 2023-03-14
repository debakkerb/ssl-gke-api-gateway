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
  parent_type = var.parent == null ? null : split("/", var.parent)[0]
  parent_id   = var.parent == null ? null : split("/", var.parent)[1]
}

resource "random_id" "default" {
  byte_length = 2
}

resource "google_project" "default" {
  org_id              = local.parent_type == "organizations" ? local.parent_id : null
  folder_id           = local.parent_type == "folders" ? local.parent_id : null
  name                = var.project_name
  project_id          = format("%s-%-s", var.project_name, random_id.default.hex)
  billing_account     = var.billing_account_id
  auto_create_network = false
}

resource "google_project_service" "default" {
  for_each                   = var.project_services
  project                    = google_project.default.project_id
  service                    = each.value
  disable_on_destroy         = true
  disable_dependent_services = true
}

resource "google_compute_shared_vpc_host_project" "default" {
  provider   = google-beta
  count      = var.is_vpc_host_project ? 1 : 0
  project    = google_project.default.project_id
  depends_on = [google_project_service.default]
}

resource "google_compute_shared_vpc_service_project" "default" {
  provider        = google-beta
  count           = var.is_vpc_service_project ? 1 : 0
  service_project = google_project.default.project_id
  host_project    = var.host_vpc_project_id
  depends_on      = [google_project_service.default]
}
