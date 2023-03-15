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

output "deployment_id" {
  description = "Unique suffix added to the project ID."
  value       = var.create_project ? random_id.default.0.hex : ""
}

output "project_id" {
  description = "Project ID"
  value       = local.project.project_id
  depends_on  = [
    google_project_service.default
  ]
}

output "project_name" {
  description = "Project name"
  value       = local.project.name
  depends_on  = [
    google_project_service.default
  ]
}

output "project_number" {
  description = "Project number"
  value       = local.project.number
  depends_on  = [
    google_project_service.default
  ]
}
