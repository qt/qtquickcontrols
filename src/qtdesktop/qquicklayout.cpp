/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
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

#include "qquicklayout.h"
#include <QEvent>
#include <QApplication>
#include <QtCore/qnumeric.h>

static const qreal q_declarativeLayoutMaxSize = 10e8;


QQuickComponentsLayoutAttached::QQuickComponentsLayoutAttached(QObject *parent)
    : QObject(parent),
      m_minimumWidth(0),
      m_minimumHeight(0),
      m_maximumWidth(q_declarativeLayoutMaxSize),
      m_maximumHeight(q_declarativeLayoutMaxSize),
      m_verticalSizePolicy(QQuickComponentsLayout::Fixed),
      m_horizontalSizePolicy(QQuickComponentsLayout::Fixed)
{

}

void QQuickComponentsLayoutAttached::setMinimumWidth(qreal width)
{
    if (qIsNaN(width) || m_minimumWidth == width)
        return;

    m_minimumWidth = width;
    updateLayout();
}

void QQuickComponentsLayoutAttached::setMinimumHeight(qreal height)
{
    if (qIsNaN(height) || m_minimumHeight == height)
        return;

    m_minimumHeight = height;
    updateLayout();
}

void QQuickComponentsLayoutAttached::setMaximumWidth(qreal width)
{
    if (qIsNaN(width) || m_maximumWidth == width)
        return;

    m_maximumWidth = width;
    updateLayout();
}

void QQuickComponentsLayoutAttached::setMaximumHeight(qreal height)
{
    if (qIsNaN(height) || m_maximumHeight == height)
        return;

    m_maximumHeight = height;
    updateLayout();
}

void QQuickComponentsLayoutAttached::setVerticalSizePolicy(QQuickComponentsLayout::SizePolicy policy)
{
    if (m_verticalSizePolicy != policy) {
        m_verticalSizePolicy = policy;
        updateLayout();
    }
}

void QQuickComponentsLayoutAttached::setHorizontalSizePolicy(QQuickComponentsLayout::SizePolicy policy)
{
    if (m_horizontalSizePolicy != policy) {
        m_horizontalSizePolicy = policy;
        updateLayout();
    }
}

void QQuickComponentsLayoutAttached::updateLayout()
{
    if (m_layout)
        m_layout->invalidate();
}



QQuickComponentsLayout::QQuickComponentsLayout(QQuickItem *parent)
    : QQuickItem(parent),
      m_dirty(false)
{

}

QQuickComponentsLayout::~QQuickComponentsLayout()
{

}

void QQuickComponentsLayout::setupItemLayout(QQuickItem *item)
{
    QObject *attached = qmlAttachedPropertiesObject<QQuickComponentsLayout>(item);
    QQuickComponentsLayoutAttached *info = static_cast<QQuickComponentsLayoutAttached *>(attached);
    info->m_layout = this;
}

QQuickComponentsLayoutAttached *QQuickComponentsLayout::qmlAttachedProperties(QObject *object)
{
    return new QQuickComponentsLayoutAttached(object);
}

bool QQuickComponentsLayout::event(QEvent *e)
{
    if (e->type() == QEvent::LayoutRequest)
        reconfigureTopDown();

    return QQuickItem::event(e);
}

void QQuickComponentsLayout::invalidate()
{
    if (m_dirty)
        return;

    QQuickComponentsLayout *layout = this;
    QQuickComponentsLayout *parentLayout = 0;

    while (!layout->m_dirty) {
        layout->m_dirty = true;
        parentLayout = qobject_cast<QQuickComponentsLayout *>(layout->parentItem());

        if (!parentLayout)
            break;
        else
            layout = parentLayout;
    }

    // just post events for top level layouts
    if (!parentLayout)
        QApplication::postEvent(layout, new QEvent(QEvent::LayoutRequest));
}

void QQuickComponentsLayout::reconfigureTopDown()
{
    const QList<QQuickItem *> &children = childItems();

    reconfigureLayout();

    foreach (QQuickItem *child, children) {
        QQuickComponentsLayout *layout = qobject_cast<QQuickComponentsLayout *>(child);

        if (layout && layout->m_dirty)
            layout->reconfigureTopDown();
    }

    m_dirty = false;
}

void QQuickComponentsLayout::reconfigureLayout()
{

}
