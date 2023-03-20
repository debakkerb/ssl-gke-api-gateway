package main

import (
	"net/http"
	"os"
)

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

func (app *application) appInformation(w http.ResponseWriter, r *http.Request) {
	namespace := os.Getenv("NAMESPACE")
	cluster := os.Getenv("CLUSTER")
	deployedRegion := os.Getenv("REGION")
	targetAudience := os.Getenv("AUDIENCE")

	env := envelope{
		"namespace": namespace,
		"cluster":   cluster,
		"region":    deployedRegion,
		"audience":  targetAudience,
	}

	err := app.writeJSON(w, http.StatusOK, env, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}
