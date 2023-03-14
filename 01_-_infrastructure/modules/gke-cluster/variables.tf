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
  description = "Project ID where the cluster should be created"
  type        = string
}

variable "version_prefix" {
  description = "Prefix of the cluster version"
  type        = string
  default     = null
}

variable "release_channel" {
  description = "Release channel to be used for the cluster"
  type        = string
  default     = "STABLE"
}

variable "name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "channel" {
  description = "Channel to use for updates"
  type        = string
  default     = "STABLE"
}

variable "description" {
  description = "Description of the GKE cluster"
  type        = string
  default     = "GKE Cluster"
}

variable "location" {
  description = "Where to create the cluster.  Passing in a region will create a regional cluster, a zone will create a zonal cluster"
  type        = string
  default     = "europe-west1"
}

variable "network_selflink" {
  description = "Selflink of the network where the cluster should be created"
  type        = string
}

variable "subnetwork_selflink" {
  description = "Selflink of the subnet where the clusters should run"
  type        = string
}

variable "pod_ip_range" {
  description = "IP range for the Pods"
  type        = string
}

variable "svc_ip_range" {
  description = "IP range of the Services"
  type        = string
}

variable "cluster_operator_service_account" {
  description = "Service account that will be attached to the cluster"
  type        = string
}

variable "enable_gateway_api" {
  description = "Enable Gateway API on the cluster"
  type        = bool
  default     = false
}

variable "enable_sandbox" {
  description = "Enable sandbox mode on the cluster.  This requires a nodepool where Sandbox is not enabled, to be able to schedule all pods"
  type        = bool
  default     = true
}

variable "cluster_version" {
  description = "What cluster version to use"
  type        = string
  default     = null
}

variable "private_cluster_config" {
  description = "Configuration for private clusters"
  type        = object({
    enable_private_nodes    = optional(bool, true)
    enable_private_endpoint = optional(bool, false)
    master_ipv4_cidr_block  = string
  })
  default = {
    master_ipv4_cidr_block = "10.255.0.0/28"
  }
}
