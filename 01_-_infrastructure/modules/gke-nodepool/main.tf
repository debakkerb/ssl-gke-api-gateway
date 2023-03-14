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

resource "google_container_node_pool" "default" {
  provider   = google-beta
  project    = var.project_id
  name       = var.name
  cluster    = var.cluster_name
  location   = var.location
  node_count = var.node_count
  version    = var.gke_version

  node_config {
    image_type      = var.node_config.image_type
    machine_type    = var.node_config.machine_type
    disk_size_gb    = var.node_config.disk_size_gb
    disk_type       = var.node_config.disk_type
    service_account = var.node_config.service_account
    tags            = var.tags
    taint           = var.taints

    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring"
    ]

    dynamic "sandbox_config" {
      for_each = var.node_config.enable_sandbox ? [""] : []
      content {
        sandbox_type = "gvisor"
      }
    }

    dynamic "shielded_instance_config" {
      for_each = var.node_config.shielded_instance_config != null ? [""] : []
      content {
        enable_secure_boot          = var.node_config.shielded_instance_config.enable_secure_boot
        enable_integrity_monitoring = var.node_config.shielded_instance_config.enable_integrity_monitoring
      }
    }
  }

  timeouts {
    create = "45m"
    update = "45m"
  }
}
