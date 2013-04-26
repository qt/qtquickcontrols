TEMPLATE = subdirs

SUBDIRS += \
    gallery \
    splitview \
    stackview \
    tableview \
    touch

qtHaveModule(widgets) {
    SUBDIRS += text \
        ApplicationTemplate
}
