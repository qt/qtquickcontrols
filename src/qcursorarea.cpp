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

#include "qcursorarea.h"

QCursorArea::QCursorArea(QQuickItem *parent)
    : QQuickItem(parent),
      m_cursor(ArrowCursor)
{

}

void QCursorArea::setCursor(Cursor cursor)
{
    if (m_cursor == cursor)
        return;

#if 0
    switch (cursor) {
    case ArrowCursor:
        QQuickItem::setCursor(Qt::ArrowCursor);
        break;
    case SizeHorCursor:
        QQuickItem::setCursor(Qt::SizeHorCursor);
        break;
    case SizeVerCursor:
        QQuickItem::setCursor(Qt::SizeVerCursor);
        break;
    case SizeAllCursor:
        QQuickItem::setCursor(Qt::SizeAllCursor);
        break;
    case SplitHCursor:
        QQuickItem::setCursor(Qt::SplitHCursor);
        break;
    case SplitVCursor:
        QQuickItem::setCursor(Qt::SplitVCursor);
        break;
    case WaitCursor:
        QQuickItem::setCursor(Qt::WaitCursor);
        break;
    case PointingHandCursor:
        QQuickItem::setCursor(Qt::PointingHandCursor);
        break;
    default:
        return;
    }
#endif

    m_cursor = cursor;
    emit cursorChanged();
}
