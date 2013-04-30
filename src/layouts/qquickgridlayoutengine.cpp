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

#include "qquickitem.h"
#include "qquickgridlayoutengine_p.h"
#include "qquicklayout_p.h"

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

/*!
    \internal
    Note: Can potentially return the attached QQuickLayoutAttached object through \a attachedInfo.

    It is like this is because it enables it to be reused.
 */
void QQuickGridLayoutItem::effectiveSizeHints_helper(QQuickItem *item, QSizeF *cachedSizeHints, QQuickLayoutAttached **attachedInfo, bool useFallbackToWidthOrHeight)
{
    QQuickLayoutAttached *info = attachedLayoutObject(item, false);
    // First, retrieve the user-specified hints from the attached "Layout." properties
    if (info) {
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
  MAX  | Layout.maximumWidth            |                   | 1000000000 (-1)
  -----+--------------------------------+-------------------+--------
Fixed    | Layout.fillWidth               | Expanding if layout, Fixed if item |

*/
    //--- GATHER MINIMUM SIZE HINTS ---
    // They are always 0

    //--- GATHER PREFERRED SIZE HINTS ---
    // First, from implicitWidth/Height
    qreal &prefWidth = prefS.rwidth();
    qreal &prefHeight = prefS.rheight();
    if (prefWidth < 0 && item->implicitWidth() > 0)
        prefWidth = item->implicitWidth();
    if (prefHeight < 0 &&  item->implicitHeight() > 0)
        prefHeight =  item->implicitHeight();

    // If that fails, make an ultimate fallback to width/height

    if (!info && (prefWidth < 0 || prefHeight < 0))
        info = attachedLayoutObject(item);

    if (useFallbackToWidthOrHeight && info) {
        /* This block is a bit hacky, but if we want to support using width/height
           as preferred size hints in layouts, (which we think most people expect),
           we only want to use the initial width.
           This is because the width will change due to layout rearrangement, and the preferred
           width should return the same value, regardless of the current width.
           We therefore store the width in the Layout.preferredWidth attached property.
           Since the layout listens to changes of Layout.preferredWidth, (it will
           basically cause an invalidation of the layout, we have to disable that
           notification while we set the preferred width.

           Only use this fallback the first time the size hint is queried. Otherwise, we might
           end up picking a width that is different than what was specified in the QML.
        */
        const bool was = info->setChangesNotificationEnabled(false);
        if (prefWidth < 0) {
            prefWidth = item->width();
            info->setPreferredWidth(prefWidth);
        }
        if (prefHeight < 0) {
            prefHeight = item->height();
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
    expandSize(minS, QSizeF(0,0));
    boundSize(minS, maxS);
    expandSize(prefS, minS);
    boundSize(prefS, maxS);

    if (attachedInfo)
        *attachedInfo = info;
}

/*!
    \internal

    Assumes \a info is set (if the object has an attached property)
 */
QLayoutPolicy::Policy QQuickGridLayoutItem::effectiveSizePolicy_helper(QQuickItem *item, Qt::Orientation orientation, QQuickLayoutAttached *info)
{
    bool fillExtent = false;
    bool isSet = false;
    if (info) {
        if (orientation == Qt::Horizontal) {
            isSet = info->isFillWidthSet();
            if (isSet) fillExtent = info->fillWidth();
        } else {
            isSet = info->isFillHeightSet();
            if (isSet) fillExtent = info->fillHeight();
        }
    }
    if (!isSet && qobject_cast<QQuickLayout*>(item))
        fillExtent = true;
    return fillExtent ? QLayoutPolicy::Preferred : QLayoutPolicy::Fixed;

}
QT_END_NAMESPACE
