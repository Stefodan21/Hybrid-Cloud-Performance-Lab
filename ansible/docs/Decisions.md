# Ansible design decisions

## Why this folder exists
This documentation captures the choices made for the Ansible part of the lab so the automation is easier to understand and maintain.

## Role decisions

### `kernel_tuning`
Chosen to apply host-level kernel performance changes such as scheduler tuning, sysctl settings, and other low-level optimizations. This keeps kernel behavior consistent across the lab and supports the latency-sensitive workload.

### `network_tuning`
Chosen to handle NIC and TCP tuning separately from kernel and storage logic. This makes the automation easier to maintain and keeps network optimization focused on throughput, packet handling, and TCP stack behavior.

### `storage_config`
Chosen to keep filesystem and disk tuning isolated from compute and network changes. Storage tuning is often its own concern, so separating it makes the automation more modular and easier to extend.

### `monitoring`
Added after the main tuning roles so the lab can observe the effect of each performance change. Monitoring is used to collect metrics, support observability, and validate that the tuned systems behave as expected under load.

### `Stress_test`
Added to generate workload during metrics collection and validate the monitoring setup under pressure. The role was split out so stress generation stays separate from the tuning roles.

## Network benchmarking decisions

For the virtual NIC and TCP load tests, we chose `iperf3` instead of `stress-ng`.

This lab is designed for a low-latency trading workload, so the network traffic is intended to resemble real TCP throughput between two hosts rather than generic socket pressure. `iperf3` is a better fit because it measures actual throughput and latency between a client and a server over the virtual NIC, while `stress-ng` socket tests are more generic and can default to loopback-style stressing that does not fully exercise the virtual NIC path.

The test setup uses two Azure VMs in the same virtual network and subnet, communicating over their private IPs. That means traffic really traverses the virtual NIC on both ends, without the extra variables of public internet routing or Azure NAT layers.

To avoid hand-writing separate commands for each machine, the inventory defines two host groups:

- `iperf_server`
- `iperf_clients`

The same Ansible tasks file can run on every VM, but each task is guarded with a `when` condition based on group membership. That means:

- the server VM runs `iperf3 -s -D` and starts listening in daemon mode without blocking the rest of the play
- the client VMs run `iperf3 -c`, and they read the server address from `hostvars` instead of hard-coding it

Because Ansible completes a task across all hosts before moving to the next task, the daemonized server task finishes first and the client task can safely connect in the same play.

The inventory keeps the existing `group_vars` and `host_vars` folders too. Those folders are still useful for shared values and host-specific overrides, and they work alongside the new `iperf_server` and `iperf_clients` groups.

This setup also keeps the benchmarking workflow separate from passive monitoring. The stress tasks plus metrics collection are meant for proactive tuning on a healthy system, not for live incident investigation on a VM that is already having problems.

## Stress test choices

The stress-test role uses three workload patterns:

- **CPU scheduler stress** — uses `stress-ng` with `--cpu 0` and `--cpu-method matrixprod` to load all available CPU and exercise the scheduler with heavy floating-point and cache activity.
- **Virtual NIC stress** — uses `iperf3` client/server traffic to create realistic network throughput pressure and help sample network-related metrics.
- **TCP connection stress** — uses the same `iperf3` client/server traffic to sample TCP metrics during the same network run, so the TCP section does not need a separate `stress-ng` task.

Because the `iperf3` NIC test already generates genuine TCP traffic between the two VMs, we dropped the originally planned separate TCP `stress-ng` task. That avoids duplicate load and keeps the benchmark more realistic for this workload.

## Why `matrixprod` was chosen
`matrixprod` was selected because it creates heavy floating-point matrix work and cache pressure, which is a good fit for a low-latency trading environment where CPU efficiency and scheduling behavior matter.

It was chosen over other CPU methods such as:
- prime number checking
- fast Fourier transform
- central counter loop

The goal was to use a workload that better resembles compute-heavy scientific or video-style processing while still stressing the CPU in a way that produces useful scheduler and performance metrics.

## Overall design summary
The Ansible automation is split into separate roles so each concern stays focused:

- kernel performance
- network tuning
- storage configuration
- monitoring and observability
- stress testing for validation

This keeps the automation easier to read, test, and extend.
