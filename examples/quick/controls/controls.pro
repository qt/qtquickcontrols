TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    splitview \
    stackview \
    tableview \
    touch \
    basiclayouts

qtHaveModule(widgets) {
    SUBDIRS += text \
        ApplicationTemplate
}
