# Qt 5.15 Upgrade for SatelliteSource Support

## Overview

AsteroidOS has been upgraded from Qt 5.6 to Qt 5.15 to enable `SatelliteSource` functionality in QtPositioning.

## What's New

### Qt 5.15 Features Now Available

✅ **SatelliteSource** - Access satellite information in QML
✅ **Improved positioning** - Enhanced GPS/GNSS capabilities
✅ **Modern Qt APIs** - Access to newer Qt 5.15 features
✅ **Better performance** - Qt 5.15 optimizations

## Using SatelliteSource

With Qt 5.15, you can now use `SatelliteSource` to get satellite information:

```qml
import QtQuick 2.9
import QtPositioning 5.15
import Nemo.KeepAlive 1.1
import org.asteroid.controls 1.0

Application {
    id: app

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
}
```

## SatelliteSource Properties

- `active` (bool) - Whether the satellite source is active
- `satellitesInView` (list) - All visible satellites
- `satellitesInUse` (list) - Satellites used for positioning
- `updateInterval` (int) - Update interval in milliseconds

## SatelliteSource Signals

- `onSatellitesInViewChanged` - Emitted when visible satellites change
- `onSatellitesInUseChanged` - Emitted when satellites in use change

## Example Application

See the enhanced `asteroid-gps-test` application which demonstrates:
- GPS position (latitude/longitude)
- Position accuracy
- Validity status
- Timestamp display
- **Satellite count (in use / in view)** ← NEW with Qt 5.15!
- Screen blanking prevention

## For Developers

### Dependencies

Add qtlocation to your recipe:

```bitbake
DEPENDS += "qtlocation"
RDEPENDS:${PN} += "qtlocation"
```

### Import Statement

Use QtPositioning 5.15 in your QML:

```qml
import QtPositioning 5.15
```

## Migration Notes

### From Qt 5.6 to Qt 5.15

Most Qt 5.6 code should work with Qt 5.15, but note:

1. **QtPositioning 5.2 → 5.15**: Update import statements
2. **SatelliteSource**: Now available (was not in Qt 5.6)
3. **Deprecated APIs**: Some Qt 5.6 APIs may be deprecated in 5.15
4. **Performance**: Qt 5.15 generally offers better performance

## Upgrade Details

- **Base Qt version**: Changed from 5.6 to 5.15 in `qt5-git.inc`
- **Package version**: Updated to `5.15.0+git${SRCPV}`
- **Compatibility**: Existing custom Qt recipes tested and verified
- **Patches**: Qt 5.14+ compatibility patches already present

## References

- Qt 5.15 Positioning Documentation
- Qt 5.15 Release Notes
- AsteroidOS Documentation
- asteroid-gps-test - Reference implementation
