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

#ifndef QWHEELAREA_H
#define QWHEELAREA_H

#include <QtGui/qevent.h>
#include <QtWidgets/qgraphicssceneevent.h>
#include <QtQuick/qquickitem.h>


class QWheelArea : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(qreal verticalDelta READ verticalDelta WRITE setVerticalDelta NOTIFY verticalWheelMoved)
    Q_PROPERTY(qreal horizontalDelta READ horizontalDelta WRITE setHorizontalDelta NOTIFY horizontalWheelMoved)
    Q_PROPERTY(qreal horizontalMinimumValue READ horizontalMinimumValue WRITE setHorizontalMinimumValue)
    Q_PROPERTY(qreal horizontalMaximumValue READ horizontalMaximumValue WRITE setHorizontalMaximumValue)
    Q_PROPERTY(qreal verticalMinimumValue READ verticalMinimumValue WRITE setVerticalMinimumValue)
    Q_PROPERTY(qreal verticalMaximumValue READ verticalMaximumValue WRITE setVerticalMaximumValue)
    Q_PROPERTY(qreal horizontalValue READ horizontalValue WRITE setHorizontalValue)
    Q_PROPERTY(qreal verticalValue READ verticalValue WRITE setVerticalValue)
    Q_PROPERTY(qreal scrollSpeed READ scrollSpeed WRITE setScrollSpeed NOTIFY scrollSpeedChanged)

public:
    QWheelArea(QQuickItem *parent = 0);
    virtual ~QWheelArea();

    void setHorizontalMinimumValue(qreal value);
    qreal horizontalMinimumValue() const;

    void setHorizontalMaximumValue(qreal value);
    qreal horizontalMaximumValue() const;

    void setVerticalMinimumValue(qreal value);
    qreal verticalMinimumValue() const;

    void setVerticalMaximumValue(qreal value);
    qreal verticalMaximumValue() const;

    void setHorizontalValue(qreal value);
    qreal horizontalValue() const;

    void setVerticalValue(qreal value);
    qreal verticalValue() const;

    void setVerticalDelta(qreal value);
    qreal verticalDelta() const;

    void setHorizontalDelta(qreal value);
    qreal horizontalDelta() const;

    void setScrollSpeed(qreal value);
    qreal scrollSpeed() const;

    void wheelEvent(QWheelEvent *event);

Q_SIGNALS:
    void verticalValueChanged();
    void horizontalValueChanged();
    void verticalWheelMoved();
    void horizontalWheelMoved();
    void scrollSpeedChanged();

private:
    qreal m_horizontalMinimumValue;
    qreal m_horizontalMaximumValue;
    qreal m_verticalMinimumValue;
    qreal m_verticalMaximumValue;
    qreal m_horizontalValue;
    qreal m_verticalValue;
    qreal m_verticalDelta;
    qreal m_horizontalDelta;
    qreal m_scrollSpeed;

    Q_DISABLE_COPY(QWheelArea)
};

QML_DECLARE_TYPE(QWheelArea)


#endif // QWHEELAREA_H
