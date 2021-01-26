/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Extras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

#ifndef CIRCULARPROGRESSBAR_P_H
#define CIRCULARPROGRESSBAR_P_H

#include <QtGui/QColor>
#include <QtGui/QGradientStops>
#include <QtQuick/QQuickPaintedItem>

class QQuickCircularProgressBar : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(qreal progress READ progress WRITE setProgress NOTIFY progressChanged)
    Q_PROPERTY(qreal barWidth READ barWidth WRITE setBarWidth NOTIFY barWidthChanged)
    Q_PROPERTY(qreal inset READ inset WRITE setInset NOTIFY insetChanged)
    Q_PROPERTY(qreal minimumValueAngle READ minimumValueAngle WRITE setMinimumValueAngle NOTIFY minimumValueAngleChanged)
    Q_PROPERTY(qreal maximumValueAngle READ maximumValueAngle WRITE setMaximumValueAngle NOTIFY maximumValueAngleChanged)
    // For Flat DialStyle, so that we don't need to create two progress bars
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)

public:
    QQuickCircularProgressBar(QQuickItem *parent = 0);
    ~QQuickCircularProgressBar();

    void paint(QPainter *painter) override;

    qreal progress() const;
    void setProgress(qreal progress);

    qreal barWidth() const;
    void setBarWidth(qreal barWidth);

    qreal inset() const;
    void setInset(qreal inset);

    qreal minimumValueAngle() const;
    void setMinimumValueAngle(qreal minimumValueAngle);

    qreal maximumValueAngle() const;
    void setMaximumValueAngle(qreal maximumValueAngle);

    Q_INVOKABLE void clearStops();
    Q_INVOKABLE void addStop(qreal position, const QColor &color);
    Q_INVOKABLE void redraw();

    QColor backgroundColor() const;
    void setBackgroundColor(const QColor &backgroundColor);
signals:
    void progressChanged(qreal progress);
    void barWidthChanged(qreal barWidth);
    void insetChanged(qreal inset);
    void minimumValueAngleChanged(qreal minimumValueAngle);
    void maximumValueAngleChanged(qreal maximumValueAngle);
    void backgroundColorChanged(const QColor &backgroundColor);
private:
    qreal mProgress;
    qreal mBarWidth;
    qreal mInset;
    QGradientStops mGradientStops;
    QColor mBackgroundColor;
    qreal mMinimumValueAngle;
    qreal mMaximumValueAngle;
};

#endif // CIRCULARPROGRESSBAR_P_H
