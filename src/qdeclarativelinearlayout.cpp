/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
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

#include "qdeclarativelinearlayout.h"
#include "qdeclarativelayoutengine_p.h"
#include <QtCore/qnumeric.h>

static const qreal q_declarativeLayoutDefaultSpacing = 0.0;


QDeclarativeLinearLayout::QDeclarativeLinearLayout(Orientation orientation,
                                                   QDeclarativeItem *parent)
    : QDeclarativeLayout(parent),
      m_spacing(q_declarativeLayoutDefaultSpacing),
      m_orientation(orientation)
{

}

qreal QDeclarativeLinearLayout::spacing() const
{
    return m_spacing;
}

void QDeclarativeLinearLayout::setSpacing(qreal spacing)
{
    if (qIsNaN(spacing) || m_spacing == spacing)
        return;

    m_spacing = spacing;
    reconfigureLayout();
}

QDeclarativeLinearLayout::Orientation QDeclarativeLinearLayout::orientation() const
{
    return m_orientation;
}

void QDeclarativeLinearLayout::setOrientation(Orientation orientation)
{
    if (m_orientation == orientation)
        return;

    m_orientation = orientation;
    reconfigureLayout();

    emit orientationChanged();
}

void QDeclarativeLinearLayout::componentComplete()
{
    QDeclarativeLayout::componentComplete();
    updateLayoutItems();
    reconfigureLayout();
}

void QDeclarativeLinearLayout::updateLayoutItems()
{
    const QList<QGraphicsItem *> &children = childItems();

    foreach (QGraphicsItem *child, children) {
        QGraphicsObject *obj = child->toGraphicsObject();

        if (obj) {
            QDeclarativeItem *item = qobject_cast<QDeclarativeItem *>(obj);

            if (item)
                insertLayoutItem(item);
        }
    }
}

QVariant QDeclarativeLinearLayout::itemChange(GraphicsItemChange change, const QVariant &value)
{
    if (change == ItemChildAddedChange || change == ItemChildRemovedChange) {
        QGraphicsItem *child = value.value<QGraphicsItem *>();
        QGraphicsObject *obj = child ? child->toGraphicsObject() : 0;
        QDeclarativeItem *item = obj ? qobject_cast<QDeclarativeItem *>(obj) : 0;

        if (item) {
            if (change == ItemChildAddedChange)
                insertLayoutItem(item);
            else
                removeLayoutItem(item);
        }
    }

    return QDeclarativeLayout::itemChange(change, value);
}

void QDeclarativeLinearLayout::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QDeclarativeLayout::geometryChanged(newGeometry, oldGeometry);
    reconfigureLayout();
}

void QDeclarativeLinearLayout::insertLayoutItem(QDeclarativeItem *item)
{
    m_items.append(item);
    setupItemLayout(item);

    reconfigureLayout();
    QObject::connect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
}

void QDeclarativeLinearLayout::removeLayoutItem(QDeclarativeItem *item)
{
    if (!m_items.removeOne(item))
        return;

    reconfigureLayout();
    QObject::disconnect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
}

void QDeclarativeLinearLayout::onItemDestroyed()
{
    if (!m_items.removeOne(static_cast<QDeclarativeItem *>(sender())))
        return;

    reconfigureLayout();
}

void QDeclarativeLinearLayout::invalidate()
{
    reconfigureLayout();
}

void QDeclarativeLinearLayout::reconfigureLayout()
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

    QVector<QDeclarativeLayoutInfo> itemData;

    for (int i = 0; i < count; i++) {
        QDeclarativeItem *item = m_items.at(i);
        QObject *attached = qmlAttachedPropertiesObject<QDeclarativeLayout>(item);
        QDeclarativeLayoutAttached *info = static_cast<QDeclarativeLayoutAttached *>(attached);

        QDeclarativeLayoutInfo data;

        if (m_orientation == Horizontal) {
            data.sizeHint = item->implicitWidth();
            data.minimumSize = info->minimumWidth();
            data.maximumSize = info->maximumWidth();
            data.expansive = (info->horizontalSizePolicy() == QDeclarativeLayout::Expanding);
        } else {
            data.sizeHint = item->implicitHeight();
            data.minimumSize = info->minimumHeight();
            data.maximumSize = info->maximumHeight();
            data.expansive = (info->verticalSizePolicy() == QDeclarativeLayout::Expanding);
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

    if (m_orientation == Horizontal) {
        qDeclarativeLayoutCalculate(itemData, 0, count, 0, width(), m_spacing);

        for (int i = 0; i < count; i++) {
            QDeclarativeItem *item = m_items.at(i);
            const QDeclarativeLayoutInfo &data = itemData.at(i);

            item->setX(data.pos);
            item->setWidth(data.size);
        }
    } else {
        qDeclarativeLayoutCalculate(itemData, 0, count, 0, height(), m_spacing);

        for (int i = 0; i < count; i++) {
            QDeclarativeItem *item = m_items.at(i);
            const QDeclarativeLayoutInfo &data = itemData.at(i);

            item->setY(data.pos);
            item->setHeight(data.size);
        }
    }

    // propagate hints to upper levels
    QObject *attached = qmlAttachedPropertiesObject<QDeclarativeLayout>(this);
    QDeclarativeLayoutAttached *info = static_cast<QDeclarativeLayoutAttached *>(attached);

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
