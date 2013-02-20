/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qtmenu_p.h"
#include "qdebug.h"
#include "qtaction_p.h"
#include "qtmenupopupwindow_p.h"
#include <qabstractitemmodel.h>

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
  \inqmlmodule QtDesktop 1.0
 */

/*!
    \qmlproperty readonly list Menu::menuItems
    \default
*/

/*!
    \qmlproperty var Menu::model
*/

/*!
    \qmlproperty int Menu::selectedIndex
*/

/*!
    \qmlproperty font Menu::font

    Write-only. For styling purposes only.
*/

/*!
    \qmlproperty readonly bool Menu::popupVisible
*/

/*!
    \qmlmethod void Menu::showPopup(x, y, item, parent)

    Shows the popup related to this menu. It can block on some platforms, so test it accordingly.
*/

/*!
    \qmlmethod void Menu::closeMenu()

    Closes current menu (and submenus) only.
*/

/*!
    \qmlmethod void Menu::dismissMenu()

    Closes all menus related to this one, including its parent menu.
*/

QtMenu::QtMenu(QObject *parent)
    : QtMenuItem(parent),
      m_selectedIndex(-1),
      m_highlightedIndex(0),
      m_hasNativeModel(false),
      m_minimumWidth(0),
      m_popupWindow(0),
      m_popupVisible(false)
{
    m_platformMenu = QGuiApplicationPrivate::platformTheme()->createPlatformMenu();
    if (m_platformMenu) {
        connect(m_platformMenu, SIGNAL(aboutToHide()), this, SLOT(closeMenu()));
        if (platformItem())
            platformItem()->setMenu(m_platformMenu);
    }
}

QtMenu::~QtMenu()
{
    delete m_platformMenu;
}

void QtMenu::updateText()
{
    if (m_platformMenu)
        m_platformMenu->setText(text());
    QtMenuItem::updateText();
}

void QtMenu::setMinimumWidth(int w)
{
    if (w == m_minimumWidth)
        return;

    m_minimumWidth = w;
    if (m_platformMenu)
        m_platformMenu->setMinimumWidth(w);

    emit minimumWidthChanged();
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

    if (m_selectedIndex >= 0 && m_selectedIndex < m_menuItems.size())
        if (QtMenuItem *item = qobject_cast<QtMenuItem *>(m_menuItems[m_selectedIndex]))
            if (item->checkable())
                item->setChecked(true);

    emit selectedIndexChanged();
}

QQmlListProperty<QtMenuBase> QtMenu::menuItems()
{
    return QQmlListProperty<QtMenuBase>(this, 0, &QtMenu::append_menuItems, &QtMenu::count_menuItems, &QtMenu::at_menuItems, 0);
}

void QtMenu::showPopup(qreal x, qreal y, int atItemIndex, QObject *reference)
{
    if (popupVisible())
        closeMenu();

    setPopupVisible(true);

    // If atItemIndex is valid, x and y is specified from the
    // the position of the corresponding QtMenuItem:
    QtMenuItem *atItem = 0;
    if (atItemIndex >= 0)
        while (!atItem && atItemIndex < m_menuItems.size())
            atItem = qobject_cast<QtMenuItem *>(m_menuItems[atItemIndex++]);

    QQuickItem *item = qobject_cast<QQuickItem *>(reference);

    QQuickWindow *parentWindow = item ? item->window() : qobject_cast<QQuickWindow *>(reference);
    if (!parentWindow) {
        QQuickItem *parentAsItem = qobject_cast<QQuickItem *>(parent());
        parentWindow = visualItem() ? visualItem()->window() :    // Menu as menu item case
                       parentAsItem ? parentAsItem->window() : 0; //Menu as context menu/popup case
    }

    if (m_platformMenu) {
        QPointF screenPosition(x, y);
        if (item)
            screenPosition = item->mapToScene(screenPosition);
        m_platformMenu->showPopup(parentWindow, screenPosition.toPoint(), atItem ? atItem->platformItem() : 0);
    } else {
        m_popupWindow = new QtMenuPopupWindow();
        m_popupWindow->setParentWindow(parentWindow);
        m_popupWindow->setMenuContentItem(m_menuContentItem);
        connect(m_popupWindow, SIGNAL(visibleChanged(bool)), this, SLOT(windowVisibleChanged(bool)));

        if (parentWindow) {
            if (item) {
                QPointF pos = item->mapToItem(parentWindow->contentItem(), QPointF(x, y));
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

void QtMenu::closeMenu()
{
    setPopupVisible(false);
    if (m_popupWindow)
        m_popupWindow->setVisible(false);
    emit menuClosed();
}

void QtMenu::dismissMenu()
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
        closeMenu();
    }
}

void QtMenu::clearMenuItems()
{
    foreach (QtMenuBase *item, m_menuItems) {
        if (m_platformMenu)
            m_platformMenu->removeMenuItem(item->platformItem());
        delete item;
    }
    m_menuItems.clear();
}

QtMenuItem *QtMenu::addMenuItem(const QString &text)
{
    QtMenuItem *menuItem = new QtMenuItem(this);
    menuItem->setText(text);
    m_menuItems.append(menuItem);
    if (QPlatformMenuItem *platformItem = menuItem->platformItem()) {
        if (m_platformMenu)
            m_platformMenu->insertMenuItem(platformItem, 0 /* append */);

        connect(platformItem, SIGNAL(activated()), this, SLOT(emitSelected()));
    }

    if (m_menuItems.size() == 1)
        // Inform QML that the selected action (0) now has changed contents:
        emit selectedIndexChanged();

    emit menuItemsChanged();
    return menuItem;
}

void QtMenu::emitSelected()
{
    QPlatformMenuItem *platformItem = qobject_cast<QPlatformMenuItem *>(sender());
    if (!platformItem)
        return;

    int index = -1;
    foreach (QtMenuBase *item, m_menuItems) {
        ++index;
        if (item->platformItem() == platformItem)
            break;
    }

    setSelectedIndex(index);
}

QString QtMenu::itemTextAt(int index) const
{
    QtMenuItem *mi = 0;
    if (index >= 0 && index < m_menuItems.size()
        && (mi = qobject_cast<QtMenuItem *>(m_menuItems.at(index))))
        return mi->text();
    else
        return "";
}

QString QtMenu::modelTextAt(int index) const
{
    if (QAbstractItemModel *model = qobject_cast<QAbstractItemModel*>(m_model.value<QObject*>())) {
        return model->data(model->index(index, 0)).toString();
    } else if (m_model.canConvert(QVariant::StringList)) {
        return m_model.toStringList().at(index);
    }
    return "";
}

int QtMenu::modelCount() const
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
    QtMenu *menu = qobject_cast<QtMenu *>(list->object);
    if (menu) {
        menuItem->setParent(menu);
        menu->m_menuItems.append(menuItem);
        if (menu->m_platformMenu)
            menu->m_platformMenu->insertMenuItem(menuItem->platformItem(), 0 /* append */);
    }
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

        // Clean up any existing connections
        if (QAbstractItemModel *oldModel = qobject_cast<QAbstractItemModel*>(m_model.value<QObject*>())) {
            disconnect(oldModel, SIGNAL(dataChanged(QModelIndex, QModelIndex)), this, SIGNAL(rebuildMenu()));
        }

        m_hasNativeModel = false;
        m_model = newModel;

        if (QAbstractItemModel *model = qobject_cast<QAbstractItemModel*>(newModel.value<QObject*>())) {
            m_hasNativeModel = true;
            connect(model, SIGNAL(dataChanged(QModelIndex, QModelIndex)), this, SIGNAL(rebuildMenu()));
        } else if (newModel.canConvert(QVariant::StringList)) {
            m_hasNativeModel = true;
        }
        emit modelChanged(m_model);
    }
}

QT_END_NAMESPACE
