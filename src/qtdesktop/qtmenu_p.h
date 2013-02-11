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

class QtMenu : public QtMenuItem
{
    Q_OBJECT
    Q_PROPERTY(QVariant model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(int selectedIndex READ selectedIndex WRITE setSelectedIndex NOTIFY selectedIndexChanged)
    Q_PROPERTY(int hoveredIndex READ hoveredIndex WRITE setHoveredIndex NOTIFY hoveredIndexChanged)
    Q_PROPERTY(int minimumWidth READ minimumWidth WRITE setMinimumWidth NOTIFY minimumWidthChanged)
    Q_PROPERTY(QFont font WRITE setFont)
    Q_PROPERTY(QQmlListProperty<QtMenuBase> menuItems READ menuItems NOTIFY menuItemsChanged)
    Q_CLASSINFO("DefaultProperty", "menuItems")
    Q_PROPERTY(QQuickItem *menuContentItem READ menuContentItem WRITE setMenuContentItem NOTIFY menuContentItemChanged)
    Q_PROPERTY(bool popupVisible READ popupVisible NOTIFY popupVisibleChanged)

public:
    QtMenu(QObject *parent = 0);
    virtual ~QtMenu();

    int selectedIndex() const { return m_selectedIndex; }
    void setSelectedIndex(int index);
    int hoveredIndex() const { return m_highlightedIndex; }
    void setHoveredIndex(int index);

    QQmlListProperty<QtMenuBase> menuItems();

    QPlatformMenu* platformMenu() { return m_platformMenu; }

    int minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(int w);

    void setFont(const QFont &font);

    Q_INVOKABLE void showPopup(qreal x, qreal y, int atActionIndex = -1, QObject *reference = 0);
    Q_INVOKABLE void clearMenuItems();
    Q_INVOKABLE QtMenuItem *addMenuItem(const QString &text);
    Q_INVOKABLE QString itemTextAt(int index) const;
    Q_INVOKABLE QString modelTextAt(int index) const;
    Q_INVOKABLE int modelCount() const;

    QVariant model() const { return m_model; }
    Q_INVOKABLE bool hasNativeModel() const { return m_hasNativeModel; }

    QQuickItem *menuContentItem() const
    {
        return m_menuContentItem;
    }

    bool popupVisible() const
    {
        return m_popupVisible;
    }

public Q_SLOTS:
    void setModel(const QVariant &newModel);
    void closeMenu();
    void dismissMenu();

    void setMenuContentItem(QQuickItem * arg)
    {
        if (m_menuContentItem != arg) {
            m_menuContentItem = arg;
            emit menuContentItemChanged(arg);
        }
    }

    void setPopupVisible(bool arg)
    {
        if (m_popupVisible != arg) {
            m_popupVisible = arg;
            emit popupVisibleChanged(arg);
        }
    }

Q_SIGNALS:
    void menuClosed();
    void selectedIndexChanged();
    void hoveredIndexChanged();
    void modelChanged(const QVariant &newModel);
    void rebuildMenu();
    void minimumWidthChanged();
    void menuItemsChanged();
    void menuContentItemChanged(QQuickItem * arg);

    void popupVisibleChanged(bool arg);

protected:
    bool isNative() { return m_platformMenu != 0; }

protected Q_SLOTS:
    void emitSelected();
    void emitHovered();
    void updateText();
    void windowVisibleChanged(bool);

private:
    static void append_menuItems(QQmlListProperty<QtMenuBase> *list, QtMenuBase *menuItem);
    static int count_menuItems(QQmlListProperty<QtMenuBase> *list);
    static QtMenuBase *at_menuItems(QQmlListProperty<QtMenuBase> *list, int index);

    QPlatformMenu *m_platformMenu;
    QList<QtMenuBase *> m_menuItems;
    int m_selectedIndex;
    int m_highlightedIndex;
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
