# Ansible folder structure

This folder contains the Ansible automation used to tune and configure the lab infrastructure after provisioning.

## Folder structure

### `playbooks/`
Entry-point YAML files that define **what to run**. Each playbook calls roles and tasks.

- `kernel.yml` — applies kernel tuning tasks such as NUMA balancing, IRQ affinity, and hugepages.
- `network.yml` — runs network tuning tasks such as `ethtool` settings and TCP parameters.
- `storage.yml` — configures storage tuning for filesystems like XFS, EXT4, and ZFS.
- `monitoring.yml` — deploys Prometheus Node Exporter and configures metrics collection. This ties directly into Step 5 (Observability).
- `security.yml` — applies baseline hardening such as firewall rules, disabling root login, and enabling `auditd`. Critical for compliance and resilience.
- `common.yml` — handles shared configuration across all nodes such as timezone, NTP, and syslog forwarding. Keeps environments consistent.

Think of playbooks as the recipes that tell Ansible which roles to execute on which hosts.

### `roles/`
Reusable collections of tasks, handlers, templates, and variables. Roles keep automation modular and easier to maintain.

- `kernel_tuning/` — sysctl configuration, GRUB parameters, hugepages setup.
- `network_tuning/` — NIC tuning, `ethtool` commands, TCP stack parameters.
- `storage_config/` — filesystem creation, mount options, and performance tuning.

Think of roles as the ingredients that playbooks call.

### `inventory/`
Defines which machines Ansible connects to and applies configuration on.

- `azure_hosts.ini` — lists Azure VM IPs or hostnames, grouped by environment such as `[azure_primary]`.
- `aws_hosts.ini` — lists AWS EC2 nodes, grouped by environment such as `[aws_secondary]`.

Think of inventories as the target list for your playbooks.

## Requirements

- **Terraform outputs → inventory**: export VM IPs from Terraform into the `.ini` inventory files automatically.
- **SSH keys**: ensure passwordless SSH access from the control node to Azure and AWS VMs.
- **Python installed**: Ansible requires Python on target nodes.
- **Privilege escalation**: use `become: true` in playbooks for kernel, network, and storage tasks.

## Workflow

1. Provision infrastructure with Terraform.
2. Update inventory files with the new VM IPs.
3. Run the playbooks:

```bash
ansible-playbook -i inventory/azure_hosts.ini playbooks/kernel.yml
ansible-playbook -i inventory/aws_hosts.ini playbooks/network.yml
```

4. Apply shared and operational playbooks as needed, for example `common.yml`, `security.yml`, and `monitoring.yml`.
5. Verify tuning with commands like:

```bash
sysctl -a
ethtool -k eth0
mount -t
```

## Why this structure works

- **Playbooks** = orchestration
- **Roles** = reusable logic
- **Inventory** = targets

This keeps the automation clean, modular, and easy to extend.
