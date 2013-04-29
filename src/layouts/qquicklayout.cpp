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

#include "qquicklayout_p.h"
#include <QEvent>
#include <QtCore/qcoreapplication.h>
#include <QtCore/qnumeric.h>

/*!
    \qmltype Layout
    \instantiates QQuickLayoutAttached
    \inqmlmodule QtQuick.Layouts 1.0
    \ingroup layouts
    \brief Provides attached properties for items pushed onto a \l GridLayout,
    \l RowLayout or \l ColumnLayout.

    An object of type Layout is attached to children of the layout to provide layout specific
    information about the item.
    The properties of the attached object influences how the layout will arrange the items.

    For instance, you can specify \l minimumWidth, \l preferredWidth, and
    \l maximumWidth if the default values are not satisfactory.

    \l fillWidth and \l fillHeight allows you to specify whether an item should
    fill the cell(s) it occupies. This allows it to stretch between \l minimumWidth
    and \l maximumWidth (or \l minimumHeight and \l maximumHeight if \l fillHeight is \c true).

    If \l fillWidth or \l fillHeight is \c false, the items' size will be fixed to its preferred size.

    \sa GridLayout
    \sa RowLayout
    \sa ColumnLayout
*/

QT_BEGIN_NAMESPACE

QQuickLayoutAttached::QQuickLayoutAttached(QObject *parent)
    : QObject(parent),
      m_minimumWidth(0),
      m_minimumHeight(0),
      m_preferredWidth(-1),
      m_preferredHeight(-1),
      m_maximumWidth(-1),
      m_maximumHeight(-1),
      m_row(-1),
      m_column(-1),
      m_rowSpan(1),
      m_columnSpan(1),
      m_fillWidth(false),
      m_fillHeight(false),
      m_isFillWidthSet(false),
      m_isFillHeightSet(false),
      m_isMinimumWidthSet(false),
      m_isMinimumHeightSet(false),
      m_isMaximumWidthSet(false),
      m_isMaximumHeightSet(false),
      m_changesNotificationEnabled(true),
      m_alignment(0)
{

}

/*!
    \qmlproperty real Layout::minimumWidth

    This property holds the minimum width of an item in a layout.
    The default is \c 0.

    \sa preferredWidth
    \sa maximumWidth
*/
void QQuickLayoutAttached::setMinimumWidth(qreal width)
{
    if (qIsNaN(width))
        return;
    m_isMinimumWidthSet = width >= 0;
    if (m_minimumWidth == width)
        return;

    m_minimumWidth = width;
    invalidateItem();
    emit minimumWidthChanged();
}

/*!
    \qmlproperty real Layout::minimumHeight

    This property holds the minimum height of an item in a layout.
    The default is \c 0.

    \sa preferredHeight
    \sa maximumHeight
*/
void QQuickLayoutAttached::setMinimumHeight(qreal height)
{
    if (qIsNaN(height))
        return;
    m_isMinimumHeightSet = height >= 0;
    if (m_minimumHeight == height)
        return;

    m_minimumHeight = height;
    invalidateItem();
    emit minimumHeightChanged();
}

/*!
    \qmlproperty real Layout::preferredWidth

    This property holds the preferred width of an item in a layout.
    If the preferred width is -1 it will be ignored, and the layout
    will use {Item::implicitWidth}{implicitWidth} instead.
    The default is \c -1.

    \sa minimumWidth
    \sa maximumWidth
*/
void QQuickLayoutAttached::setPreferredWidth(qreal width)
{
    if (qIsNaN(width) || m_preferredWidth == width)
        return;

    m_preferredWidth = width;
    invalidateItem();
    emit preferredWidthChanged();
}

/*!
    \qmlproperty real Layout::preferredHeight

    This property holds the preferred height of an item in a layout.
    If the preferred height is -1 it will be ignored, and the layout
    will use {Item::implicitHeight}{implicitHeight} instead.
    The default is \c -1.

    \sa minimumHeight
    \sa maximumHeight
*/
void QQuickLayoutAttached::setPreferredHeight(qreal height)
{
    if (qIsNaN(height) || m_preferredHeight == height)
        return;

    m_preferredHeight = height;
    invalidateItem();
    emit preferredHeightChanged();
}

/*!
    \qmlproperty real Layout::maximumWidth

    This property holds the maximum width of an item in a layout.
    The default is \c -1, which means it there is no limit on the maxiumum width.

    \note There is actually a limit on the maximum width, but it's set to such a
    large number that the arrangement is virtually the same as if it didn't have a limit.

    \sa minimumWidth
    \sa preferredWidth
*/
void QQuickLayoutAttached::setMaximumWidth(qreal width)
{
    if (qIsNaN(width))
        return;
    m_isMaximumWidthSet = width >= 0;
    if (m_maximumWidth == width)
        return;

    m_maximumWidth = width;
    invalidateItem();
    emit maximumWidthChanged();
}

/*!
    \qmlproperty real Layout::maximumHeight

    This property holds the maximum height of an item in a layout.
    The default is \c -1, which means it there is no limit on the maxiumum height.

    \note There is actually a limit on the maximum height, but it's set to such a
    large number that the arrangement is virtually the same as if it didn't have a limit.

    \sa minimumHeight
    \sa preferredHeight
*/
void QQuickLayoutAttached::setMaximumHeight(qreal height)
{
    if (qIsNaN(height))
        return;
    m_isMaximumHeightSet = height >= 0;
    if (m_maximumHeight == height)
        return;

    m_maximumHeight = height;
    invalidateItem();
    emit maximumHeightChanged();
}

void QQuickLayoutAttached::setMinimumImplicitSize(const QSizeF &sz)
{
    bool emitWidthChanged = false;
    bool emitHeightChanged = false;
    if (!m_isMinimumWidthSet && m_minimumWidth != sz.width()) {
        m_minimumWidth = sz.width();
        emitWidthChanged = true;
    }
    if (!m_isMinimumHeightSet && m_minimumHeight != sz.height()) {
        m_minimumHeight = sz.height();
        emitHeightChanged = true;
    }
    // Only invalidate the item once, and make sure we emit signal changed after the call to
    // invalidateItem()
    if (emitWidthChanged || emitHeightChanged) {
        invalidateItem();
        if (emitWidthChanged)
            emit minimumWidthChanged();
        if (emitHeightChanged)
            emit minimumHeightChanged();
    }
}

void QQuickLayoutAttached::setMaximumImplicitSize(const QSizeF &sz)
{
    bool emitWidthChanged = false;
    bool emitHeightChanged = false;
    if (!m_isMaximumWidthSet && m_maximumWidth != sz.width()) {
        m_maximumWidth = sz.width();
        emitWidthChanged = true;
    }
    if (!m_isMaximumHeightSet && m_maximumHeight != sz.height()) {
        m_maximumHeight = sz.height();
        emitHeightChanged = true;
    }
    // Only invalidate the item once, and make sure we emit changed signal after the call to
    // invalidateItem()
    if (emitWidthChanged || emitHeightChanged) {
        invalidateItem();
        if (emitWidthChanged)
            emit maximumWidthChanged();
        if (emitHeightChanged)
            emit maximumHeightChanged();
    }
}

/*!
    \qmlproperty bool Layout::fillWidth

    If this property is \c true, the item will be as wide as possible while respecting
    the given constraints. If the property is \c false, the item will have a fixed width
    set to the preferred width.
    The default is \c false, except for layouts themselves which defaults to \c true.

    \sa fillHeight
*/
void QQuickLayoutAttached::setFillWidth(bool fill)
{
    m_isFillWidthSet = true;
    if (m_fillWidth != fill) {
        m_fillWidth = fill;
        invalidateItem();
        emit fillWidthChanged();
    }
}

/*!
    \qmlproperty bool Layout::fillHeight

    If this property is \c true, the item will be as tall as possible while respecting
    the given constraints. If the property is \c false, the item will have a fixed height
    set to the preferred height.
    The default is \c false, except for layouts themselves which defaults to \c true.

    \sa fillWidth
*/
void QQuickLayoutAttached::setFillHeight(bool fill)
{
    m_isFillHeightSet = true;
    if (m_fillHeight != fill) {
        m_fillHeight = fill;
        invalidateItem();
        emit fillHeightChanged();
    }
}

/*!
    \qmlproperty int Layout::row

    This property allows you to specify the row position of an item in a \l GridLayout.

    If both \l column and this property are not set, it is up to the layout to assign a cell to the item.

    The default value is \c 0.

    \sa column
    \sa rowSpan
*/
void QQuickLayoutAttached::setRow(int row)
{
    if (row >= 0 && row != m_row)
        m_row = row;
}

/*!
    \qmlproperty int Layout::column

    This property allows you to specify the column position of an item in a \l GridLayout.

    If both \l row and this property are not set, it is up to the layout to assign a cell to the item.

    The default value is \c 0.

    \sa row
    \sa columnSpan
*/
void QQuickLayoutAttached::setColumn(int column)
{
    if (column >= 0 && column != m_column)
        m_column = column;
}


/*!
    \qmlproperty Qt.Alignment Layout::alignment

    This property allows you to specify the alignment of an item within the cell(s) it occupies.

    The default value is \c 0, which means it will be \c{Qt.AlignVCenter | Qt.AlignLeft}
*/


/*!
    \qmlproperty int Layout::rowSpan

    This property allows you to specify the row span of an item in a \l GridLayout.

    The default value is \c 1.

    \sa columnSpan
    \sa row
*/


/*!
    \qmlproperty int Layout::columnSpan

    This property allows you to specify the column span of an item in a \l GridLayout.

    The default value is \c 1.

    \sa rowSpan
    \sa column
*/

void QQuickLayoutAttached::invalidateItem()
{
    if (!m_changesNotificationEnabled)
        return;
    quickLayoutDebug() << "QQuickLayoutAttached::invalidateItem";
    if (QQuickLayout *layout = parentLayout()) {
        layout->invalidate(item());
    }
}

QQuickLayout *QQuickLayoutAttached::parentLayout() const
{
    QQuickItem *parentItem = item()->parentItem();
    if (qobject_cast<QQuickLayout *>(parentItem))
        return static_cast<QQuickLayout *>(parentItem);
    return 0;
}

QQuickItem *QQuickLayoutAttached::item() const
{
    Q_ASSERT(qobject_cast<QQuickItem*>(parent()));
    return static_cast<QQuickItem*>(parent());
}





QQuickLayout::QQuickLayout(QQuickLayoutPrivate &dd, QQuickItem *parent)
    : QQuickItem(dd, parent),
      m_dirty(false)
{
}

QQuickLayout::~QQuickLayout()
{

}

QQuickLayoutAttached *QQuickLayout::qmlAttachedProperties(QObject *object)
{
    return new QQuickLayoutAttached(object);
}

bool QQuickLayout::event(QEvent *e)
{
    if (e->type() == QEvent::LayoutRequest)
        rearrange(QSizeF(width(), height()));

    return QQuickItem::event(e);
}

void QQuickLayout::componentComplete()
{
    QQuickItem::componentComplete();
}

void QQuickLayout::invalidate(QQuickItem * /*childItem*/)
{
    if (m_dirty)
        return;

    m_dirty = true;

    if (!qobject_cast<QQuickLayout *>(parentItem())) {
        quickLayoutDebug() << "QQuickLayout::invalidate(), postEvent";
        QCoreApplication::postEvent(this, new QEvent(QEvent::LayoutRequest));
    }
}

void QQuickLayout::rearrange(const QSizeF &/*size*/)
{
    m_dirty = false;
}

QT_END_NAMESPACE
