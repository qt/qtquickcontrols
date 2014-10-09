TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    splitview \
    tableview \
    touch \
    basiclayouts \
    styles

qtHaveModule(widgets) {
    SUBDIRS += texteditor
}

qtHaveModule(sql) {
    SUBDIRS += calendar
}
