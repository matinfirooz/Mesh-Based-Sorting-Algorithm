# Mesh-Based Sorting Algorithm

## Course: **Parallel Processing**  

**Academic Year:** 2024-2025 

**Assignment Title:** Implementing a Sorting Algorithm on Mesh Architecture  

## Overview
This assignment involves implementing a parallel sorting algorithm using a **mesh architecture**. The objective is to design a hardware model of a processor capable of sorting numbers within a **mesh structure**, then simulate and verify its functionality.

<div align="center">
  <img src="https://github.com/user-attachments/assets/d4166907-76e7-473e-82c0-ffbd20942dba" />
</div>


## Tasks & Requirements

### **1. Processor Design**
- Develop a **hardware model** of a processor that can sort numbers in a mesh structure.
- The processor should be implemented using **Verilog** or **VHDL**.
- The processor should support operations in the **middle** and on the **edges** of the mesh.

### **2. Mesh Architecture & Integration**
- Arrange multiple processors in a **4×4 mesh** configuration to create a complete sorting system.
- Implement communication between processors.
- The entire mesh should work under a **global clock signal**.

### **3. Implementation Guidelines**
- Each processor should include:
  - **Inputs/Outputs**: `clock`, `reset`, neighbor communication signals.
  - **Registers**: To store numerical values and tracking execution steps.
- Utilize a **state machine** to manage processor operations and execution flow.
- Use **parallel initialization** to load initial values into the processors simultaneously.
- Implement **2D array structures** for signal management.
- Utilize the `generate` statement in Verilog/VHDL to instantiate processors dynamically.

### **4. Simulation & Reporting**
- Simulate the developed model in a **preferred simulation environment**.
- Provide:
  - **Processor structure analysis**
  - **Mesh configuration details**
  - **Result analysis with waveform outputs**

## Evaluation Criteria

<div align="center">

| Task                              | Points |
|-----------------------------------|--------|
| Processor Design                  | 15     |
| Algorithm Implementation           | 25     |
| Processor Communication            | 15     |
| Simulation                         | 25     |
| Report                             | 20     |
| First Submission                   | 10     |
| Second Submission                  | 10     |
| **Total**                          | **100** |

</div>


## Submission Requirements
- Submit the following files:
  - **Verilog/VHDL source files** (`.v`, `.vhdl`)
  - **Testbench for simulation**
  - **Waveform outputs**
  - **Technical report (`.pdf` or `.docx`)** detailing:
    - Design methodology
    - Implementation details
    - Observations and results

## Notes
- The processor should be **generic**, meaning it can be used in different mesh sizes.
- Bonus points for implementing on a **hardware platform (FPGA/ASIC)**.

---
