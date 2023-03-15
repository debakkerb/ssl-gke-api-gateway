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

resource "google_compute_network" "default" {
  project                 = module.project.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.network_routing_mode
}

resource "google_compute_subnetwork" "subnet_region_one" {
  project                  = module.project.project_id
  name                     = var.subnet_region_one.name
  network                  = google_compute_network.default.self_link
  ip_cidr_range            = var.subnet_region_one.ip_cidr_range
  region                   = var.subnet_region_one.region
  private_ip_google_access = var.subnet_region_one.enable_private_access

  secondary_ip_range = var.subnet_region_one.secondary_ip_ranges == null ? [] : [
    for name, range in var.subnet_region_one.secondary_ip_ranges :
    { range_name = name, ip_cidr_range = range }
  ]
}

resource "google_compute_subnetwork" "subnet_region_two" {
  project                  = module.project.project_id
  name                     = var.subnet_region_two.name
  network                  = google_compute_network.default.self_link
  ip_cidr_range            = var.subnet_region_two.ip_cidr_range
  region                   = var.subnet_region_two.region
  private_ip_google_access = var.subnet_region_two.enable_private_access

  secondary_ip_range = var.subnet_region_two.secondary_ip_ranges == null ? [] : [
    for name, range in var.subnet_region_two.secondary_ip_ranges :
    { range_name = name, ip_cidr_range = range }
  ]
}
