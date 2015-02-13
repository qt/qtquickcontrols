TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    tableview \
    touch \
    basiclayouts \
    styles

qtHaveModule(widgets) {
    SUBDIRS += texteditor filesystembrowser
}

qtHaveModule(sql) {
    SUBDIRS += calendar
}
