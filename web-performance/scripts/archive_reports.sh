#!/bin/bash

ARCHIVE_DIR="reports/archive/$(date +'%Y-%m-%d_%H-%M-%S')"

echo "Archiving reports to $ARCHIVE_DIR"
mkdir -p "$ARCHIVE_DIR"

if [[ -d "reports/latest" ]]; then
    mv reports/latest/* "$ARCHIVE_DIR"/
    echo "Reports archived."
else
    echo "No reports found to archive."
fi
