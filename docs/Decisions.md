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


## VM SKU Type

**Problem:** We needed to choose a VM SKU for testing that balanced performance, cost, and operational simplicity.

**Options Considered:**  
- **Standard_A2_v2** — A cost-effective Azure VM size suitable for lightweight testing and container-based workloads.
- **Multiple VMs / VM scale set** — Better for horizontal scaling, but adds cost and operational complexity for this testing scenario.

**Acceptance Criteria:**  
- The VM must be affordable for testing.
- The VM must be capable of running Docker containers for scaling experiments.
- The VM must allow SSH access for administration and validation.

**Decision:**  
- Use a single **Standard_A2_v2** Linux VM. A Terraform-generated SSH key (`tls_private_key`) is used so the VM can be accessed securely over SSH and used to run Docker containers during testing.

**Impact:**  
- Lower cost than running multiple VMs or a VM scale set.
- Simpler deployment and management during testing.
- No built-in horizontal autoscaling, so scaling experiments are handled manually on the single VM.
