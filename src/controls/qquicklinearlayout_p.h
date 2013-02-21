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

#ifndef QQUICKLINEARLAYOUT_P_H
#define QQUICKLINEARLAYOUT_P_H

#include "qquicklayout_p.h"

QT_BEGIN_NAMESPACE

class QQuickComponentsLinearLayout : public QQuickComponentsLayout
{
    Q_OBJECT
    Q_PROPERTY(qreal spacing READ spacing WRITE setSpacing NOTIFY spacingChanged)

public:
    enum Orientation {
        Vertical,
        Horizontal
    };

    explicit QQuickComponentsLinearLayout(Orientation orientation,
                                          QQuickItem *parent = 0);
    ~QQuickComponentsLinearLayout() {}

    qreal spacing() const;
    void setSpacing(qreal spacing);

    Orientation orientation() const;
    void setOrientation(Orientation orientation);

    void componentComplete();

signals:
    void spacingChanged();
    void orientationChanged();

protected:
    void updateLayoutItems();
    void reconfigureLayout();
    void insertLayoutItem(QQuickItem *item);
    void removeLayoutItem(QQuickItem *item);
    void itemChange(ItemChange change, const ItemChangeData &data);
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

protected slots:
    void onItemVisibleChanged();
    void onItemDestroyed();

private:
    qreal m_spacing;
    Orientation m_orientation;
    QList<QQuickItem *> m_items;
};


class QQuickComponentsRowLayout : public QQuickComponentsLinearLayout
{
    Q_OBJECT

public:
    explicit QQuickComponentsRowLayout(QQuickItem *parent = 0)
        : QQuickComponentsLinearLayout(Horizontal, parent) {}
};


class QQuickComponentsColumnLayout : public QQuickComponentsLinearLayout
{
    Q_OBJECT

public:
    explicit QQuickComponentsColumnLayout(QQuickItem *parent = 0)
        : QQuickComponentsLinearLayout(Vertical, parent) {}
};

QT_END_NAMESPACE

#endif // QQUICKLINEARLAYOUT_P_H
