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

#include "qquicklinearlayout_p.h"
#include "qquicklayoutengine_p.h"
#include <QtCore/qnumeric.h>

/*!
    \qmltype RowLayout
    \instantiates QQuickComponentsRowLayout
    \inqmlmodule QtQuick.Controls 1.0
    \brief RowLayout is doing bla...bla...
*/

/*!
    \qmltype ColumnLayout
    \instantiates QQuickComponentsColumnLayout
    \inqmlmodule QtQuick.Controls 1.0
    \brief ColumnLayout is doing bla...bla...
*/

QT_BEGIN_NAMESPACE

static const qreal q_declarativeLayoutDefaultSpacing = 4.0;


QQuickComponentsLinearLayout::QQuickComponentsLinearLayout(Orientation orientation,
                                                           QQuickItem *parent)
    : QQuickComponentsLayout(parent),
      m_spacing(q_declarativeLayoutDefaultSpacing),
      m_orientation(orientation)
{

}

qreal QQuickComponentsLinearLayout::spacing() const
{
    return m_spacing;
}

void QQuickComponentsLinearLayout::setSpacing(qreal spacing)
{
    if (qIsNaN(spacing) || m_spacing == spacing)
        return;

    m_spacing = spacing;
    invalidate();
}

QQuickComponentsLinearLayout::Orientation QQuickComponentsLinearLayout::orientation() const
{
    return m_orientation;
}

void QQuickComponentsLinearLayout::setOrientation(Orientation orientation)
{
    if (m_orientation == orientation)
        return;

    m_orientation = orientation;
    invalidate();

    emit orientationChanged();
}

void QQuickComponentsLinearLayout::componentComplete()
{
    QQuickComponentsLayout::componentComplete();
    updateLayoutItems();
    invalidate();
}

void QQuickComponentsLinearLayout::updateLayoutItems()
{
    const QList<QQuickItem *> &children = childItems();
    qreal implicitWidth = 0;
    qreal implicitHeight = 0;
    foreach (QQuickItem *child, children) {
        if (m_orientation == Horizontal) {
            implicitWidth += child->implicitWidth();
            implicitHeight = qMax(implicitHeight, child->implicitHeight());
        } else {
            implicitHeight += child->implicitHeight();
            implicitWidth = qMax(implicitWidth, child->implicitWidth());
        }
        insertLayoutItem(child);
    }
    setImplicitWidth(implicitWidth);
    setImplicitHeight(implicitHeight);
}

void QQuickComponentsLinearLayout::itemChange(ItemChange change, const ItemChangeData &value)
{
    if (isComponentComplete()) {
        if (change == ItemChildAddedChange)
            insertLayoutItem(value.item);
        else if (change == ItemChildRemovedChange)
            removeLayoutItem(value.item);
    }

    QQuickComponentsLayout::itemChange(change, value);
}

void QQuickComponentsLinearLayout::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QQuickComponentsLayout::geometryChanged(newGeometry, oldGeometry);
    invalidate();
}

void QQuickComponentsLinearLayout::insertLayoutItem(QQuickItem *item)
{
    m_items.append(item);
    setupItemLayout(item);

    invalidate();
    QObject::connect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
    QObject::connect(item, SIGNAL(visibleChanged()), this, SLOT(onItemVisibleChanged()));
}

void QQuickComponentsLinearLayout::removeLayoutItem(QQuickItem *item)
{
    if (!m_items.removeOne(item))
        return;

    invalidate();
    QObject::disconnect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
    QObject::disconnect(item, SIGNAL(visibleChanged()), this, SLOT(onItemVisibleChanged()));
}

void QQuickComponentsLinearLayout::onItemVisibleChanged()
{
    invalidate();
}

void QQuickComponentsLinearLayout::onItemDestroyed()
{
    if (!m_items.removeOne(static_cast<QQuickItem *>(sender())))
        return;

    invalidate();
}

void QQuickComponentsLinearLayout::reconfigureLayout()
{
    if (!isComponentComplete())
        return;

    const int count = m_items.count();

    if (count == 0)
        return;

    qreal totalSpacing = 0;
    qreal totalSizeHint = 0;
    qreal totalMinimumSize = 0;
    qreal totalMaximumSize = 0;

    QVector<QQuickComponentsLayoutInfo> itemData;

    for (int i = 0; i < count; i++) {
        QQuickItem *item = m_items.at(i);
        QObject *attached = qmlAttachedPropertiesObject<QQuickComponentsLayout>(item);
        QQuickComponentsLayoutAttached *info = static_cast<QQuickComponentsLayoutAttached *>(attached);

        QQuickComponentsLayoutInfo data;

        if (item->isVisible()) {
            if (m_orientation == Horizontal) {
                data.sizeHint = item->implicitWidth();
                data.minimumSize = info->minimumWidth();
                data.maximumSize = info->maximumWidth();
                data.expansive = (info->horizontalSizePolicy() == QQuickComponentsLayout::Expanding);
                data.stretch = info->horizontalSizePolicy() == Expanding ? 1.0 : 0;
            } else {
                data.sizeHint = item->implicitHeight();
                data.minimumSize = info->minimumHeight();
                data.maximumSize = info->maximumHeight();
                data.expansive = (info->verticalSizePolicy() == QQuickComponentsLayout::Expanding);
                data.stretch = info->verticalSizePolicy() == Expanding ? 1.0 : 0;
            }

            itemData.append(data);
            // sum
            totalSizeHint += data.sizeHint;
            totalMinimumSize += data.minimumSize;
            totalMaximumSize += data.maximumSize;

            // don't count last spacing
            if (i < count - 1)
                totalSpacing += data.spacing + m_spacing;
        }
    }

    qreal extent = m_orientation == Horizontal ? width() : height();
    qDeclarativeLayoutCalculate(itemData, 0, itemData.count(), 0, extent, m_spacing);

    int i = 0;
    int id = 0;
    while (i < count) {
        QQuickItem *item = m_items.at(i++);
        if (!item->isVisible())
            continue;
        const QQuickComponentsLayoutInfo &data = itemData.at(id);

        if (m_orientation == Horizontal) {
            item->setX(data.pos);
            item->setY(height()/2 - item->height()/2);
            item->setWidth(data.size);
        } else {
            item->setY(data.pos);
            item->setX(width()/2 - item->width()/2);
            item->setHeight(data.size);
        }
        ++id;
    }

    // propagate hints to upper levels
    QObject *attached = qmlAttachedPropertiesObject<QQuickComponentsLayout>(this);
    QQuickComponentsLayoutAttached *info = static_cast<QQuickComponentsLayoutAttached *>(attached);

    if (m_orientation == Horizontal) {
        setImplicitWidth(totalSizeHint);
        info->setMinimumWidth(totalMinimumSize + totalSpacing);
        info->setMaximumWidth(totalMaximumSize + totalSpacing);
    } else {
        setImplicitHeight(totalSizeHint);
        info->setMinimumHeight(totalMinimumSize + totalSpacing);
        info->setMaximumHeight(totalMaximumSize + totalSpacing);
    }
}

QT_END_NAMESPACE
