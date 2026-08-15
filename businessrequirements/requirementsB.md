🏢 Business Requirements (Scenario)

Company: Quant trading firm expanding globally.

Workload: Latency-sensitive trading applications plus analytics dashboards.

Primary requirements:

- High Availability (HA) → no single point of failure.
- Disaster Recovery (DR) → failover to a secondary region within 15 minutes.
- Observability → metrics, logs, and alerts across infrastructure.
- Hybrid Cloud → Azure + AWS for resilience.
- Automation → infrastructure as code, config management, and monitoring agents.
- ITIL Service Management → ticketing for incidents, changes, and requests.

---

🧑‍🤝‍🧑 Roles and Ownership

- High Availability (HA) → IT Operations team
	- Failover configs
	- Clustering
- Disaster Recovery (DR) → Infrastructure team
	- Replication
	- Cross-region recovery
	- Site Recovery
- Observability → SRE / Monitoring team
	- Metrics
	- Logs
	- Alerts
	- Dashboards
- Hybrid Cloud → Cloud Admins
	- Azure / AWS provisioning
	- RBAC
	- Governance
- Automation → Dev / Automation team
	- Terraform
	- Ansible
	- CI/CD pipelines
- ITIL Service Management → Service Management team
	- Incident, change, and request workflows in Azure DevOps Boards

Collaboration & communication: each team has defined responsibilities, escalation paths for incidents, and SLA tracking.

---

🧩 Azure Setup

Azure AD groups:

- Dev-Team → Contributor on DevOps project, pipeline permissions
- IT-Ops → Contributor on VM resource groups, HA/DR configs
- SRE-Monitoring → Monitoring Contributor role, access to Azure Monitor + Grafana dashboards
- Infra-Storage → Storage Blob Data Contributor, disk/NAS management
- Admins → Owner role at subscription level

RBAC assignments:

- Apply least privilege at the resource-group level.
- Dev team can deploy infrastructure but cannot modify RBAC.
- Ops can manage failover but not pipelines.

Azure DevOps teams:

- Map each AD group into DevOps teams.
- Boards → ITIL tickets assigned to the right team.
- Pipelines → restricted to Dev / Automation team.
- Wiki → DR runbooks owned by Infra team.

---

📊 Deliverables

- Architecture diagram: Azure VNets + AWS EC2 + Terraform + Ansible + Kubernetes + Grafana + Azure DevOps Boards, annotated with team ownership.
- GitHub repo: infrastructure code + playbooks, with a README showing which team owns which configs.
- Demo script: “Dev team commits Terraform → Pipeline deploys infra → Ops tests failover → SRE monitors → Service Mgmt logs incident.”
- Business impact statement: achieved HA/DR with <15 min failover, 30% latency reduction, ITIL-aligned incident response, and clear team ownership across Dev, Ops, Infra, and SRE.

---

✨ Resume-ready impact line

Built a hybrid cloud performance lab using Terraform, Ansible, and Azure Arc to deploy Linux servers across AWS and Azure. Tuned kernel parameters and optimized network throughput, achieving 30% latency reduction for real-time workloads.