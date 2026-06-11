#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::kubectl::internal::load::completion {
    # shellcheck source=/dev/null
    source <(kubectl completion zsh)
    # make completion work with kubecolor
    command -v kubecolor >/dev/null 2>&1 && compdef kubecolor=kubectl
}

function devops::kubectl::internal::krew::install {
    message_info "Installing KREW"
    (set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew)
    message_success "Installed KREW"
}

function devops::kubectl::internal::kubecolor::install {
    if ! core::exists kubecolor; then
        brew install hidetatz/tap/kubecolor
    fi
}

function devops::kubectl::internal::krew::load {
    if core::exists kubectl; then
        [ -e "${KREW_ROOT_BIN}" ] && export PATH="${KREW_ROOT_BIN}:${PATH}"
    fi
}

function devops::kubectl::internal::crossplane::install {
    message_info "Installing crossplane"
    curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
    mv crossplane "${DEVOPS_KUBECTL_LOCAL_PATH_BIN}/"
    message_success "Installed crossplane"
}

function devops::kubectl::internal::plugin::install {
    if ! core::exists kubectl-krew; then
        message_warning "it's necessary have krew"
        return
    fi
    message_info "Installing krew plugin ${1}"
    kubectl krew install "${1}"
    message_success "Installed ${1} krew plugin"
}

function devops::kubectl::internal::plugins::install {
    if ! core::exists kubectl-krew; then
        message_warning "it's necessary have krew"
        return
    fi

    if ! core::exists kubectl; then
        message_warning "it's necessary have kubectl"
        return
    fi

    message_info "Installing required krew plugins"

    for plugin in "${KREW_PLUGINS[@]}"; do
        devops::kubectl::internal::plugin::install "${plugin}"
    done
    message_success "Installed required krew plugins"
}

function devops::kubectl::go::internal::packages::install {
    if ! core::exists go; then
        message_warning "${DEVOPS_KUBECTL_MESSAGE_GO_NOT_FOUND}"
        return
    fi

    for package in "${DEVOPS_KUBECTL_GO_PACKAGES[@]}"; do
        goenv::internal::package::install "${package}"
    done

    for package in "${DEVOPS_KUBECTL_GO_INSTALL[@]}"; do
        goenv::internal::package::install "${package}"
    done
}

function devops::kubectl::internal::main::factory {
    devops::kubectl::internal::krew::load

    core::ensure kubectl
    core::ensure helm
    if ! core::exists kubectl-krew; then devops::kubectl::internal::krew::install; fi
    core::ensure kubectx
    if ! core::exists crossplane; then devops::kubectl::internal::crossplane::install; fi
    if ! core::exists kubecolor; then devops::kubectl::internal::kubecolor::install; fi

    devops::kubectl::internal::load::completion
}

devops::kubectl::internal::main::factory
