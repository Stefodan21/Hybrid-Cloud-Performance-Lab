# Architecture

## Purpose

This page describes the high-level Azure architecture for the platform.

The design uses a single subscription, a dedicated resource group, Azure Blob Storage for Terraform state, and a virtual network that hosts the application subnet and compute layer.

## Diagram

TODO: Insert the architecture diagram here.

## Components

- Virtual network and application subnet
- Linux VM Scale Set behind a public load balancer
- Azure Blob Storage for Terraform state
- Cosmos DB with service endpoint access from the application subnet
- Monitoring and alerting via Azure-native services

## Design notes

- Resiliency is built around managed Azure services and repeatable infrastructure provisioning.
- Latency-sensitive traffic is constrained to the application subnet and approved service paths.
- Observability should cover infrastructure, connectivity, and application health.