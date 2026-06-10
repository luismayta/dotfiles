#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::kubectl::install {
    devops::kubectl::internal::main::factory
}

function devops::kubectl::plugins::install {
    devops::kubectl::internal::plugins::install
}

function devops::kubectl::plugin::install {
    devops::kubectl::internal::plugin::install "${@}"
}

function devops::kubectl::after::install {
    devops::kubectl::plugins::install
    devops::kubectl::go::packages::install
}

function devops::kubectl::go::packages::install {
    devops::kubectl::go::internal::packages::install
}

function devops::kubectl::go::package::install {
    Goenv::internal::package::install "${@}"
}

# Kubectl aliases
alias k='kubecolor'

alias kubectl="kubecolor"

# Utility
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kucx='kubectl config use-context'
alias kgcx='kubectl config get-contexts'
alias kscn='kubectl config set-context --current --namespace'

# Pods
alias kgp='kubectl get pods'
alias kdp='kubectl describe pods'

# Deployments
alias kgd="kubectl get deployment"
alias kdd="kubectl describe deployment"

# Service
alias kgs="kubectl get service"
alias kds="kubectl describe service"

# Ingress
alias kgi="kubectl get ingress"
alias kdi="kubectl describe ingress"

# Apply
alias ka="kubectl apply -f"

# Logs
alias kl="kubectl logs"
alias klf="kubectl logs -f"
