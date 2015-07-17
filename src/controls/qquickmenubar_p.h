/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QQUICKMENUBAR_P_H
#define QQUICKMENUBAR_P_H

#include "qquickmenu_p.h"

#include <QtCore/qobject.h>
#include <QtQuick/qquickitem.h>

QT_BEGIN_NAMESPACE

class QPlatformMenuBar;
class QQuickItem;

class QQuickMenuBar: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQmlListProperty<QQuickMenu> menus READ menus NOTIFY menusChanged)
    Q_CLASSINFO("DefaultProperty", "menus")

    Q_PROPERTY(QQuickItem *__contentItem READ contentItem WRITE setContentItem NOTIFY contentItemChanged)
    Q_PROPERTY(QQuickWindow *__parentWindow READ parentWindow WRITE setParentWindow)
    Q_PROPERTY(bool __isNative READ isNative WRITE setNative NOTIFY nativeChanged)

Q_SIGNALS:
    void menusChanged();
    void nativeChanged();
    void contentItemChanged();

public:
    QQuickMenuBar(QObject *parent = 0);
    ~QQuickMenuBar();

    QQmlListProperty<QQuickMenu> menus();

    bool isNative() const;
    void setNative(bool native);

    QQuickItem *contentItem() const { return m_contentItem; }
    void setContentItem(QQuickItem *);

    QQuickWindow *parentWindow() const { return m_parentWindow; }
    void setParentWindow(QQuickWindow *);

    QPlatformMenuBar *platformMenuBar() const { return m_platformMenuBar; }

private:
    void setNativeNoNotify(bool native);
    static void append_menu(QQmlListProperty<QQuickMenu> *list, QQuickMenu *menu);
    static int count_menu(QQmlListProperty<QQuickMenu> *list);
    static QQuickMenu *at_menu(QQmlListProperty<QQuickMenu> *list, int index);

private:
    QList<QQuickMenu *> m_menus;
    QPlatformMenuBar *m_platformMenuBar;
    QQuickItem *m_contentItem;
    QQuickWindow *m_parentWindow;
};

QT_END_NAMESPACE

#endif // QQUICKMENUBAR_P_H
