variable "chart" {
  description = "chart name"
  type        = string
}

variable "chart_version" {
  description = "chart version"
  type        = string
}

variable "create_namespace" {
  description = "creates namespace if it doesn't exist"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "namespace"
  type        = string
}

variable "release_name" {
  description = "Release name or helm chart project name"
  type        = string
}

variable "repository" {
  description = "repository url"
  type        = string
}

variable "timeout" {
  description = "timout for the helm install"
  type        = number
}

variable "values_map" {
  description = "values to be passed into the chart"
  type        = object({any = any})
}
