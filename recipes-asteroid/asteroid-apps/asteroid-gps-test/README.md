# GPS Positioning with SatelliteSource in AsteroidOS (Qt 5.15)

## SatelliteSource Now Available!

With the Qt 5.15 upgrade, `SatelliteSource` is now fully supported in AsteroidOS.

## Features

### PositionSource (GPS Position)

✅ GPS coordinates (latitude/longitude)
✅ Position accuracy
✅ Altitude, speed, heading
✅ Timestamps
✅ Validity status

### SatelliteSource (Satellite Information)

✅ **Satellite count (in use)** - Satellites used for positioning
✅ **Satellite count (in view)** - All visible satellites
✅ **Real-time updates** - Get notified when satellite status changes

## Complete Example

```qml
import QtQuick 2.9
import QtPositioning 5.15
import Nemo.KeepAlive 1.1
import org.asteroid.controls 1.0

Application {
    Column {
        Label { text: "GPS Status" }
        Label { text: src.valid ? "Active" : "Searching..." }
        Label { text: "Lat: " + src.position.coordinate.latitude.toFixed(6) }
        Label { text: "Lon: " + src.position.coordinate.longitude.toFixed(6) }
        Label { text: "Accuracy: " + src.position.horizontalAccuracy.toFixed(1) + "m" }
        Label { text: "Satellites: " + sats.satellitesInUse.length + " / " + sats.satellitesInView.length }
    }

    PositionSource {
        id: src
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods
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

    Component.onCompleted: {
        DisplayBlanking.preventBlanking = true
    }
}
```

## The Enhanced Patch

The patch `0001-Add-satellite-information-display.patch` demonstrates:
- Using PositionSource with Qt 5.15
- Using SatelliteSource to display satellite counts
- Displaying position, accuracy, and timestamps
- GPS validity status with color indicators
- Screen blanking prevention

## SatelliteSource API

### Properties
- `active` (bool) - Enable/disable satellite tracking
- `satellitesInView` (list) - All visible satellites
- `satellitesInUse` (list) - Satellites used for fix
- `updateInterval` (int) - Update frequency in milliseconds

### Signals
- `onSatellitesInViewChanged` - Called when visible satellites change
- `onSatellitesInUseChanged` - Called when satellites in use change

## Dependencies

Your recipe must include:
```bitbake
DEPENDS += "qtlocation nemo-keepalive"
RDEPENDS:${PN} += "qtlocation nemo-keepalive"
```

## Qt 5.15 Upgrade

AsteroidOS has been upgraded from Qt 5.6 to Qt 5.15, enabling:
- SatelliteSource support
- Improved Qt Positioning APIs
- Better performance
- Modern Qt features

See `QT515_UPGRADE.md` in the repository root for details.

## References

- Qt 5.15 Positioning Documentation
- Qt 5.15 SatelliteSource API
- Enhanced asteroid-gps-test application
