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
#include <limits>

/*!
    \qmltype RowLayout
    \instantiates QQuickRowLayout
    \inqmlmodule QtQuick.Layouts 1.0
    \ingroup layouts
    \brief Identical to \l GridLayout, but having only one row.

    It is available as a convenience for developers, as it offers a cleaner API.

    \sa ColumnLayout
    \sa GridLayout
*/

/*!
    \qmltype ColumnLayout
    \instantiates QQuickColumnLayout
    \inqmlmodule QtQuick.Layouts 1.0
    \ingroup layouts
    \brief Identical to \l GridLayout, but having only one column.

    It is available as a convenience for developers, as it offers a cleaner API.

    \sa RowLayout
    \sa GridLayout
*/


/*!
    \qmltype GridLayout
    \instantiates QQuickGridLayout
    \inqmlmodule QtQuick.Layouts 1.0
    \ingroup layouts
    \brief Provides a way of dynamically arranging items in a grid.

    If the GridLayout is resized, all items in the layout will be rearranged. It is similar
    to the widget-based QGridLayout. All children of the GridLayout element will belong to
    the layout. If you want a layout with just one row or one column, you can use the
    \l RowLayout or \l ColumnLayout. These offers a bit more convenient API, and improves
    readability.

    By default items will be arranged according to the \l flow property. The default value of
    the \l flow property is \c GridLayout.LeftToRight.

    If the \l columns property is specified, it will be treated as a maximum bound of how many
    columns the layout can have, before the auto-positioning wraps back to the beginning of the
    next row. The \l columns property is only used when \l flow is  \c GridLayout.LeftToRight.

    \code
        GridLayout {
            id: grid
            columns: 3
            Text { text: "Three" }
            Text { text: "words" }
            Text { text: "in" }
            Text { text: "a" }
            Text { text: "row" }
        }
    \endcode

    The \l rows property works in a similar way, but items are auto-positioned vertically.
    The \l rows property is only used when \l flow is  \c GridLayout.TopToBottom.

    You can specify which cell you want an item to occupy by setting the \c Layout.row
    and \c Layout.column properties. You can also specify the row span or column span by
    setting the \c Layout.rowSpan or \c Layout.columnSpan properties.

    When the layout is resized, items may grow or shrink. Due to this, items have a
    minimum size, preferred size and a maximum size.

    Minimum size can be specified with the
    Layout.minimumWidth and Layout.minimumHeight properties. These properties are 0 by default.

    Preferred size can be specified with the Layout.preferredWidth and Layout.preferredHeight
    properties. If Layout.preferredWidth or Layout.preferredHeight is not specified, it will
    use the items' implicitWidth or implicitHeight as the preferred size. Finally, if
    neither of these properties are set, it will use the width and height properties of the item.

    \note It is not recommended to have bindings to the width and height properties of items in a
    GridLayout, since this would conflict with the goal of the GridLayout.

    Maximum size can be specified with the Layout.maximumWidth and Layout.maximumHeight
    properties. If not set, these properties will be interpreted as infinite.

    \note They are not actually infinite, but simply set to a very high value. The result of
    the arrangement is virtually the same as if it was infinite.

    The \c Layout.fillWidth and \c Layout.fillHeight can either be
    \c true or \c false. If it is \c false, the items size will be fixed to its preferred size.
    Otherwise, it will grow or shrink between its minimum
    and maximum bounds.

    \sa RowLayout
    \sa ColumnLayout

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
    if (!isComponentComplete() || !isVisible())
        return;
    quickLayoutDebug() << "QQuickGridLayoutBase::updateLayoutItems";
    d->engine.deleteItems();
    insertLayoutItems();

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

/*!
    \qmlproperty real GridLayout::columnSpacing

    This property holds the spacing between each column.
    The default value is \c 4.
*/
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

/*!
    \qmlproperty real GridLayout::rowSpacing

    This property holds the spacing between each row.
    The default value is \c 4.
*/
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

/*!
    \qmlproperty int GridLayout::columns

    This property holds the column limit for items positioned if \l flow is
    \c GridLayout.LeftToRight.
    The default value is that there is no limit.
*/
int QQuickGridLayout::columns() const
{
    Q_D(const QQuickGridLayout);
    return d->columns;
}

void QQuickGridLayout::setColumns(int columns)
{
    Q_D(QQuickGridLayout);
    if (d->columns == columns)
        return;
    d->columns = columns;
    invalidate();
    emit columnsChanged();
}


/*!
    \qmlproperty int GridLayout::rows

    This property holds the row limit for items positioned if \l flow is \c GridLayout.TopToBottom.
    The default value is that there is no limit.
*/
int QQuickGridLayout::rows() const
{
    Q_D(const QQuickGridLayout);
    return d->rows;
}

void QQuickGridLayout::setRows(int rows)
{
    Q_D(QQuickGridLayout);
    if (d->rows == rows)
        return;
    d->rows = rows;
    invalidate();
    emit rowsChanged();
}


/*!
    \qmlproperty enumeration GridLayout::flow

    This property holds the flow direction of items that does not have an explicit cell
    position set.
    It is used together with the \l columns or \l rows property, where
    they specify when flow is reset to the next row or column respectively.

    Possible values are:

    \list
    \li GridLayout.LeftToRight (default) - Items are positioned next to
       each other, then wrapped to the next line.
    \li GridLayout.TopToBottom - Items are positioned next to each
       other from top to bottom, then wrapped to the next column.
    \endlist

    \sa rows
    \sa columns
*/
QQuickGridLayout::Flow QQuickGridLayout::flow() const
{
    Q_D(const QQuickGridLayout);
    return d->flow;
}

void QQuickGridLayout::setFlow(QQuickGridLayout::Flow flow)
{
    Q_D(QQuickGridLayout);
    if (d->flow == flow)
        return;
    d->flow = flow;
    invalidate();
    emit flowChanged();
}

void QQuickGridLayout::insertLayoutItems()
{
    Q_D(QQuickGridLayout);

    int nextCellPos[2] = {0,0};
    int &nextColumn = nextCellPos[0];
    int &nextRow = nextCellPos[1];

    const int flowOrientation = flow();
    int &flowColumn = nextCellPos[flowOrientation];
    int &flowRow = nextCellPos[1 - flowOrientation];
    int flowBound = (flowOrientation == QQuickGridLayout::LeftToRight) ? columns() : rows();

    if (flowBound < 0)
        flowBound = std::numeric_limits<int>::max();

    foreach (QQuickItem *child,  childItems()) {
        if (child->isVisible()) {
            Qt::Alignment alignment = 0;
            QQuickLayoutAttached *info = attachedLayoutObject(child, false);

            // Will skip Repeater among other things
            const bool skipItem = !info && (!child->width() || !child->height())
                      && (!child->implicitWidth() || !child->implicitHeight());
            if (skipItem)
                continue;

            int row = -1;
            int column = -1;
            int span[2] = {1,1};
            int &columnSpan = span[0];
            int &rowSpan = span[1];

            bool invalidRowColumn = false;
            if (info) {
                if (info->isRowSet() || info->isColumnSet()) {
                    // If row is specified and column is not specified (or vice versa),
                    // the unspecified component of the cell position should default to 0
                    row = column = 0;
                    if (info->isRowSet()) {
                        row = info->row();
                        invalidRowColumn = row < 0;
                    }
                    if (info->isColumnSet()) {
                        column = info->column();
                        invalidRowColumn = column < 0;
                    }
                }
                if (invalidRowColumn) {
                    qWarning("QQuickGridLayoutBase::insertLayoutItems: invalid row/column: %d",
                             row < 0 ? row : column);
                    return;
                }
                rowSpan = info->rowSpan();
                columnSpan = info->columnSpan();
                if (columnSpan < 1 || rowSpan < 1) {
                    qWarning("QQuickGridLayoutBase::addItem: invalid row span/column span: %d",
                             rowSpan < 1 ? rowSpan : columnSpan);
                    return;
                }

                alignment = info->alignment();
            }

            Q_ASSERT(columnSpan >= 1);
            Q_ASSERT(rowSpan >= 1);

            if (row >= 0)
                nextRow = row;
            if (column >= 0)
                nextColumn = column;

            if (row < 0 || column < 0) {
                /* if row or column is not specified, find next position by
                   advancing in the flow direction until there is a cell that
                   can accept the item.

                   The acceptance rules are pretty simple, but complexity arises
                   when an item requires several cells (due to spans):
                   1. Check if the cells that the item will require
                      does not extend beyond columns (for LeftToRight) or
                      rows (for TopToBottom).
                   2. Check if the cells that the item will require is not already
                      taken by another item.
                */
                bool cellAcceptsItem;
                while (true) {
                    // Check if the item does not span beyond the layout bound
                    cellAcceptsItem = (flowColumn + span[flowOrientation]) <= flowBound;

                    // Check if all the required cells are not taken
                    for (int rs = 0; cellAcceptsItem && rs < rowSpan; ++rs) {
                        for (int cs = 0; cellAcceptsItem && cs < columnSpan; ++cs) {
                            if (d->engine.itemAt(nextRow + rs, nextColumn + cs)) {
                                cellAcceptsItem = false;
                            }
                        }
                    }
                    if (cellAcceptsItem)
                        break;
                    ++flowColumn;
                    if (flowColumn == flowBound) {
                        flowColumn = 0;
                        ++flowRow;
                    }
                }
            }
            column = nextColumn;
            row = nextRow;
            QQuickGridLayoutItem *layoutItem = new QQuickGridLayoutItem(child, row, column, rowSpan, columnSpan, alignment);

            d->engine.insertItem(layoutItem, -1);
        }
    }
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

/*!
    \qmlproperty real RowLayout::spacing

    This property holds the spacing between each cell.
    The default value is \c 4.
*/
/*!
    \qmlproperty real ColumnLayout::spacing

    This property holds the spacing between each cell.
    The default value is \c 4.
*/

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

void QQuickLinearLayout::insertLayoutItems()
{
    Q_D(QQuickLinearLayout);
    foreach (QQuickItem *child,  childItems()) {
        Q_ASSERT(child);
        if (child->isVisible()) {
            const int index = d->engine.rowCount(d->orientation);
            d->engine.insertRow(index, d->orientation);

            int gridRow = 0;
            int gridColumn = index;
            if (d->orientation == Qt::Vertical)
                qSwap(gridRow, gridColumn);
            QQuickGridLayoutItem *layoutItem = new QQuickGridLayoutItem(child, gridRow, gridColumn, 1, 1, 0);
            d->engine.insertItem(layoutItem, index);
        }
    }
}

QT_END_NAMESPACE
