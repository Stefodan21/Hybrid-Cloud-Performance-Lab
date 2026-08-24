# Getting Started Guide

## Purpose

This guide captures the first-time Azure setup steps for the lab, including sign-in, resource group creation, and the storage resources used by Terraform.

## Quick start

1. Install the Azure CLI.
2. Sign in with an account that has Owner or equivalent permissions.
3. Create the Azure resource group.
4. Create the storage account used for Terraform state.
5. Create the storage container inside that account.

## Prerequisites

- Azure CLI installed locally, or access to Azure Cloud Shell.
- An Azure account with access to the target subscription.
- Owner, Contributor, or equivalent permissions for the subscription and resource group.
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
3. Create the resource group:
	```bash
	az group create --name Janestreeteastus --location eastus
	```
4. Create the storage account for Terraform state:
	```bash
	az storage account create \
	  --name sttradeeastus001 \
	  --resource-group Janestreeteastus \
	  --location "East US" \
	  --sku Standard_RAGRS \
	  --kind StorageV2 \
	  --encryption-services blob
	```
5. Create the storage container for the Terraform backend:
	```bash
	az storage container create \
	  --name terraform \
	  --account-name sttradeeastus001 \
	  --auth-mode login
	```
6. Verify the resources were created successfully.

## Notes

- If the storage account creation fails with a provider registration error, register `Microsoft.Storage` first.
- Keep the resource group name, storage account name, and container name consistent with the Terraform backend configuration.