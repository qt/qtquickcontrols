/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QQUICKRANGEMODEL_P_P_H
#define QQUICKRANGEMODEL_P_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt Components API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#include "qquickrangemodel_p.h"

QT_BEGIN_NAMESPACE

class QQuickRangeModelPrivate
{
    Q_DECLARE_PUBLIC(QQuickRangeModel)
public:
    QQuickRangeModelPrivate(QQuickRangeModel *qq);
    virtual ~QQuickRangeModelPrivate();

    void init();

    qreal posatmin, posatmax;
    qreal minimum, maximum, stepSize, pos, value;

    uint inverted : 1;

    QQuickRangeModel *q_ptr;

    inline qreal effectivePosAtMin() const {
        return inverted ? posatmax : posatmin;
    }

    inline qreal effectivePosAtMax() const {
        return inverted ? posatmin : posatmax;
    }

    inline qreal equivalentPosition(qreal value) const {
        // Return absolute position from absolute value
        const qreal valueRange = maximum - minimum;
        if (valueRange == 0)
            return effectivePosAtMin();

        const qreal scale = (effectivePosAtMax() - effectivePosAtMin()) / valueRange;
        return (value - minimum) * scale + effectivePosAtMin();
    }

    inline qreal equivalentValue(qreal pos) const {
        // Return absolute value from absolute position
        const qreal posRange = effectivePosAtMax() - effectivePosAtMin();
        if (posRange == 0)
            return minimum;

        const qreal scale = (maximum - minimum) / posRange;
        // Avoid perverse rounding glitches when at an end:
        const qreal mid = (effectivePosAtMax() + effectivePosAtMin()) * 0.5;
        if (pos < mid)
            return (pos - effectivePosAtMin()) * scale + minimum;
        return maximum - scale * (effectivePosAtMax() - pos);
    }

    qreal publicPosition(qreal position) const;
    qreal publicValue(qreal value) const;
    void emitValueAndPositionIfChanged(const qreal oldValue, const qreal oldPosition);
};

QT_END_NAMESPACE

#endif // QQUICKRANGEMODEL_P_P_H
