variable "description" {
  type    = string
  default = ""
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}

variable "alias" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "policy" {
  default = ""
}

variable "policy_flavor" {
  default = "default"
}

variable "customer_master_key_spec" {
  default = "SYMMETRIC_DEFAULT"
}

variable "key_usage" {
  default = "ENCRYPT_DECRYPT"
}

variable "multi_region" {
  default = false
}
