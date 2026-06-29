#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# --- Config aliases ---
alias gconf='gcloud config'
alias gprojects='gcloud projects list'

# --- Compute Engine aliases ---
alias gce_instances='gcloud compute instances list'
alias gce_ssh='gcloud compute ssh'
alias gce_describe='gcloud compute instances describe'
alias gce_disks='gcloud compute disks list'
alias gce_disk_describe='gcloud compute disks describe'
alias gce_snapshots='gcloud compute snapshots list'
alias gce_snapshot_create='gcloud compute snapshots create'

# --- GKE aliases ---
alias gke_clusters='gcloud container clusters list'
alias gke_node_pools='gcloud container node-pools list'
alias gke_node_pool_describe='gcloud container node-pools describe'

# --- GKE credentials helper ---
function devops::gcloud::gke::get-credentials {
    if ! core::exists gke-gcloud-auth-plugin; then
        message_warning "gke-gcloud-auth-plugin not found. Run devops::gcloud::components::install first."
        return 1
    fi
    gcloud container clusters get-credentials "$@"
}
