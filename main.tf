provider "google" {
  credentials = file("crafty-centaur-323418-234ce57e133e.json")
  project = "crafty-centaur-323418"
  region = "us-west1"
}
module "gcp_k8s_infra" {
  source = "./modules/k8s_infra"
  subnet_cidr = "10.240.0.0/24"
  pod_cidr = "10.200.0.0/16"
  svc_acct_id = "k8s-svc-acct"
  machine_type = "e2-standard-2"
  image = "ubuntu-os-cloud/ubuntu-2004-lts"
  vm_list = {
              master = { 
                count = 2
                instance_private_ip = "10.240.0.1"
              },
             worker = {
                count = 2
                instance_private_ip = "10.240.0.2"
              }
            }
              
}
