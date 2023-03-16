# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export PROJECT_ID=${PROJECT_ID}
export CLUSTER_ONE_NAME=${CLUSTER_ONE_NAME}
export CLUSTER_TWO_NAME=${CLUSTER_TWO_NAME}
export LOCATION_ONE=${LOCATION_ONE}
export LOCATION_TWO=${LOCATION_TWO}
export IMAGE_NAME=${IMAGE_NAME}
export CONSUMER_APP_IDENTITY=${CONSUMER_APP_IDENTITY}
export ACCOUNTING_APP_IDENTITY=${ACCOUNTING_APP_IDENTITY}
export IMAGE_TAG=$(git describe --always --dirty)