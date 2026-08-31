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

**Problem:** TODO: Add the VM SKU selection decision and rationale.

**Options Considered:**
- TODO: Add candidate VM SKUs.

**Acceptance Criteria:**
- TODO: Add requirements for performance, cost, and availability.

**Decision:**
- TODO: Add the selected VM SKU and justification.

**Impact:**
- TODO: Add the expected operational and performance impact.
