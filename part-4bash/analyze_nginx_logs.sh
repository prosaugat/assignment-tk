#!/bin/bash

set -euo pipefail

LOG_FILE="${1:-}"

if [[ -z "$LOG_FILE" ]]; then
    echo "Usage: $0 <nginx_access_log>"
    exit 1
fi

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Log file '$LOG_FILE' not found."
    exit 1
fi

# Count only valid nginx log lines (IP at beginning)
TOTAL_REQUESTS=$(awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {count++} END {print count+0}' "$LOG_FILE")

if [[ "$TOTAL_REQUESTS" -eq 0 ]]; then
    echo "No valid log entries found."
    exit 1
fi

# Top 10 IP Addresses
TOP_IPS=$(awk '
$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {
    print $1
}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10)

# Top 10 Endpoints
TOP_ENDPOINTS=$(awk -F\" '
NF >= 2 {
    split($2, req, " ")
    if (req[2] != "")
        print req[2]
}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10)

# Error Analysis
read ERR4XX ERR5XX <<< $(awk '
{
    status=$9
    if (status ~ /^4[0-9][0-9]$/) err4++
    if (status ~ /^5[0-9][0-9]$/) err5++
}
END {
    print err4+0, err5+0
}' "$LOG_FILE")

# Unique IP Addresses
UNIQUE_IPS=$(awk '
$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {
    print $1
}' "$LOG_FILE" | sort -u | wc -l)

# Calculate percentages
ERR4XX_PCT=$(awk -v e="$ERR4XX" -v t="$TOTAL_REQUESTS" \
'BEGIN { printf "%.2f", (e/t)*100 }')

ERR5XX_PCT=$(awk -v e="$ERR5XX" -v t="$TOTAL_REQUESTS" \
'BEGIN { printf "%.2f", (e/t)*100 }')

# Output Report
echo "=============================================================="
echo "                 NGINX LOG ANALYSIS REPORT"
echo "=============================================================="
echo
printf "%-25s %'d\n" "Total Requests:" "$TOTAL_REQUESTS"
printf "%-25s %'d\n" "Unique IPs:" "$UNIQUE_IPS"
printf "%-25s %'d (%s%%)\n" "4xx Errors:" "$ERR4XX" "$ERR4XX_PCT"
printf "%-25s %'d (%s%%)\n" "5xx Errors:" "$ERR5XX" "$ERR5XX_PCT"

echo
echo "Top 10 IP Addresses"
echo "--------------------------------------------------------------"
printf "%-5s %-20s %-15s\n" "Rank" "IP Address" "Requests"

echo "$TOP_IPS" | nl -w2 -s'. ' | while read rank count ip
do
    printf "%-5s %-20s %-15s\n" "$rank" "$ip" "$count"
done

echo
echo "Top 10 Endpoints"
echo "--------------------------------------------------------------"
printf "%-5s %-40s %-15s\n" "Rank" "Endpoint" "Requests"

echo "$TOP_ENDPOINTS" | nl -w2 -s'. ' | while read rank count endpoint
do
    printf "%-5s %-40s %-15s\n" "$rank" "$endpoint" "$count"
done

echo
echo "Report generated on: $(date)"
echo "=============================================================="
