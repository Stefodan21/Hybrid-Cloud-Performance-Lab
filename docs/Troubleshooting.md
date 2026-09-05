# Troubleshooting

## Purpose

This page captures known issues and fixes for the platform.

## Known Issues

### `SubscriptionNotFound` when creating a storage account

**Problem**

Running `az storage account create` fails with:

```
(SubscriptionNotFound) Subscription <id> was not found.
Code: SubscriptionNotFound
```

This happens even when you are logged in, on the correct subscription, and the owner.

**What actually happened**

The error message is misleading. The subscription was valid and reachable the whole time — `az account show`, `az account list`, and `az group list` all worked. The real cause was that the **`Microsoft.Storage` resource provider was `NotRegistered`** on the subscription. On new subscriptions, resource providers are not registered until the first resource of that type is created, and the CLI reports this as `SubscriptionNotFound` instead of a registration error.

**How to fix it next time**

1. Check the provider state:
   ```bash
   # Show whether the Microsoft.Storage provider is registered in this subscription.
   az provider show -n Microsoft.Storage --query registrationState -o tsv
   ```
2. If it returns `NotRegistered`, register it and wait:
   ```bash
   # Register the Storage provider and block until Azure finishes the registration.
   az provider register --namespace Microsoft.Storage --wait
   ```
3. Re-run the storage account create command. Use space-separated `key=value` tags (not a JSON object):
   ```bash
   # Create the storage account with the required redundancy, encryption, and tags.
   az storage account create \
     --name sttradeeastus001 \
     --resource-group Janestreeteastus \
     --location "East US" \
     --sku Standard_RAGRS \
     --kind StorageV2 \
     --encryption-services blob \
     --tags "ServiceTeam=ITOps" "Compliance=Confidential" "Lifecycle=LongTerm" "SLA=Internal"
   ```

**Prevention**

Register the common providers up front before deploying, so you don't hit the same misleading error mid-deploy:

```bash
# Register the most common resource providers used by this platform.
az provider register --namespace Microsoft.Storage --wait
# Needed for networking resources such as VNets, NSGs, and load balancers.
az provider register --namespace Microsoft.Network --wait
# Needed for VMs, VMSS, and related compute resources.
az provider register --namespace Microsoft.Compute --wait
# Needed for backup and recovery services.
az provider register --namespace Microsoft.RecoveryServices --wait
```

List anything still unregistered:

```bash
# Show any providers that still need registration in this subscription.
az provider list --query "[?registrationState=='NotRegistered'].namespace" -o table
```

## Common issues

- TODO: Terraform errors
- TODO: VM provisioning failures
- TODO: Connectivity or DNS issues
- TODO: Monitoring or alerting gaps

## Error reference

- TODO: Add error codes and remediation steps
- TODO: Add links to logs or dashboards