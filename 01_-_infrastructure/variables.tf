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

variable "create_project" {
  description = "When set to true, a project will be created.  If it's set to false, an existing project will be used.  Use variable `project_name` to pass in the existing project."
  type        = bool
  default     = true
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

variable "project_name" {
  description = "Name of the project.  Will be augmented with a random suffix."
  type        = string
  default     = "mc-gw-tst"
}

variable "subnet_region_one" {
  description = "First region where a GKE cluster will be created."
  type = object({
    name                  = string
    ip_cidr_range         = string
    region                = string
    description           = optional(string, "Terraform managed")
    enable_private_access = optional(bool, true)
    secondary_ip_ranges   = optional(map(string))
  })
  default = {
    name          = "mc-gw-snw-euw1"
    ip_cidr_range = "10.0.0.0/16"
    region        = "europe-west1"
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
    region                = string
    description           = optional(string, "Terraform managed")
    enable_private_access = optional(bool, true)
    secondary_ip_ranges   = optional(map(string))
  })
  default = {
    name          = "mc-gw-snw-euw4"
    ip_cidr_range = "10.5.0.0/16"
    region        = "europe-west4"
    description   = "Subnetwork hosting the GKE cluster in europe-west4"
    secondary_ip_ranges = {
      pod-ip-range = "10.6.0.0/16"
      svc-ip-range = "10.7.0.0/16"
    }
  }
}
