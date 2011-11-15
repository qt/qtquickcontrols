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

#include "qdeclarativelayoutengine_p.h"


/*
  This function is a modification of qGeomCalc() included in "QtCore/kernel/qlayoutengine_p.h".
  It is used as a helper function to handle linear layout recalculations for QDeclarativeItems.

  chain contains input and output parameters describing the geometry.
  count is the count of items in the chain; pos and space give the
  interval (relative to parentWidget topLeft).
*/
void qDeclarativeLayoutCalculate(QVector<QDeclarativeLayoutInfo> &chain, int start,
                                 int count, qreal pos, qreal space, qreal spacer)
{
    if (chain.count() == 0)
        return;

    bool wannaGrow = false;
    qreal totalStretch = 0;
    qreal totalSpacing = 0;
    qreal totalSizeHint = 0;
    qreal totalMinimumSize = 0;

    const int end = start + count;
    const int spacerCount = chain.count() - 1;

    for (int i = start; i < end; i++) {
        QDeclarativeLayoutInfo *data = &chain[i];

        data->done = false;

        totalStretch += data->stretch;
        totalSizeHint += data->smartSizeHint();
        totalMinimumSize += data->minimumSize;

        // don't count last spacing
        if (i < end - 1)
            totalSpacing += data->effectiveSpacer(spacer);

        wannaGrow = (wannaGrow || data->expansive || data->stretch > 0);
    }

    qreal extraSpace = 0;

    if (space < totalMinimumSize + totalSpacing) {
        // Less space than minimumSize; take from the biggest first
        qreal minSize = totalMinimumSize + totalSpacing;

        // shrink the spacers proportionally
        if (spacer >= 0) {
            spacer = minSize > 0 ? spacer * space / minSize : 0;
            totalSpacing = spacer * spacerCount;
        }

        QList<qreal> list;

        for (int i = start; i < end; i++)
            list << chain.at(i).minimumSize;

        qSort(list);

        qreal spaceLeft = space - totalSpacing;

        qreal sum = 0;
        int idx = 0;
        qreal spaceUsed = 0;
        qreal current = 0;

        while (idx < count && spaceUsed < spaceLeft) {
            current = list.at(idx);
            spaceUsed = sum + current * (count - idx);
            sum += current;
            ++idx;
        }

        --idx;

        int items = count - idx;
        qreal deficit = spaceUsed - spaceLeft;
        qreal deficitPerItem = deficit / items;
        qreal maxval = current - deficitPerItem;

        for (int i = start; i < end; i++) {
            QDeclarativeLayoutInfo *data = &chain[i];
            data->done = true;

            if (data->minimumSize > 0)
                data->size = data->minimumSize;
            else
                data->size = qMin<qreal>(data->minimumSize, maxval);
        }
    } else if (space < totalSizeHint + totalSpacing) {
        /*
          Less space than smartSizeHint(), but more than minimumSize.
          Currently take space equally from each, as in Qt 2.x.
          Commented-out lines will give more space to stretchier
          items.
        */
        int n = count;
        qreal spaceLeft = space - totalSpacing;
        qreal overdraft = totalSizeHint - spaceLeft;

        // first give to the fixed ones
        for (int i = start; i < end; i++) {
            QDeclarativeLayoutInfo *data = &chain[i];

            if (!data->done && data->minimumSize >= data->smartSizeHint()) {
                data->done = true;
                data->size = data->smartSizeHint();
                spaceLeft -= data->smartSizeHint();
                n--;
            }
        }

        bool finished = (n == 0);

        while (!finished) {
            finished = true;

            for (int i = start; i < end; i++) {
                QDeclarativeLayoutInfo *data = &chain[i];

                if (data->done)
                    continue;

                qreal w = overdraft / n;
                data->size = data->smartSizeHint() - w;

                if (data->size < data->minimumSize) {
                    data->done = true;
                    data->size = data->minimumSize;
                    finished = false;
                    overdraft -= data->smartSizeHint() - data->minimumSize;
                    n--;
                    break;
                }
            }
        }
    } else { // extra space
        int n = count;
        qreal spaceLeft = space - totalSpacing;

        // first give to the fixed ones, and handle non-expansiveness
        for (int i = start; i < end; i++) {
            QDeclarativeLayoutInfo *data = &chain[i];

            if (data->done)
                continue;

            if (data->maximumSize <= data->smartSizeHint()
                || (wannaGrow && !data->expansive && data->stretch == 0)
                || (!data->expansive && data->stretch == 0)) {
                data->done = true;
                data->size = data->smartSizeHint();
                spaceLeft -= data->size;
                totalStretch -= data->stretch;
                n--;
            }
        }

        extraSpace = spaceLeft;

        /*
          Do a trial distribution and calculate how much it is off.
          If there are more deficit pixels than surplus pixels, give
          the minimum size items what they need, and repeat.
          Otherwise give to the maximum size items, and repeat.

          Paul Olav Tvete has a wonderful mathematical proof of the
          correctness of this principle, but unfortunately this
          comment is too small to contain it.
        */
        qreal surplus, deficit;

        do {
            surplus = deficit = 0;

            for (int i = start; i < end; i++) {
                QDeclarativeLayoutInfo *data = &chain[i];

                if (data->done)
                    continue;

                extraSpace = 0;

                qreal w;

                if (totalStretch <= 0)
                    w = (spaceLeft / n);
                else
                    w = (spaceLeft * data->stretch) / totalStretch;

                data->size = w;

                if (w < data->smartSizeHint())
                    deficit +=  data->smartSizeHint() - w;
                else if (w > data->maximumSize)
                    surplus += w - data->maximumSize;
            }

            if (deficit > 0 && surplus <= deficit) {
                // give to the ones that have too little
                for (int i = start; i < end; i++) {
                    QDeclarativeLayoutInfo *data = &chain[i];

                    if (!data->done && data->size < data->smartSizeHint()) {
                        data->done = true;
                        data->size = data->smartSizeHint();
                        spaceLeft -= data->smartSizeHint();
                        totalStretch -= data->stretch;
                        n--;
                    }
                }
            }

            if (surplus > 0 && surplus >= deficit) {
                // take from the ones that have too much
                for (int i = start; i < end; i++) {
                    QDeclarativeLayoutInfo *data = &chain[i];

                    if (!data->done && data->size > data->maximumSize) {
                        data->done = true;
                        data->size = data->maximumSize;
                        spaceLeft -= data->maximumSize;
                        totalStretch -= data->stretch;
                        n--;
                    }
                }
            }
        } while (n > 0 && surplus != deficit);

        if (n == 0)
            extraSpace = spaceLeft;
    }

    /*
      As a last resort, we distribute the unwanted space equally
      among the spacers (counting the start and end of the chain). We
      could, but don't, attempt a sub-pixel allocation of the extra
      space.
    */
    qreal extra = extraSpace / (spacerCount + 2);
    qreal p = pos + extra;

    for (int i = start; i < end; i++) {
        QDeclarativeLayoutInfo *data = &chain[i];
        data->pos = p;
        p += data->size;
        p += data->effectiveSpacer(spacer) + extra;
    }
}
