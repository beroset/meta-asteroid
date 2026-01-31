# SatelliteSource Not Available in AsteroidOS

## Important Notice

**`SatelliteSource` QML type is NOT available in AsteroidOS** because the system uses Qt 5.6, which predates this feature by 3 years.

## Why This Happens

When you try to use `SatelliteSource`, you get:
```
SatelliteSource is not a type
```

**Root Cause:**
- AsteroidOS uses **Qt 5.6** (released 2016)
- `SatelliteSource` was introduced in **Qt 5.14** (released 2019)
- Qt modules must maintain ABI compatibility - you cannot mix Qt 5.6 qtbase with Qt 5.15 qtlocation

## What You CAN Use (Qt 5.6)

Use `PositionSource` which IS available and provides:
- ✅ GPS coordinates (latitude/longitude)
- ✅ Altitude
- ✅ Speed
- ✅ Heading/bearing
- ✅ Position accuracy  
- ✅ Timestamp

What you CANNOT get:
- ❌ Satellite count (in use / in view)
- ❌ Individual satellite information (PRN, signal strength, elevation, azimuth)

## Working Example (Qt 5.6 Compatible)

```qml
import QtQuick 2.9
import QtPositioning 5.2
import Nemo.KeepAlive 1.1
import org.asteroid.controls 1.0

Application {
    id: app

    Column {
        anchors.fill: parent
        spacing: 10

        Label {
            text: src.valid ? "GPS Active" : "Searching..."
            color: src.valid ? "#00ff00" : "#ffaa00"
        }

        Label {
            text: "Lat: " + src.position.coordinate.latitude.toFixed(6)
        }

        Label {
            text: "Lon: " + src.position.coordinate.longitude.toFixed(6)
        }

        Label {
            text: "Accuracy: " + src.position.horizontalAccuracy.toFixed(1) + "m"
        }
    }

    PositionSource {
        id: src
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods
    }

    Component.onCompleted: {
        DisplayBlanking.preventBlanking = true
    }
}
```

## Alternative Solutions

### Option 1: Use PositionSource (Recommended)
This is what the enhanced asteroid-gps-test now does - shows position, accuracy, and status.

### Option 2: Access Geoclue Directly
Create a C++ Qt plugin that interfaces directly with Geoclue to get satellite information.

**Pros:** Can access satellite data  
**Cons:** Complex, requires C++ development

### Option 3: Wait for Qt Upgrade
AsteroidOS may eventually upgrade to Qt 5.14+ in a future release.

## Why We Can't Just Upgrade qtlocation

Qt modules must have **matching versions for ABI compatibility**:

- Qt 5.6 qtbase has different binary interface than Qt 5.15
- Mixing versions causes build failures and runtime crashes
- Upgrading just qtlocation requires upgrading ALL Qt modules system-wide
- This is a major change affecting the entire distribution

## Summary

- ✅ Use `PositionSource` with `QtPositioning 5.2` (works in Qt 5.6)
- ❌ Cannot use `SatelliteSource` (requires Qt 5.14+)
- 🔧 System-wide Qt upgrade needed to enable SatelliteSource
- 📱 The enhanced asteroid-gps-test shows what IS possible with Qt 5.6

See the asteroid-gps-test application patch for a complete working example.
