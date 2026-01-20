#!/bin/bash

set -euo pipefail

domain="${1:-}"

RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[0m"

# -------------------- ARGUMENT CHECK --------------------
if [[ -z "$domain" ]]; then
    echo -e "${RED}[-] Usage: $0 <domain>${RESET}"
    exit 1
fi

# -------------------- DEPENDENCY CHECK --------------------
REQUIRED_TOOLS=(
    subfinder
    assetfinder
    httprobe
    subjs
    subjack
    gowitness
    nmap
    sort
    sed
)

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${RED}[-] Required tool '$tool' not found in PATH${RESET}"
        exit 1
    fi
done

echo -e "${GREEN}[+] All required tools are installed${RESET}"

# -------------------- DIRECTORY SETUP --------------------
subdomain_path="$domain/subdomains"
scan_path="$domain/scans"
screenshot_path="$domain/screenshots"

mkdir -p "$subdomain_path" "$scan_path" "$screenshot_path"

# -------------------- SUBDOMAIN ENUM --------------------
echo -e "${RED}[+] Launching Subfinder...${RESET}"
subfinder -silent -d "$domain" > "$subdomain_path/found.txt"

echo -e "${RED}[+] Launching Assetfinder...${RESET}"
assetfinder --subs-only "$domain" >> "$subdomain_path/found.txt"

sort -u "$subdomain_path/found.txt" -o "$subdomain_path/found.txt"

# -------------------- ALIVE HOSTS --------------------
echo -e "${RED}[+] Finding alive subdomains...${RESET}"
cat "$subdomain_path/found.txt" | \
    httprobe -prefer-https | \
    sed 's|https\?://||' > "$subdomain_path/alive.txt"

# -------------------- JAVASCRIPT DISCOVERY --------------------
echo -e "${RED}[+] Extracting JavaScript files (subjs)...${RESET}"
cat "$subdomain_path/alive.txt" | \
    subjs > "$subdomain_path/jsfiles.txt"

# -------------------- SUBDOMAIN TAKEOVER CHECK --------------------
echo -e "${RED}[+] Checking for subdomain takeovers (subjack)...${RESET}"
subjack \
    -w "$subdomain_path/found.txt" \
    -ssl \
    -t 50 \
    -o "$scan_path/takeovers.txt"
    
# -------------------- SCREENSHOT WEB SERVICES --------------------
echo -e "${RED}[+] Taking screenshots with gowitness...${RESET}"

awk '{print "https://" $0 "\nhttp://" $0}' "$subdomain_path/alive.txt" | \
    gowitness scan file \
        -f - \
        --threads 6 \
        --timeout 10 \
        --screenshot-path "$screenshot_path"



# -------------------- NMAP SCAN --------------------
echo -e "${RED}[+] Running Nmap on alive subdomains...${RESET}"
nmap -iL "$subdomain_path/alive.txt" \
     -T4 \
     --top-ports 1000 \
     -sV \
     -oN "$scan_path/nmap.txt"

echo -e "${GREEN}[+] Recon completed for $domain${RESET}"
