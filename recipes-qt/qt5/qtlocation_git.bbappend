PACKAGECONFIG = "geoclue geoservices_itemsoverlay geoservices_osm geoservices_esri"

# QtPositioning QML types (including SatelliteSource) require qtdeclarative
DEPENDS += "qtdeclarative"
RDEPENDS:${PN} += "geoclue qtdeclarative-qmlplugins"

do_install:append() {
    rm ${D}/usr/lib/plugins/position/libqtposition_geoclue2.so
    rm ${D}/usr/lib/cmake/Qt5Positioning/Qt5Positioning_QGeoPositionInfoSourceFactoryGeoclue2.cmake
}
