/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qquicklayoutengine_p.h"


/*
  This function is a modification of qGeomCalc() included in "QtCore/kernel/qlayoutengine_p.h".
  It is used as a helper function to handle linear layout recalculations for QQuickItems.

  chain contains input and output parameters describing the geometry.
  count is the count of items in the chain; pos and space give the
  interval (relative to parentWidget topLeft).
*/
void qDeclarativeLayoutCalculate(QVector<QQuickComponentsLayoutInfo> &chain, int start,
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
        QQuickComponentsLayoutInfo *data = &chain[i];

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
            QQuickComponentsLayoutInfo *data = &chain[i];
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
            QQuickComponentsLayoutInfo *data = &chain[i];

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
                QQuickComponentsLayoutInfo *data = &chain[i];

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
            QQuickComponentsLayoutInfo *data = &chain[i];

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
                QQuickComponentsLayoutInfo *data = &chain[i];

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
                    QQuickComponentsLayoutInfo *data = &chain[i];

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
                    QQuickComponentsLayoutInfo *data = &chain[i];

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
        QQuickComponentsLayoutInfo *data = &chain[i];
        data->pos = p;
        p += data->size;
        p += data->effectiveSpacer(spacer) + extra;
    }
}
