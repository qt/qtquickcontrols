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

#include "qtmenubar_p.h"

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
  \inqmlmodule QtDesktop 1.0
 */
QtMenuBar::QtMenuBar(QQuickItem *parent)
    : QQuickItem(parent)
{
    connect(this, SIGNAL(parentChanged(QQuickItem *)), this, SLOT(updateParent(QQuickItem *)));
    m_platformMenuBar = QGuiApplicationPrivate::platformTheme()->createPlatformMenuBar();
}

QtMenuBar::~QtMenuBar()
{
}

QQmlListProperty<QtMenu> QtMenuBar::menus()
{
    return QQmlListProperty<QtMenu>(this, 0, &QtMenuBar::append_menu, &QtMenuBar::count_menu, &QtMenuBar::at_menu, 0);
}

bool QtMenuBar::isNative() {
    return m_platformMenuBar != 0;
}

void QtMenuBar::updateParent(QQuickItem *newParent)
{
    QWindow *newParentWindow = newParent ? newParent->window() : 0;
    if (newParentWindow != window() && m_platformMenuBar)
        m_platformMenuBar->handleReparent(newParentWindow);
}

void QtMenuBar::append_menu(QQmlListProperty<QtMenu> *list, QtMenu *menu)
{
    if (QtMenuBar *menuBar = qobject_cast<QtMenuBar *>(list->object)) {
        menu->setParent(menuBar);
        menuBar->m_menus.append(menu);

        if (menuBar->m_platformMenuBar)
            menuBar->m_platformMenuBar->insertMenu(menu->platformMenu(), 0 /* append */);

        menuBar->menuChanged();
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
