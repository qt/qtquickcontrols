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

#include "qdeclarativelayout.h"
#include <QtCore/qnumeric.h>


static const qreal q_declarativeLayoutMaxSize = 10e8;


QDeclarativeLayoutAttached::QDeclarativeLayoutAttached(QObject *parent)
    : QObject(parent),
      m_minimumWidth(0),
      m_minimumHeight(0),
      m_maximumWidth(q_declarativeLayoutMaxSize),
      m_maximumHeight(q_declarativeLayoutMaxSize),
      m_verticalSizePolicy(QDeclarativeLayout::Fixed),
      m_horizontalSizePolicy(QDeclarativeLayout::Fixed)
{

}

void QDeclarativeLayoutAttached::setMinimumWidth(qreal width)
{
    if (qIsNaN(width) || m_minimumWidth == width)
        return;

    m_minimumWidth = width;
    updateLayout();
}

void QDeclarativeLayoutAttached::setMinimumHeight(qreal height)
{
    if (qIsNaN(height) || m_minimumHeight == height)
        return;

    m_minimumHeight = height;
    updateLayout();
}

void QDeclarativeLayoutAttached::setMaximumWidth(qreal width)
{
    if (qIsNaN(width) || m_maximumWidth == width)
        return;

    m_maximumWidth = width;
    updateLayout();
}

void QDeclarativeLayoutAttached::setMaximumHeight(qreal height)
{
    if (qIsNaN(height) || m_maximumHeight == height)
        return;

    m_maximumHeight = height;
    updateLayout();
}

void QDeclarativeLayoutAttached::setVerticalSizePolicy(QDeclarativeLayout::SizePolicy policy)
{
    if (m_verticalSizePolicy != policy) {
        m_verticalSizePolicy = policy;
        updateLayout();
    }
}

void QDeclarativeLayoutAttached::setHorizontalSizePolicy(QDeclarativeLayout::SizePolicy policy)
{
    if (m_horizontalSizePolicy != policy) {
        m_horizontalSizePolicy = policy;
        updateLayout();
    }
}

void QDeclarativeLayoutAttached::updateLayout()
{
    if (m_layout)
        m_layout->invalidate();
}



QDeclarativeLayout::QDeclarativeLayout(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
{

}

QDeclarativeLayout::~QDeclarativeLayout()
{

}

void QDeclarativeLayout::setupItemLayout(QDeclarativeItem *item)
{
    QObject *attached = qmlAttachedPropertiesObject<QDeclarativeLayout>(item);
    QDeclarativeLayoutAttached *info = static_cast<QDeclarativeLayoutAttached *>(attached);
    info->m_layout = this;
}

QDeclarativeLayoutAttached *QDeclarativeLayout::qmlAttachedProperties(QObject *object)
{
    return new QDeclarativeLayoutAttached(object);
}
