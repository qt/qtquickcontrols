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

#include "qtmenubar_p.h"

#include <QtQuick/QQuickItem>
#include "private/qguiapplication_p.h"
#include <QtGui/qpa/qplatformtheme.h>
#include <QtGui/qpa/qplatformmenu.h>

QT_BEGIN_NAMESPACE


/*!
  \class QtMenuBar
  \internal
 */

/*!
  \qmltype MenuBarPrivate
  \instantiates QtMenuBar
  \internal
  \inqmlmodule QtQuick.Controls 1.0
 */

QtMenuBar::QtMenuBar(QObject *parent)
    : QObject(parent), m_contentItem(0), m_parentWindow(0)
{
    m_platformMenuBar = QGuiApplicationPrivate::platformTheme()->createPlatformMenuBar();
}

QtMenuBar::~QtMenuBar()
{
}

QQmlListProperty<QtMenu> QtMenuBar::menus()
{
    return QQmlListProperty<QtMenu>(this, 0, &QtMenuBar::append_menu, &QtMenuBar::count_menu, &QtMenuBar::at_menu, 0);
}

bool QtMenuBar::isNative()
{
    return m_platformMenuBar != 0;
}

void QtMenuBar::setContentItem(QQuickItem *item)
{
    if (item != m_contentItem) {
        m_contentItem = item;
        emit contentItemChanged();
    }
}

void QtMenuBar::setParentWindow(QQuickWindow *newParentWindow)
{
    if (newParentWindow != m_parentWindow) {
        m_parentWindow = newParentWindow;
        if (m_platformMenuBar)
            m_platformMenuBar->handleReparent(m_parentWindow);
    }
}

void QtMenuBar::append_menu(QQmlListProperty<QtMenu> *list, QtMenu *menu)
{
    if (QtMenuBar *menuBar = qobject_cast<QtMenuBar *>(list->object)) {
        menu->setParent(menuBar);
        menuBar->m_menus.append(menu);

        if (menuBar->m_platformMenuBar)
            menuBar->m_platformMenuBar->insertMenu(menu->platformMenu(), 0 /* append */);

        emit menuBar->menusChanged();
    }
}

int QtMenuBar::count_menu(QQmlListProperty<QtMenu> *list)
{
    if (QtMenuBar *menuBar = qobject_cast<QtMenuBar *>(list->object))
        return menuBar->m_menus.size();
    return 0;
}

QtMenu *QtMenuBar::at_menu(QQmlListProperty<QtMenu> *list, int index)
{
    QtMenuBar *menuBar = qobject_cast<QtMenuBar *>(list->object);
    if (menuBar &&  0 <= index && index < menuBar->m_menus.size())
        return menuBar->m_menus[index];
    return 0;
}

QT_END_NAMESPACE
