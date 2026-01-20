# 🚀🕵️‍♂️ Bug-Bounty-Automation

Bug-Bounty-Automation is a Bash-based automated reconnaissance framework designed for bug bounty hunters, red teamers, and cybersecurity learners.
It helps identify an external attack surface by automating subdomain discovery, live host detection, JavaScript enumeration, subdomain takeover checks, visual reconnaissance, and port scanning.

The project focuses on simplicity, reliability, and real-world usability.

## ⚡Features

Subdomain enumeration using Subfinder and Assetfinder
Live host detection
JavaScript file discovery using subjs
Subdomain takeover detection using subjack
Website screenshots using gowitness
Port and service scanning using Nmap
Automatic dependency checks
Strict Bash error handling (set -euo pipefail)
Clean, per-target output structure

## 🔥Recon Workflow
Subdomain Enumeration
```
→ Alive Host Detection
→ JavaScript Discovery
→ Subdomain Takeover Check
→ Visual Recon (Gowitness)
→ Port & Service Scan (Nmap)
```

## 🌐Directory Structure

For a target like example.com:
```
example.com/
├── subdomains/
│   ├── found.txt        # All discovered subdomains
│   ├── alive.txt        # Live HTTP/HTTPS hosts
│   └── jsfiles.txt      # Discovered JavaScript files
├── scans/
│   ├── takeovers.txt    # Subdomain takeover results
│   └── nmap.txt         # Nmap scan output
└── screenshots/
    ├── gowitness.sqlite3
    └── *.jpeg
```

## 🔍Requirements

The following tools must be installed and available in your $PATH:
```
subfinder
assetfinder
httprobe
subjs
subjack
gowitness
nmap
sort
sed
```

### The script automatically checks for missing dependencies before execution.

## 🛡️Installation

Clone the repository:
``
git clone https://github.com/dhruva127/Bug-Bounty-Automation.git
cd Bug-Bounty-Automation
``

Make the script executable:
```
chmod +x auto-recon.sh
```
Usage

Run the script against a target domain:
```
./auto-recon.sh example.com
```

