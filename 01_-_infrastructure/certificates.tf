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

resource "google_certificate_manager_dns_authorization" "default" {
  project = module.project.project_id
  name    = "domain-dns-auth"
  domain  = var.domain

  labels = {
    "managed-by-terraform" : true
  }
}

resource "google_certificate_manager_certificate" "root_certificate" {
  project     = module.project.project_id
  name        = "root-certificate"
  description = "Certificate with wildcard for domain ${var.domain}"

  managed {
    domains = [var.domain, "*.${var.domain}"]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.default.id
    ]
  }
}

resource "google_certificate_manager_certificate_map" "default" {
  project     = module.project.project_id
  name        = "certificate-map"
  description = "Certificate map for domain ${var.domain}"
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  project      = module.project.project_id
  name         = "certificate-map-domain"
  map          = google_certificate_manager_certificate_map.default.name
  certificates = [google_certificate_manager_certificate.root_certificate.id]
  hostname     = var.domain
}


resource "google_certificate_manager_certificate_map_entry" "wildcard_certificate_map_entry" {
  project      = module.project.project_id
  name         = "wildcard-cert-domain"
  description  = "Certificate map entry for the wildcard domain"
  map          = google_certificate_manager_certificate_map.default.name
  certificates = [google_certificate_manager_certificate.root_certificate.id]
  hostname     = "*.${var.domain}"
}