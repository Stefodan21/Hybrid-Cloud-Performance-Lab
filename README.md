# Hybrid Cloud Performance Platform

A reference implementation for a latency-sensitive trading workload. The repository focuses on **Terraform-driven Azure infrastructure**, with supporting documentation for architecture, governance, operations, and troubleshooting.

## What’s in this repo

- `terraform/azure/` — Azure infrastructure code for networking, VM scale sets, load balancing, storage, and Cosmos DB
- `docs/` — handoff-ready documentation for getting started, architecture, operations, governance, and troubleshooting
- `businessrequirements/` — business and platform requirements that shape the overall design

## Current Azure design

- Virtual network and application subnet
- Linux VM Scale Set behind a public load balancer
- Network security group applied at the subnet level
- Cosmos DB with private access via service endpoint
- Remote Terraform state stored in Azure Blob Storage

## How to run it

### Prerequisites

- Azure CLI installed and authenticated
- Terraform installed
- Access to the target subscription and backend storage account
- Azure RBAC permission to read and write the Terraform state container

### Deploy Azure infrastructure

1. Sign in to Azure:

	```bash
	az login
	```

2. Select the correct subscription:

	```bash
	az account set --subscription "<subscription-id-or-name>"
	```

3. Move into the Azure Terraform folder:

	```bash
	cd terraform/azure
	```

4. Initialize Terraform with the backend config file:

	```bash
	terraform init -backend-config=backend.hcl
	```

5. Review the plan:

	```bash
	terraform plan -var-file=terraform.tfvars
	```

6. Apply the configuration:

	```bash
	terraform apply -var-file=terraform.tfvars
	```

## Tagging

All Azure resources use a shared Terraform tag map. The current standard includes:

- `environment`
- `project`
- `owner`

See `docs/Governance.md` for the tagging standard and ownership rules.

## Documentation

- `docs/README.md` — documentation index
- `docs/Getting-Started-Guide.md` — deployment prerequisites and Terraform workflow
- `docs/Architecture.md` — architecture overview and component breakdown
- `docs/Operations.md` — repeatable operational steps
- `docs/Troubleshooting.md` — common issues and fixes
- `docs/Governance.md` — tagging, RBAC, and ownership standards

## Notes

This repository is intentionally small and focused. The goal is to show a clean, realistic Azure implementation that is easy to understand, easy to run, and easy to extend.
