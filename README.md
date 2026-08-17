# Hybrid Cloud Performance Lab

A hybrid cloud performance lab for a quant trading firm expanding globally. The project combines **Azure**, **AWS**, **Terraform**, **Ansible**, **Azure Arc**, and observability tooling to support latency-sensitive trading applications and analytics dashboards with high availability and disaster recovery in mind.

## Overview

This lab is designed to demonstrate how a distributed infrastructure team can:

- Deploy Linux servers across **Azure** and **AWS**
- Automate provisioning with **Terraform**
- Configure systems with **Ansible**
- Onboard AWS instances into **Azure Arc**
- Monitor performance with **Azure Monitor**, **Log Analytics**, **Prometheus**, and **Grafana**
- Tune kernel and networking settings for lower latency and higher throughput
- Support HA/DR, observability, and ITIL-aligned operations

## Business Scenario

**Company:** Quant trading firm expanding globally  
**Workload:** Latency-sensitive trading applications plus analytics dashboards

### Core requirements

- **High Availability (HA):** no single point of failure
- **Disaster Recovery (DR):** failover to a secondary region within 15 minutes
- **Observability:** metrics, logs, and alerts across infrastructure
- **Hybrid Cloud:** Azure + AWS for resilience
- **Automation:** infrastructure as code, config management, and monitoring agents
- **ITIL Service Management:** incident, change, and request workflows

## Roles and Ownership

- **IT Operations:** HA configurations, clustering, failover readiness
- **Infrastructure:** replication, cross-region recovery, Site Recovery
- **SRE / Monitoring:** metrics, logs, alerts, dashboards
- **Cloud Admins:** Azure/AWS provisioning, RBAC, governance
- **Dev / Automation:** Terraform, Ansible, CI/CD pipelines
- **Service Management:** Azure DevOps Boards workflows and incident handling

## Azure Setup

### Azure AD groups

- `Dev-Team` → Contributor on DevOps project, pipeline permissions
- `IT-Ops` → Contributor on VM resource groups, HA/DR configs
- `SRE-Monitoring` → Monitoring Contributor, access to Azure Monitor + Grafana
- `Infra-Storage` → Storage Blob Data Contributor, disk/NAS management
- `Admins` → Owner at subscription level

### RBAC principles

- Use least privilege at the resource-group level
- Dev can deploy infrastructure but cannot modify RBAC
- Ops can manage failover but not pipelines

### Azure DevOps mapping

- Map each AD group into DevOps teams
- Boards for ITIL tickets and tracking
- Pipelines restricted to Dev / Automation
- Wiki for DR runbooks owned by Infrastructure

## Deliverables

- **Architecture diagram** showing Azure VNets + AWS EC2 + Terraform + Ansible + Kubernetes + Grafana + Azure DevOps Boards
- **GitHub repo** containing infrastructure code, playbooks, and monitoring configuration
- **Demo script** showing provisioning, config application, failover, and Grafana metrics
- **Business impact statement** describing HA/DR, latency reduction, observability, and team ownership

## Demo Flow

1. Provision infrastructure with Terraform
2. Apply configurations with Ansible
3. Onboard and monitor hybrid resources with Azure Arc
4. Trigger a failover scenario
5. Show Grafana / Azure Monitor metrics
6. Capture incident tracking in Azure DevOps Boards

## Resume-ready impact line

> Built a hybrid cloud performance lab using Terraform, Ansible, and Azure Arc to deploy Linux servers across AWS and Azure. Tuned kernel parameters and optimized network throughput, achieving 30% latency reduction for real-time workloads.

## Repository Contents

- `businessrequirements/requirementsB.md` — consolidated business requirements and ownership model
- `docs/` — documentation boilerplate for architecture, operations, troubleshooting, and governance

## Documentation

The detailed documentation now lives under `docs/` and is ready for you to fill in step by step:

- `docs/README.md` — documentation index and navigation
- `docs/Getting-Started-Guide.md` — deployment prerequisites and Terraform workflow
- `docs/Architecture.md` — lab architecture, diagrams, and component breakdown
- `docs/Operations.md` — SOPs for deploy, scale, failover, and backup
- `docs/Troubleshooting.md` — known issues, error codes, and fixes
- `docs/Governance.md` — tagging, RBAC, ownership, and control standards

## Notes

This repository is intended as a portfolio-style architecture and implementation brief. It focuses on the design, automation, monitoring, and operational story behind the lab.
