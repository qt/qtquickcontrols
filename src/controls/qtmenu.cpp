/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qtmenu_p.h"
#include "qdebug.h"
#include "qtaction_p.h"
#include "qtmenupopupwindow_p.h"
#include <qabstractitemmodel.h>

#include <QtGui/QCursor>
#include "private/qguiapplication_p.h"
#include <QtGui/qpa/qplatformtheme.h>
#include <QtGui/qpa/qplatformmenu.h>

QT_BEGIN_NAMESPACE

/*!
  \class QtMenu
  \internal
 */

/*!
  \qmltype MenuPrivate
  \instantiates QtMenu
  \internal
  \inqmlmodule QtQuick.Controls 1.0
 */

/*!
    \qmlproperty readonly list Menu::items
    \default

    The list of items in the menu.

    \sa MenuItem, MenuSeparator
*/

/*!
    \qmlproperty bool Menu::visible

    Whether the menu should be visible. This is only enabled when the menu is used as
    a submenu.
*/

/*!
    \qmlproperty string Menu::text

    Text for the menu, whether in a \l MenuBar or as a submenu.
    Accelerators are supported with the usual \& convention.
*/

/*!
    \qmlproperty bool Menu::enabled

    Whether the menu is enabled, and responsive to user interaction as a submenu.
*/

/*!
    \qmlproperty url Menu::iconSource

    Sets the icon file or resource url for the menu icon as a submenu.

    \sa iconName
*/

/*!
    \qmlproperty string Menu::iconName

    Sets the icon name for the menu icon. This will pick the icon
    with the given name from the current theme. Only works as a submenu.

    \sa iconSource
*/

/*!
    \qmlproperty int Menu::selectedIndex

    The index for the last selected item in the menu.
*/

/*!
    \qmlmethod void Menu::popup()

    Pops up this menu under the mouse cursor.
    It can block on some platforms, so test it accordingly.
*/

/*!
    \qmlproperty var Menu::model
*/

QtMenu::QtMenu(QObject *parent)
    : QtMenuText(parent),
      m_selectedIndex(-1),
      m_highlightedIndex(0),
      m_hasNativeModel(false),
      m_minimumWidth(0),
      m_popupWindow(0),
      m_menuContentItem(0),
      m_popupVisible(false),
      m_parentWindow(0)
{
    m_platformMenu = QGuiApplicationPrivate::platformTheme()->createPlatformMenu();
    if (m_platformMenu) {
        connect(m_platformMenu, SIGNAL(aboutToHide()), this, SLOT(__closeMenu()));
        if (platformItem())
            platformItem()->setMenu(m_platformMenu);
    }
}

QtMenu::~QtMenu()
{
    delete m_platformMenu;
}

void QtMenu::setText(const QString &text)
{
    QtMenuText::setText(text);
    if (m_platformMenu)
        m_platformMenu->setText(this->text());
}

void QtMenu::setMinimumWidth(int w)
{
    if (w == m_minimumWidth)
        return;

    m_minimumWidth = w;
    if (m_platformMenu)
        m_platformMenu->setMinimumWidth(w);
}

void QtMenu::setFont(const QFont &arg)
{
    if (m_platformMenu)
        m_platformMenu->setFont(arg);
}

void QtMenu::setSelectedIndex(int index)
{
    if (m_selectedIndex == index)
        return;

    m_selectedIndex = index;
    emit selectedIndexChanged();
}

void QtMenu::updateSelectedIndex()
{
    if (QtMenuBase *menuItem = qobject_cast<QtMenuItem*>(sender())) {
        int index = m_menuItems.indexOf(menuItem);
        setSelectedIndex(index);
    }
}

QQmlListProperty<QtMenuBase> QtMenu::menuItems()
{
    return QQmlListProperty<QtMenuBase>(this, 0, &QtMenu::append_menuItems, &QtMenu::count_menuItems, &QtMenu::at_menuItems, 0);
}

QQuickWindow *QtMenu::findParentWindow()
{
    if (!m_parentWindow) {
        QQuickItem *parentAsItem = qobject_cast<QQuickItem *>(parent());
        m_parentWindow = visualItem() ? visualItem()->window() :    // Menu as menu item case
                         parentAsItem ? parentAsItem->window() : 0; //Menu as context menu/popup case
    }
    return m_parentWindow;
}

void QtMenu::popup()
{
    QPoint mousePos = QCursor::pos();
    if (QQuickWindow *parentWindow = findParentWindow())
        mousePos = parentWindow->mapFromGlobal(mousePos);

    __popup(mousePos.x(), mousePos.y());
}

void QtMenu::__popup(qreal x, qreal y, int atItemIndex)
{
    if (popupVisible())
        __closeMenu();

    setPopupVisible(true);

    // If atItemIndex is valid, x and y is specified from the
    // the position of the corresponding QtMenuItem:
    QtMenuItem *atItem = 0;
    if (atItemIndex >= 0)
        while (!atItem && atItemIndex < m_menuItems.size())
            atItem = qobject_cast<QtMenuItem *>(m_menuItems[atItemIndex++]);

    QQuickWindow *parentWindow = findParentWindow();

    if (m_platformMenu) {
        QPointF screenPosition(x, y);
        if (visualItem())
            screenPosition = visualItem()->mapToScene(screenPosition);
        m_platformMenu->showPopup(parentWindow, screenPosition.toPoint(), atItem ? atItem->platformItem() : 0);
    } else {
        m_popupWindow = new QtMenuPopupWindow();
        m_popupWindow->setParentWindow(parentWindow);
        m_popupWindow->setMenuContentItem(m_menuContentItem);
        connect(m_popupWindow, SIGNAL(visibleChanged(bool)), this, SLOT(windowVisibleChanged(bool)));

        if (parentWindow) {
            if (visualItem()) {
                QPointF pos = visualItem()->mapToItem(parentWindow->contentItem(), QPointF(x, y));
                x = pos.x();
                y = pos.y();
            }

            x += parentWindow->geometry().left();
            y += parentWindow->geometry().top();
        }

        QQuickItem *visualItem = atItem ? atItem->visualItem() : 0;
        if (visualItem) {
            QPointF pos = visualItem->position();
            x -= pos.x();
            y -= pos.y();
            m_popupWindow->setItemAt(visualItem);
        }

        m_popupWindow->setGeometry(x, y, m_menuContentItem->width(), m_menuContentItem->height());
        m_popupWindow->show();
        m_popupWindow->setMouseGrabEnabled(true); // Needs to be done after calling show()
        m_popupWindow->setKeyboardGrabEnabled(true);
    }
}

void QtMenu::setMenuContentItem(QQuickItem *item)
{
    if (m_menuContentItem != item)
        m_menuContentItem = item;
}

void QtMenu::setPopupVisible(bool v)
{
    if (m_popupVisible != v) {
        m_popupVisible = v;
        emit popupVisibleChanged();
    }
}

void QtMenu::__closeMenu()
{
    setPopupVisible(false);
    if (m_popupWindow)
        m_popupWindow->setVisible(false);
    m_parentWindow = 0;
    emit __menuClosed();
}

void QtMenu::__dismissMenu()
{
    if (m_popupWindow)
        m_popupWindow->dismissMenu();
}

void QtMenu::windowVisibleChanged(bool v)
{
    if (!v) {
        if (qobject_cast<QtMenuPopupWindow *>(m_popupWindow->transientParent())) {
            m_popupWindow->transientParent()->setMouseGrabEnabled(true);
            m_popupWindow->transientParent()->setKeyboardGrabEnabled(true);
        }
        m_popupWindow->deleteLater();
        m_popupWindow = 0;
        __closeMenu();
    }
}

void QtMenu::clear()
{
    foreach (QtMenuBase *item, m_menuItems) {
        if (m_platformMenu)
            m_platformMenu->removeMenuItem(item->platformItem());
        delete item;
    }
    m_menuItems.clear();
}

void QtMenu::addMenuItem(QtMenuBase *menuItem)
{
    menuItem->setParentMenu(this);
    m_menuItems.append(menuItem);
    if (QPlatformMenuItem *platformItem = menuItem->platformItem()) {
        if (m_platformMenu)
            m_platformMenu->insertMenuItem(platformItem, 0 /* append */);
    }
}

QtMenuItem *QtMenu::addItem(const QString &text)
{
    QtMenuItem *menuItem = new QtMenuItem(this);
    menuItem->setText(text);
    addMenuItem(menuItem);

    emit itemsChanged();
    return menuItem;
}

QString QtMenu::__modelTextAt(int index) const
{
    if (QAbstractItemModel *model = qobject_cast<QAbstractItemModel*>(m_model.value<QObject*>())) {
        return model->data(model->index(index, 0)).toString();
    } else if (m_model.canConvert(QVariant::StringList)) {
        return m_model.toStringList().at(index);
    }
    return "";
}

int QtMenu::__modelCount() const
{
    if (QAbstractItemModel *model = qobject_cast<QAbstractItemModel*>(m_model.value<QObject*>())) {
        return model->rowCount();
    } else if (m_model.canConvert(QVariant::StringList)) {
        return m_model.toStringList().count();
    }
    return -1;
}

void QtMenu::append_menuItems(QQmlListProperty<QtMenuBase> *list, QtMenuBase *menuItem)
{
    if (QtMenu *menu = qobject_cast<QtMenu *>(list->object))
        menu->addMenuItem(menuItem);
}

int QtMenu::count_menuItems(QQmlListProperty<QtMenuBase> *list)
{
    QtMenu *menu = qobject_cast<QtMenu *>(list->object);
    if (menu)
        return menu->m_menuItems.size();
    return 0;
}

QtMenuBase *QtMenu::at_menuItems(QQmlListProperty<QtMenuBase> *list, int index)
{
    QtMenu *menu = qobject_cast<QtMenu *>(list->object);
    if (menu && 0 <= index && index < menu->m_menuItems.size())
        return menu->m_menuItems[index];
    return 0;
}


void QtMenu::setModel(const QVariant &newModel) {
    if (m_model != newModel) {
        m_hasNativeModel = false;
        m_model = newModel;

        if (qobject_cast<QAbstractItemModel*>(newModel.value<QObject*>()))
            m_hasNativeModel = true;
        else if (newModel.canConvert(QVariant::StringList))
            m_hasNativeModel = true;

        emit modelChanged(m_model);
    }
}

QT_END_NAMESPACE
