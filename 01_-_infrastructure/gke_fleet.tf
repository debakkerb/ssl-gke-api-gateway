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

resource "google_gke_hub_membership" "cluster_one" {
  provider      = google-beta
  project       = module.project.project_id
  membership_id = "cluster-one-member"

  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke_cluster_one.cluster_id}"
    }
  }
}

resource "google_gke_hub_membership" "cluster_two" {
  provider      = google-beta
  membership_id = "cluster-two-member"
  project       = module.project.project_id

  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke_cluster_two.cluster_id}"
    }
  }
}

/*
  Multi-cluster ingress has to be enabled on the config-cluster.  In this demo, we chose our first cluster
  as the config cluster
*/
resource "google_gke_hub_feature" "multi_cluster_ingress" {
  provider = google-beta
  project  = module.project.project_id
  name     = "multiclusteringress"
  location = "global"

  spec {
    multiclusteringress {
      config_membership = google_gke_hub_membership.cluster_one.id
    }
  }
}

resource "google_gke_hub_feature" "multi_cluster_service" {
  provider = google-beta
  project  = module.project.project_id
  location = "global"
  name     = "multiclusterservicediscovery"
}

resource "google_project_iam_binding" "multi_cluster_network_viewer" {
  members = [
    "serviceAccount:${module.project.project_id}.svc.id.goog[gke-mcs/gke-mcs-importer]"
  ]
  project = module.project.project_id
  role    = "roles/compute.networkViewer"

  depends_on = [
    google_gke_hub_membership.cluster_one,
    google_gke_hub_membership.cluster_two,
    google_gke_hub_feature.multi_cluster_ingress,
    google_gke_hub_feature.multi_cluster_service,
  ]
}

resource "google_project_iam_binding" "gateway_admin_permissions" {
  members = [
    "serviceAccount:service-${module.project.project_number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com"
  ]
  project = module.project.project_id
  role    = "roles/container.admin"

  depends_on = [
    google_gke_hub_membership.cluster_one,
    google_gke_hub_membership.cluster_two,
    google_gke_hub_feature.multi_cluster_ingress,
    google_gke_hub_feature.multi_cluster_service,
  ]
}