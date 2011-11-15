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
    virtual void invalidate() = 0;
    void setupItemLayout(QDeclarativeItem *item);

private:
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
