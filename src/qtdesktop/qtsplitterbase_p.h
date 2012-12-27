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

#ifndef QTSPLITTERBASE_H
#define QTSPLITTERBASE_H

#include <QtQml>
#include <QtQuick>


class QtSplitterAttached : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal minimumWidth READ minimumWidth WRITE setMinimumWidth NOTIFY minimumWidthChanged)
    Q_PROPERTY(qreal maximumWidth READ maximumWidth WRITE setMaximumWidth NOTIFY maximumWidthChanged)
    Q_PROPERTY(qreal minimumHeight READ minimumHeight WRITE setMinimumHeight NOTIFY minimumHeightChanged)
    Q_PROPERTY(qreal maximumHeight READ maximumHeight WRITE setMaximumHeight NOTIFY maximumHeightChanged)
    Q_PROPERTY(qreal percentageSize READ percentageSize WRITE setPercentageSize NOTIFY percentageWidthSize)
    Q_PROPERTY(bool expanding READ expanding WRITE setExpanding NOTIFY expandingChanged)
    Q_PROPERTY(int itemIndex READ itemIndex WRITE setItemIndex NOTIFY itemIndexChanged)

public:
    explicit QtSplitterAttached(QObject *object);

    qreal minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(qreal width);

    qreal maximumWidth() const { return m_maximumWidth; }
    void setMaximumWidth(qreal width);

    qreal minimumHeight() const { return m_minimumHeight; }
    void setMinimumHeight(qreal width);

    qreal maximumHeight() const { return m_maximumHeight; }
    void setMaximumHeight(qreal width);

    bool expanding() const { return m_expanding; }
    void setExpanding(bool expanding);

    qreal percentageSize() const { return m_percentageSize; }

    int itemIndex() const { return m_itemIndex; }

    void setPercentageSize(qreal arg) { m_percentageSize = arg; }
    void setItemIndex(int arg) {
        if (m_itemIndex != arg) {
            m_itemIndex = arg;
            emit itemIndexChanged(arg);
        }
    }

signals:
    void minimumWidthChanged(qreal arg);
    void maximumWidthChanged(qreal arg);
    void minimumHeightChanged(qreal arg);
    void maximumHeightChanged(qreal arg);
    void expandingChanged(bool arg);
    void percentageWidthSize(qreal arg);
    void itemIndexChanged(int arg);

private:
    qreal m_minimumWidth;
    qreal m_maximumWidth;
    qreal m_minimumHeight;
    qreal m_maximumHeight;
    qreal m_percentageSize;
    int m_itemIndex;
    bool m_expanding;

    friend class QtSplitterBase;
};


class QtSplitterBase : public QQuickItem
{
    Q_OBJECT
public:
    explicit QtSplitterBase(QQuickItem *parent = 0);
    ~QtSplitterBase() {}

    static QtSplitterAttached *qmlAttachedProperties(QObject *object);
};

QML_DECLARE_TYPEINFO(QtSplitterBase, QML_HAS_ATTACHED_PROPERTIES)

#endif // QTSPLITTERBASE_H
