# Decision Log Entry
application gateway > web app > employee app > azure load balancer > database

## Storage Redundancy

**Problem:** We needed to choose a redundancy option for the storage account that would support high availability, disaster recovery, and compliance requirements for logs, Terraform state, and backups.

**Options Considered:**  
- **ZRS** — Provides low latency and zone resilience, with strong availability within a region. It can be paired with a Recovery Services Vault for additional cross-region protection.
- **RA-GZRS** — Easier to implement, with cross-region disaster recovery support, but at a higher cost.
- **GRS** — Lower-cost asynchronous replication across regions.
- **RA-GRS** — Similar to GRS, but includes read access in the secondary region, which is useful for disaster recovery testing and compliance.

**Acceptance Criteria:**  
- Terraform state and logs must survive a zone outage.
- Backup data must be readable from the secondary region during disaster recovery testing.
- The solution must support disaster recovery compliance requirements.


**Decision:**  
- Use Standard RA-GRS for Terraform state, logs, and backups. It provides cross-region resilience, supports read access for testing and validation, and offers a good balance between cost and operational simplicity.
 

**Impact:**  
- Balanced cost and resilience.
- Supports clear separation between hot-path workloads and disaster recovery data.


## VM Scale Set Configuration

**Problem:** We needed to choose a compute layout for testing that balanced performance, cost, and operational simplicity while also supporting horizontal scaling.

**Options Considered:**  
- **Single `Standard_A2_v2` VM** — Lower operational overhead, but no built-in autoscaling.
- **Linux VM Scale Set** — Supports horizontal scaling and automated instance management, but adds some deployment complexity.

**Acceptance Criteria:**  
- The compute layer must be affordable for testing.
- The workload must support Docker containers for scaling experiments.
- The solution must allow SSH access for administration and validation.
- The compute layer must support autoscaling for load-based experiments.

**Decision:**  
- Use a Linux **Azure Virtual Machine Scale Set (VMSS)** with `Standard_A2_v2` instances. A Terraform-generated SSH key (`tls_private_key`) is used so the instances can be accessed securely over SSH and used to run Docker containers during testing.

**Impact:**  
- Enables horizontal scaling through VMSS instead of a single VM.
- Matches the Terraform implementation and autoscale configuration.
- Slightly more complex than a single VM, but better suited for scaling experiments and load testing.


## Managed Database Choice

**Problem:** We needed to choose a managed database for the trading application that could provide global reach, low latency, and strong performance for time-sensitive workloads.

**Options Considered:**  
- **Cosmos DB** — Globally distributed, high performance, and well suited for low-latency trading application access.
- **Traditional managed relational database** — Familiar and reliable, but typically less optimized for globally distributed low-latency access.

**Acceptance Criteria:**  
- The database must support low-latency access for trading workloads.
- The database must be suitable for global, high-performance access patterns.
- The solution must support access through a service endpoint.

**Decision:**  
- Use **Cosmos DB** as the managed database because it provides global high performance for trading apps and low latency when accessed through a service endpoint.

**Impact:**  
- Better fit for globally distributed, latency-sensitive trading scenarios.
- Simplifies managed database operations while supporting scalable access patterns.
- Service endpoint access helps keep traffic to the database controlled and private within the Azure network boundary.


## Private Database Connectivity

**Problem:** We needed a secure way for the application subnet to reach Cosmos DB without exposing the database broadly to the public internet.

**Options Considered:**  
- **Public endpoint with firewall rules** — Easy to configure, but relies more heavily on public network exposure.
- **Private endpoint** — Strong isolation, but adds more configuration overhead.
- **Service endpoint** — Keeps traffic on the Azure backbone and provides private connectivity from the subnet to Cosmos DB with simpler setup.

**Acceptance Criteria:**  
- The database connection must remain private from the application subnet.
- The solution must avoid unnecessary public internet exposure.
- The configuration must stay simple enough for the platform environment.

**Decision:**  
- Use a **service endpoint** on the application subnet for Cosmos DB access so the trading application can connect privately over Azure infrastructure.

**Impact:**  
- Improves network security by limiting database access to the intended subnet.
- Keeps database traffic on Azure-managed networking instead of the public internet.
- Provides a practical balance between security and operational simplicity for this project.


## Subnet Security Rules

**Problem:** We needed subnet-level security rules that allow only the required traffic for administration, application access, and Cosmos DB connectivity while blocking everything else by default.

**Options Considered:**  
- **Open subnet with minimal filtering** — Simple, but too permissive for the platform.
- **Custom allow rules plus explicit deny-all rule** — Clear and secure, but the deny-all behavior is already provided by the NSG defaults.
- **Allow required traffic and rely on default deny rules** — Cleanest approach for this setup.

**Acceptance Criteria:**  
- Allow SSH for administration.
- Allow HTTPS for application traffic.
- Allow Cosmos DB access through the service endpoint.
- Block all other traffic.

**Decision:**  
- Configure the subnet NSG to allow **SSH (22)**, **HTTPS (443)**, and **Cosmos DB service endpoint traffic**, then rely on the NSG default deny rules to block all remaining traffic.

**Impact:**  
- Keeps the subnet locked down to only the required ports and services.
- Supports secure administration and app access.
- Preserves a deny-all posture without adding unnecessary explicit deny rules.
