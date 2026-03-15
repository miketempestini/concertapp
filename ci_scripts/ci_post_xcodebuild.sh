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
        # .xcdistributionlogs are directories containing log files
        find "$logdir" -type f -name "*.log" -o -name "*.txt" -o -name "*.plist" | while read logfile; do
            echo "--- $logfile ---"
            cat "$logfile" 2>/dev/null
            echo ""
        done
        # Also try reading any file inside .xcdistributionlogs directories
        find "$logdir" -name "*.xcdistributionlogs" -type d | while read distlogdir; do
            echo "--- Distribution log dir: $distlogdir ---"
            find "$distlogdir" -type f | while read innerfile; do
                echo "--- $innerfile ---"
                cat "$innerfile" 2>/dev/null
                echo ""
            done
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
        echo "--- Code signature info ---"
        codesign -dvvv "$archive/Products/Applications/"*.app 2>&1
        echo ""
    fi
done

echo "=== Done ==="
