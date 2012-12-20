/****************************************************************************
**
** Copyright (C) 2010 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
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

#include "qquicklinearlayout.h"
#include "qquicklayoutengine_p.h"
#include <QtCore/qnumeric.h>

/*!
    \qmltype RowLayout
    \instantiates QQuickComponentsRowLayout
    \inqmlmodule QtDesktop 1.0
    \brief RowLayout is doing bla...bla...
*/

/*!
    \qmltype ColumnLayout
    \instantiates QQuickComponentsColumnLayout
    \inqmlmodule QtDesktop 1.0
    \brief ColumnLayout is doing bla...bla...
*/

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
}

void QQuickComponentsLinearLayout::removeLayoutItem(QQuickItem *item)
{
    if (!m_items.removeOne(item))
        return;

    invalidate();
    QObject::disconnect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
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

    if (m_orientation == Horizontal) {
        qDeclarativeLayoutCalculate(itemData, 0, count, 0, width(), m_spacing);

        for (int i = 0; i < count; i++) {
            QQuickItem *item = m_items.at(i);
            const QQuickComponentsLayoutInfo &data = itemData.at(i);

            item->setX(data.pos);
            item->setY(height()/2 - item->height()/2);
            item->setWidth(data.size);
        }
    } else {
        qDeclarativeLayoutCalculate(itemData, 0, count, 0, height(), m_spacing);

        for (int i = 0; i < count; i++) {
            QQuickItem *item = m_items.at(i);
            const QQuickComponentsLayoutInfo &data = itemData.at(i);

            item->setY(data.pos);
            item->setX(width()/2 - item->width()/2);
            item->setHeight(data.size);
        }
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
