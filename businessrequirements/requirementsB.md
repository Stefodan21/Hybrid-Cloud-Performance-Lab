🏢 Business Requirements (Azure‑Only Scenario)
Company: Quant trading firm expanding globally.

Workload: Latency‑sensitive trading apps + analytics dashboards.

Requirements:

High Availability (HA) → Multi‑region VNets, Availability Zones, Load Balancers.

Disaster Recovery (DR) → Azure Site Recovery + cross‑region replication.

Observability → Azure Monitor + Log Analytics + Grafana dashboards.

Automation → Terraform + Ansible pipelines for infra + config.

ITIL Service Management → Azure DevOps Boards for incidents, changes, requests.

Collaboration → Clear team ownership via RBAC and tagging (CloudAdmins, ITOps, Dev/Automation, SRE).

🔧 Azure‑Only Architecture Outline
Networking

VNets + subnets for trading workloads.

NSGs for traffic control.

Azure Load Balancer / Application Gateway for HA.

Compute

Linux VMs for trading engines.

VM Scale Sets for elasticity.

Availability Sets/Zones for resilience.

Storage

Managed Disks for VMs.

Blob Storage for Terraform backend + data.

Azure Files for shared storage.

Disaster Recovery

Azure Site Recovery replicating VMs across regions.

Backup Vaults for snapshots.

Monitoring

Azure Monitor + Log Analytics for metrics/logs.

Grafana connected to Azure Monitor for dashboards.

Automation

Terraform for infra provisioning.

Ansible for VM config (kernel/network tuning).

Azure DevOps Pipelines for CI/CD.

📊 Deliverables
Architecture Diagram: VNets + VMs + Load Balancers + Site Recovery + Monitor + DevOps Boards.

GitHub Repo: Terraform configs, Ansible playbooks, monitoring dashboards.

Demo Script: “Terraform deploys infra → Ansible configures VMs → Azure Monitor alert → DevOps ticket created.”

Business Impact Statement: Achieved HA/DR across Azure regions, <15 min failover, ITIL‑aligned incident response, fully Azure‑based.




