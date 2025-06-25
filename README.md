# VaultScan GitHub Action

> Seamlessly integrate secrets detection into your GitHub workflows with one line.

[![Version](https://img.shields.io/badge/VaultScan-v1.2-blue)](https://github.com/vaultscanhq/vaultscan-community)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

> ⭐ Star / 👀 Watch / 🍴 Fork this project if you find it useful!

**VaultScan GitHub Action** is a reusable GitHub Action that automatically scans your repository for secrets and credentials using the [VaultScan Community Edition](https://github.com/vaultscanhq/vaultscan-community).

---

## 🚀 Coming Soon: VaultScan Pro

VaultScan Pro is the advanced version of VaultScan, designed for security-conscious teams and enterprises.

**🔐 What's coming:**
- Team-based scan reports
- GitHub org-wide scanning
- REST API for dashboards and automation
- False positive filtering & custom rules
- Web dashboard (in development)

📬 [**Join the Waitlist Here**](https://docs.google.com/forms/d/e/1FAIpQLSdKnjmm-qyHQoqp6gFu7k0wkNJ1Nt1DIx4BVMYxyWSfWLJWVQ/viewform?usp=header)

---

## 📌 Purpose

This action integrates VaultScan directly into your CI/CD pipeline to detect sensitive information (like AWS keys, Slack tokens, GitHub tokens, and private keys) in your codebase before it reaches production.

---

## ⚙️ Setup Instructions

Create `.github/workflows/scan.yml` and paste:

```yaml
name: VaultScan Secrets Detection

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  vaultscan:
    name: Run VaultScan on Codebase
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Run VaultScan via GitHub Action
        uses: vaultscanhq/vaultscan-action@v1.2
```
---

## 📸 Screenshots

### 🖥️ CLI Output
![CLI Output](assets/cli-output.png)

### ⚙️ GitHub Action Logs
![GitHub Action](assets/github-action.png)

### 🛒 GitHub Marketplace Listing
![Marketplace](assets/marketplace.png)

---

## 🧪 What This Does
- Clones the latest VaultScan
- Installs its Python dependencies
- Runs the scanner on your repo with --verbose logs
- Outputs any detected secrets in the Actions tab

---
## 📦 What It Detects
- AWS Access & Secret Keys
- Slack Tokens
- GitHub Tokens
- Private Keys
- Generic API Keys
---

## 🔗 VaultScan CLI
This action wraps around the VaultScan Community Edition CLI. You can also run VaultScan locally:

```bash
git clone https://github.com/vaultscanhq/vaultscan-community.git
cd vaultscan-community
pip install -r requirements.txt
python -m vaultscan.main --path . --verbose
```
---

## ⚙️ Advanced

- Respects `.vaultscanignore` file.
- Uses `--verbose` flag for clearer logging.
- Powered by [VaultScan Community Edition v1.2](https://github.com/vaultscanhq/vaultscan-community/tree/v1.2)

---

## 📜 License

Licensed under the [Apache 2.0 License](LICENSE)

---
## 🛡️ Author & Attribution

**Developed by [Pavan Gajjala](https://github.com/pavangajjala)**
Unauthorized removal of attribution is a license violation.

---

## 🤝 Community Contributions

This is a community edition. Contributions, suggestions, and improvements are welcome!

**📣 Report misuse or unauthorized rebranding [GitHub issues](https://github.com/vaultscanhq/vaultscan-action/issues)**