/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QQUICKLAYOUT_P_H
#define QQUICKLAYOUT_P_H

#include <QPointer>
#include <QQuickItem>

QT_BEGIN_NAMESPACE

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
    Q_PROPERTY(qreal minimumWidth READ minimumWidth WRITE setMinimumWidth NOTIFY minimumWidthChanged)
    Q_PROPERTY(qreal minimumHeight READ minimumHeight WRITE setMinimumHeight NOTIFY minimumHeightChanged)
    Q_PROPERTY(qreal maximumWidth READ maximumWidth WRITE setMaximumWidth NOTIFY maximumWidthChanged)
    Q_PROPERTY(qreal maximumHeight READ maximumHeight WRITE setMaximumHeight NOTIFY maximumHeightChanged)
    Q_PROPERTY(QQuickComponentsLayout::SizePolicy verticalSizePolicy READ verticalSizePolicy WRITE setVerticalSizePolicy NOTIFY verticalSizePolicyChanged)
    Q_PROPERTY(QQuickComponentsLayout::SizePolicy horizontalSizePolicy READ horizontalSizePolicy WRITE setHorizontalSizePolicy NOTIFY horizontalSizePolicyChanged)

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

signals:
    void minimumWidthChanged();
    void minimumHeightChanged();
    void maximumWidthChanged();
    void maximumHeightChanged();
    void verticalSizePolicyChanged();
    void horizontalSizePolicyChanged();

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

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickComponentsLayout)
QML_DECLARE_TYPEINFO(QQuickComponentsLayout, QML_HAS_ATTACHED_PROPERTIES)

#endif // QQUICKLAYOUT_P_H
