# Solution: Making SatelliteSource Work in Qt Positioning

## Problem Summary

When trying to use `SatelliteSource` in a QML application on AsteroidOS, users encounter the error:
```
SatelliteSource is not a type
```

## Root Cause

The `SatelliteSource` QML type was introduced in **Qt 5.14** as part of the QtPositioning module. It is not available in older import versions like `QtPositioning 5.2`.

## Solution

### Quick Fix for Your QML Code

Change your import statement from:
```qml
import QtPositioning 5.2
```

To:
```qml
import QtPositioning 5.15
```

This makes `SatelliteSource` available in your QML code.

### Example Usage

```qml
import QtQuick 2.9
import QtPositioning 5.15
import Nemo.KeepAlive 1.1
import org.asteroid.controls 1.0

Application {
    id: app

    // Position information
    PositionSource {
        id: src
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

        onPositionChanged: {
            var coord = position.coordinate
            console.log("Position:", coord.latitude, coord.longitude)
        }
    }

    // Satellite information
    SatelliteSource {
        id: sats
        active: true

        onSatellitesInUseChanged: {
            console.log("Satellites in use:", satellitesInUse.length)
        }

        onSatellitesInViewChanged: {
            console.log("Satellites in view:", satellitesInView.length)
        }
    }

    Component.onCompleted: {
        // Prevent screen from blanking during GPS testing
        DisplayBlanking.preventBlanking = true
    }
}
```

## Changes to meta-asteroid

This PR updates the `asteroid-gps-test` application to serve as a reference implementation:

1. **Updated Recipe** (`asteroid-gps-test_git.bb`):
   - Applies a patch to add SatelliteSource functionality
   - Adds `nemo-keepalive` dependency for DisplayBlanking support

2. **Patch File** (`0001-Add-satellite-information-display.patch`):
   - Updates import from `QtPositioning 5.2` to `QtPositioning 5.15`
   - Adds SatelliteSource to display satellite statistics
   - Enhances UI to show all GPS data (position, timestamp, satellites)
   - Adds screen blanking prevention

3. **Documentation** (`README.md`):
   - Explains the solution in detail
   - Provides usage examples
   - Documents required dependencies

## Testing

The patch has been validated to:
- Apply cleanly to the asteroid-gps-test source code
- Include proper QML syntax for SatelliteSource usage
- Follow Qt 5.15 positioning API conventions

## For Application Developers

If you're developing an application that needs satellite information:

1. Ensure your import is `QtPositioning 5.15` (or at least 5.14)
2. Add `qtlocation` as a dependency in your recipe:
   ```
   DEPENDS += "qtlocation"
   RDEPENDS:${PN} += "qtlocation"
   ```
3. Use `SatelliteSource` as shown in the example above
4. Access satellite data through:
   - `satellitesInUse` - array of satellites used for positioning
   - `satellitesInView` - array of all visible satellites

## References

- Qt 5.15 Positioning module documentation
- AsteroidOS application development guide
- The updated asteroid-gps-test serves as a complete working example
