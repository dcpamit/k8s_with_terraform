output "subnetwork_self_link" {
    description = "self_link of the subnetwork"
    value = google_compute_subnetwork.k8s_subnetwork.self_link
}
