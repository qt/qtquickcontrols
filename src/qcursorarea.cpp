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

QCursorArea::QCursorArea(QDeclarativeItem *parent)
    : QDeclarativeItem(parent),
      m_cursor(DefaultCursor)
{

}

void QCursorArea::setCursor(Cursor cursor)
{
    if (m_cursor == cursor)
        return;

    switch (cursor) {
    case DefaultCursor:
        QDeclarativeItem::setCursor(QCursor());
        break;
    case ArrowCursor:
        QDeclarativeItem::setCursor(Qt::ArrowCursor);
        break;
    case SizeHorCursor:
        QDeclarativeItem::setCursor(Qt::SizeHorCursor);
        break;
    case SizeVerCursor:
        QDeclarativeItem::setCursor(Qt::SizeVerCursor);
        break;
    case SizeAllCursor:
        QDeclarativeItem::setCursor(Qt::SizeAllCursor);
        break;
    case SplitHCursor:
        QDeclarativeItem::setCursor(Qt::SplitHCursor);
        break;
    case SplitVCursor:
        QDeclarativeItem::setCursor(Qt::SplitVCursor);
        break;
    case WaitCursor:
        QDeclarativeItem::setCursor(Qt::WaitCursor);
        break;
    case PointingHandCursor:
        QDeclarativeItem::setCursor(Qt::PointingHandCursor);
        break;
    default:
        return;
    }

    m_cursor = cursor;
    emit cursorChanged();
}
