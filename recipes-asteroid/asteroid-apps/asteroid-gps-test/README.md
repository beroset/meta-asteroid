# Using SatelliteSource in Qt Positioning on AsteroidOS

## Problem

When trying to use `SatelliteSource` QML type from Qt Positioning, you may encounter an error:
```
SatelliteSource is not a type
```

## Root Cause

1. The `SatelliteSource` QML type was introduced in **Qt 5.14** (QtPositioning 5.14)
2. **Meta-asteroid was using Qt 5.6 for qtlocation by default**, which does not support `SatelliteSource`
3. Simply changing the import statement is not sufficient - the underlying Qt module must be upgraded

## Solution

This requires **TWO changes**:

### 1. Upgrade qtlocation to Qt 5.15 (at the build system level)

The `recipes-qt/qt5/qtlocation_git.bbappend` file now includes:
```bitbake
# Override Qt version to use 5.15 branch for SatelliteSource support
QT_MODULE_BRANCH = "5.15"
```

This ensures qtlocation is built from Qt 5.15 source instead of Qt 5.6.

### 2. Update the QML import statement (in your application code)

Change from:
```qml
import QtPositioning 5.2
```

To:
```qml
import QtPositioning 5.15
```

Or at minimum:
```qml
import QtPositioning 5.14
```

### 3. Use SatelliteSource correctly

```qml
import QtQuick 2.9
import QtPositioning 5.15
import org.asteroid.controls 1.0

Application {
    PositionSource {
        id: positionSource
        active: true
        updateInterval: 1000
    }
    
    SatelliteSource {
        id: satelliteSource
        active: true
        
        onSatellitesInUseChanged: {
            console.log("Satellites in use:", satellitesInUse.length)
        }
        
        onSatellitesInViewChanged: {
            console.log("Satellites in view:", satellitesInView.length)
        }
    }
}
```

## Key Properties and Signals

**SatelliteSource provides:**
- `active` (bool): Whether the source is active
- `satellitesInView` (list): List of all visible satellites
- `satellitesInUse` (list): List of satellites used for positioning
- `updateInterval` (int): Update interval in milliseconds

**Signals:**
- `onSatellitesInViewChanged`: Emitted when visible satellites change
- `onSatellitesInUseChanged`: Emitted when satellites used for fix change

## Dependencies

Your recipe must include `qtlocation` as a dependency:

```bitbake
DEPENDS += "qtlocation"
RDEPENDS:${PN} += "qtlocation"
```

## Why Both Changes Are Needed

**The Qt 5.15 upgrade is critical** because:
- Qt 5.6 (released 2016) does not have `SatelliteSource` at all
- Qt 5.14+ (released 2019) introduced `SatelliteSource` support
- Without upgrading the Qt source, changing the import statement alone will fail
- The qtlocation module must be built with Qt 5.15 source to provide the functionality

## Example

See the patch `0001-Add-satellite-information-display.patch` in this directory for a complete working example that displays:
- GPS position (latitude/longitude)
- Timestamp
- Satellite information (used/visible count)

This patch is applied to the asteroid-gps-test application and demonstrates proper usage of both `PositionSource` and `SatelliteSource` with Qt 5.15.
