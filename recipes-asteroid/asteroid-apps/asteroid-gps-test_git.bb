SUMMARY = "Asteroid's GPS test app"
HOMEPAGE = "https://github.com/AsteroidOS/asteroid-gps-test.git"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=84dcc94da3adb52b53ae4fa38fe49e5d"

SRC_URI = "git://github.com/AsteroidOS/asteroid-gps-test.git;protocol=https;branch=master \
           file://0001-Enhance-GPS-display-Qt515.patch"
SRCREV = "${AUTOREV}"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

REMOVE_TRANSLATIONS = "1"

require asteroid-app.inc

DEPENDS += "qtlocation qtdeclarative nemo-keepalive"
# qtlocation-qmlplugins provides QtPositioning QML module (PositionSource, etc.)
RDEPENDS:${PN} += "qtlocation-qmlplugins qtdeclarative-qmlplugins nemo-keepalive"

