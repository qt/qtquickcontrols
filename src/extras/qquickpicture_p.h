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

#ifndef QQUICKPICTURE_H
#define QQUICKPICTURE_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QPicture>

#if QT_CONFIG(picture)

class QQuickPicture : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged RESET resetColor)
public:
    explicit QQuickPicture(QQuickItem *parent = 0);
    ~QQuickPicture();

    void paint(QPainter *painter) override;

    QUrl source() const;
    void setSource(const QUrl &source);

    QColor color() const;
    void setColor(const QColor &color);
    void resetColor();

Q_SIGNALS:
    void sourceChanged();
    void colorChanged();

private:
    QUrl mSource;
    QColor mColor;
    QPicture mPicture;
};

#endif // QT_CONFIG(picture)

#endif // QQUICKPICTURE_H
