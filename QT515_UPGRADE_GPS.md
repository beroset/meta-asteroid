# Qt 5.15 Upgrade - GPS Positioning Support

## Overview

AsteroidOS has been upgraded from Qt 5.6 to Qt 5.15, enabling modern QtPositioning features.

## Important: SatelliteSource Does NOT Exist

**CRITICAL:** The QML type `SatelliteSource` does NOT exist in Qt. This was a misunderstanding of Qt's API.

### What Actually Exists in QtPositioning:

**Available QML Types:**
- ✅ `PositionSource` - GPS position information
- ✅ `Position` - Position data container
- ✅ `Address` - Geographic address
- ✅ `Location` - Location with address
- ✅ `CoordinateAnimation` - Coordinate animations

**NOT Available as QML Types:**
- ❌ `SatelliteSource` - Does not exist
- ❌ Satellite count (in use / visible) - Not exposed to QML
- ❌ Individual satellite info - Not exposed to QML

### C++ Only (Not in QML):
- `QGeoSatelliteInfo` - Satellite data class
- `QGeoSatelliteInfoSource` - Satellite info source

Qt provides satellite information only in C++, not QML.

## Using PositionSource in Qt 5.15

The `PositionSource` QML type provides comprehensive GPS information:

```qml
import QtQuick 2.9
import QtPositioning 5.15
import org.asteroid.controls 1.0

Application {
    PositionSource {
        id: src
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

        onPositionChanged: {
            var coord = position.coordinate
            console.log("Latitude:", coord.latitude)
            console.log("Longitude:", coord.longitude)
            console.log("Altitude:", coord.altitude)
            console.log("Accuracy:", position.horizontalAccuracy, "m")
            console.log("Speed:", position.speed, "m/s")
            console.log("Heading:", position.direction, "degrees")
            console.log("Timestamp:", position.timestamp)
        }
    }
}
```

## PositionSource Properties

**Position Data:**
- `position.coordinate.latitude` - Latitude in decimal degrees
- `position.coordinate.longitude` - Longitude in decimal degrees
- `position.coordinate.altitude` - Altitude in meters
- `position.horizontalAccuracy` - Horizontal accuracy in meters
- `position.verticalAccuracy` - Vertical accuracy in meters
- `position.speed` - Ground speed in meters/second
- `position.direction` - Direction of travel in degrees
- `position.timestamp` - Timestamp of the position fix

**Source Properties:**
- `active` (bool) - Whether positioning is active
- `valid` (bool) - Whether source provides valid data
- `name` (string) - Name of the position source
- `updateInterval` (int) - Update interval in milliseconds
- `preferredPositioningMethods` - Preferred positioning methods

## Example: Enhanced GPS Test Application

See `asteroid-gps-test` for a complete example showing:
- GPS coordinates (latitude/longitude)
- Position accuracy
- Altitude
- Speed
- Validity status
- Timestamp
- Screen blanking prevention

## For Developers

### Dependencies

```bitbake
DEPENDS += "qtlocation qtdeclarative"
RDEPENDS:${PN} += "qtlocation-qmlplugins qtdeclarative-qmlplugins"
```

### Import Statement

```qml
import QtPositioning 5.15
```

## Getting Satellite Information

If you need satellite count/info, you must:

### Option 1: C++ Plugin (Recommended)
Create a C++ QML type that wraps `QGeoSatelliteInfoSource`:

```cpp
class SatelliteInfo : public QObject {
    Q_OBJECT
    Q_PROPERTY(int satellitesInUse READ satellitesInUse NOTIFY updated)
    Q_PROPERTY(int satellitesInView READ satellitesInView NOTIFY updated)
    // ... implementation using QGeoSatelliteInfoSource
};
```

### Option 2: Accept Limitation
Use only PositionSource for GPS coordinates without satellite details.

## Qt 5.15 Benefits

- Modern QtPositioning API
- Better GPS accuracy
- Improved performance
- Bug fixes from Qt 5.6
- Security updates

## Migration from Qt 5.6

Most Qt 5.6 applications work unchanged. Update import:

```qml
// Old
import QtPositioning 5.2

// New  
import QtPositioning 5.15
```

## References

- Qt 5.15 QtPositioning Documentation
- PositionSource QML Type Documentation
- QGeoSatelliteInfoSource C++ Documentation (for C++ plugins)
