resource "google_compute_network" "k8s_network" {
  name = "k8s-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s_subnetwork" {
  name = "k8s-subnetwork"
  ip_cidr_range = var.subnet_cidr
  network = google_compute_network.k8s_network.id
}

resource "google_compute_firewall" "k8s_firewall_allow_internal" {
  name    = "k8s-firewall-allow-internal"
  network = google_compute_network.k8s_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }

  source_ranges = [var.subnet_cidr,var.pod_cidr]
}

resource "google_compute_firewall" "k8s_firewall_allow_external" {
  name    = "k8s-firewall-allow-external"
  network = google_compute_network.k8s_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22","6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

data "google_service_account" "myaccount" {
  account_id = var.svc_acct_id
}

locals {
    vm-list = flatten([
    for node, node_param in var.vm_list : [
      for i in range(node_param.count) : {
        name = "${node}-${i}" 
        ip = "${node_param.instance_private_ip}${i}"
      }
    ]

  ])


 }

resource "google_compute_instance" "default" {
  for_each = { for item in local.vm-list: item.name => item.ip }
  name         = "${each.key}"
  machine_type = var.machine_type
  zone         = "us-west1-a"
  can_ip_forward = true

  tags = ["k8s-network",split("-","${each.key}")[0]]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.k8s_subnetwork.self_link
    network_ip = "${each.value}"

  }

  service_account {
    email  = data.google_service_account.myaccount.email
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
}
