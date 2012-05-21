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

#include "qtooltiparea.h"
#include <QGraphicsView>
#include <QToolTip>
#include <QApplication>
#include <QGraphicsSceneEvent>

QTooltipArea::QTooltipArea(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    m_containsMouse(false)
{
    setAcceptHoverEvents(true);
    connect(&m_tiptimer, SIGNAL(timeout()), this, SLOT(timeout()));
    m_tiptimer.setSingleShot(true);
}

void QTooltipArea::setText(const QString &t)
{
    if (t != m_text) {
        m_text = t;
        emit textChanged();
    }
}

void QTooltipArea::showToolTip(const QString &str) const
{
    QToolTip::showText(cursor().pos(), str);
}

void QTooltipArea::hoverEnterEvent(QGraphicsSceneHoverEvent *event)
{
    m_tiptimer.start(1000);

    m_containsMouse = true;
    emit containsMouseChanged();
    QDeclarativeItem::hoverEnterEvent(event);
}

void QTooltipArea::hoverLeaveEvent(QGraphicsSceneHoverEvent *event)
{
    m_tiptimer.stop();
    m_containsMouse = false;
    emit containsMouseChanged();
    QDeclarativeItem::hoverLeaveEvent(event);
}

void QTooltipArea::timeout()
{
    showToolTip(m_text);
}
