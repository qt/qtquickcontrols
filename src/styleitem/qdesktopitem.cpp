#include "qdesktopitem.h"

QDesktopItem::QDesktopItem(QObject* obj) : QObject(obj) {
    connect(&desktopWidget, SIGNAL(resized(int)), this, SIGNAL(screenGeometryChanged()));
    connect(&desktopWidget, SIGNAL(resized(int)), this, SIGNAL(availableGeometryChanged()));
    connect(&desktopWidget, SIGNAL(workAreaResized(int)), this, SIGNAL(availableGeometryChanged()));
    connect(&desktopWidget, SIGNAL(screenCountChanged(int)), this, SIGNAL(screenCountChanged()));
}

int QDesktopItem::screenCount() const
{
    return desktopWidget.screenCount();
}

QRect QDesktopItem::screenGeometry(int screen) const {
    return desktopWidget.screenGeometry(screen);
}

QRect QDesktopItem::availableGeometry(int screen) const {
    return desktopWidget.availableGeometry(screen);
}

int QDesktopItem::screenWidth() const
{
    return desktopWidget.screenGeometry().width();
}

int QDesktopItem::screenHeight() const
{
    return desktopWidget.screenGeometry().height();
}

int QDesktopItem::availableWidth() const
{
    return desktopWidget.availableGeometry().width();
}

int QDesktopItem::availableHeight() const
{
    return desktopWidget.availableGeometry().height();
}

QDesktopItem *QDesktopItem::qmlAttachedProperties(QObject *obj) {
    return new QDesktopItem(obj);
}
