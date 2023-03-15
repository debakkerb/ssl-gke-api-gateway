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

variable "billing_account_id" {
  description = "Billing account ID to attach to the project."
  type        = string
  default     = null
}

variable "cluster_one_name" {
  description = "Name of the cluster that will be created in region 1"
  type        = string
  default     = "gke-cluster-zone-one"
}

variable "cluster_one_location" {
  description = "Location where the first cluster should be created"
  type        = string
  default     = "europe-west1-b"
}

variable "cluster_two_location" {
  description = "Location where the second cluster will be created"
  type        = string
  default     = "europe-west4-b"
}

variable "cluster_two_name" {
  description = "Name of the second cluster"
  type        = string
  default     = "gke-cluster-zone-two"
}

variable "create_project" {
  description = "When set to true, a project will be created.  If it's set to false, an existing project will be used.  Use variable `project_name` to pass in the existing project."
  type        = bool
  default     = true
}

variable "domain" {
  description = "Domain that should be used to generate the certificate."
  type        = string
}

variable "network_name" {
  description = "Name of the network where the clusters will be hosted."
  type        = string
  default     = "gke-gw-ssl-nw"
}

variable "network_routing_mode" {
  description = "Routing mode for the network (default set to 'GLOBAL')"
  type        = string
  default     = "GLOBAL"

  validation {
    condition     = var.network_routing_mode == "GLOBAL" || var.network_routing_mode == "REGIONAL"
    error_message = "Routing mode must be either set to GLOBAL or REGIONAL"
  }
}

variable "parent_id" {
  description = "ID of the parent.  This can either be a folder or organization and should be specified in the form `folders/FOLDER_ID` or `organizations/[ORGANIZATION_ID]`"
  type        = string
  default     = null
}

variable "pod_ip_range_name" {
  description = "Common name for Pod IP ranges on the subnets."
  type        = string
  default     = "pod-ip-range"
}

variable "project_name" {
  description = "Name of the project.  Will be augmented with a random suffix."
  type        = string
  default     = "mc-gw-tst"
}

variable "region_one" {
  description = "Region where the first cluster will be created"
  type        = string
  default     = "europe-west1"
}

variable "region_two" {
  description = "Region where the second cluster will be created"
  type        = string
  default     = "europe-west4"
}

variable "service_ip_range_name" {
  description = "Common name for the Service IP ranges on the subnets."
  type        = string
  default     = "svc-ip-range"
}

variable "subnet_region_one" {
  description = "First region where a GKE cluster will be created."
  type = object({
    name                  = string
    ip_cidr_range         = string
    description           = optional(string, "Terraform managed")
    enable_private_access = optional(bool, true)
    secondary_ip_ranges   = optional(map(string))
  })
  default = {
    name          = "mc-gw-snw-euw1"
    ip_cidr_range = "10.0.0.0/16"
    description   = "Subnetwork hosting the GKE cluster in europe-west1"
    secondary_ip_ranges = {
      pod-ip-range = "10.1.0.0/16"
      svc-ip-range = "10.2.0.0/16"
    }
  }
}

variable "subnet_region_two" {
  description = "Second region where a GKE cluster will be created."
  type = object({
    name                  = string
    ip_cidr_range         = string
    description           = optional(string, "Terraform managed")
    enable_private_access = optional(bool, true)
    secondary_ip_ranges   = optional(map(string))
  })
  default = {
    name          = "mc-gw-snw-euw4"
    ip_cidr_range = "10.5.0.0/16"
    description   = "Subnetwork hosting the GKE cluster in europe-west4"
    secondary_ip_ranges = {
      pod-ip-range = "10.6.0.0/16"
      svc-ip-range = "10.7.0.0/16"
    }
  }
}
