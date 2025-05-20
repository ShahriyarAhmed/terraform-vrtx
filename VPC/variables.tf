variable "name" {
  default = "n8n-vpc"
}

variable "private_subnet" {
    default= "n8n-vpc-subnet"
}

variable "private_subnet_ip_cidr_range" {
    default = "10.0.1.0/24"
}

variable region {
    default="us-west1"
}