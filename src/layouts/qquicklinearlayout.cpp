/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Layouts module of the Qt Toolkit.
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
#include <QtCore/qnumeric.h>
#include "qdebug.h"
/*!
    \qmltype RowLayout
    \instantiates QQuickRowLayout
    \inqmlmodule QtDesktop 1.0
    \brief RowLayout is doing bla...bla...
*/

/*!
    \qmltype ColumnLayout
    \instantiates QQuickColumnLayout
    \inqmlmodule QtDesktop 1.0
    \brief ColumnLayout is doing bla...bla...
*/

QT_BEGIN_NAMESPACE

static const qreal q_declarativeLayoutDefaultSpacing = 4.0;


QQuickGridLayoutBase::QQuickGridLayoutBase(QQuickGridLayoutBasePrivate &dd,
                                           Qt::Orientation orientation,
                                           QQuickItem *parent /*= 0*/)
    : QQuickLayout(dd, parent)
{
    Q_D(QQuickGridLayoutBase);
    d->orientation = orientation;
}

Qt::Orientation QQuickGridLayoutBase::orientation() const
{
    Q_D(const QQuickGridLayoutBase);
    return d->orientation;
}

void QQuickGridLayoutBase::setOrientation(Qt::Orientation orientation)
{
    Q_D(QQuickGridLayoutBase);
    if (d->orientation == orientation)
        return;

    d->orientation = orientation;
    invalidate();
}

void QQuickGridLayoutBase::componentComplete()
{
    Q_D(QQuickGridLayoutBase);
    quickLayoutDebug() << objectName() << "QQuickGridLayoutBase::componentComplete()" << parent();
    d->m_disableRearrange = true;
    QQuickLayout::componentComplete();    // will call our geometryChange(), (where isComponentComplete() == true)
    d->m_disableRearrange = false;
    updateLayoutItems();

    QQuickItem *par = parentItem();
    if (qobject_cast<QQuickLayout*>(par))
        return;
    rearrange(QSizeF(width(), height()));
}

/*
  Invalidation happens like this as a reaction to that a size hint changes on an item "a":

  Suppose we have the following Qml document:
    RowLayout {
        id: l1
        RowLayout {
            id: l2
            Item {
                id: a
            }
            Item {
                id: b
            }
        }
    }

  1.    l2->invalidateChildItem(a) is called on l2, where item refers to "a".
        (this will dirty the cached size hints of item "a")
  2.    l2->invalidate() is called
        this will :
            i)  invalidate the layout engine
            ii) dirty the cached size hints of item "l2" (by calling parentLayout()->invalidateChildItem

 */
/*!
   \internal

    Invalidates \a childItem and this layout.
    After a call to invalidate, the next call to retrieve e.g. sizeHint will be up-to date.
    This function will also call QQuickLayout::invalidate(0), to ensure that the parent layout
    is invalidated.
 */
void QQuickGridLayoutBase::invalidate(QQuickItem *childItem)
{
    Q_D(QQuickGridLayoutBase);
    if (!isComponentComplete())
        return;
    quickLayoutDebug() << "QQuickGridLayoutBase::invalidate()";

    if (childItem) {
        if (QQuickGridLayoutItem *layoutItem = d->engine.findLayoutItem(childItem))
            layoutItem->invalidate();
    }
    // invalidate engine
    d->engine.invalidate();

    QQuickLayout::invalidate(this);
}

void QQuickGridLayoutBase::updateLayoutItems()
{
    Q_D(QQuickGridLayoutBase);
    if (!isComponentComplete())
        return;
    quickLayoutDebug() << "QQuickGridLayoutBase::updateLayoutItems";
    d->engine.deleteItems();
    foreach (QQuickItem *child,  childItems()) {
        if (child->isVisible())
            insertLayoutItem(child);
    }

    invalidate();
    quickLayoutDebug() << "QQuickGridLayoutBase::updateLayoutItems LEAVING";
    propagateLayoutSizeHints();
}

void QQuickGridLayoutBase::propagateLayoutSizeHints()
{
    Q_D(QQuickGridLayoutBase);
    quickLayoutDebug() << "propagateLayoutSizeHints()";
    QObject *attached = qmlAttachedPropertiesObject<QQuickLayout>(this);
    QQuickLayoutAttached *info = static_cast<QQuickLayoutAttached *>(attached);

    const QSizeF min = d->engine.sizeHint(Qt::MinimumSize, QSizeF());
    const QSizeF pref = d->engine.sizeHint(Qt::PreferredSize, QSizeF());
    const QSizeF max = d->engine.sizeHint(Qt::MaximumSize, QSizeF());

    info->setMinimumWidth(min.width());
    info->setMinimumHeight(min.height());
    setImplicitWidth(pref.width());
    setImplicitHeight(pref.height());
    info->setMaximumWidth(max.width());
    info->setMaximumHeight(max.height());
}

void QQuickGridLayoutBase::itemChange(ItemChange change, const ItemChangeData &value)
{
    if (change == ItemChildAddedChange) {
        quickLayoutDebug() << "ItemChildAddedChange";
        QQuickItem *item = value.item;
        QObject::connect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
        QObject::connect(item, SIGNAL(visibleChanged()), this, SLOT(onItemVisibleChanged()));
        QObject::connect(item, SIGNAL(implicitWidthChanged()), this, SLOT(onItemImplicitSizeChanged()));
        QObject::connect(item, SIGNAL(implicitHeightChanged()), this, SLOT(onItemImplicitSizeChanged()));

        if (isComponentComplete() && isVisible())
            updateLayoutItems();
    } else if (change == ItemChildRemovedChange) {
        quickLayoutDebug() << "ItemChildRemovedChange";
        QQuickItem *item = value.item;
        QObject::disconnect(item, SIGNAL(destroyed()), this, SLOT(onItemDestroyed()));
        QObject::disconnect(item, SIGNAL(visibleChanged()), this, SLOT(onItemVisibleChanged()));
        QObject::disconnect(item, SIGNAL(implicitWidthChanged()), this, SLOT(onItemImplicitSizeChanged()));
        QObject::disconnect(item, SIGNAL(implicitHeightChanged()), this, SLOT(onItemImplicitSizeChanged()));
        if (isComponentComplete() && isVisible())
            updateLayoutItems();
    }

    QQuickLayout::itemChange(change, value);
}

void QQuickGridLayoutBase::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    Q_D(QQuickGridLayoutBase);
    QQuickLayout::geometryChanged(newGeometry, oldGeometry);
    if (d->m_disableRearrange || !isComponentComplete() || !newGeometry.isValid())
        return;
    quickLayoutDebug() << "QQuickGridLayoutBase::geometryChanged" << newGeometry << oldGeometry;
    rearrange(newGeometry.size());
}

void QQuickGridLayoutBase::insertLayoutItem(QQuickItem *item)
{
    Q_D(QQuickGridLayoutBase);
    if (!item) {
        qWarning("QGraphicsGridLayout::addItem: cannot add null item");
        return;
    }
    QQuickLayoutAttached *info = attachedLayoutObject(item, false);
    int row = 0;
    int column = 0;
    int rowSpan = 1;
    int columnSpan = 1;
    Qt::Alignment alignment = 0;
    if (info) {
        row = info->row();
        column = info->column();
        rowSpan = info->rowSpan();
        columnSpan = info->columnSpan();
    }
    if (row < 0 || column < 0) {
        qWarning("QQuickGridLayoutBase::insertLayoutItemAt: invalid row/column: %d",
                 row < 0 ? row : column);
        return;
    }
    if (columnSpan < 1 || rowSpan < 1) {
        qWarning("QQuickGridLayoutBase::addItem: invalid row span/column span: %d",
                 rowSpan < 1 ? rowSpan : columnSpan);
        return;
    }
    QQuickGridLayoutItem *layoutItem = new QQuickGridLayoutItem(item, row, column, rowSpan, columnSpan, alignment);
    d->engine.insertItem(layoutItem, -1);

    setupItemLayout(item);
}

void QQuickGridLayoutBase::removeGridItem(QGridLayoutItem *gridItem)
{
    Q_D(QQuickGridLayoutBase);
    const int index = gridItem->firstRow(d->orientation);
    d->engine.removeItem(gridItem);
    d->engine.removeRows(index, 1, d->orientation);
}

void QQuickGridLayoutBase::removeLayoutItem(QQuickItem *item)
{
    Q_D(QQuickGridLayoutBase);
    quickLayoutDebug() << "QQuickGridLayoutBase::removeLayoutItem";
    if (QQuickGridLayoutItem *gridItem = d->engine.findLayoutItem(item)) {
        removeGridItem(gridItem);
        delete gridItem;
        invalidate();
    }
}

void QQuickGridLayoutBase::onItemVisibleChanged()
{
    if (!isComponentComplete())
        return;
    quickLayoutDebug() << "QQuickGridLayoutBase::onItemVisibleChanged";
    updateLayoutItems();
}

void QQuickGridLayoutBase::onItemDestroyed()
{
    Q_D(QQuickGridLayoutBase);
    quickLayoutDebug() << "QQuickGridLayoutBase::onItemDestroyed";
    QQuickItem *inDestruction = static_cast<QQuickItem *>(sender());
    if (QQuickGridLayoutItem *gridItem = d->engine.findLayoutItem(inDestruction)) {
        removeGridItem(gridItem);
        delete gridItem;
        invalidate();
    }
}

void QQuickGridLayoutBase::onItemImplicitSizeChanged()
{
    QQuickItem *item = static_cast<QQuickItem *>(sender());
    Q_ASSERT(item);
    invalidate(item);
    propagateLayoutSizeHints();
}

void QQuickGridLayoutBase::rearrange(const QSizeF &size)
{
    Q_D(QQuickGridLayoutBase);
    if (!isComponentComplete())
        return;

    quickLayoutDebug() << objectName() << "QQuickGridLayoutBase::rearrange()" << size;
    Qt::LayoutDirection visualDir = Qt::LeftToRight;    // ### Fix if RTL support is needed
    d->engine.setVisualDirection(visualDir);

    /*
    qreal left, top, right, bottom;
    left = top = right = bottom = 0;                    // ### support for margins?
    if (visualDir == Qt::RightToLeft)
        qSwap(left, right);
    */

    d->engine.setGeometries(QRectF(QPointF(0,0), size));

    QQuickLayout::rearrange(size);
    // propagate hints to upper levels
    propagateLayoutSizeHints();
}


/**********************************
 **
 ** QQuickGridLayout
 **
 **/
QQuickGridLayout::QQuickGridLayout(QQuickItem *parent /* = 0*/)
    : QQuickGridLayoutBase(*new QQuickGridLayoutPrivate, Qt::Horizontal, parent)
{
    Q_D(QQuickGridLayout);
    d->columnSpacing = q_declarativeLayoutDefaultSpacing;
    d->rowSpacing = q_declarativeLayoutDefaultSpacing;
    d->engine.setSpacing(q_declarativeLayoutDefaultSpacing, Qt::Horizontal | Qt::Vertical);
}

qreal QQuickGridLayout::columnSpacing() const
{
    Q_D(const QQuickGridLayout);
    return d->columnSpacing;
}

void QQuickGridLayout::setColumnSpacing(qreal spacing)
{
    Q_D(QQuickGridLayout);
    if (qIsNaN(spacing) || d->columnSpacing == spacing)
        return;

    d->columnSpacing = spacing;
    d->engine.setSpacing(spacing, Qt::Horizontal);
    invalidate();
}

qreal QQuickGridLayout::rowSpacing() const
{
    Q_D(const QQuickGridLayout);
    return d->rowSpacing;
}

void QQuickGridLayout::setRowSpacing(qreal spacing)
{
    Q_D(QQuickGridLayout);
    if (qIsNaN(spacing) || d->rowSpacing == spacing)
        return;

    d->rowSpacing = spacing;
    d->engine.setSpacing(spacing, Qt::Vertical);
    invalidate();
}


/**********************************
 **
 ** QQuickLinearLayout
 **
 **/
QQuickLinearLayout::QQuickLinearLayout(Qt::Orientation orientation,
                                        QQuickItem *parent /*= 0*/)
    : QQuickGridLayoutBase(*new QQuickLinearLayoutPrivate, orientation, parent)
{
    Q_D(QQuickLinearLayout);
    d->spacing = q_declarativeLayoutDefaultSpacing;
    d->engine.setSpacing(d->spacing, Qt::Horizontal | Qt::Vertical);
}

qreal QQuickLinearLayout::spacing() const
{
    Q_D(const QQuickLinearLayout);
    return d->spacing;
}

void QQuickLinearLayout::setSpacing(qreal spacing)
{
    Q_D(QQuickLinearLayout);
    if (qIsNaN(spacing) || d->spacing == spacing)
        return;

    d->spacing = spacing;
    d->engine.setSpacing(spacing, Qt::Horizontal | Qt::Vertical);
    invalidate();
}


void QQuickLinearLayout::insertLayoutItem(QQuickItem *item)
{
    Q_D(QQuickLinearLayout);
    const int index = d->engine.rowCount(d->orientation);
    d->engine.insertRow(index, d->orientation);

    int gridRow = 0;
    int gridColumn = index;
    if (d->orientation == Qt::Vertical)
        qSwap(gridRow, gridColumn);
    QQuickGridLayoutItem *layoutItem = new QQuickGridLayoutItem(item, gridRow, gridColumn, 1, 1, 0);
    d->engine.insertItem(layoutItem, index);

    setupItemLayout(item);
}



QT_END_NAMESPACE
