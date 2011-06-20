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

QtMenu::QtMenu(QObject *parent)
    : QObject(parent)
{
    _qmenu = new QMenu(0);
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

QDeclarativeListProperty<QtMenuItem> QtMenu::menuItems()
{
    return QDeclarativeListProperty<QtMenuItem>(this, 0, &QtMenu::append_qmenuItem);
}

void QtMenu::showPopup(qreal x, qreal y)
{
    // x,y are in view coordinates, QMenu expects screen coordinates
    // ### activeWindow hack
    QPoint screenPosition = QApplication::activeWindow()->mapToGlobal(QPoint(x, y));

    _qmenu->popup(screenPosition);
}

Q_INVOKABLE void QtMenu::clearMenuItems()
{
    _qmenu->clear();
    foreach (QtMenuItem *item, _qmenuItems) {
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
}

void QtMenu::append_qmenuItem(QDeclarativeListProperty<QtMenuItem> *list, QtMenuItem *menuItem)
{
    QtMenu *menu = qobject_cast<QtMenu *>(list->object);
    if (menu) {
        menuItem->setParent(menu);
        menu->_qmenuItems.append(menuItem);
        menu->qmenu()->addAction(menuItem->action());
    }
}


