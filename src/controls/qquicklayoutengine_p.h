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

#ifndef QQUICKLAYOUTENGINE_P_H
#define QQUICKLAYOUTENGINE_P_H

#include <QVector>

QT_BEGIN_NAMESPACE

struct QQuickComponentsLayoutInfo
{
    QQuickComponentsLayoutInfo()
        : stretch(1),
          sizeHint(0),
          spacing(0),
          minimumSize(0),
          maximumSize(0),
          expansive(true),
          done(false),
          pos(0),
          size(0)
    { }

    inline qreal smartSizeHint() {
        return (stretch > 0) ? minimumSize : sizeHint;
    }

    inline qreal effectiveSpacer(qreal value) const {
        return value + spacing;
    }

    qreal stretch;
    qreal sizeHint;
    qreal spacing;
    qreal minimumSize;
    qreal maximumSize;
    bool expansive;

    // result
    bool done;
    qreal pos;
    qreal size;
};

void qDeclarativeLayoutCalculate(QVector<QQuickComponentsLayoutInfo> &chain, int start,
                                 int count, qreal pos, qreal space, qreal spacer);

QT_END_NAMESPACE

#endif // QQUICKLAYOUTENGINE_P_H
