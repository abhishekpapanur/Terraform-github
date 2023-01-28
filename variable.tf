# --- root/variable.tf

variable "aws_region" {
  default = "us-east-1"
}

variable "access_ip" {
  type = string
}

# ----- database variable  ----

variable "dbname" {
  type = string
}

variable "dbuser" {
  type      = string
  sensitive = "true"
}

variable "dbpassword" {
  type      = string
  sensitive = "true"
}

variable "key_name" {
  type      = string
  sensitive = "true"
  default = "TF_key"
}