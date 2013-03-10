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
#include <QtWidgets/qsizepolicy.h>
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

    If any values are "not set" (i.e. 0 or less), they will be left untouched, so that we
    know which values needs to be fetched from the implicit hints (not user hints).
  */
static void normalizeHints(qreal &minimum, qreal &preferred, qreal &maximum, qreal &descent)
{
    if (minimum > 0 && maximum > 0 && minimum > maximum)
        minimum = maximum;

    if (preferred > 0) {
        if (minimum > 0 && preferred < minimum) {
            preferred = minimum;
        } else if (maximum > 0 && preferred > maximum) {
            preferred = maximum;
        }
    }

    if (minimum > 0 && descent > minimum)
        descent = minimum;
}

static void boundSize(QSizeF &result, const QSizeF &size)
{
    if (size.width() > 0 && size.width() < result.width())
        result.setWidth(size.width());
    if (size.height() > 0 && size.height() < result.height())
        result.setHeight(size.height());
}

static void expandSize(QSizeF &result, const QSizeF &size)
{
    if (size.width() > 0 && size.width() > result.width())
        result.setWidth(size.width());
    if (size.height() > 0 && size.height() > result.height())
        result.setHeight(size.height());
}

static inline void combineHints(qreal &current, qreal fallbackHint)
{
    if (current <= 0)
        current = fallbackHint;
}

class QQuickGridLayoutItem : public QGridLayoutItem {
public:
    QQuickGridLayoutItem(QQuickItem *item, int row, int column,
                         int rowSpan = 1, int columnSpan = 1, Qt::Alignment alignment = 0)
        : QGridLayoutItem(row, column, rowSpan, columnSpan, alignment), m_item(item), sizeHintCacheDirty(true) {}


    typedef qreal (QQuickLayoutAttached::*SizeGetter)() const;

    QSizeF sizeHint(Qt::SizeHint which, const QSizeF &constraint) const
    {
        Q_UNUSED(constraint);   // Quick Layouts does not support constraint atm
        return effectiveSizeHints()[which];
    }

    QSizeF *effectiveSizeHints() const
    {
        if (!sizeHintCacheDirty)
            return cachedSizeHints;

        QQuickLayoutAttached *info = 0;
        // First, retrieve the user-specified hints from the attached "Layout." properties
        if (QObject *attached = qmlAttachedPropertiesObject<QQuickLayout>(m_item, false)) {
            info = static_cast<QQuickLayoutAttached *>(attached);

            struct Getters {
                SizeGetter call[NSizes];
            };

            static Getters horGetters = {
                {&QQuickLayoutAttached::minimumWidth, &QQuickLayoutAttached::preferredWidth, &QQuickLayoutAttached::maximumWidth},
            };

            static Getters verGetters = {
                {&QQuickLayoutAttached::minimumHeight, &QQuickLayoutAttached::preferredHeight, &QQuickLayoutAttached::maximumHeight}
            };
            for (int i = 0; i < NSizes; ++i) {
                SizeGetter getter = horGetters.call[i];
                Q_ASSERT(getter);
                cachedSizeHints[i].setWidth((info->*getter)());
                getter = verGetters.call[i];
                Q_ASSERT(getter);
                cachedSizeHints[i].setHeight((info->*getter)());
            }
        } else {
            for (int i = 0; i < NSizes; ++i)
                cachedSizeHints[i] = QSize();
        }
        cachedSizeHints[Qt::MinimumDescent] = QSize();  //### FIXME when baseline support is added

        QSizeF &minS = cachedSizeHints[Qt::MinimumSize];
        QSizeF &prefS = cachedSizeHints[Qt::PreferredSize];
        QSizeF &maxS = cachedSizeHints[Qt::MaximumSize];
        QSizeF &descentS = cachedSizeHints[Qt::MinimumDescent];

        // For instance, will normalize the following user-set hints
        // from: [10, 5, 60]
        // to:   [10, 10, 60]
        normalizeHints(minS.rwidth(), prefS.rwidth(), maxS.rwidth(), descentS.rwidth());
        normalizeHints(minS.rheight(), prefS.rheight(), maxS.rheight(), descentS.rheight());
/*
      The following table illustrates the preference of the properties used for measuring layout
      items. If present, the USER properties will be preferred. If USER properties are not present,
      the HINT 1 properties will be preferred. Finally, the HINT 2 properties will be used as an
      ultimate fallback.

           | USER                           | HINT 1            | HINT 2
      -----+--------------------------------+-------------------+-------
      MIN  | Layout.minimumWidth            |                   | 0
      PREF | Layout.preferredWidth          | implicitWidth     | width
      MAX  | Layout.maximumWidth            |                   | 100000
      -----+--------------------------------+-------------------+--------
SizePolicy | Layout.horizontalSizePolicy    | Expanding if layout, Fixed if item |

*/
        //--- GATHER MINIMUM SIZE HINTS ---
        // They are always 0

        //--- GATHER PREFERRED SIZE HINTS ---
        // First, from implicitWidth/Height
        qreal &prefWidth = prefS.rwidth();
        qreal &prefHeight = prefS.rheight();
        combineHints(prefWidth, m_item->implicitWidth());
        combineHints(prefHeight, m_item->implicitHeight());

        // If that fails, make an ultimate fallback to width/height

        if (!info && (prefWidth <= 0 || prefHeight <= 0))
            info = static_cast<QQuickLayoutAttached *>(qmlAttachedPropertiesObject<QQuickLayout>(m_item));

        if (info) {
            /* This block is a bit hacky, but if we want to support using width/height
               as preferred size hints in layouts, (which we think most people expect),
               we only want to use the initial width.
               This is because the width will change due to layout rearrangement, and the preferred
               width should return the same value, regardless of the current width.
               We therefore store the width in the Layout.preferredWidth attached property.
               Since the layout listens to changes of Layout.preferredWidth, (it will
               basically cause an invalidation of the layout, we have to disable that
               notification while we set the preferred width.
            */
            //### Breaks with items that has Layout.preferredWidth: 0
            const bool was = info->setChangesNotificationEnabled(false);
            if (prefWidth <= 0) {
                prefWidth = m_item->width();
                info->setPreferredWidth(prefWidth);
            }
            if (prefHeight <= 0) {
                prefHeight = m_item->height();
                info->setPreferredHeight(prefHeight);
            }
            info->setChangesNotificationEnabled(was);
        }
        //--- GATHER MAXIMUM SIZE HINTS ---
        // They are always q_declarativeLayoutMaxSize
        combineHints(cachedSizeHints[Qt::MaximumSize].rwidth(), q_declarativeLayoutMaxSize);
        combineHints(cachedSizeHints[Qt::MaximumSize].rheight(), q_declarativeLayoutMaxSize);

        //--- GATHER DESCENT
        // ### Not implemented


        // Normalize again after the implicit hints have been gathered
        // (using different rules than normalizeHints actually??))
        // This is consistent with QGraphicsLayoutItemPrivate::effectiveSizeHints()
/*
The following shows how the different [min,pref,max] combinations are normalized after performing
each normalization stage (maxS, minS and prefS):

input   [1, 2, 3]   [1, 3, 2] [2, 1, 3] [2, 3, 1] [3, 2, 1] [3, 1, 2]
------------------------------------------------------------------
maxS    [1, 2, 3]   [1, 3, 3] [2, 1, 3] [2, 3, 3] [3, 2, 3] [3, 1, 3]
minS    [1, 2, 3]   [1, 3, 3] [1, 1, 3] [2, 3, 3] [2, 2, 3] [1, 1, 3]
prefS   [1, 2, 3]   [1, 3, 3] [1, 1, 3] [2, 3, 3] [2, 2, 3] [1, 1, 3] ###No change here.
*/
        expandSize(minS, QSizeF(0,0));
        boundSize(minS, maxS);
        expandSize(prefS, minS);
        boundSize(prefS, maxS);
        //expandSize(maxS, prefS);    // [3,2,1] > [3,2,2]
        //expandSize(maxS, minS);
        //boundSize(maxS, QSizeF(q_declarativeLayoutMaxSize, q_declarativeLayoutMaxSize));


        //boundSize(minS, prefS);     // [3,2,1] > [2,2,1]
        //boundSize(minS, maxS);

        // Both of these are invariants and inconsistent with the above combinations of the
        // "symmetric" combination (i.e. boundSize(minS, prefS) and expandSize(maxS, prefS)
        //expandSize(prefS, minS);    //[3,2,1] > [3,3,1]
        //boundSize(prefS, maxS);     //[3,2,1] > [3,1,1]

        sizeHintCacheDirty = false;
        return cachedSizeHints;
    }

    void invalidate()
    {
        quickLayoutDebug() << "engine::invalidate()";
        sizeHintCacheDirty = true;
    }


    static QLayoutPolicy::Policy fromSizePolicy(QQuickLayout::SizePolicy policy) {
        return (policy == QQuickLayout::Fixed ? QLayoutPolicy::Fixed : QLayoutPolicy::Preferred);
    }

    QLayoutPolicy::Policy sizePolicy(Qt::Orientation orientation) const
    {
        if (QQuickLayoutAttached *info = attachedLayoutObject(m_item, false)) {
            QQuickLayout::SizePolicy sp = (orientation == Qt::Horizontal
                                        ? info->horizontalSizePolicy()
                                        : info->verticalSizePolicy());
            if (sp != QQuickLayout::Unspecified)
                return fromSizePolicy(sp);
        }
        // ### Correct way is to, go through all child items and combine the policies.
        return qobject_cast<QQuickLayout*>(m_item) ? QLayoutPolicy::Preferred : QLayoutPolicy::Fixed;
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
    mutable bool sizeHintCacheDirty;
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
