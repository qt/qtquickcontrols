TEMPLATE = subdirs

SUBDIRS += \
    calendar \
    gallery \
    splitview \
    tableview \
    touch \
    basiclayouts

qtHaveModule(widgets) {
    SUBDIRS += texteditor
}
