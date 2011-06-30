/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

#include "qtmenu.h"
#include "qdebug.h"
#include <qapplication.h>

QtMenu::QtMenu(QDeclarativeItem *parent)
    : QDeclarativeItem(parent), m_selectedIndex(0), m_highlightedIndex(0)
{
    m_menu = new QMenu(0);
    connect(m_menu, SIGNAL(aboutToHide()), this, SIGNAL(menuClosed()));
}

QtMenu::~QtMenu()
{
    delete m_menu;
}

void QtMenu::setTitle(const QString &title)
{
    m_title = title;
}

QString QtMenu::title() const
{
    return m_title;
}

void QtMenu::setSelectedIndex(int index)
{
    m_selectedIndex = index;
    QList<QAction *> actionList = m_menu->actions();
    if (m_selectedIndex >= 0 && m_selectedIndex < actionList.size())
        m_menu->setActiveAction(actionList[m_selectedIndex]);
    emit selectedIndexChanged();
}

void QtMenu::setHoveredIndex(int index)
{
    m_highlightedIndex = index;
    QList<QAction *> actionList = m_menu->actions();
    if (m_highlightedIndex >= 0 && m_highlightedIndex < actionList.size())
        m_menu->setActiveAction(actionList[m_highlightedIndex]);
    emit hoveredIndexChanged();
}

void QtMenu::closePopup()
{
    m_menu->close();
}

void QtMenu::showPopup(qreal x, qreal y, int atActionIndex)
{
    if (m_menu->isVisible())
        return;

    // If atActionIndex is valid, x and y is specified from the
    // the position of the corresponding QAction:
    QAction *atAction = 0;
    if (atActionIndex >= 0 && atActionIndex < m_menu->actions().size())
        atAction = m_menu->actions()[atActionIndex];

    // x,y are in view coordinates, QMenu expects screen coordinates
    // ### activeWindow hack
    QPoint screenPosition = QApplication::activeWindow()->mapToGlobal(QPoint(x, y));

    setHoveredIndex(m_selectedIndex);
    m_menu->popup(screenPosition, atAction);
}

void QtMenu::clearMenuItems()
{
    m_menu->clear();
}

void QtMenu::addMenuItem(const QString &text)
{
    QAction *action = new QAction(text, m_menu);
    connect(action, SIGNAL(triggered()), this, SLOT(emitSelected()));
    connect(action, SIGNAL(hovered()), this, SLOT(emitHovered()));
    m_menu->insertAction(0, action);

    if (m_menu->actions().size() == 1)
        // Inform QML that the selected action (0) now has changed contents:
        emit selectedIndexChanged();
}

QString QtMenu::itemTextAt(int index) const
{
    QList<QAction *> actionList = m_menu->actions();
    if (index >= 0 && index < actionList.size())
        return actionList[index]->text();
    else
        return "";
}

void QtMenu::emitSelected()
{
    QAction *act = qobject_cast<QAction *>(sender());
    if (!act)
        return;
    m_selectedIndex = m_menu->actions().indexOf(act);
    emit selectedIndexChanged();
}

void QtMenu::emitHovered()
{
    QAction *act = qobject_cast<QAction *>(sender());
    if (!act)
        return;
    m_highlightedIndex = m_menu->actions().indexOf(act);
    emit hoveredIndexChanged();
}

