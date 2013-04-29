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

void QQuickGridLayoutItem::effectiveSizeHint_helper(QQuickItem *item, QSizeF *cachedSizeHints, bool useFallbackToWidthOrHeight)
{
    QQuickLayoutAttached *info = 0;
    // First, retrieve the user-specified hints from the attached "Layout." properties
    if (QObject *attached = qmlAttachedPropertiesObject<QQuickLayout>(item, false)) {
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
        info = static_cast<QQuickLayoutAttached *>(qmlAttachedPropertiesObject<QQuickLayout>(item));

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
}

