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
#include <qguiapplication.h>
#include <qmenubar.h>

#include "qtoplevelwindow.h"

QtMenu::QtMenu(QObject *parent)
    : QtMenuBase(parent)
{
    _qmenu = new QMenu(0);
    connect(_qmenu, SIGNAL(aboutToHide()), this, SIGNAL(menuClosed()));
}

QtMenu::~QtMenu()
{
    delete _qmenu;
}

void QtMenu::setText(const QString &text)
{
    _qmenu->setTitle(text);
}

QString QtMenu::text() const
{
    return _qmenu->title();
}

void QtMenu::setSelectedIndex(int index)
{
    _selectedIndex = index;
    QList<QAction *> actionList = _qmenu->actions();
    if (_selectedIndex >= 0 && _selectedIndex < actionList.size())
        _qmenu->setActiveAction(actionList[_selectedIndex]);
    emit selectedIndexChanged();
}

void QtMenu::setHoveredIndex(int index)
{
    _highlightedIndex = index;
    QList<QAction *> actionList = _qmenu->actions();
    if (_highlightedIndex >= 0 && _highlightedIndex < actionList.size())
        _qmenu->setActiveAction(actionList[_highlightedIndex]);
    emit hoveredIndexChanged();
}

QDeclarativeListProperty<QtMenuBase> QtMenu::menuItems()
{
    return QDeclarativeListProperty<QtMenuBase>(this, 0, &QtMenu::append_qmenuItem);
}

void QtMenu::showPopup(qreal x, qreal y, int atActionIndex)
{
    if (_qmenu->isVisible())
        return;

    // If atActionIndex is valid, x and y is specified from the
    // the position of the corresponding QAction:
    QAction *atAction = 0;
    if (atActionIndex >= 0 && atActionIndex < _qmenu->actions().size())
        atAction = _qmenu->actions()[atActionIndex];

    // x,y are in view coordinates, QMenu expects screen coordinates
    // ### activeWindow hack
    int menuBarHeight = 0;
    QWindow *window = QGuiApplication::focusWindow();
//    QWidget *window = QApplication::activeWindow();
    QTopLevelWindow *tw = qobject_cast<QTopLevelWindow*>(window);
    if (tw) {
        QMenuBar *menuBar = tw->menuBar();
        menuBarHeight = menuBar->height();
    }

    QPoint screenPosition = window->mapToGlobal(QPoint(x, y+menuBarHeight));

    setHoveredIndex(_selectedIndex);
    _qmenu->popup(screenPosition, atAction);
}

void QtMenu::hidePopup()
{
    _qmenu->close();
}

QAction* QtMenu::action()
{
    return _qmenu->menuAction();
}

Q_INVOKABLE void QtMenu::clearMenuItems()
{
    _qmenu->clear();
    foreach (QtMenuBase *item, _qmenuItems) {
        delete item;
    }
    _qmenuItems.clear();
}

void QtMenu::addMenuItem(const QString &text)
{
    QtMenuItem *menuItem = new QtMenuItem(this);
    menuItem->setText(text);
    _qmenuItems.append(menuItem);
    _qmenu->addAction(menuItem->action());

    connect(menuItem->action(), SIGNAL(triggered()), this, SLOT(emitSelected()));
    connect(menuItem->action(), SIGNAL(hovered()), this, SLOT(emitHovered()));

    if (_qmenu->actions().size() == 1)
        // Inform QML that the selected action (0) now has changed contents:
        emit selectedIndexChanged();
}

void QtMenu::emitSelected()
{
    QAction *act = qobject_cast<QAction *>(sender());
    if (!act)
        return;
    _selectedIndex = _qmenu->actions().indexOf(act);
    emit selectedIndexChanged();
}

void QtMenu::emitHovered()
{
    QAction *act = qobject_cast<QAction *>(sender());
    if (!act)
        return;
    _highlightedIndex = _qmenu->actions().indexOf(act);
    emit hoveredIndexChanged();
}

QString QtMenu::itemTextAt(int index) const
{
    QList<QAction *> actionList = _qmenu->actions();
    if (index >= 0 && index < actionList.size())
        return actionList[index]->text();
    else
        return "";
}

void QtMenu::append_qmenuItem(QDeclarativeListProperty<QtMenuBase> *list, QtMenuBase *menuItem)
{
    QtMenu *menu = qobject_cast<QtMenu *>(list->object);
    if (menu) {
        menuItem->setParent(menu);
        menu->_qmenuItems.append(menuItem);
        menu->qmenu()->addAction(menuItem->action());
    }
}


