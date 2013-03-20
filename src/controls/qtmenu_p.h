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

#ifndef QTMENU_P_H
#define QTMENU_P_H

#include "qtmenuitem_p.h"

#include <QtCore/qglobal.h>
#include <QtCore/qvariant.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmllist.h>

QT_BEGIN_NAMESPACE

class QPlatformMenu;
class QtMenuPopupWindow;
class QtMenuItemContainer;
class QQuickWindow;

typedef QQmlListProperty<QObject> QtMenuItems;

class QtMenu : public QtMenuText
{
    Q_OBJECT
    Q_PROPERTY(QString title READ text WRITE setText NOTIFY titleChanged)
    Q_PROPERTY(QQmlListProperty<QObject> items READ menuItems NOTIFY itemsChanged)
    Q_CLASSINFO("DefaultProperty", "items")

    Q_PROPERTY(int __selectedIndex READ selectedIndex WRITE setSelectedIndex NOTIFY __selectedIndexChanged)
    Q_PROPERTY(bool __popupVisible READ popupVisible NOTIFY popupVisibleChanged)
    Q_PROPERTY(QQuickItem *__contentItem READ menuContentItem WRITE setMenuContentItem)
    Q_PROPERTY(int __minimumWidth READ minimumWidth WRITE setMinimumWidth)
    Q_PROPERTY(QFont __font WRITE setFont)

public:
    Q_INVOKABLE void popup();
    Q_INVOKABLE QtMenuItem *addItem(QString);
    Q_INVOKABLE QtMenuSeparator *addSeparator();

    Q_INVOKABLE void __popup(qreal x, qreal y, int atActionIndex = -1);

public Q_SLOTS:
    void insertItem(int, QtMenuBase *);
    void removeItem(QtMenuBase *);
    void clear();

    void __closeMenu();
    void __dismissMenu();

Q_SIGNALS:
    void itemsChanged();
    void titleChanged();

    void __selectedIndexChanged();
    void __menuClosed();
    void popupVisibleChanged();

public:
    QtMenu(QObject *parent = 0);
    virtual ~QtMenu();

    int selectedIndex() const { return m_selectedIndex; }
    void setSelectedIndex(int index);

    QtMenuItems menuItems();
    QtMenuBase *menuItemAtIndex(int index) const;
    bool contains(QtMenuBase *);
    int indexOfMenuItem(QtMenuBase *) const;

    QPlatformMenu *platformMenu() const { return m_platformMenu; }

    int minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(int w);

    void setFont(const QFont &font);

    QQuickItem *menuContentItem() const { return m_menuContentItem; }
    bool popupVisible() const { return m_popupVisible; }

    QtMenuItemType::MenuItemType type() { return QtMenuItemType::Menu; }
    bool isNative() { return m_platformMenu != 0; }

protected Q_SLOTS:
    void updateSelectedIndex();

    void setMenuContentItem(QQuickItem *);
    void setPopupVisible(bool);

    void updateText();
    void windowVisibleChanged(bool);

private:
    QQuickWindow *findParentWindow();

    int itemIndexForListIndex(int listIndex) const;
    void itemIndexToListIndex(int, int *, int *) const;

    struct MenuItemIterator
    {
        MenuItemIterator(): index(-1), containerIndex(-1) {}
        int index, containerIndex;
    };

    QtMenuBase *nextMenuItem(MenuItemIterator *) const;

    static void append_menuItems(QtMenuItems *list, QObject *o);
    static int count_menuItems(QtMenuItems *list);
    static QObject *at_menuItems(QtMenuItems *list, int index);
    void setupMenuItem(QtMenuBase *item, int platformIndex = -1);

    QPlatformMenu *m_platformMenu;
    QList<QtMenuBase *> m_menuItems;
    QHash<QObject *, QtMenuItemContainer *> m_containers;
    int m_itemsCount;
    int m_selectedIndex;
    int m_highlightedIndex;
    QQuickWindow *m_parentWindow;
    int m_minimumWidth;
    QtMenuPopupWindow *m_popupWindow;
    QQuickItem * m_menuContentItem;
    bool m_popupVisible;
    int m_containersCount;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QtMenu)

#endif // QTMENU_P_H
