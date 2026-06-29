## ADDED Requirements

### Requirement: GKE cluster listing alias
The module SHALL define an alias for listing GKE clusters.

#### Scenario: List clusters
- **WHEN** the module loads
- **THEN** `gke_clusters` SHALL expand to `gcloud container clusters list`

### Requirement: GKE cluster credentials helper
The module SHALL define a function `devops::gcloud::gke::get-credentials` that wraps `gcloud container clusters get-credentials` with a check for the `gke-gcloud-auth-plugin` component.

#### Scenario: Get credentials with plugin available
- **WHEN** `devops::gcloud::gke::get-credentials <cluster> --region <region>` is called AND `gke-gcloud-auth-plugin` is installed
- **THEN** `gcloud container clusters get-credentials <cluster> --region <region>` SHALL be executed

#### Scenario: Get credentials without plugin
- **WHEN** `devops::gcloud::gke::get-credentials` is called AND `gke-gcloud-auth-plugin` is NOT installed
- **THEN** a warning message SHALL be displayed instructing the user to run `devops::gcloud::components::install`

### Requirement: GKE node pool aliases
The module SHALL define aliases for listing and describing node pools.

#### Scenario: List node pools
- **WHEN** the module loads
- **THEN** `gke_node_pools <cluster>` SHALL expand to `gcloud container node-pools list --cluster <cluster>`

#### Scenario: Describe node pool
- **WHEN** the module loads
- **THEN** `gke_node_pool_describe <cluster> <pool>` SHALL expand to `gcloud container node-pools describe <pool> --cluster <cluster>`
