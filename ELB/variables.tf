variable "ami" {
  default = "ami-01dee7de9d47a3d45"
}

variable "public_subnet_ids" {
  default = {
    "ap-northeast-1a" = "subnet-08b587c3a9022a179"
    "ap-northeast-1c" = "subnet-042d88b6cc4d215e2"
  }
}

variable "security_group_web" {
  default = "sg-093901660bd0d9e94"
}