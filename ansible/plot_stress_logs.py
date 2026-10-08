#!/usr/bin/env python3
"""Turn stress-test logs (dstat CSV + vmstat) into one dashboard PNG.

Usage:
    python3 plot_stress_logs.py logs.txt
    python3 plot_stress_logs.py ./logs/vm1/ -o vm1-dashboard.png

Accepts files or folders. Everything is concatenated and parsed by line shape,
so a single combined file or the separate dstat.csv / vmstat.log both work.
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
DSTAT_COLS = ["time", "usr", "sys", "idl", "wai", "stl", "rd", "wr",
              "recv", "send", "pgin", "pgout", "intr", "csw"]
VM_COLS = "r b swpd free buff cache si so bi bo in cs us sy id wa st".split()


def read_text(paths):
    chunks = []
    for p in map(Path, paths):
        files = sorted(p.rglob("*")) if p.is_dir() else [p]
        for f in files:
            if f.is_file() and f.suffix in {".txt", ".log", ".csv"}:
                chunks.append(f.read_text(errors="replace"))
    return "\n".join(chunks)


def parse_dstat(text):
    rows = [l.split(",") for l in text.splitlines() if DSTAT_ROW.match(l)]
    rows = [r for r in rows if len(r) == len(DSTAT_COLS) and r[1] != ""]
    df = pd.DataFrame(rows, columns=DSTAT_COLS)
    for c in DSTAT_COLS[1:]:
        df[c] = pd.to_numeric(df[c], errors="coerce")
    df["t"] = range(len(df))
    return df


def parse_vmstat(text):
    rows = [l.split() for l in text.splitlines() if VMSTAT_ROW.match(l)]
    df = pd.DataFrame(rows, columns=VM_COLS).astype(int)
    df = df.iloc[1:].reset_index(drop=True)  # first row = average since boot
    df["t"] = range(len(df))
    return df


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("paths", nargs="+")
    ap.add_argument("-o", "--out", default="stress_dashboard.png")
    args = ap.parse_args()

    text = read_text(args.paths)
    d, v = parse_dstat(text), parse_vmstat(text)
    if d.empty:
        raise SystemExit("No dstat CSV rows found.")

    fig, ax = plt.subplots(3, 2, figsize=(14, 10), constrained_layout=True)
    fig.suptitle(f"Stress test capture ({len(d)} s window)", fontsize=15)

    a = ax[0, 0]
    a.stackplot(d.t, d.usr, d.sys, d.wai, labels=["user", "system", "iowait"])
    a.set(title="CPU busy %", ylim=(0, 100), xlabel="seconds", ylabel="%")
    a.legend(loc="upper right")

    a = ax[0, 1]
    a.plot(d.t, d.csw, color="tab:purple")
    a.set(title="Context switches / s", xlabel="seconds")

    a = ax[1, 0]
    a.plot(d.t, d.intr, color="tab:orange")
    a.set(title="Interrupts / s", xlabel="seconds")

    a = ax[1, 1]
    a.plot(d.t, d.recv / 1024, label="recv")
    a.plot(d.t, d.send / 1024, label="send")
    a.set(title="Network KB/s", xlabel="seconds")
    a.legend()

    a = ax[2, 0]
    a.plot(d.t, d.rd / 1024, label="read")
    a.plot(d.t, d.wr / 1024, label="write")
    a.set(title="Disk KB/s", xlabel="seconds")
    a.legend()

    a = ax[2, 1]
    if not v.empty:
        a.step(v.t, v.r, where="post", label="runnable (r)")
        a.step(v.t, v.b, where="post", label="blocked (b)")
        a.set(title=f"vmstat run queue (steal max {v.st.max()}%)", xlabel="seconds")
        a.legend()

    idle = d.idl.clip(upper=100).mean()
    if idle > 90:
        fig.get_layout_engine().set(rect=(0, 0.04, 1, 0.96))
        fig.text(0.5, 0.01,
                 f"WARNING: CPU averaged {idle:.1f}% idle. The stress load probably "
                 "did not overlap this capture.",
                 ha="center", color="red", fontsize=12, weight="bold")

    fig.savefig(args.out, dpi=110)
    print(f"saved {args.out}; mean CPU idle {idle:.1f}%")


if __name__ == "__main__":
    main()
