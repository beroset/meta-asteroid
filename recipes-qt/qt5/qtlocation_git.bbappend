PACKAGECONFIG = "geoclue geoservices_itemsoverlay geoservices_osm geoservices_esri declarative"
RDEPENDS:${PN} += "geoclue"

do_install:append() {
    rm ${D}/usr/lib/plugins/position/libqtposition_geoclue2.so
}