#!/bin/bash

REPORTS_DIR="reports/latest"
GENERATED_REPORTS_DIR="reports/generated"

mkdir -p "$GENERATED_REPORTS_DIR"

for jtl_file in "$REPORTS_DIR"/*.jtl; do
    if [[ -f "$jtl_file" ]]; then
        report_name=$(basename "$jtl_file" .jtl)
        echo "Generating report for $jtl_file"
        jmeter -g "$jtl_file" -o "$GENERATED_REPORTS_DIR/$report_name" || {
            echo "Failed to generate report for $jtl_file"
        }
    else
        echo "No JTL files found in $REPORTS_DIR"
    fi
done

echo "All reports generated."
