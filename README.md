# Xilinx DSP48A1 Slice

## Project Overview

This project implements a Xilinx DSP48A1 Slice using Verilog HDL. The design focuses on implementing the main datapath and control functionality of the DSP48A1 block, including multiplexing, arithmetic operations, and pipelined registers.

A testbench is also provided to verify the functionality of the design through simulation.

## Project Files

* **`top.v`** - Top-level module that integrates the DSP48A1 components.
* **`dff_mux.v`** - Parameterized D flip-flop with multiplexer functionality used for pipelining and input selection.
* **`mux4x1.v`** - 4-to-1 multiplexer used for datapath/control selection.
* **`dsp_tb.v`** - Testbench used to simulate and verify the DSP48A1 implementation.
* **`Project Report.pdf`** - Detailed project report containing the design description, implementation, simulation results, and analysis.

## Main Features

* Verilog HDL implementation
* DSP48A1-inspired arithmetic datapath
* Multiplexer-based configurable data paths
* Pipelined registers using D flip-flops
* Functional verification using a dedicated testbench
* Designed for FPGA-oriented digital signal processing applications

## Simulation

The project can be simulated using a Verilog simulator such as QuestaSim/ModelSim.

Compile the design files and testbench, then run `dsp_tb.v` to verify the functionality and observe the simulation waveforms.

## Tools

* Verilog HDL
* QuestaSim / ModelSim
* *Xilinx FPGA Architecture

## Project Report

For a detailed explanation of the architecture, design methodology, and simulation results, refer to:

**`Project Report.pdf`**
