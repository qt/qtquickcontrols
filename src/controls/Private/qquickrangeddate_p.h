/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

#ifndef QQUICKRANGEDDATE_H
#define QQUICKRANGEDDATE_H

#include <QDate>

#include <QtQml/qqml.h>

QT_BEGIN_NAMESPACE

class QQuickRangedDate1 : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged RESET resetDate)
    Q_PROPERTY(QDateTime minimumDate READ minimumDate WRITE setMinimumDate NOTIFY minimumDateChanged RESET resetMinimumDate)
    Q_PROPERTY(QDateTime maximumDate READ maximumDate WRITE setMaximumDate NOTIFY maximumDateChanged RESET resetMaximumDate)
public:
    QQuickRangedDate1();
    ~QQuickRangedDate1() {}

    QDateTime date() const { return mDate; }
    void setDate(const QDateTime &date);
    void resetDate() {}

    QDateTime minimumDate() const { return QDateTime(mMinimumDate, QTime()); }
    void setMinimumDate(const QDateTime &minimumDate);
    void resetMinimumDate() {}

    QDateTime maximumDate() const { return QDateTime(mMaximumDate, QTime(23, 59, 59, 999)); }
    void setMaximumDate(const QDateTime &maximumDate);
    void resetMaximumDate() {}

Q_SIGNALS:
    void dateChanged();
    void minimumDateChanged();
    void maximumDateChanged();

private:
    QDateTime mDate;
    QDate mMinimumDate;
    QDate mMaximumDate;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickRangedDate1)

#endif // QQUICKRANGEDDATE_H
