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

#ifndef QQUICKMENUPOPUPWINDOW_H
#define QQUICKMENUPOPUPWINDOW_H

#include "qquickpopupwindow_p.h"

QT_BEGIN_NAMESPACE

class QQuickMenu1;
class QQuickMenuBar1;

class QQuickMenuPopupWindow1 : public QQuickPopupWindow1
{
    Q_OBJECT
public:
    QQuickMenuPopupWindow1(QQuickMenu1 *menu);

    void setItemAt(QQuickItem *menuItem);
    void setParentWindow(QWindow *effectiveParentWindow, QQuickWindow *parentWindow);
    void setGeometry(int posx, int posy, int w, int h);

    void setParentItem(QQuickItem *) override;

    QQuickMenu1 *menu() const;
public Q_SLOTS:
    void setToBeDeletedLater();

protected Q_SLOTS:
    void updateSize();
    void updatePosition();

Q_SIGNALS:
    void willBeDeletedLater();

protected:
    void focusInEvent(QFocusEvent *) override;
    void exposeEvent(QExposeEvent *) override;
    bool shouldForwardEventAfterDismiss(QMouseEvent *) const override;

private:
    QQuickItem *m_itemAt;
    QPointF m_oldItemPos;
    QPointF m_initialPos;
    QPointer<QQuickWindow> m_logicalParentWindow;
    QQuickMenu1 *m_menu;
};

QT_END_NAMESPACE

#endif // QQUICKMENUPOPUPWINDOW_H
