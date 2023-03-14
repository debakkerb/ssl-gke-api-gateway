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

output "location" {
  description = "Location where the cluster is created"
  value       = google_container_cluster.default.location
}

output "name" {
  description = "Name of the cluster"
  value       = google_container_cluster.default.name
}

output "gke_version" {
  description = "Version of the cluster"
  value       = google_container_cluster.default.master_version
}

output "download_credentials_cmd" {
  description = "CLI command to download the cluster's credentials"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.default.name}"
}

output "cluster_id" {
  description = "Cluster ID"
  value       = google_container_cluster.default.id
}
