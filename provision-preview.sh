#!/bin/bash
# This is sourced by ipa-preview for .mobileprovision files

# Extract plist from CMS
security cms -D -i "$INPUT_FILE" -o "$PROFILE_PLIST" 2>/dev/null

if [ ! -f "$PROFILE_PLIST" ]; then
    echo "Error: Failed to parse provisioning profile"
    exit 1
fi

PROFILE_NAME=$(defaults read "$PROFILE_PLIST" Name 2>/dev/null || echo "Unknown")
TEAM_NAME=$(defaults read "$PROFILE_PLIST" TeamName 2>/dev/null || echo "Unknown")
TEAM_ID=$(defaults read "$PROFILE_PLIST" TeamIdentifier 2>/dev/null | sed 's/[()]//g' | awk '{print $1}' || echo "Unknown")
APP_ID_NAME=$(defaults read "$PROFILE_PLIST" AppIDName 2>/dev/null || echo "Unknown")
PROFILE_UUID=$(defaults read "$PROFILE_PLIST" UUID 2>/dev/null || echo "Unknown")
EXPIRY=$(defaults read "$PROFILE_PLIST" ExpirationDate 2>/dev/null || echo "Unknown")
CREATION=$(defaults read "$PROFILE_PLIST" CreationDate 2>/dev/null || echo "Unknown")
PLATFORM=$(defaults read "$PROFILE_PLIST" Platform 2>/dev/null | sed 's/[()]//g' | tr '\n' ',' | sed 's/,$//' || echo "iOS")

# Determine profile type
HAS_DEVICES=$(defaults read "$PROFILE_PLIST" ProvisionedDevices 2>/dev/null)
GET_TASK_ALLOW=$(defaults read "$PROFILE_PLIST" Entitlements:get-task-allow 2>/dev/null || echo "0")
PROVISIONS_ALL=$(defaults read "$PROFILE_PLIST" ProvisionsAllDevices 2>/dev/null || echo "0")

if [ "$PROVISIONS_ALL" == "1" ]; then
    PROFILE_TYPE="Enterprise"
elif [ -n "$HAS_DEVICES" ]; then
    if [ "$GET_TASK_ALLOW" == "1" ]; then
        PROFILE_TYPE="Development"
    else
        PROFILE_TYPE="Distribution (Ad Hoc)"
    fi
else
    PROFILE_TYPE="Distribution (App Store)"
fi

# Extract devices
DEVICES=$(defaults read "$PROFILE_PLIST" ProvisionedDevices 2>/dev/null | grep -v "(" | grep -v ")" | sed 's/^[[:space:]]*//' | sed '/^$/d' | sort)
DEVICE_COUNT=0
DEVICES_HTML=""
if [ -n "$DEVICES" ]; then
    DEVICE_COUNT=$(echo "$DEVICES" | wc -l | tr -d ' ')
    DEVICES_HTML="<div class='section'><h2>Devices ($DEVICE_COUNT)</h2><div class='device-list'>"
    while IFS= read -r device; do
        device=$(echo "$device" | sed 's/[,;]$//')
        DEVICES_HTML="$DEVICES_HTML<div class='device-row'>$device</div>"
    done <<< "$DEVICES"
    DEVICES_HTML="$DEVICES_HTML</div></div>"
fi

# Extract entitlements
ENTITLEMENTS_HTML=""
/usr/libexec/PlistBuddy -c "Print Entitlements" "$PROFILE_PLIST" -x > "$ENTITLEMENTS_PLIST" 2>/dev/null
if [ -f "$ENTITLEMENTS_PLIST" ]; then
    ENTITLEMENTS_TEXT=$(plutil -convert json -o - "$ENTITLEMENTS_PLIST" 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for key in sorted(data.keys()):
        val = data[key]
        if isinstance(val, bool):
            val = 'true' if val else 'false'
        elif isinstance(val, list):
            if len(val) == 0:
                val = '()'
            else:
                val = '(' + ', '.join(str(v) for v in val) + ')'
        elif isinstance(val, dict):
            if len(val) == 0:
                val = '{}'
            else:
                val = '{' + ', '.join(f'{k}: {v}' for k,v in val.items()) + '}'
        print(f'{key} = {val}')
except:
    pass
" 2>/dev/null)
    if [ -n "$ENTITLEMENTS_TEXT" ]; then
        ENTITLEMENTS_HTML="<div class='section'><h2>Entitlements</h2><pre class='entitlements'>$ENTITLEMENTS_TEXT</pre></div>"
    fi
fi

# Generate HTML for provisioning profile
cat > "$OUTPUT_HTML" << 'HTMLEND'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Provisioning Profile</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
            padding: 40px;
            background: #f5f5f7;
            color: #1d1d1f;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }
        .header {
            margin-bottom: 24px;
            padding-bottom: 24px;
            border-bottom: 2px solid #e5e5e7;
        }
        .header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 12px;
        }
        .badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge.development { background: rgba(0, 122, 255, 0.15); color: #007aff; }
        .badge.adhoc { background: rgba(175, 82, 222, 0.15); color: #af52de; }
        .badge.appstore { background: rgba(52, 199, 89, 0.15); color: #34c759; }
        .badge.enterprise { background: rgba(255, 149, 0, 0.15); color: #ff9500; }
        .badge.platform { background: rgba(90, 200, 250, 0.15); color: #5ac8fa; }
        .section {
            margin-bottom: 32px;
        }
        .section h2 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #1d1d1f;
        }
        .info-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f7;
        }
        .info-label {
            width: 200px;
            font-size: 15px;
            color: #86868b;
            flex-shrink: 0;
        }
        .info-value {
            font-size: 15px;
            color: #1d1d1f;
            font-weight: 500;
        }
        .device-list {
            background: #f5f5f7;
            border-radius: 8px;
            padding: 16px;
        }
        .device-row {
            font-family: 'SF Mono', Monaco, 'Courier New', monospace;
            font-size: 13px;
            padding: 8px 0;
            border-bottom: 1px solid #e5e5e7;
        }
        .device-row:last-child { border-bottom: none; }
        .entitlements {
            background: #f5f5f7;
            border-radius: 8px;
            padding: 16px;
            font-family: 'SF Mono', Monaco, 'Courier New', monospace;
            font-size: 12px;
            line-height: 1.6;
            overflow-x: auto;
            white-space: pre-wrap;
            word-break: break-all;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Provisioning Profile</h1>
HTMLEND

PROFILE_BADGE_CLASS=$(echo "$PROFILE_TYPE" | tr '[:upper:]' '[:lower:]' | tr -d ' ()' )
cat >> "$OUTPUT_HTML" << HTMLEND
            <div class="badges">
                <span class="badge platform">$PLATFORM</span>
                <span class="badge $PROFILE_BADGE_CLASS">$PROFILE_TYPE</span>
HTMLEND
if [ "$DEVICE_COUNT" -gt 0 ]; then
    echo "                <span class=\"badge platform\">$DEVICE_COUNT devices</span>" >> "$OUTPUT_HTML"
fi
cat >> "$OUTPUT_HTML" << HTMLEND
            </div>
        </div>
        <div class="section">
            <h2>Profile Information</h2>
            <div class="info-row">
                <div class="info-label">Profile Name</div>
                <div class="info-value">$PROFILE_NAME</div>
            </div>
            <div class="info-row">
                <div class="info-label">UUID</div>
                <div class="info-value">$PROFILE_UUID</div>
            </div>
            <div class="info-row">
                <div class="info-label">Team</div>
                <div class="info-value">$TEAM_NAME ($TEAM_ID)</div>
            </div>
            <div class="info-row">
                <div class="info-label">App ID</div>
                <div class="info-value">$APP_ID_NAME</div>
            </div>
            <div class="info-row">
                <div class="info-label">Created</div>
                <div class="info-value">$CREATION</div>
            </div>
            <div class="info-row">
                <div class="info-label">Expires</div>
                <div class="info-value">$EXPIRY</div>
            </div>
        </div>
HTMLEND

if [ -n "$ENTITLEMENTS_HTML" ]; then
    echo "$ENTITLEMENTS_HTML" >> "$OUTPUT_HTML"
fi

if [ -n "$DEVICES_HTML" ]; then
    echo "$DEVICES_HTML" >> "$OUTPUT_HTML"
fi

cat >> "$OUTPUT_HTML" << 'HTMLEND'
    </div>
</body>
</html>
HTMLEND

# Open in browser
open "$OUTPUT_HTML"

# Keep temp file
trap "rm -rf $TEMP_DIR" EXIT
tail -f /dev/null
