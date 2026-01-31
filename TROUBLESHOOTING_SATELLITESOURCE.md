# Troubleshooting SatelliteSource "is not a type" Error

## Quick Verification Checklist

After rebuilding and installing, verify these on your device:

### 1. Check Qt Version
```bash
qmlscene --version
```
**Expected**: Qt 5.15.x

### 2. Check QML Positioning Module Exists
```bash
ls -la /usr/lib/qml/QtPositioning/
```
**Expected files:**
- `libdeclarative_positioning.so` (QML plugin library)
- `qmldir` (type registration file)
- `plugins.qmltypes` (type information)

### 3. Verify SatelliteSource Registration
```bash
cat /usr/lib/qml/QtPositioning/qmldir | grep -i satellite
```
**Expected output:**
```
typeinfo plugins.qmltypes
SatelliteSource 5.15 libdeclarative_positioningplugin
```

### 4. Check Installed Packages
```bash
opkg list-installed | grep -E "qtlocation|qtdeclarative"
```
**Must include:**
- `qtlocation-qmlplugins` - Contains QtPositioning QML module
- `qtdeclarative-qmlplugins` - QML engine support

### 5. Test Simple QML
Create test file `/tmp/test-satellite.qml`:
```qml
import QtQuick 2.9
import QtPositioning 5.15

Item {
    SatelliteSource {
        id: sats
        active: true
        Component.onCompleted: {
            console.log("SatelliteSource created successfully!")
        }
    }
}
```

Run:
```bash
qmlscene /tmp/test-satellite.qml
```

**Expected**: No "is not a type" error

## Common Issues and Solutions

### Issue 1: Old Qt 5.6 Still Installed
**Symptom**: `qmlscene --version` shows Qt 5.6.x

**Solution**: 
```bash
# Full clean rebuild required
bitbake -c cleansstate qtbase qtdeclarative qtlocation
bitbake qtbase qtdeclarative qtlocation
bitbake asteroid-gps-test
```

### Issue 2: QML Plugin Not Installed
**Symptom**: `/usr/lib/qml/QtPositioning/` directory missing or empty

**Solution**: Ensure `qtlocation-qmlplugins` is installed:
```bash
opkg install qtlocation-qmlplugins
```

If not available, rebuild qtlocation:
```bash
bitbake -c cleansstate qtlocation
bitbake qtlocation
```

### Issue 3: Wrong SRCREV
**Symptom**: Build uses old qtlocation version

**Solution**: Verify recipe has:
```bitbake
SRCREV = "684e5d19b9a985fa47cb2ba541903020ce95bda9"
```

Clear AUTOREV cache:
```bash
bitbake -c cleansstate qtlocation
rm -rf tmp/cache/
bitbake qtlocation
```

### Issue 4: Package Split Issue
**Symptom**: qtlocation installed but no QML plugins

**Check**: 
```bash
opkg files qtlocation-qmlplugins
```

Should list files in `/usr/lib/qml/QtPositioning/`

**Solution**: Rebuild with explicit FILES directive:
```bitbake
FILES:${PN}-qmlplugins += "${OE_QMAKE_PATH_QML}/QtPositioning/*"
```

### Issue 5: Runtime Library Path Issue
**Symptom**: Plugin found but not loaded

**Check**:
```bash
QML2_IMPORT_PATH=/usr/lib/qml qmlscene /tmp/test-satellite.qml
```

**Solution**: Set QML import path in application or environment

## Build Order

For a clean build, use this order:

```bash
# 1. Clean everything Qt
bitbake -c cleansstate qtbase qtdeclarative qtlocation

# 2. Build base Qt
bitbake qtbase

# 3. Build declarative (QML engine)
bitbake qtdeclarative

# 4. Build location with QML support
bitbake qtlocation

# 5. Build application
bitbake asteroid-gps-test

# 6. Create image
bitbake asteroid-image
```

## Verification on Device

After flashing/installing:

1. **Reboot device** (important for library cache refresh)

2. **Check versions**:
```bash
qmlscene --version
opkg info qtlocation-qmlplugins | grep Version
```

3. **Check files**:
```bash
ls -R /usr/lib/qml/QtPositioning/
cat /usr/lib/qml/QtPositioning/qmldir
```

4. **Run test app**:
```bash
cd /usr/share/asteroid-gps-test/
qmlscene main.qml
```

## Expected Result

The asteroid-gps-test application should:
1. Start without "SatelliteSource is not a type" error
2. Display GPS status
3. Show "used: 0 vis: 0" (or actual satellite counts when GPS locked)
4. Update satellite information when GPS has fix

## Still Not Working?

If all above checks pass but error persists:

1. Check QML cache:
```bash
rm -rf ~/.cache/asteroid-gps-test/qmlcache/*
```

2. Enable QML debugging:
```bash
QML_IMPORT_TRACE=1 qmlscene main.qml 2>&1 | grep -i positioning
```

3. Check for conflicting Qt installations:
```bash
find /usr -name "libQt5Positioning*"
# Should only find Qt 5.15 versions
```

4. Verify QML module loading:
```bash
QT_LOGGING_RULES="*.debug=true" qmlscene main.qml 2>&1 | grep -i satellite
```

## Contact Information

If issue persists after all troubleshooting steps, provide:
- Output of all verification commands above
- `opkg list-installed | grep qt`
- `qmlscene --version`
- Content of `/usr/lib/qml/QtPositioning/qmldir`
