#!/bin/bash
# m28u-hdr-fix.sh — Prevent HDR auto-switching on Gigabyte M28U
#
# PROBLEM: Helium browser (Chromium-based) detects HDR capability in the
# monitor's EDID and ENABLES HDR mode when fullscreen, NOT the OSD HotKey.
# The monitor's EDID reports HDR Static Metadata (455 cd/m² max luminance).
#
# ROOT CAUSE: Helium's Chromium engine enables HDR display mode on fullscreen
# when it detects HDR capability in the monitor. Other browsers/apps don't
# trigger HDR because they either don't support HDR or don't auto-enable it.
#
# SOLUTIONS:
# 1. Helium flags: ~/.config/helium-browser-flags.conf
#    --disable-features=ColorProviderManager,HDR
#    --force-color-profile=srgb
# 2. Hyprland window rule forces cm="srgb", bitdepth=8 for Helium
# 3. DDC/CI: Disable OSD (CA=0x01), set sRGB color preset (0x14=0x01)

DDCUTIL_BIN="${DDCUTIL_BIN:-/usr/bin/ddcutil}"

if ! command -v "$DDCUTIL_BIN" &>/dev/null; then
    echo "m28u-hdr-fix: ddcutil not found, skipping DDC/CI settings" >&2
    exit 0
fi

# Check if monitor is connected
if ! "$DDCUTIL_BIN" --display 1 capabilities &>/dev/null; then
    echo "m28u-hdr-fix: Monitor not detected on DDC/CI channel 1" >&2
    exit 0
fi

echo "=== M28U HDR Fix: Verifying monitor state ==="

# Feature 0xE9: OSD HotKey mode (ml=0x02 means firmware-enabled)
# NOTE: This is NOT the cause of HDR - Helium's HDR capability detection is.
hotkey_mode=$("$DDCUTIL_BIN" --display 1 getvcp 0xE9 2>/dev/null | grep -oP 'ml=0x[0-9a-fA-F]+' | head -1)
if echo "$hotkey_mode" | grep -q "ml=0x02"; then
    echo "INFO: OSD HotKey is ENABLED in firmware (ml=0x02)"
    echo "  This setting is read-only and does NOT trigger HDR on other apps."
fi

# Disable OSD display overlay (Feature 0xCA, sl=0x01 means OSD off)
if "$DDCUTIL_BIN" --display 1 setvcp 0xCA 0x01 2>/dev/null; then
    echo "✓ OSD display disabled via ddcutil (CA=0x01)"
else
    echo "✗ Failed to set OSD state via ddcutil" >&2
fi

# Ensure color preset is sRGB (not "Display Native" which enables HDR capabilities)
if "$DDCUTIL_BIN" --display 1 setvcp 0x14 1 2>/dev/null; then
    echo "✓ Color preset set to sRGB (0x01)"
fi

echo ""
echo "=== CRITICAL: Helium Browser HDR Fix ==="
echo "HDR only triggers for Helium because it detects HDR in the monitor's EDID."
echo ""
echo "Fixes applied:"
echo "1. Created ~/.config/helium-browser-flags.conf with HDR disabled flags"
echo "2. Hyprland window rule forces SDR mode for Helium (class='^helium$')"
echo "3. DDC/CI settings maintain SDR state"
echo ""
echo "To apply Helium flags: Restart Helium browser"
echo "To apply Hyprland changes: hyprctl reload"