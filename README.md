# RTL to GDS Workshop

> A hands-on record of my journey through the complete digital ASIC implementation flow, from RTL design to physical design, using industry-standard concepts and commercial/open-source EDA tools.

---

## Overview

This repository contains the exercises, examples, notes, reports, and design artifacts produced while working through an RTL-to-GDS workshop.

The objective is not only to complete the workshop but also to build a long-term reference for digital ASIC design, covering both the theoretical concepts and their practical implementation.

Topics include:

- SystemVerilog fundamentals
- RTL design
- Functional simulation
- Testbench development
- Timing libraries
- Design for Test (DFT)
- Physical Design
- Timing analysis
- Design verification

As the workshop progresses, additional reports, scripts, and documentation will be added to make this repository a complete reference for future ASIC projects.

---

# Repository Structure

```text
rtl-to-gds-workshop
│
├── Day_1/
│   ├── example1.sv
│   ├── ...
│   └── example9.v
│
├── Day_2/
│   ├── example10.sv
│   ├── example10tb.sv
│   ├── mem.sv
│   ├── mem_tb.sv
│   ├── run.sh
│   ├── simulation outputs
│   └── screenshots
│
├── Day_3/
│   ├── lib/
│   ├── DFT/
│   ├── timing libraries
│   └── screenshots
│
├── Day_4_and_5/
│   └── Physical_Design/
│       ├── reports
│       ├── checkDesign
│       └── implementation data
│
└── README.md
```

---

# Workshop Progress

| Day | Topics Covered |
|------|----------------|
| Day 1 | Introduction to SystemVerilog, language syntax, basic RTL examples |
| Day 2 | Simulation, memory design, testbenches, waveform generation |
| Day 3 | Timing libraries, Design for Test (DFT), library characterization |
| Day 4–5 | Physical Design, implementation reports, design checking |

---

# Learning Objectives

This workshop focuses on understanding the complete ASIC implementation flow rather than simply writing RTL.

Major learning goals include:

- Writing synthesizable SystemVerilog
- Developing verification testbenches
- Understanding standard cell libraries
- Learning setup/hold timing concepts
- Reading Liberty (`.lib`) files
- Exploring DFT methodologies
- Understanding physical implementation
- Interpreting implementation reports
- Building intuition about the RTL-to-GDS flow

---

# Tools Used

Throughout the workshop, the following categories of tools are used:

- SystemVerilog
- Verilog
- Cadence Xcelium (simulation)
- Liberty timing libraries
- Physical Design tools
- Linux shell scripting

Additional open-source equivalents that can be used for experimentation include:

- Icarus Verilog
- Verilator
- Yosys
- OpenROAD
- OpenSTA
- Magic
- KLayout

---

# Repository Goals

This repository is intended to become:

- a personal knowledge base for ASIC design
- a reference for future chip projects
- a collection of reusable RTL examples
- a record of workshop progress
- a portfolio demonstrating practical VLSI learning

---

# Current Status

- ✅ RTL examples
- ✅ Simulation exercises
- ✅ Testbench development
- ✅ Memory design examples
- ✅ Liberty library exploration
- ✅ DFT introduction
- ✅ Physical Design reports

Planned additions include:

- Detailed notes for every day
- Timing analysis explanations
- Physical Design walkthroughs
- Screenshots of important results
- Automation scripts
- OpenROAD/OpenLane equivalents where applicable

---

# Getting Started

Clone the repository:

```bash
git clone https://github.com/adi05rjn/rtl-to-gds-workshop.git
cd rtl-to-gds-workshop
```

Each workshop day is organized into its own directory.

Explore the folders sequentially, as later exercises build upon concepts introduced earlier.

---

# Future Improvements

- [ ] Add detailed documentation for each workshop day
- [ ] Explain every example with comments
- [ ] Include waveform screenshots
- [ ] Document synthesis and timing reports
- [ ] Add automation scripts
- [ ] Compare commercial and open-source ASIC flows
- [ ] Build a complete RTL-to-GDS example project

---

# License

This repository is intended for educational purposes.

If workshop material originates from external instructors or organizations, all original copyrights remain with their respective owners.

---

## Author

**Adithya Rajan**

Interested in:

- ASIC Design
- Physical Design
- RISC-V
- Computer Architecture
- EDA
- Digital IC Design