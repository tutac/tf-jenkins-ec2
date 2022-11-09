variable "vpc_cidr" {
    default = "172.16.0.0/16"
}
variable "az-a" {
    default = "us-east-1a"
}
variable "az-b" {
    default = "us-east-1b"
}
variable "az-c" {
    default = "us-east-1c"
}
variable "public-subnet-cidr-a" {
    default = "172.16.0.0/24"
 }
# variable "public-subnet-cidr-b" {
#     default = "The cidr range for public subnet b"
# }
# variable "public-subnet-cidr-c" {
#     default = "The cidr range for public subnet c"
# }
variable "private-subnet-cidr-a" {
    default =  "172.16.3.0/24"
}
# variable "private-subnet-cidr-b" {
#     default = "The cidr range for private subnet b"
# }
# variable "private-subnet-cidr-c" {
#     default = "The cidr range for private subnet c"
# }
variable "env" {
    default = "hasan-test"
}