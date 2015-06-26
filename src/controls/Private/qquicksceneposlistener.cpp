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

#include "qquicksceneposlistener_p.h"
#include <QtQuick/private/qquickitem_p.h>

QT_BEGIN_NAMESPACE

static const QQuickItemPrivate::ChangeTypes AncestorChangeTypes = QQuickItemPrivate::Geometry
                                                                  | QQuickItemPrivate::Parent
                                                                  | QQuickItemPrivate::Children;

static const QQuickItemPrivate::ChangeTypes ItemChangeTypes = QQuickItemPrivate::Geometry
                                                             | QQuickItemPrivate::Parent
                                                             | QQuickItemPrivate::Destroyed;

QQuickScenePosListener::QQuickScenePosListener(QObject *parent)
    : QObject(parent)
    , m_enabled(false)
    , m_item(0)
{
}

QQuickScenePosListener::~QQuickScenePosListener()
{
    if (m_item == 0)
        return;

    QQuickItemPrivate::get(m_item)->removeItemChangeListener(this, ItemChangeTypes);
    removeAncestorListeners(m_item->parentItem());
}

QQuickItem *QQuickScenePosListener::item() const
{
    return m_item;
}

void QQuickScenePosListener::setItem(QQuickItem *item)
{
    if (m_item == item)
        return;

    if (m_item != 0) {
        QQuickItemPrivate::get(m_item)->removeItemChangeListener(this, ItemChangeTypes);
        removeAncestorListeners(m_item->parentItem());
    }

    m_item = item;

    if (m_item == 0)
        return;

    if (m_enabled) {
        QQuickItemPrivate::get(m_item)->addItemChangeListener(this, ItemChangeTypes);
        addAncestorListeners(m_item->parentItem());
    }

    updateScenePos();
}

QPointF QQuickScenePosListener::scenePos() const
{
    return m_scenePos;
}

bool QQuickScenePosListener::isEnabled() const
{
    return m_enabled;
}

void QQuickScenePosListener::setEnabled(bool enabled)
{
    if (m_enabled == enabled)
        return;

    m_enabled = enabled;

    if (m_item != 0) {
        if (enabled) {
            QQuickItemPrivate::get(m_item)->addItemChangeListener(this, ItemChangeTypes);
            addAncestorListeners(m_item->parentItem());
        } else {
            QQuickItemPrivate::get(m_item)->removeItemChangeListener(this, ItemChangeTypes);
            removeAncestorListeners(m_item->parentItem());
        }
    }

    emit enabledChanged();
}

void QQuickScenePosListener::itemGeometryChanged(QQuickItem *, const QRectF &, const QRectF &)
{
    updateScenePos();
}

void QQuickScenePosListener::itemParentChanged(QQuickItem *, QQuickItem *parent)
{
    addAncestorListeners(parent);
}

void QQuickScenePosListener::itemChildRemoved(QQuickItem *, QQuickItem *child)
{
    if (isAncestor(child))
        removeAncestorListeners(child);
}

void QQuickScenePosListener::itemDestroyed(QQuickItem *item)
{
    Q_ASSERT(m_item == item);

    // Remove all injected listeners.
    m_item = 0;
    QQuickItemPrivate::get(item)->removeItemChangeListener(this, ItemChangeTypes);
    removeAncestorListeners(item->parentItem());
}

void QQuickScenePosListener::updateScenePos()
{
    const QPointF &scenePos = m_item->mapToScene(QPointF(0, 0));
    if (m_scenePos != scenePos) {
        m_scenePos = scenePos;
        emit scenePosChanged();
    }
}

/*!
    \internal

    Remove this listener from \a item and all its ancestors.
 */
void QQuickScenePosListener::removeAncestorListeners(QQuickItem *item)
{
    if (item == m_item)
        return;

    QQuickItem *p = item;
    while (p != 0) {
        QQuickItemPrivate::get(p)->removeItemChangeListener(this, AncestorChangeTypes);
        p = p->parentItem();
    }
}

/*!
    \internal

    Injects this as a listener to \a item and all its ancestors.
 */
void QQuickScenePosListener::addAncestorListeners(QQuickItem *item)
{
    if (item == m_item)
        return;

    QQuickItem *p = item;
    while (p != 0) {
        QQuickItemPrivate::get(p)->addItemChangeListener(this, AncestorChangeTypes);
        p = p->parentItem();
    }
}

bool QQuickScenePosListener::isAncestor(QQuickItem *item) const
{
    if (!m_item)
        return false;

    QQuickItem *parent = m_item->parentItem();
    while (parent) {
        if (parent == item)
            return true;
        parent = parent->parentItem();
    }
    return false;
}

QT_END_NAMESPACE
