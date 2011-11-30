/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the examples of the Qt Toolkit.
**
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
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
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
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qdeclarativelinearlayout.h"
#include "qdeclarativelayoutengine_p.h"
#include <QtCore/qnumeric.h>

static const qreal q_declarativeLayoutDefaultSpacing = 4.0;


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
    invalidate();
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
    invalidate();

    emit orientationChanged();
}

void QDeclarativeLinearLayout::componentComplete()
{
    QDeclarativeLayout::componentComplete();
    updateLayoutItems();
    invalidate();
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
    invalidate();
}

void QDeclarativeLinearLayout::insertLayoutItem(QDeclarativeItem *item)
{
    m_items.append(item);
    setupItemLayout(item);

    invalidate();
    QObject::connect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
}

void QDeclarativeLinearLayout::removeLayoutItem(QDeclarativeItem *item)
{
    if (!m_items.removeOne(item))
        return;

    invalidate();
    QObject::disconnect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
}

void QDeclarativeLinearLayout::onItemDestroyed()
{
    if (!m_items.removeOne(static_cast<QDeclarativeItem *>(sender())))
        return;

    invalidate();
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
            data.stretch = info->horizontalSizePolicy() == Expanding ? 1.0 : 0;
        } else {
            data.sizeHint = item->implicitHeight();
            data.minimumSize = info->minimumHeight();
            data.maximumSize = info->maximumHeight();
            data.expansive = (info->verticalSizePolicy() == QDeclarativeLayout::Expanding);
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

    if (m_orientation == Horizontal) {
        qDeclarativeLayoutCalculate(itemData, 0, count, 0, width(), m_spacing);

        for (int i = 0; i < count; i++) {
            QDeclarativeItem *item = m_items.at(i);
            const QDeclarativeLayoutInfo &data = itemData.at(i);

            item->setX(data.pos);
            item->setY(height()/2 - item->height()/2);
            item->setWidth(data.size);
        }
    } else {
        qDeclarativeLayoutCalculate(itemData, 0, count, 0, height(), m_spacing);

        for (int i = 0; i < count; i++) {
            QDeclarativeItem *item = m_items.at(i);
            const QDeclarativeLayoutInfo &data = itemData.at(i);

            item->setY(data.pos);
            item->setX(width()/2 - item->width()/2);
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
