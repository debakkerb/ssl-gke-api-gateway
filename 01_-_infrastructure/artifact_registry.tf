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

resource "google_artifact_registry_repository" "default" {
  project       = module.project.project_id
  repository_id = var.artifact_registry_repository_id
  format        = "DOCKER"
  description   = "Registry where the application container image will be stored"
  location      = var.artifact_registry_location
}

resource "google_artifact_registry_repository_iam_member" "gke_operator_registry_access" {
  for_each = toset([
    google_service_account.cluster_one_operator.email,
    google_service_account.cluster_two_operator.email
  ])

  project    = module.project.project_id
  member     = "serviceAccount:${each.value}"
  repository = google_artifact_registry_repository.default.name
  role       = "roles/artifactregistry.reader"
  location   = var.artifact_registry_location
}

resource "local_file" "env_rc_file" {
  filename = "../02_-_app/.envrc"

  content = templatefile("${path.module}/templates/.envrc.tpl", {
    IMAGE_NAME = "${var.artifact_registry_location}-docker.pkg.dev/${module.project.project_id}/${google_artifact_registry_repository.default.name}/demo-app"
  })
}