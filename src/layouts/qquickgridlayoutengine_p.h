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

#ifndef QQUICKGRIDLAYOUTENGINE_P_H
#define QQUICKGRIDLAYOUTENGINE_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists for the convenience
// of the graphics view layout classes.  This header
// file may change from version to version without notice, or even be removed.
//
// We mean it.
//

#include "qgridlayoutengine_p.h"
#include "qquickitem.h"
#include "qquicklayout_p.h"
#include "qdebug.h"
QT_BEGIN_NAMESPACE


/*
  The layout engine assumes:
    1. minimum <= preferred <= maximum
    2. descent is within minimum and maximum bounds     (### verify)

    This function helps to ensure that by the following rules (in the following order):
    1. If minimum > maximum, set minimum = maximum
    2. Make sure preferred is not outside the [minimum,maximum] range.
    3. If descent > minimum, set descent = minimum      (### verify if this is correct, it might
                                                        need some refinements to multiline texts)

    If any values are "not set" (i.e. negative), they will be left untouched, so that we
    know which values needs to be fetched from the implicit hints (not user hints).
  */
static void normalizeHints(qreal &minimum, qreal &preferred, qreal &maximum, qreal &descent)
{
    if (minimum >= 0 && maximum >= 0 && minimum > maximum)
        minimum = maximum;

    if (preferred >= 0) {
        if (minimum >= 0 && preferred < minimum) {
            preferred = minimum;
        } else if (maximum >= 0 && preferred > maximum) {
            preferred = maximum;
        }
    }

    if (minimum >= 0 && descent > minimum)
        descent = minimum;
}

static void boundSize(QSizeF &result, const QSizeF &size)
{
    if (size.width() >= 0 && size.width() < result.width())
        result.setWidth(size.width());
    if (size.height() >= 0 && size.height() < result.height())
        result.setHeight(size.height());
}

static void expandSize(QSizeF &result, const QSizeF &size)
{
    if (size.width() >= 0 && size.width() > result.width())
        result.setWidth(size.width());
    if (size.height() >= 0 && size.height() > result.height())
        result.setHeight(size.height());
}

static inline void combineHints(qreal &current, qreal fallbackHint)
{
    if (current < 0)
        current = fallbackHint;
}

class QQuickGridLayoutItem : public QGridLayoutItem {
public:
    QQuickGridLayoutItem(QQuickItem *item, int row, int column,
                         int rowSpan = 1, int columnSpan = 1, Qt::Alignment alignment = 0)
        : QGridLayoutItem(row, column, rowSpan, columnSpan, alignment), m_item(item), sizeHintCacheDirty(true), useFallbackToWidthOrHeight(true) {}


    typedef qreal (QQuickLayoutAttached::*SizeGetter)() const;

    QSizeF sizeHint(Qt::SizeHint which, const QSizeF &constraint) const
    {
        Q_UNUSED(constraint);   // Quick Layouts does not support constraint atm
        return effectiveSizeHints()[which];
    }

    static void effectiveSizeHint_helper(QQuickItem *item, QSizeF *cachedSizeHints, bool useFallbackToWidthOrHeight);

    QSizeF *effectiveSizeHints() const
    {
        if (!sizeHintCacheDirty)
            return cachedSizeHints;

        effectiveSizeHint_helper(m_item, cachedSizeHints, useFallbackToWidthOrHeight);
        useFallbackToWidthOrHeight = false;

        sizeHintCacheDirty = false;
        return cachedSizeHints;
    }

    void invalidate()
    {
        quickLayoutDebug() << "engine::invalidate()";
        sizeHintCacheDirty = true;
    }

    QLayoutPolicy::Policy sizePolicy(Qt::Orientation orientation) const
    {
        bool fillExtent = false;
        bool isSet = false;
        if (QQuickLayoutAttached *info = attachedLayoutObject(m_item, false)) {
            if (orientation == Qt::Horizontal) {
                isSet = info->isFillWidthSet();
                if (isSet) fillExtent = info->fillWidth();
            } else {
                isSet = info->isFillHeightSet();
                if (isSet) fillExtent = info->fillHeight();
            }
        }
        if (!isSet && qobject_cast<QQuickLayout*>(m_item))
            fillExtent = true;
        return fillExtent ? QLayoutPolicy::Preferred : QLayoutPolicy::Fixed;
    }

    void setGeometry(const QRectF &rect)
    {
        m_item->setPosition(rect.topLeft());
        m_item->setSize(rect.size());
    }

    QQuickItem *layoutItem() const { return m_item; }

    QQuickItem *m_item;
private:
    mutable QSizeF cachedSizeHints[Qt::NSizeHints];
    mutable unsigned sizeHintCacheDirty : 1;
    mutable unsigned useFallbackToWidthOrHeight : 1;
};

class QQuickGridLayoutEngine : public QGridLayoutEngine {
public:
    QQuickGridLayoutEngine() : QGridLayoutEngine() {} //### not needed

    int indexOf(QQuickItem *item) const {
        for (int i = 0; i < q_items.size(); ++i) {
            if (item == static_cast<QQuickGridLayoutItem*>(q_items.at(i))->layoutItem())
                return i;
        }
        return -1;
    }

    QQuickGridLayoutItem *findLayoutItem(QQuickItem *layoutItem) const
    {
        for (int i = q_items.count() - 1; i >= 0; --i) {
            QQuickGridLayoutItem *item = static_cast<QQuickGridLayoutItem*>(q_items.at(i));
            if (item->layoutItem() == layoutItem)
                return item;
        }
        return 0;
    }
};



QT_END_NAMESPACE

#endif // QQUICKGRIDLAYOUTENGINE_P_H
