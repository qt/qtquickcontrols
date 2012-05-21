/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
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
    case IBeamCursor:
        QDeclarativeItem::setCursor(Qt::IBeamCursor);
        break;
    default:
        return;
    }

    m_cursor = cursor;
    emit cursorChanged();
}
