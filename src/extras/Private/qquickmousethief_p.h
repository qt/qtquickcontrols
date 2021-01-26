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

#ifndef MOUSETHIEF_H
#define MOUSETHIEF_H

#include <QObject>
#include <QPointer>
#include <QtQuick/QQuickItem>

class QQuickMouseThief : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool receivedPressEvent READ receivedPressEvent
        WRITE setReceivedPressEvent NOTIFY receivedPressEventChanged)
public:
    explicit QQuickMouseThief(QObject *parent = 0);

    bool receivedPressEvent() const;
    void setReceivedPressEvent(bool receivedPressEvent);

    Q_INVOKABLE void grabMouse(QQuickItem *item);
    Q_INVOKABLE void ungrabMouse();
    Q_INVOKABLE void acceptCurrentEvent();
signals:
    /*!
        Coordinates are relative to the window of mItem.
    */
    void pressed(int mouseX, int mouseY);

    void released(int mouseX, int mouseY);

    void clicked(int mouseX, int mouseY);

    void touchUpdate(int mouseX, int mouseY);

    void receivedPressEventChanged();

    void handledEventChanged();
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
private slots:
    void itemWindowChanged(QQuickWindow *window);
private:
    void emitPressed(const QPointF &pos);
    void emitReleased(const QPointF &pos);
    void emitClicked(const QPointF &pos);

    QPointer<QQuickItem> mItem;
    bool mReceivedPressEvent;
    bool mAcceptCurrentEvent;
};

#endif // MOUSETHIEF_H
