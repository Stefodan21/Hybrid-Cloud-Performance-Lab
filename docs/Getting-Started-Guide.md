# Getting Started Guide

## Purpose

This guide captures the first-time Azure setup steps for the platform, including sign-in, backend storage, and the Terraform workflow used to deploy Azure resources.

## Quick start

1. Install the Azure CLI and Terraform.
2. Sign in with an account that has access to the target subscription.
3. Make sure the backend storage account and container already exist.
4. Confirm your identity has `Storage Blob Data Contributor` on the backend storage account.
5. Run `terraform init`, `plan`, and `apply` from `terraform/azure`.

## Prerequisites

- Azure CLI installed locally, or access to Azure Cloud Shell.
- Terraform installed locally.
- An Azure account with access to the target subscription.
- Contributor or equivalent permissions for the resource group that will host the platform resources.
- `Storage Blob Data Contributor` on the storage account used for the Terraform backend.
- The Microsoft.Storage provider registered in the subscription.

## Deployment workflow

1. Sign in to Azure:

   ```bash
   az login
   ```

2. Select the correct subscription if needed:

   ```bash
   az account set --subscription "<subscription-name-or-id>"
   ```

3. Verify your backend identity has access to the storage account.

4. Initialize Terraform from the Azure folder:

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

7. Confirm the deployment in Azure and review the VMSS, load balancer, subnet NSG, and Cosmos DB resources.

## Notes

- If the storage account creation fails with a provider registration error, register `Microsoft.Storage` first.
- Keep the resource group name, storage account name, and container name consistent with the Terraform backend configuration.
- If `terraform init` returns a 403 on the backend, confirm the current identity has a Blob data role on the storage account.
- Keep the resource group name, storage account name, and container name consistent with the backend config file.