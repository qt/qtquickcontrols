TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    tableview \
    touch \
    styles \
    uiforms

qtHaveModule(widgets) {
    SUBDIRS += texteditor filesystembrowser
}

qtHaveModule(sql) {
    SUBDIRS += calendar
}
