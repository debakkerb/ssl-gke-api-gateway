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

variable "project_id" {
  description = "Project ID where the nodepool should be created"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster where the nodepool should be attached to"
  type        = string
}

variable "name" {
  description = "Name of the nodepool"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the Nodepool"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "location" {
  description = "Location where the nodepool should be created"
  type        = string
}

variable "node_count" {
  description = "Number of nodes that should be created in the nodepool"
  type        = number
  default     = 1
}

variable "gke_version" {
  description = "Version of the GKE cluster"
  type        = string
}

variable "node_config" {
  description = "Configuration of the nodes in the nodepool"
  type = object({
    disk_size_gb    = optional(number, 50)
    disk_type       = optional(string, "pd-ssd")
    image_type      = optional(string, "cos_containerd")
    machine_type    = optional(string, "e2-standard-4")
    service_account = string
    enable_sandbox  = optional(bool, true)
    shielded_instance_config = optional(object({
      enable_integrity_monitoring = optional(bool, false)
      enable_secure_boot          = optional(bool, false)
    }))
  })
}

variable "tags" {
  description = "Network tags applied to nodes"
  type        = list(string)
  default     = null
}

variable "taints" {
  description = "Kubernetes taints to apply to all nodes in the nodepool"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = null
}

