#!/bin/bash
set -x

echo "=== Xcode Cloud Export Diagnostic Logs ==="
echo ""

echo "=== Export Options Plists ==="
for plist in /Volumes/workspace/ci/*.plist; do
    if [ -f "$plist" ]; then
        echo "--- $plist ---"
        cat "$plist"
        echo ""
    fi
done

echo "=== Export Archive Logs ==="
for logdir in /Volumes/workspace/tmp/*-export-archive-logs; do
    if [ -d "$logdir" ]; then
        echo "--- Log directory: $logdir ---"
        for logfile in "$logdir"/*; do
            if [ -f "$logfile" ]; then
                echo "--- $logfile ---"
                cat "$logfile"
                echo ""
            fi
        done
    fi
done

echo "=== Archive Info ==="
for archive in /Volumes/workspace/tmp/*.xcarchive; do
    if [ -d "$archive" ]; then
        echo "--- $archive/Info.plist ---"
        cat "$archive/Info.plist" 2>/dev/null
        echo ""
        echo "--- Embedded provisioning profiles ---"
        find "$archive" -name "*.mobileprovision" -exec echo "Found: {}" \;
        echo ""
        echo "--- Entitlements in binary ---"
        codesign -d --entitlements - "$archive/Products/Applications/"*.app 2>&1
        echo ""
    fi
done

echo "=== Done ==="
