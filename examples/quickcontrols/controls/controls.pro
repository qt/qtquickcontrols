TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    tableview \
    touch \
    basiclayouts \
    styles \
    uiforms

qtHaveModule(widgets) {
    SUBDIRS += texteditor filesystembrowser
}

qtHaveModule(sql) {
    SUBDIRS += calendar
}

EXAMPLE_FILES += \
    shared
