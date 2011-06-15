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

#ifndef QTMLMENU_H
#define QTMLMENU_H

#include <QtGui/qmenu.h>
#include <QtDeclarative/qdeclarative.h>
#include <QtDeclarative/qdeclarativeitem.h>
#include <QtDeclarative/QDeclarativeListProperty>
#include "qtmenuitem.h"
class QtMenu : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle)
    Q_PROPERTY(int selectedIndex READ selectedIndex WRITE setSelectedIndex NOTIFY selectedIndexChanged)
    Q_PROPERTY(int hoveredIndex READ hoveredIndex WRITE setHoveredIndex NOTIFY hoveredIndexChanged)

    // The only reason we declare a list of menu items here, is so we can make it a default
    // property from within QML, if needed. The reason we don't implement the code for using
    // the list here, is that we expect the QML code to mix both ListModel and MenuItems API for
    // adding menu items. And we don't wan't to decide how to mix those two API-s from here. So the only
    // API in his class will be 'addMenuItem' and 'clearMenuItems'.
    Q_PROPERTY(QDeclarativeListProperty<QtMenuItem> menuItems READ menuItems NOTIFY menuItemsChanged)
    Q_CLASSINFO("DefaultProperty", "menuItems")
public:
    QtMenu(QDeclarativeItem *parent = 0);
    virtual ~QtMenu();

    void setTitle(const QString &title);
    QString title() const;
    int selectedIndex() const { return m_selectedIndex; }
    void setSelectedIndex(int index);
    int hoveredIndex() const { return m_highlightedIndex; }
    void setHoveredIndex(int index);
    QDeclarativeListProperty<QtMenuItem> menuItems();

    Q_INVOKABLE void showPopup(qreal x, qreal y, int atActionIndex = -1);
    Q_INVOKABLE void closePopup();
    Q_INVOKABLE void clearMenuItems();
    Q_INVOKABLE void addMenuItem(const QString &text);
    Q_INVOKABLE QString itemTextAt(int index) const;

Q_SIGNALS:
    void selectedIndexChanged();
    void hoveredIndexChanged();
    void menuClosed();
    void menuItemsChanged();
private Q_SLOTS:
    void emitSelected();
    void emitHovered();
private:
    QString m_title;
    int m_selectedIndex;
    int m_highlightedIndex;
    QWidget *dummy;
    QMenu *m_menu;
    QList<QtMenuItem *> m_menuItems;
};

QML_DECLARE_TYPE(QtMenu)

#endif // QTMLMENU_H
