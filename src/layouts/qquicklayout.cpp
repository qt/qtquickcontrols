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

QT_BEGIN_NAMESPACE

QQuickLayoutAttached::QQuickLayoutAttached(QObject *parent)
    : QObject(parent),
      m_minimumWidth(0),
      m_minimumHeight(0),
      m_preferredWidth(0),
      m_preferredHeight(0),
      m_maximumWidth(q_declarativeLayoutMaxSize),
      m_maximumHeight(q_declarativeLayoutMaxSize),
      m_verticalSizePolicy(QQuickLayout::Unspecified),
      m_horizontalSizePolicy(QQuickLayout::Unspecified),
      m_row(0),
      m_column(0),
      m_rowSpan(1),
      m_columnSpan(1),
      m_changesNotificationEnabled(true)
{

}

void QQuickLayoutAttached::setMinimumWidth(qreal width)
{
    if (qIsNaN(width) || m_minimumWidth == width)
        return;

    m_minimumWidth = width;
    invalidateItem();
    emit minimumWidthChanged();
}

void QQuickLayoutAttached::setMinimumHeight(qreal height)
{
    if (qIsNaN(height) || m_minimumHeight == height)
        return;

    m_minimumHeight = height;
    invalidateItem();
    emit minimumHeightChanged();
}

void QQuickLayoutAttached::setPreferredWidth(qreal width)
{
    if (qIsNaN(width) || m_preferredWidth == width)
        return;

    m_preferredWidth = width;
    if (m_changesNotificationEnabled)
        invalidateItem();
    emit preferredWidthChanged();
}

void QQuickLayoutAttached::setPreferredHeight(qreal height)
{
    if (qIsNaN(height) || m_preferredHeight == height)
        return;

    m_preferredHeight = height;
    if (m_changesNotificationEnabled)
        invalidateItem();
    emit preferredHeightChanged();
}

void QQuickLayoutAttached::setMaximumWidth(qreal width)
{
    if (qIsNaN(width) || m_maximumWidth == width)
        return;

    m_maximumWidth = width;
    invalidateItem();
    emit maximumWidthChanged();
}

void QQuickLayoutAttached::setMaximumHeight(qreal height)
{
    if (qIsNaN(height) || m_maximumHeight == height)
        return;

    m_maximumHeight = height;
    invalidateItem();
    emit maximumHeightChanged();
}

void QQuickLayoutAttached::setVerticalSizePolicy(QQuickLayout::SizePolicy policy)
{
    if (m_verticalSizePolicy != policy) {
        m_verticalSizePolicy = policy;
        invalidateItem();
        emit verticalSizePolicyChanged();
    }
}

void QQuickLayoutAttached::setHorizontalSizePolicy(QQuickLayout::SizePolicy policy)
{
    if (m_horizontalSizePolicy != policy) {
        m_horizontalSizePolicy = policy;
        invalidateItem();
        emit horizontalSizePolicyChanged();
    }
}

void QQuickLayoutAttached::invalidateItem()
{
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

void QQuickLayout::setupItemLayout(QQuickItem *item)
{
    //### not needed anymore, since these are deducted from hierarcy?
    qmlAttachedPropertiesObject<QQuickLayout>(item);
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

    if (QQuickLayout *parentLayout = qobject_cast<QQuickLayout *>(parentItem())) {
        parentLayout->invalidate(this);
    } else {
        quickLayoutDebug() << "QQuickLayout::invalidate(), postEvent";
        QCoreApplication::postEvent(this, new QEvent(QEvent::LayoutRequest));
    }
}

void QQuickLayout::rearrange(const QSizeF &/*size*/)
{
    m_dirty = false;
}

QT_END_NAMESPACE
