# Governance

## Purpose

This page defines the governance, ownership, and control standards for the platform.

## Tagging standards

- Every Azure resource should use the shared Terraform `tags` map.
- Required tags:
	- `environment`
	- `project`
	- `owner`
	- `managed_by`
	- `purpose`
- Tag values should stay short, consistent, and lowercase where practical.
- Use tags to separate development, test, and production-style examples clearly.

## RBAC and ownership

- Subscription Owner: platform administration and IAM oversight
- Contributor: deployment and day-to-day platform management
- Storage Blob Data Contributor: access to Terraform backend state
- Keep RBAC scoped to the narrowest resource group or storage account possible.

## Compliance notes

- Changes should be made through Terraform instead of ad hoc portal edits.
- Update documentation whenever infrastructure or tag standards change.
- Keep a simple audit trail by using clear commit messages and small, reviewable changes.