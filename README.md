# RRAM Crossbar FPGA Controller

Verilog-based FPGA control and read/write interface for an 8×8 RRAM crossbar, implemented on the Terasic DE0-Nano FPGA and verified using ModelSim and Quartus Prime.

## Overview

This project implements the digital control infrastructure for an RRAM crossbar array, including cell selection, read/write pulse generation, row/column decoding, analog MUX/switch control, and ADC interfacing.

The design focuses on generating precise high-speed read/write control pulses and coordinating the digital interface with the analog RRAM readout circuitry.

## Key Features

- 8×8 RRAM crossbar cell-selection controller
- Verilog RTL implementation with FSM-based control
- Row/column decoding and analog MUX/switch control
- High-speed read/write pulse generation
- **5 ns read/write pulses at 50 MHz**
- ADC/SPI control for data acquisition
- ModelSim functional verification
- Quartus Prime synthesis and FPGA implementation
- Target platform: **Terasic DE0-Nano / Cyclone IV FPGA**

## Architecture

```text
             Verilog RTL Controller
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
   Row Decoder   Column Decoder   Pulse Generator
        │             │             │
        └─────────────┼─────────────┘
                      ▼
              Analog MUX / Switch
                      │
                      ▼
                8×8 RRAM Array
                      │
                      ▼
                Analog Readout
                      │
                      ▼
                 ADC / SPI
                      │
                      ▼
                Digital Data
