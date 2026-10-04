# Ansible folder structure

```text
ansible/
│

├── README.md                    # Main Ansible overview and usage guide
├── structure.md                 # This folder structure reference

├── inventory/                   # Hosts Ansible can reach and the variables tied to them
│   ├── aws_hosts.ini            # AWS hosts grouped for targeted playbook runs
│   ├── azure_hosts.ini          # Azure hosts grouped for targeted playbook runs
│   ├── group_vars/              # Variables shared across all hosts in a group
│   │   ├── aws.yml              # Shared settings for AWS hosts
│   │   ├── azure.yml            # Shared settings for Azure hosts
│   │   └── .gitkeep             # Keeps the folder in Git even if empty
│   └── host_vars/               # Variables that apply to individual hosts
│       └── .gitkeep             # Keeps the folder in Git even if empty

├── playbooks/                   # Top-level automation entry points that tell Ansible what to run
│   ├── kernel.yml               # Runs kernel tuning tasks such as sysctl and performance settings
│   ├── network.yml              # Runs network tuning tasks such as NIC and TCP optimizations
│   ├── storage.yml              # Runs storage tuning and filesystem configuration tasks
│   └── testing.yml              # Runs validation or smoke-test steps after configuration

└── roles/                       # Reusable automation components that keep logic modular
    ├── kernel_tuning/           # Role for kernel performance changes
    │   ├── handlers/            # Handlers used when kernel changes need a restart or reload
    │   ├── tasks/               # Main task logic for this role
    │   │   └── main.yml         # Entry point for kernel tuning tasks
    │   └── vars/                # Role-specific variables for kernel tuning

    ├── network_tuning/          # Role for network performance changes
    │   ├── handlers/            # Handlers used when network changes need a restart or reload
    │   ├── tasks/               # Main task logic for this role
    │   │   └── main.yml         # Entry point for network tuning tasks
    │   └── vars/                # Role-specific variables for network tuning

    ├── storage_config/          # Role for storage and filesystem configuration
    │   ├── handlers/            # Handlers used when storage changes need a reload or remount
    │   ├── tasks/               # Main task logic for this role
    │   │   └── main.yml         # Entry point for storage configuration tasks
    │   └── vars/                # Role-specific variables for storage configuration
    |
    └── monitoring/              # Role for setting up observability tools, metrics collection, and alerting
        ├── tasks/               # Contains the step-by-step automation for installing and configuring monitoring components
        │   └── main.yml         # Main task file for deploying monitoring agents, exporters, and related setup steps
        └── vars/                # Stores role-specific values that make the monitoring setup flexible and reusable
            └── main.yml         # Variables for service names, ports, endpoints, thresholds, and other monitoring settings
```

## What each part does

- `inventory/` tells Ansible which machines to manage.
- `playbooks/` defines what to run.
- `roles/` keeps the logic modular and reusable.

## Why this layout works

- Playbooks coordinate the automation flow.
- Inventory separates Azure and AWS targets cleanly.
- Roles make the configuration reusable and easier to maintain.
