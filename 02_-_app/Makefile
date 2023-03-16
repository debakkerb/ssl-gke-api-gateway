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

include ./.envrc

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

.PHONY: run/app
run/app:
	go run ./cmd/demo

# ==================================================================================== #
# BUILD
# ==================================================================================== #

current_time := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
git_description := $(shell git describe --always --dirty)
linker_flags := '-s -X main.buildTime=${current_time} -X main.version=${git_description}'

.PHONY: build/app
build/app:
	@echo 'Building app ...'
	go build -ldflags=${linker_flags} -o=./bin/app ./cmd/demo
	GOOS=linux GOARCH=amd64 go build -ldflags=${linker_flags} -o=./bin/linux_amd64/app ./cmd/demo

PHONY: build/docker
build/docker:
	@echo 'Building app container ...'
	docker build --platform linux/amd64 -t ${IMAGE_NAME}:${git_description} ./ && docker push ${IMAGE_NAME}:${git_description}
	@echo 'New container image created, with image name ${IMAGE_NAME} and tag ${git_description}'

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

.PHONY: vendor
vendor:
	@echo 'Tidying and verifying module dependencies ...'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies ...'
	go mod vendor