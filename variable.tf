variable "public_key_file" {
  type        = string
  default     = "/home/ubuntu/.ssh/id_rsa.pub"
}

variable "master_instance_type"{
  type        = string
  default     = "t2.medium"
}

variable "worker_instance_type"{
  type        = string
  default     = "t2.micro"
}
