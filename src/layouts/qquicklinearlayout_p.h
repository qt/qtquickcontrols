/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Layouts module of the Qt Toolkit.
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
#include "qquickgridlayoutengine_p.h"

QT_BEGIN_NAMESPACE

/**********************************
 **
 ** QQuickGridLayoutBase
 **
 **/
class QQuickGridLayoutBasePrivate;

class QQuickGridLayoutBase : public QQuickLayout
{
    Q_OBJECT
public:
    explicit QQuickGridLayoutBase(QQuickGridLayoutBasePrivate &dd,
                                  Qt::Orientation orientation,
                                  QQuickItem *parent = 0);
    ~QQuickGridLayoutBase() {}

    void componentComplete();
    void invalidate(QQuickItem *childItem = 0);
    Qt::Orientation orientation() const;
    void setOrientation(Qt::Orientation orientation);

protected:
    void updateLayoutItems();
    void rearrange(const QSizeF &size);
    virtual void insertLayoutItem(QQuickItem *item);
    void removeLayoutItem(QQuickItem *item);
    void itemChange(ItemChange change, const ItemChangeData &data);
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

protected slots:
    void onItemVisibleChanged();
    void onItemDestroyed();
    void onItemImplicitSizeChanged();

private:
    void removeGridItem(QGridLayoutItem *gridItem);
    void propagateLayoutSizeHints();
    Q_DECLARE_PRIVATE(QQuickGridLayoutBase)
};


class QQuickGridLayoutBasePrivate : public QQuickLayoutPrivate
{
    Q_DECLARE_PUBLIC(QQuickGridLayoutBase)

public:
    QQuickGridLayoutBasePrivate() : m_disableRearrange(true) { }
    QQuickGridLayoutEngine engine;
    Qt::Orientation orientation;
    bool m_disableRearrange;

};

/**********************************
 **
 ** QQuickGridLayout
 **
 **/
class QQuickGridLayoutPrivate;
class QQuickGridLayout : public QQuickGridLayoutBase
{
    Q_OBJECT
    Q_PROPERTY(qreal columnSpacing READ columnSpacing WRITE setColumnSpacing NOTIFY columnSpacingChanged)
    Q_PROPERTY(qreal rowSpacing READ rowSpacing WRITE setRowSpacing NOTIFY rowSpacingChanged)
public:
    explicit QQuickGridLayout(QQuickItem *parent = 0);
    qreal columnSpacing() const;
    void setColumnSpacing(qreal spacing);
    qreal rowSpacing() const;
    void setRowSpacing(qreal spacing);
signals:
    void columnSpacingChanged();
    void rowSpacingChanged();

private:
    Q_DECLARE_PRIVATE(QQuickGridLayout)
};

class QQuickGridLayoutPrivate : public QQuickGridLayoutBasePrivate
{
    Q_DECLARE_PUBLIC(QQuickGridLayout)
public:
    QQuickGridLayoutPrivate() {}
    qreal columnSpacing;
    qreal rowSpacing;
};


/**********************************
 **
 ** QQuickLinearLayout
 **
 **/
class QQuickLinearLayoutPrivate;
class QQuickLinearLayout : public QQuickGridLayoutBase
{
    Q_OBJECT
    Q_PROPERTY(qreal spacing READ spacing WRITE setSpacing NOTIFY spacingChanged)
public:
    explicit QQuickLinearLayout(Qt::Orientation orientation,
                                QQuickItem *parent = 0);
    void insertLayoutItem(QQuickItem *item);
    qreal spacing() const;
    void setSpacing(qreal spacing);

signals:
    void spacingChanged();
private:
    Q_DECLARE_PRIVATE(QQuickLinearLayout)
};

class QQuickLinearLayoutPrivate : public QQuickGridLayoutBasePrivate
{
    Q_DECLARE_PUBLIC(QQuickLinearLayout)
public:
    QQuickLinearLayoutPrivate() {}
    qreal spacing;
};


/**********************************
 **
 ** QQuickRowLayout
 **
 **/
class QQuickRowLayout : public QQuickLinearLayout
{
    Q_OBJECT

public:
    explicit QQuickRowLayout(QQuickItem *parent = 0)
        : QQuickLinearLayout(Qt::Horizontal, parent) {}
};


/**********************************
 **
 ** QQuickColumnLayout
 **
 **/
class QQuickColumnLayout : public QQuickLinearLayout
{
    Q_OBJECT

public:
    explicit QQuickColumnLayout(QQuickItem *parent = 0)
        : QQuickLinearLayout(Qt::Vertical, parent) {}
};

QT_END_NAMESPACE

#endif // QQUICKLINEARLAYOUT_P_H
