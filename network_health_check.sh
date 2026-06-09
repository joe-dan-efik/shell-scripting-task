#!/bin/bash
# Author: joe-dan-efik

REPORT_FILE="network_report.txt"
> "$REPORT_FILE"

log_output() {
    echo -e "$1" | tee -a "$REPORT_FILE"
}

log_output "=================================================="
log_output "               NETWORK HEALTH REPORT              "
log_output "=================================================="

log_output "\n[1] SERVER INFORMATION"
log_output "--------------------------------------------------"
log_output "Hostname:     $(hostname)"
log_output "Current User: $(whoami)"
log_output "Date and Time: $(date)"

log_output "\n[2] NETWORK INFORMATION"
log_output "--------------------------------------------------"
log_output "IP Address:      $(hostname -I | awk '{print $1}')"
log_output "Default Gateway: $(ip route | grep default | awk '{print $3}')"
log_output "DNS Server:      $(grep -i nameserver /etc/resolv.conf | head -n 1 | awk '{print $2}')"

log_output "\n[3] INTERNET CONNECTIVITY CHECK"
log_output "--------------------------------------------------"
ping -c 2 8.8.8.8 > /dev/null 2>&1 && log_output "Internet Connectivity: UP" || log_output "Internet Connectivity: DOWN"

log_output "\n[4] DNS RESOLUTION CHECK"
log_output "--------------------------------------------------"
(nslookup google.com > /dev/null 2>&1 || host google.com > /dev/null 2>&1) && log_output "DNS Resolution: WORKING" || log_output "DNS Resolution: FAILED"

log_output "\n[5] WEBSITE AVAILABILITY"
log_output "--------------------------------------------------"
for site in "google.com" "github.com" "amazon.com"; do
    (curl -s --connect-timeout 5 -I "https://$site" > /dev/null 2>&1 || ping -c 1 "$site" > /dev/null 2>&1) && log_output "$site : UP" || log_output "$site : DOWN"
done

log_output "\n=================================================="
log_output "Report generated successfully saved to: $REPORT_FILE"
log_output "=================================================="
