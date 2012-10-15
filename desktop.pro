TEMPLATE = subdirs

contains(QT_CONFIG, accessibility) {
    SUBDIRS = imports/QtDesktop/components.pro src
} else {
    message("Building Qt without accessibility is not supported for desktop components.")
}

