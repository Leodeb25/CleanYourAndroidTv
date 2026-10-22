# Android TV Debloat & Apple TV Launcher Guide

**Device:** Xiaomi MiTV-AXSO0 (Mi TV 4A Pro / 4C Pro)  
**Codename:** `dangal`  
**Android Version:** 9 (Pie, SDK 28, Firmware `PI.6036`)  
**IP Address:** `192.168.29.18`

---

## 1. Summary of Changes

1. **Backups Created:**
   - Full package list: `backup/packages-all.txt`
   - Initial disabled list: `backup/packages-disabled.txt`
   - System properties (`getprop`): `backup/getprop.txt`
   - Global / Secure / System Settings: `backup/settings-*.txt`
   - Baseline screenshot: `shots/00-baseline.png`

2. **Debloated Packages:**
   - 33 telemetry, PatchWall, sponsored rows, background cleaners, and unused preloaded apps safely disabled using `pm disable-user --user 0` (never uninstalled).
   - Essential inputs, TV app, HDMI routing, Gboard, Bluetooth remote, and Google Play Store/Services are completely preserved.
   - Per your preference: **YouTube & YouTube Music** and **Xiaomi System Firmware Update Service** were kept active.

3. **Apple TV 4K Style Launcher:**
   - Package: `com.gathin.tvhome`
   - Clean, dark minimal home screen with fluid glass highlights.
   - Pinned 4-slot dock row: YouTube, YouTube Music, Media Explorer, and Play Store.
   - Top pills for Inputs (HDMI / AV / Live TV switching), Wi-Fi, and Settings.
   - Verified across reboots, app launches, and remote navigation.

4. **Ad-blocking Private DNS:**
   - Configured to `dns.adguard-dns.com` (Hostname mode) to block in-app tracking and banner ads without root or VPN.

---

## 2. Restoring Apps & Reverting Changes

### Re-enable a Specific App
To re-enable any single app (e.g. Disney+ Hotstar or Prime Video), run:
```bash
# Using the restore script:
./cleanyourtv/backup/restore_tv.sh in.startv.hotstar

# Or directly via tv.py:
TV_HOST=192.168.29.18 cleanyourtv/tools/venv/bin/python cleanyourtv/tools/tv.py "pm enable <package_name>"
```

Common package names:
- Disney+ Hotstar: `in.startv.hotstar`
- Amazon Prime Video: `com.amazon.amazonvideo.livingroom`
- SonyLIV: `com.sonyliv`
- Google Assistant: `com.google.android.katniss`
- Chromecast built-in: `com.google.android.apps.mediashell`
- Miracast / Screen Mirroring: `com.xiaomi.wfdsinkhelperservice`

### Full Factory Restore
To revert all disabled packages, restore the stock Google TV launcher as default Home, and reset DNS:
```bash
./cleanyourtv/backup/restore_tv.sh
```

---

## 3. Customizing the Launcher

### Changing Dock Apps & Columns
The dock and grid layout can be adjusted in:
`cleanyourtv/launcher/app/src/main/res/values/config.xml`

- **Dock Apps:** Edit the `<string-array name="dock_apps">` list to change which apps appear in the dock row and their order.
- **Columns:** Change `<integer name="columns">4</integer>` (supported: 4, 5, 6, 7).
- **Hidden Apps:** Add packages to `<string-array name="hidden_apps">` to hide them from the app drawer grid.

After making edits, apply them with:
```bash
./cleanyourtv/build_and_install.sh
```

### Changing Wallpapers & Themes
CleanYourTV includes built-in themes in `cleanyourtv/themes/` (e.g. `aurora`, `scenes`, `oled`, `flow`).
To push a theme and wallpaper to the TV:
```bash
TV_HOST=192.168.29.18 cleanyourtv/tools/theme.sh cleanyourtv/themes/scenes
```
To set a custom wallpaper, push a 1920x1080 or 1280x720 JPG/PNG:
```bash
TV_HOST=192.168.29.18 cleanyourtv/tools/venv/bin/python cleanyourtv/tools/b64push.py /path/to/my_wallpaper.jpg /sdcard/Android/data/com.gathin.tvhome/files/wallpaper.jpg
```

---

## 4. Reverting AdGuard Private DNS
If an app requires standard ISP DNS or if you wish to disable Private DNS:
```bash
TV_HOST=192.168.29.18 cleanyourtv/tools/venv/bin/python cleanyourtv/tools/tv.py "settings put global private_dns_mode opportunistic"
```

---

## 5. Security: Closing Network ADB

Leaving port 5555 open over Wi-Fi exposes ADB to any device on your local network. Now that configuration is verified:

1. On your TV, navigate to:
   **Settings** → **Device Preferences** → **Developer Options**
2. Toggle **USB debugging** to **OFF** (and **Network / ADB debugging** if present).
3. Select **Revoke USB debugging authorizations**.
4. Reboot the TV using your physical remote.
5. Verify that port 5555 is closed by running:
   ```bash
   cleanyourtv/tools/venv/bin/python cleanyourtv/tools/adb-closed.py 192.168.29.18
   ```

