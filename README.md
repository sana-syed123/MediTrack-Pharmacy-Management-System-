# 💊 MediTrack — Pharmacy Management System

<p align="center">

**A low-level pharmacy management application built with NASM x86 Assembly Language.**

*Managing medicines, monitoring inventory, processing sales, and tracking revenue — one instruction at a time.*

</p>

<p align="center">

![Assembly](https://img.shields.io/badge/Language-x86%20Assembly-blue?style=for-the-badge)
![NASM](https://img.shields.io/badge/Assembler-NASM-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Linux-black?style=for-the-badge&logo=linux&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-32--bit%20x86-purple?style=for-the-badge)

</p>

---

## 📌 Overview

**MediTrack** is a console-based Pharmacy Management System developed using **NASM (Netwide Assembler) and 32-bit x86 Assembly Language**. It simulates essential pharmacy operations, including medicine record management, stock monitoring, sales transactions, and revenue reporting.

The project demonstrates how low-level instructions, CPU registers, memory addressing, loops, conditional jumps, and Linux system calls can be combined to build a practical application.

This project was developed as part of the **CT073-3-2 Computer System Low Level Technique (CSLLT)** individual assignment.

## ✨ Key Features

### 💊 Medicine Management
- View available medicine records.
- Add new medicines.
- Search medicines by name.
- Remove existing medicine records.
- Manage medicine IDs, prices, names, and stock quantities.

### 📦 Inventory Management
- View current stock levels.
- Identify medicines that have reached the low-stock threshold.
- Restock existing medicines.
- Track inventory through fixed-size medicine arrays.

### 🛒 Sales Processing
- Select medicines and specify purchase quantities.
- Calculate subtotals and apply quantity-based discounts.
- Accept customer payments.
- Calculate change.
- Update stock following successful payment.

### 📊 Sales Summary
- View the total number of completed sales.
- Calculate total gross revenue.
- Track the total quantity of items sold.
- Monitor the total discounts offered.

### ⚙️ Low-Level Programming
- Register-based operations using x86 registers.
- Memory management using arrays and fixed-size data structures.
- Conditional branching with `CMP` and `JE`.
- Loops and procedures for searching and processing records.
- Linux system calls for program termination.

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| NASM | Assemble x86 Assembly source code |
| x86 Assembly | Implement application logic and data handling |
| Linux / Ubuntu | Runtime environment |
| WSL2 | Run Ubuntu on Windows |
| GNU `ld` | Link the 32-bit object file into an executable |
| Git & GitHub | Version control and project hosting |

## 🚀 Getting Started

### Prerequisites

You will need:
- Windows with WSL2 and Ubuntu, or a suitable Linux environment.
- NASM assembler.
- GNU linker (`ld`) and supporting build tools.

### 1. Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
cd YOUR-REPOSITORY
```

Replace the repository URL with your actual GitHub repository URL.

### 2. Install the required tools

On Ubuntu or WSL2, run:

```bash
sudo apt update
sudo apt install nasm binutils
```

### 3. Assemble the source code

```bash
nasm -f elf32 meditrack.asm -o meditrack.o
```

The `-f elf32` option generates a 32-bit ELF object file.

### 4. Link the executable

```bash
ld -m elf_i386 meditrack.o -o meditrack
```

The linker creates a 32-bit executable from the object file.

### 5. Run MediTrack

```bash
./meditrack
```

**Note:** These commands assume the source file is named `meditrack.asm` and uses Linux-compatible 32-bit system calls.

## 🖥️ Using the Application

After launching MediTrack, the main menu provides five options:

| Option | Function |
|---|---|
| `1` | Medicine Management |
| `2` | Inventory Management |
| `3` | Process Sale |
| `4` | Sales Summary |
| `5` | Exit |

Enter the corresponding menu number and follow the on-screen instructions.

## 🧠 Core Assembly Concepts

One of the main goals of MediTrack is to demonstrate how application logic works at the machine level.

| Concept | Application in MediTrack |
|---|---|
| Registers | Store values and intermediate results during operations |
| Arrays | Store medicine IDs, prices, stock, and names |
| `CMP` | Compare values and determine program flow |
| `JE` | Jump to a matching menu option or code branch |
| Loops | Search medicine records and process inventory |
| Procedures | Organize reusable operations such as searching for free slots |
| Memory addressing | Access medicine records using array indices and offsets |
| Linux system calls | Terminate the program through `int 0x80` |

### Example: Finding an Available Medicine Slot

The `find_free_slot` procedure searches the medicine array for an unused slot. A medicine ID of `0` indicates that the slot is available. The procedure returns the available index in `EAX`, or `-1` when all ten slots are occupied.

This demonstrates how loops, comparisons, registers, and memory addressing work together in Assembly Language.

## 🔮 Future Improvements

Potential enhancements include:

- [ ] Medicine expiry-date tracking.
- [ ] Stronger input validation and error handling.
- [ ] Expanded medicine storage capacity.
- [ ] Persistent storage so records can survive program restarts.
- [ ] More detailed sales reports and transaction history.
- [ ] Improved inventory alerts and reporting.

## 🎯 Learning Outcomes

Through this project, I gained practical experience with:

- Writing and assembling NASM x86 Assembly code.
- Understanding processor registers and memory addressing.
- Implementing loops, conditional jumps, and procedures.
- Managing structured records using fixed-size arrays.
- Performing arithmetic calculations for sales and discounts.
- Using Linux system calls and the GNU linker.
- Applying low-level programming concepts to a real-world scenario.

## 👩‍💻 Author

**Sana Syed**

Computer Science Student

Project: CT073-3-2 Computer System Low Level Technique

GitHub: [@sana-syed123](https://github.com/sana-syed123)

---

<p align="center">

**Built with 💻, Assembly instructions, and a passion for understanding how computers work under the hood.**

</p>
