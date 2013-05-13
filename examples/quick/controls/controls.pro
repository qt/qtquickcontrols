TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    splitview \
    tableview \
    touch \
    basiclayouts

qtHaveModule(widgets) {
    SUBDIRS += text
}
