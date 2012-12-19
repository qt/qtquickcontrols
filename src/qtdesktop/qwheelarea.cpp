/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
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

#include "qwheelarea.h"

/*!
    \qmltype WheelArea
    \instantiates QWheelArea
    \inqmlmodule QtDesktop 1.0
    \brief WheelArea is doing bla...bla...
*/

QWheelArea::QWheelArea(QQuickItem *parent)
    : QQuickItem(parent),
      m_horizontalMinimumValue(0),
      m_horizontalMaximumValue(0),
      m_verticalMinimumValue(0),
      m_verticalMaximumValue(0),
      m_horizontalValue(0),
      m_verticalValue(0),
      m_verticalDelta(0),
      m_horizontalDelta(0),
      m_scrollSpeed(1.0)
{

}

QWheelArea::~QWheelArea()
{

}

void QWheelArea::wheelEvent(QWheelEvent *we)
{
    if (we->orientation() == Qt::Vertical) {
        setVerticalDelta(we->delta());
    } else {
        setHorizontalDelta(we->delta());
    }
    we->accept();
}

void QWheelArea::setHorizontalMinimumValue(qreal value)
{
    m_horizontalMinimumValue = value;
}

qreal QWheelArea::horizontalMinimumValue() const
{
    return m_horizontalMinimumValue;
}

void QWheelArea::setHorizontalMaximumValue(qreal value)
{
    m_horizontalMaximumValue = value;
}

qreal QWheelArea::horizontalMaximumValue() const
{
    return m_horizontalMaximumValue;
}

void QWheelArea::setVerticalMinimumValue(qreal value)
{
    m_verticalMinimumValue = value;
}

qreal QWheelArea::verticalMinimumValue() const
{
    return m_verticalMinimumValue;
}

void QWheelArea::setVerticalMaximumValue(qreal value)
{
    m_verticalMaximumValue = value;
}

qreal QWheelArea::verticalMaximumValue() const
{
    return m_verticalMaximumValue;
}

void QWheelArea::setHorizontalValue(qreal value)
{
    value = qBound<qreal>(m_horizontalMinimumValue, value, m_horizontalMaximumValue);

    if (value != m_horizontalValue) {
        m_horizontalValue = value;
        emit horizontalValueChanged();
    }
}

qreal QWheelArea::horizontalValue() const
{
    return m_horizontalValue;
}

void QWheelArea::setVerticalValue(qreal value)
{
    value = qBound<qreal>(m_verticalMinimumValue, value, m_verticalMaximumValue);

    if (value != m_verticalValue) {
        m_verticalValue = value;
        emit verticalValueChanged();
    }
}

qreal QWheelArea::verticalValue() const
{
    return m_verticalValue;
}

void QWheelArea::setVerticalDelta(qreal value)
{
    m_verticalDelta = m_scrollSpeed * value / 15;
    setVerticalValue(m_verticalValue - m_verticalDelta);

    emit verticalWheelMoved();
}

qreal QWheelArea::verticalDelta() const
{
    return m_verticalDelta;
}

void QWheelArea::setHorizontalDelta(qreal value)
{
    m_horizontalDelta = value / 15;
    setHorizontalValue(m_horizontalValue - m_horizontalDelta);

    emit horizontalWheelMoved();
}

qreal QWheelArea::horizontalDelta() const
{
    return m_horizontalDelta;
}

void QWheelArea::setScrollSpeed(qreal value)
{
    if (value != m_scrollSpeed) {
        m_scrollSpeed = value;
        emit scrollSpeedChanged();
    }
}

qreal QWheelArea::scrollSpeed() const
{
    return m_scrollSpeed;
}
