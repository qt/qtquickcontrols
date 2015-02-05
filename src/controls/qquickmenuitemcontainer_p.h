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

#ifndef QQUICKMENUITEMCONTAINER_P_H
#define QQUICKMENUITEMCONTAINER_P_H

#include "qquickmenuitem_p.h"
#include <QtCore/qlist.h>

QT_BEGIN_NAMESPACE

class QQuickMenuItemContainer : public QQuickMenuBase
{
    Q_OBJECT
public:
    explicit QQuickMenuItemContainer(QObject *parent = 0)
        : QQuickMenuBase(parent, -1)
    { }

    ~QQuickMenuItemContainer()
    {
        clear();
        setParentMenu(0);
    }

    void setParentMenu(QQuickMenu *parentMenu)
    {
        QQuickMenuBase::setParentMenu(parentMenu);
        Q_FOREACH (QQuickMenuBase *item, m_menuItems)
            item->setParentMenu(parentMenu);
    }

    void insertItem(int index, QQuickMenuBase *item)
    {
        if (index == -1)
            index = m_menuItems.count();
        m_menuItems.insert(index, item);
        item->setContainer(this);
    }

    void removeItem(QQuickMenuBase *item)
    {
        item->setParentMenu(0);
        item->setContainer(0);
        m_menuItems.removeOne(item);
    }

    const QList<QPointer<QQuickMenuBase> > &items()
    {
        return m_menuItems;
    }

    void clear()
    {
        while (!m_menuItems.empty()) {
            QQuickMenuBase *item = m_menuItems.takeFirst();
            if (item) {
                item->setParentMenu(0);
                item->setContainer(0);
            }
        }
    }

private:
    QList<QPointer<QQuickMenuBase> > m_menuItems;
};

QT_END_NAMESPACE

#endif // QQUICKMENUITEMCONTAINER_P_H
