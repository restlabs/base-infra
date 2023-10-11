variable "params" {
  type = list(object({
    description = string
    name        = string
    value       = string
  }))
}

variable "tags" {
  type = map(string)
}
