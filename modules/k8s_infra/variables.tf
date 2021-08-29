variable "subnet_cidr" {
    description = "GCP Subnet CIDR range"
    type = string
}

variable "pod_cidr" {
    description = "POD CIDR range"
    type = string
}
variable "svc_acct_id" {
    description = "Service Account id"
    type = string
}
variable "machine_type" {
    description = "GCP Machine Type"
    type = string
}
variable "image" {
    description = "GCP image=project/family"
    type = string
}
variable "tags" {
    description = "VM Tags"
    type = list(string)
}
variable "vm_list" {
    description = "VM Details"
    type = map(object({
       count = number
       instance_private_ip = string
}))
}

