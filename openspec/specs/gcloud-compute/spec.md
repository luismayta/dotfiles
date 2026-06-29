## ADDED Requirements

### Requirement: Compute Engine instance aliases
The module SHALL define aliases for listing, describing, and SSH-ing into Compute Engine instances.

#### Scenario: List instances
- **WHEN** the module loads
- **THEN** `gce_instances` SHALL expand to `gcloud compute instances list`

#### Scenario: SSH into instance
- **WHEN** the module loads
- **THEN** `gce_ssh <name>` SHALL expand to `gcloud compute ssh <name>`

#### Scenario: Describe instance
- **WHEN** the module loads
- **THEN** `gce_describe <name>` SHALL expand to `gcloud compute instances describe <name>`

### Requirement: Compute Engine disk aliases
The module SHALL define aliases for listing and describing persistent disks.

#### Scenario: List disks
- **WHEN** the module loads
- **THEN** `gce_disks` SHALL expand to `gcloud compute disks list`

#### Scenario: Describe disk
- **WHEN** the module loads
- **THEN** `gce_disk_describe <name>` SHALL expand to `gcloud compute disks describe <name>`

### Requirement: Compute Engine snapshot aliases
The module SHALL define aliases for listing and creating disk snapshots.

#### Scenario: List snapshots
- **WHEN** the module loads
- **THEN** `gce_snapshots` SHALL expand to `gcloud compute snapshots list`

#### Scenario: Create snapshot
- **WHEN** the module loads
- **THEN** `gce_snapshot_create <disk>` SHALL expand to `gcloud compute snapshots create --source-disk <disk>`
