variable "organization" {
  type    = string
  default = "ender-corp"
}

variable "HCP_CLIENT_ID" {
  type    = string
  sensitive = true
}

variable "HCP_CLIENT_SECRET" {
  type    = string
  sensitive = true
}