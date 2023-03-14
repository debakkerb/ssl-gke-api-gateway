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
}

variable "parent_id" {
  description = "ID of the parent.  This can either be a folder or organization and should be specified in the form `folders/FOLDER_ID` or `organizations/[ORGANIZATION_ID]`"
  type        = string
}

variable "project_name" {
  description = "Name of the project.  Will be augmented with a random suffix."
  type        = string
  default     = "mc-gw-tst"
}