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
  description = "Billing account ID attached to the project."
  type        = string
}

variable "create_project" {
  description = "Either use an existing project, or create a brand new project.  When using an existing project, use the variable `project_name` to pass in the project ID."
  type        = bool
  default     = true
}

variable "parent" {
  description = "Parent for the project.  Should be formed as folders/ or organizations/"
  type        = string
}

variable "project_labels" {
  description = "Labels to attach to the project"
  type        = map(string)
  default     = null
}

variable "project_name" {
  description = "Name for the project.  A unique ID will be added to the project_id as a suffix."
  type        = string
}

variable "project_services" {
  description = "APIs to enable on the project"
  type        = set(string)
  default     = []
}
