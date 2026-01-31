PACKAGECONFIG = "geoclue geoservices_itemsoverlay geoservices_osm geoservices_esri"

# Explicitly use Qt 5.15 qtlocation
SRCREV = "684e5d19b9a985fa47cb2ba541903020ce95bda9"

# QtPositioning QML types (including SatelliteSource) require qtdeclarative
DEPENDS += "qtdeclarative"
RDEPENDS:${PN} += "geoclue qtdeclarative-qmlplugins"

# Ensure QML plugins are included in the package
FILES:${PN}-qmlplugins += "${OE_QMAKE_PATH_QML}/QtPositioning/* ${OE_QMAKE_PATH_QML}/QtLocation/*"

do_install:append() {
    rm ${D}/usr/lib/plugins/position/libqtposition_geoclue2.so
    rm ${D}/usr/lib/cmake/Qt5Positioning/Qt5Positioning_QGeoPositionInfoSourceFactoryGeoclue2.cmake
}
