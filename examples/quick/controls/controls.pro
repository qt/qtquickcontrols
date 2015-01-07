TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    tableview \
    touch \
    basiclayouts \
    styles \
    filesystembrowser

qtHaveModule(widgets) {
    SUBDIRS += texteditor
}

qtHaveModule(sql) {
    SUBDIRS += calendar
}
