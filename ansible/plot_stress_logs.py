#!/usr/bin/env python3
"""Plot stress-test logs into one dashboard PNG.

Usage:
    python3 plot_stress_logs.py combined-logs.txt -o dashboard.png

The input should be a single combined text file that contains dstat CSV rows
and vmstat rows.
"""

import argparse
import re
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd


DSTAT_ROW = re.compile(r"^\d\d-\d\d \d\d:\d\d:\d\d,")
VMSTAT_ROW = re.compile(r"^\s*\d+(?:\s+\d+){16}\s*$")
DSTAT_COLS = [
    "time", "usr", "sys", "idl", "wai", "stl", "rd", "wr",
    "recv", "send", "pgin", "pgout", "intr", "csw",
]
VM_COLS = "r b swpd free buff cache si so bi bo in cs us sy id wa st".split()


def load_text(path):
    return Path(path).read_text(errors="replace")


def parse_dstat(text):
    rows = [line.split(",") for line in text.splitlines() if DSTAT_ROW.match(line)]
    rows = [row for row in rows if len(row) == len(DSTAT_COLS) and row[1] != ""]
    df = pd.DataFrame(rows, columns=DSTAT_COLS)
    for col in DSTAT_COLS[1:]:
        df[col] = pd.to_numeric(df[col], errors="coerce")
    df["t"] = range(len(df))
    return df


def parse_vmstat(text):
    rows = [line.split() for line in text.splitlines() if VMSTAT_ROW.match(line)]
    if not rows:
        return pd.DataFrame(columns=VM_COLS + ["t"])
    df = pd.DataFrame(rows, columns=VM_COLS).astype(int)
    df = df.iloc[1:].reset_index(drop=True)
    df["t"] = range(len(df))
    return df


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("-o", "--out", default="stress_dashboard.png")
    args = parser.parse_args()

    text = load_text(args.input)
    dstat_df = parse_dstat(text)
    vmstat_df = parse_vmstat(text)

    if dstat_df.empty:
        raise SystemExit("No dstat rows found in the input file.")

    fig, axes = plt.subplots(2, 2, figsize=(14, 8), constrained_layout=True)
    fig.suptitle(f"Stress test capture ({len(dstat_df)} s window)", fontsize=15)

    ax = axes[0, 0]
    ax.stackplot(dstat_df.t, dstat_df.usr, dstat_df.sys, dstat_df.wai,
                 labels=["user", "system", "iowait"])
    ax.set(title="CPU busy %", ylim=(0, 100), xlabel="seconds", ylabel="%")
    ax.legend(loc="upper right")

    ax = axes[0, 1]
    ax.plot(dstat_df.t, dstat_df.recv / 1024, label="recv")
    ax.plot(dstat_df.t, dstat_df.send / 1024, label="send")
    ax.set(title="Network KB/s", xlabel="seconds")
    ax.legend()

    ax = axes[1, 0]
    ax.plot(dstat_df.t, dstat_df.rd / 1024, label="read")
    ax.plot(dstat_df.t, dstat_df.wr / 1024, label="write")
    ax.set(title="Disk KB/s", xlabel="seconds")
    ax.legend()

    ax = axes[1, 1]
    if not vmstat_df.empty:
        ax.step(vmstat_df.t, vmstat_df.r, where="post", label="runnable (r)")
        ax.step(vmstat_df.t, vmstat_df.b, where="post", label="blocked (b)")
        ax.legend()
    ax.set(title="vmstat run queue", xlabel="seconds")

    fig.savefig(args.out, dpi=110)
    print(f"saved {args.out}")


if __name__ == "__main__":
    main()
