load(qt_parts)

# We need accessibility
!contains(QT_CONFIG, accessibility) {
    error("Building Qt without accessibility is not supported for qt quick controls.")
}
