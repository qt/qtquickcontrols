/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the examples of the Qt Toolkit.
**
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

#ifndef QDECLARATIVELAYOUT_H
#define QDECLARATIVELAYOUT_H

#include <QPointer>
#include <QDeclarativeItem>

class QDeclarativeLayoutAttached;


class QDeclarativeLayout : public QDeclarativeItem
{
    Q_OBJECT
    Q_ENUMS(SizePolicy)

public:
    enum SizePolicy {
        Fixed,
        Expanding
    };

    explicit QDeclarativeLayout(QDeclarativeItem *parent = 0);
    ~QDeclarativeLayout();

    static QDeclarativeLayoutAttached *qmlAttachedProperties(QObject *object);

protected:
    void invalidate();
    bool event(QEvent *e);
    void reconfigureTopDown();
    virtual void reconfigureLayout();
    void setupItemLayout(QDeclarativeItem *item);

private:
    bool m_dirty;

    friend class QDeclarativeLayoutAttached;
};


class QDeclarativeLayoutAttached : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal minimumWidth READ minimumWidth WRITE setMinimumWidth)
    Q_PROPERTY(qreal minimumHeight READ minimumHeight WRITE setMinimumHeight)
    Q_PROPERTY(qreal maximumWidth READ maximumWidth WRITE setMaximumWidth)
    Q_PROPERTY(qreal maximumHeight READ maximumHeight WRITE setMaximumHeight)
    Q_PROPERTY(QDeclarativeLayout::SizePolicy verticalSizePolicy READ verticalSizePolicy WRITE setVerticalSizePolicy)
    Q_PROPERTY(QDeclarativeLayout::SizePolicy horizontalSizePolicy READ horizontalSizePolicy WRITE setHorizontalSizePolicy)

public:
    QDeclarativeLayoutAttached(QObject *object);

    qreal minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(qreal width);

    qreal minimumHeight() const { return m_minimumHeight; }
    void setMinimumHeight(qreal height);

    qreal maximumWidth() const { return m_maximumWidth; }
    void setMaximumWidth(qreal width);

    qreal maximumHeight() const { return m_maximumHeight; }
    void setMaximumHeight(qreal height);

    QDeclarativeLayout::SizePolicy verticalSizePolicy() const { return m_verticalSizePolicy; }
    void setVerticalSizePolicy(QDeclarativeLayout::SizePolicy policy);

    QDeclarativeLayout::SizePolicy horizontalSizePolicy() const { return m_horizontalSizePolicy; }
    void setHorizontalSizePolicy(QDeclarativeLayout::SizePolicy policy);

protected:
    void updateLayout();

private:
    qreal m_minimumWidth;
    qreal m_minimumHeight;
    qreal m_maximumWidth;
    qreal m_maximumHeight;
    QDeclarativeLayout::SizePolicy m_verticalSizePolicy;
    QDeclarativeLayout::SizePolicy m_horizontalSizePolicy;
    QPointer<QDeclarativeLayout> m_layout;

    friend class QDeclarativeLayout;
};

QML_DECLARE_TYPEINFO(QDeclarativeLayout, QML_HAS_ATTACHED_PROPERTIES)

#endif
