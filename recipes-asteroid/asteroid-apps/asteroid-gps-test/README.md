# GPS Positioning in AsteroidOS (Qt 5.6)

## Important: SatelliteSource Not Available

**`SatelliteSource` does NOT work in AsteroidOS** because it requires Qt 5.14+, but AsteroidOS uses Qt 5.6.

## What Works: PositionSource

Use `PositionSource` from QtPositioning 5.2 which provides:

✅ **Available in Qt 5.6:**
- GPS coordinates (latitude/longitude)
- Position accuracy
- Altitude, speed, heading
- Timestamps
- Validity status

❌ **NOT Available (requires Qt 5.14+):**
- `SatelliteSource` type
- Satellite count (in use/in view)
- Individual satellite info

## Working Example

```qml
import QtQuick 2.9
import QtPositioning 5.2
import Nemo.KeepAlive 1.1
import org.asteroid.controls 1.0

Application {
    Column {
        Label { text: src.valid ? "GPS Active" : "Searching..." }
        Label { text: "Lat: " + src.position.coordinate.latitude.toFixed(6) }
        Label { text: "Lon: " + src.position.coordinate.longitude.toFixed(6) }
        Label { text: "Accuracy: " + src.position.horizontalAccuracy.toFixed(1) + "m" }
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

## The Enhanced Patch

The patch `0001-Enhance-GPS-display-Qt56-compatible.patch` demonstrates:
- Using PositionSource (Qt 5.6 compatible)
- Displaying position, accuracy, and timestamps
- GPS validity status with color indicators
- Screen blanking prevention

## Why SatelliteSource Doesn't Work

1. **Qt Version:** AsteroidOS uses Qt 5.6 (2016)
2. **SatelliteSource Introduced:** Qt 5.14 (2019)
3. **ABI Compatibility:** Cannot mix Qt 5.6 qtbase with Qt 5.15 qtlocation
4. **Required Fix:** System-wide Qt upgrade (major undertaking)

## Dependencies

Your recipe must include:
```bitbake
DEPENDS += "qtlocation nemo-keepalive"
RDEPENDS:${PN} += "qtlocation nemo-keepalive"
```

## See Also

- `SATELLITESOURCE_NOT_AVAILABLE.md` - Full explanation
- Enhanced asteroid-gps-test patch - Working Qt 5.6 example
