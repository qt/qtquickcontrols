/****************************************************************************
**
** Copyright (C) 2010 Digia Plc and/or its subsidiary(-ies).
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

#ifndef QDECLARATIVELAYOUT_H
#define QDECLARATIVELAYOUT_H

#include <QPointer>
#include <QQuickItem>

class QQuickComponentsLayoutAttached;


class QQuickComponentsLayout : public QQuickItem
{
    Q_OBJECT
    Q_ENUMS(SizePolicy)

public:
    enum SizePolicy {
        Fixed,
        Expanding
    };

    explicit QQuickComponentsLayout(QQuickItem *parent = 0);
    ~QQuickComponentsLayout();

    static QQuickComponentsLayoutAttached *qmlAttachedProperties(QObject *object);

protected:
    void invalidate();
    bool event(QEvent *e);
    void reconfigureTopDown();
    virtual void reconfigureLayout();
    void setupItemLayout(QQuickItem *item);

private:
    bool m_dirty;

    friend class QQuickComponentsLayoutAttached;
};


class QQuickComponentsLayoutAttached : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal minimumWidth READ minimumWidth WRITE setMinimumWidth)
    Q_PROPERTY(qreal minimumHeight READ minimumHeight WRITE setMinimumHeight)
    Q_PROPERTY(qreal maximumWidth READ maximumWidth WRITE setMaximumWidth)
    Q_PROPERTY(qreal maximumHeight READ maximumHeight WRITE setMaximumHeight)
    Q_PROPERTY(QQuickComponentsLayout::SizePolicy verticalSizePolicy READ verticalSizePolicy WRITE setVerticalSizePolicy)
    Q_PROPERTY(QQuickComponentsLayout::SizePolicy horizontalSizePolicy READ horizontalSizePolicy WRITE setHorizontalSizePolicy)

public:
    QQuickComponentsLayoutAttached(QObject *object);

    qreal minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(qreal width);

    qreal minimumHeight() const { return m_minimumHeight; }
    void setMinimumHeight(qreal height);

    qreal maximumWidth() const { return m_maximumWidth; }
    void setMaximumWidth(qreal width);

    qreal maximumHeight() const { return m_maximumHeight; }
    void setMaximumHeight(qreal height);

    QQuickComponentsLayout::SizePolicy verticalSizePolicy() const { return m_verticalSizePolicy; }
    void setVerticalSizePolicy(QQuickComponentsLayout::SizePolicy policy);

    QQuickComponentsLayout::SizePolicy horizontalSizePolicy() const { return m_horizontalSizePolicy; }
    void setHorizontalSizePolicy(QQuickComponentsLayout::SizePolicy policy);

protected:
    void updateLayout();

private:
    qreal m_minimumWidth;
    qreal m_minimumHeight;
    qreal m_maximumWidth;
    qreal m_maximumHeight;
    QQuickComponentsLayout::SizePolicy m_verticalSizePolicy;
    QQuickComponentsLayout::SizePolicy m_horizontalSizePolicy;
    QPointer<QQuickComponentsLayout> m_layout;

    friend class QQuickComponentsLayout;
};

QML_DECLARE_TYPE(QQuickComponentsLayout)
QML_DECLARE_TYPEINFO(QQuickComponentsLayout, QML_HAS_ATTACHED_PROPERTIES)

#endif
