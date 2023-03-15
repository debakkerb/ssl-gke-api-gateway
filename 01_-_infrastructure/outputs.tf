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

output "certificate_cname_data" {
  value = google_certificate_manager_dns_authorization.default.dns_resource_record[0].data
}

output "certificate_status" {
  value = "gcloud certificate-manager certificates describe ${google_certificate_manager_certificate.root_certificate.name} --project ${module.project.project_id}"
}

output "cluster_one_credentials" {
  value = "gcloud container clusters get-credentials ${module.gke_cluster_one.name} --zone ${var.cluster_one_location} --project ${module.project.project_id}"
}

output "cluster_one_location" {
  value = var.cluster_one_location
}

output "cluster_one_name" {
  value = var.cluster_one_name
}

output "cluster_two_credentials" {
  value = "gcloud container clusters get-credentials ${module.gke_cluster_two.name} --zone ${var.cluster_two_location} --project ${module.project.project_id}"
}

output "cluster_two_location" {
  value = var.cluster_two_location
}

output "cluster_two_name" {
  value = var.cluster_two_name
}

output "project_id" {
  value = module.project.project_id
}

output "project_name" {
  value = module.project.project_name
}

output "project_number" {
  value = module.project.project_number
}
