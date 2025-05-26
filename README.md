# CIROH DevCon 2025 Workshop: Hydrological Model Calibration in the NGIAB Ecosystem

[![Workshop](https://img.shields.io/badge/Workshop-CIROH%20DevCon%202025-blue.svg)](https://ciroh.ua.edu/devconference/)
[![NextGen](https://img.shields.io/badge/NextGen-Framework-green.svg)](https://github.com/NOAA-OWP/ngen)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://docs.docker.com/engine/install/)

**"How do I calibrate, regionalize and share the calibrated parameters in a NextGen Framework ecosystem"**

* **📅 Date**: Thursday, May 29, 2025
* **⏰ Time**: 1:30 PM – 3:00 PM (US Eastern Time)
* **📍 Location**: UVM Dudley H. Davis Center – Level 4, 590 Main Street, Burlington, VT 05405
* **🏛️ Organized by**: [Cooperative Institute for Research to Operations in Hydrology - CIROH](https://ciroh.ua.edu/devconference/)

---

## 🚀 Quick Start

**Ready to jump in?** Choose your path:

| I want to... | Go to... |
|--------------|----------|
| **Start calibrating immediately** | [**🚀 Quickstart Guide**](../../wiki/Quickstart-Guide) |
| **Understand the process first** | [📚 Step-by-Step Instructions](../../wiki/Step-by-Step-Instructions) |
| **Learn about NextGen** | [🔍 What is NextGen?](../../wiki/What-is-NextGen) |
| **Modify the code** | [⚙️ Development Setup](../../wiki/Development-Setup) |

---

## 🎯 Workshop Purpose

This hands-on workshop provides comprehensive guidance for hydrological model calibration, regionalization, and parameter sharing within the NextGen In A Box (NGIAB) ecosystem. You'll gain practical experience using open-source tools with pre-configured datasets.

### What You'll Learn

- ✅ **Model Calibration Fundamentals** - Theory and practice of improving hydrological model accuracy
- ✅ **Regionalization Techniques** - Apply calibrated parameters to ungauged basins
- ✅ **Hands-on NextGen Experience** - Complete calibration workflows using real tools and data
- ✅ **Parameter Management** - Share and collaborate on calibrated parameters effectively
- ✅ **Best Practices** - Learn from experts and discuss real-world challenges

### Workshop Workflow

![Workshop Workflow](./Information/figures/Workflow-Figure.png)

*Complete workflow from data preparation through calibration to validation and parameter sharing*

---

## 🛠️ Prerequisites

**Minimum Requirements:**
- [Docker](https://docs.docker.com/engine/install/) (for running containerized tools)
- [UV](https://docs.astral.sh/uv/getting-started/installation/) (Python package manager)

**For Workshop Participants:**
- Access to provided Jetstream Virtual Machines (instructions emailed before workshop)
- Pre-installed data at `/home/exouser/workshop/calibration/provo-10154200`

**For Local Setup:**
- Download workshop data: `https://communityhydrofabric.s3.us-east-1.amazonaws.com/example_data/provo-10154200.tar.gz`

> 📋 **Complete setup guide**: [Pre-Workshop Checklist](../../wiki/Pre-Workshop-Checklist)

---

## 📚 Workshop Resources

### 🚀 Get Started
- [**Quickstart Guide**](../../wiki/Quickstart-Guide) - Start calibrating in 5 minutes
- [Step-by-Step Instructions](../../wiki/Step-by-Step-Instructions) - Detailed tutorial
- [Workshop Materials](../../wiki/Workshop-Materials) - Slides and datasets

### 🔧 Understanding the Tools
- [What is NextGen?](../../wiki/What-is-NextGen) - Framework overview
- [Tools and Modules](../../wiki/Tools-and-Modules) - Component explanations
- [Workflow Process](../../wiki/Workflow-Process) - How everything connects

### 🔬 Advanced Topics
- [Development Setup](../../wiki/Development-Setup) - Modify and extend tools
- [Directory Structure](../../wiki/Directory-Structure) - File organization reference

### 📞 Support
- [Contact Information](../../wiki/Contact-and-Acknowledgment) - Get help and support
- [GitHub Issues](https://github.com/skoriche/NGIAB-Calibration-DevCon25/issues) - Report bugs or ask questions

---

## 🏃‍♂️ 5-Minute Start

**On Jetstream VMs:**
```bash
cd /home/exouser/workshop/calibration/provo-10154200
uvx ngiab-cal . -g 10154200 --run -i 20
```

**On Local Systems:**
```bash
wget https://communityhydrofabric.s3.us-east-1.amazonaws.com/example_data/provo-10154200.tar.gz
tar -xzf provo-10154200.tar.gz && cd provo-10154200
uvx ngiab-cal . -g 10154200 --run -i 20
```

That's it! Your first calibration will complete in ~5-10 minutes.

> 🔍 **Want details?** See the [Quickstart Guide](../../wiki/Quickstart-Guide) for complete instructions.

---

## 🧩 The NGIAB Ecosystem

This workshop uses four integrated tools:

| Tool | Purpose | Type |
|------|---------|------|
| **NGIAB-Data-Preprocess** | Prepare hydrofabric and forcing data | Python CLI |
| **NGIAB-Cal** | Configure and run calibration | Python CLI |
| **NGIAB** | NextGen framework container | Docker Image |
| **NGEN-Cal** | Calibration algorithms and analysis | Docker Image |

> 🔧 **Learn more**: [Tools and Modules](../../wiki/Tools-and-Modules)

---

## 📖 What is NextGen?

The **Next Generation Water Resources Modeling Framework (NextGen)** is a model-agnostic, standards-based framework that enables:

- **🔗 Model Interoperability** - Connect different hydrological models seamlessly
- **🏗️ Standards-Based Design** - Consistent interfaces and data formats
- **🌐 Multi-language Support** - C++, C, Fortran, Python models
- **☁️ Flexible Deployment** - Cloud, HPC, or local environments

> 📚 **Learn more**: [What is NextGen?](../../wiki/What-is-NextGen)

---

## 🏗️ For Developers

### Quick Development Setup

```bash
# Clone and setup
git clone https://github.com/skoriche/NGIAB-Calibration-DevCon25.git
cd NGIAB-Calibration-DevCon25
./dev_install.sh
```

### What You Can Modify

| Modify | Tool to Change | Also Update |
|--------|---------------|-------------|
| Data processing, forcing inputs | `ngiab_data_preprocess` | - |
| Calibration CLI, default configs | `ngiab-cal` | - |
| NextGen core, add models | `NGIAB-CloudInfra` | - |
| Calibration algorithms | `ngen-cal` | `NGIAB-CloudInfra` |

> ⚙️ **Complete guide**: [Development Setup](../../wiki/Development-Setup)

---

## 🤝 Getting Help

### During the Workshop
- Ask instructors and assistants
- Use workshop Slack/chat channels
- Collaborate with fellow participants

### After the Workshop
- [Open GitHub Issues](https://github.com/skoriche/NGIAB-Calibration-DevCon25/issues) for bugs/questions
- Email contacts: [sakoriche@ua.edu](mailto:sakoriche@ua.edu), [jcunningham8@ua.edu](mailto:jcunningham8@ua.edu)
- Browse the [complete wiki](../../wiki) for detailed documentation

---

## 📝 License and Acknowledgment

This workshop was supported by the **Cooperative Institute for Research to Operations in Hydrology (CIROH)** with funding from the **NOAA Cooperative Institute Program**.

The statements, findings, conclusions, and recommendations are those of the author(s) and do not necessarily reflect the opinions of NOAA.

> 📞 **Full contact info**: [Contact and Acknowledgment](../../wiki/Contact-and-Acknowledgment)

---

## 🗂️ Repository Structure

```
├── 📁 Data/                    # Workshop datasets (Provo River example)
├── 📁 Information/             # Workshop materials and figures
├── 📁 Slides/                  # Presentation slides
├── 📁 tools/                   # Source code submodules
│   ├── NGIAB_data_preprocess/  # Data preparation tool
│   ├── ngiab-cal/              # Calibration CLI tool
│   ├── NGIAB-CloudInfra/       # Docker build configurations
│   └── ngen-cal/               # Calibration algorithms
└── 📄 dev_install.sh           # Development setup script
```

---

**🚀 Ready to start?** Jump to the [**Quickstart Guide**](../../wiki/Quickstart-Guide) now!
