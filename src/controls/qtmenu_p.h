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
#include <QtCore/qglobal.h>
#include <QtQuick/QtQuick>
#include <QtQml/QtQml>
#include <QtCore/qabstractitemmodel.h>
#include <QtCore/QVariant>
#include "qtmenuitem_p.h"

QT_BEGIN_NAMESPACE

class QPlatformMenu;
class QtMenuPopupWindow;
class QQuickWindow;

class QtMenu : public QtMenuText
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<QtMenuBase> items READ menuItems NOTIFY itemsChanged)
    Q_CLASSINFO("DefaultProperty", "items")
    Q_PROPERTY(int selectedIndex READ selectedIndex WRITE setSelectedIndex NOTIFY selectedIndexChanged)
    Q_PROPERTY(QVariant model READ model WRITE setModel NOTIFY modelChanged)

    Q_PROPERTY(bool __popupVisible READ popupVisible NOTIFY popupVisibleChanged)
    Q_PROPERTY(QQuickItem *__contentItem READ menuContentItem WRITE setMenuContentItem)
    Q_PROPERTY(int __minimumWidth READ minimumWidth WRITE setMinimumWidth)
    Q_PROPERTY(QFont __font WRITE setFont)

public:
    Q_INVOKABLE void popup();

    Q_INVOKABLE QtMenuItem *addItem(const QString &text);
    Q_INVOKABLE void clear();

    Q_INVOKABLE void __popup(qreal x, qreal y, int atActionIndex = -1);
    Q_INVOKABLE QString __modelTextAt(int index) const;
    Q_INVOKABLE int __modelCount() const;
    Q_INVOKABLE bool __hasNativeModel() const { return m_hasNativeModel; }

public Q_SLOTS:
    void __closeMenu();
    void __dismissMenu();

Q_SIGNALS:
    void selectedIndexChanged();
    void modelChanged(const QVariant &newModel);
    void itemsChanged();

    void __menuClosed();
    void popupVisibleChanged();

public:
    QtMenu(QObject *parent = 0);
    virtual ~QtMenu();

    void setText(const QString &text);

    int selectedIndex() const { return m_selectedIndex; }
    void setSelectedIndex(int index);

    QQmlListProperty<QtMenuBase> menuItems();

    QPlatformMenu* platformMenu() { return m_platformMenu; }
    void addMenuItem(QtMenuBase *);

    int minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(int w);

    void setFont(const QFont &font);

    QVariant model() const { return m_model; }

    QQuickItem *menuContentItem() const { return m_menuContentItem; }
    bool popupVisible() const { return m_popupVisible; }

    void setModel(const QVariant &newModel);

    void setMenuContentItem(QQuickItem *);
    void setPopupVisible(bool);

    bool isNative() { return m_platformMenu != 0; }


protected Q_SLOTS:
    void updateText();
    void windowVisibleChanged(bool);
    void updateSelectedIndex();

private:
    QQuickWindow *findParentWindow();

    static void append_menuItems(QQmlListProperty<QtMenuBase> *list, QtMenuBase *menuItem);
    static int count_menuItems(QQmlListProperty<QtMenuBase> *list);
    static QtMenuBase *at_menuItems(QQmlListProperty<QtMenuBase> *list, int index);

    QPlatformMenu *m_platformMenu;
    QList<QtMenuBase *> m_menuItems;
    int m_selectedIndex;
    int m_highlightedIndex;
    QQuickWindow *m_parentWindow;
    bool m_hasNativeModel;
    QVariant m_model;
    int m_minimumWidth;
    QtMenuPopupWindow *m_popupWindow;
    QQuickItem * m_menuContentItem;
    bool m_popupVisible;

    friend class QtMenuBase;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QtMenu)

#endif // QTMENU_P_H
