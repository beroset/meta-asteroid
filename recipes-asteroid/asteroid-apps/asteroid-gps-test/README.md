# Using SatelliteSource in Qt Positioning on AsteroidOS

## Problem

When trying to use `SatelliteSource` QML type from Qt Positioning, you may encounter an error:
```
SatelliteSource is not a type
```

## Solution

The `SatelliteSource` QML type was introduced in **Qt 5.14** (QtPositioning 5.14). To use it, you must:

### 1. Update the import statement

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

### 2. Use SatelliteSource correctly

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

### 3. Key properties and signals

**SatelliteSource provides:**
- `active` (bool): Whether the source is active
- `satellitesInView` (list): List of all visible satellites
- `satellitesInUse` (list): List of satellites used for positioning
- `updateInterval` (int): Update interval in milliseconds

**Signals:**
- `onSatellitesInViewChanged`: Emitted when visible satellites change
- `onSatellitesInUseChanged`: Emitted when satellites used for fix change

### 4. Dependencies

Your recipe must include `qtlocation` as a dependency:

```bitbake
DEPENDS += "qtlocation"
RDEPENDS:${PN} += "qtlocation"
```

## Example

See the patch `0001-Add-satellite-information-display.patch` in this directory for a complete working example that displays:
- GPS position (latitude/longitude)
- Timestamp
- Satellite information (used/visible count)

This patch is applied to the asteroid-gps-test application and demonstrates proper usage of both `PositionSource` and `SatelliteSource`.
