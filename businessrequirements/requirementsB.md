# Business Requirements – Azure‑Only Hybrid Cloud Lab

## Company Context
Quant trading firm expanding globally with latency‑sensitive trading applications and analytics dashboards.

---

## Core Requirements
- **High Availability (HA)**  
  Multi‑region VNets, Availability Zones, Load Balancers.

- **Disaster Recovery (DR)**  
  Azure Site Recovery + cross‑region replication.

- **Observability**  
  Azure Monitor + Log Analytics + Grafana dashboards.

- **Automation**  
  Terraform + Ansible pipelines for infrastructure and configuration.

- **ITIL Service Management**  
  Azure DevOps Boards for incidents, changes, and requests.

- **Collaboration & Governance**  
  Clear team ownership via RBAC and tagging:
  - `Owner = CloudAdmins` → resource groups, governance, billing.
  - `ServiceTeam = ITOps` → VM operations, HA/DR.
  - `DeployedBy = CloudTeam` → automation pipelines.

---

## Architecture Outline

### Networking
- VNets + subnets for trading workloads  
- NSGs for traffic control  
- Azure Load Balancer / Application Gateway for HA  

### Compute
- Linux VMs for trading engines  
- VM Scale Sets for elasticity  
- Availability Sets/Zones for resilience  

### Storage
- Managed Disks for VMs  
- Blob Storage for Terraform backend + data  
- Azure Files for shared storage  

### Disaster Recovery
- Azure Site Recovery replicating VMs across regions  
- Backup Vaults for snapshots  

### Monitoring
- Azure Monitor + Log Analytics for metrics/logs  
- Grafana connected to Azure Monitor for dashboards  

### Automation
- Terraform for infra provisioning  
- Ansible for VM configuration (kernel/network tuning)  
- Azure DevOps Pipelines for CI/CD  

---

## Deliverables
- **Architecture Diagram**: VNets + VMs + Load Balancers + Site Recovery + Monitor + DevOps Boards  
- **GitHub Repo**: Terraform configs, Ansible playbooks, monitoring dashboards  
- **Demo Script**:  
  1. Terraform deploys infra  
  2. Ansible configures VMs  
  3. Azure Monitor raises alert  
  4. DevOps Board ticket created  

- **Business Impact Statement**:  
  *Achieved HA/DR across Azure regions, <15 min failover, ITIL‑aligned incident response, fully Azure‑based.*

