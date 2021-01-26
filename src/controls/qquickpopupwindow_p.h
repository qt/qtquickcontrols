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

#ifndef QQUICKPOPUPWINDOW_H
#define QQUICKPOPUPWINDOW_H

#include <QtCore/QPointer>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickwindow.h>

QT_BEGIN_NAMESPACE

class QQuickPopupWindow1 : public QQuickWindow
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem *popupContentItem READ popupContentItem WRITE setPopupContentItem)
    Q_CLASSINFO("DefaultProperty", "popupContentItem")
    Q_PROPERTY(QQuickItem *parentItem READ parentItem WRITE setParentItem)

public:
    QQuickPopupWindow1();

    QQuickItem *popupContentItem() const { return m_contentItem; }
    void setPopupContentItem(QQuickItem *popupContentItem);

    QQuickItem *parentItem() const { return m_parentItem; }
    virtual void setParentItem(QQuickItem *);

public Q_SLOTS:
    virtual void show();
    void dismissPopup();

Q_SIGNALS:
    void popupDismissed();
    void geometryChanged();

protected:
    void mousePressEvent(QMouseEvent *) override;
    void mouseReleaseEvent(QMouseEvent *) override;
    void mouseMoveEvent(QMouseEvent *) override;
    void exposeEvent(QExposeEvent *) override;
    void hideEvent(QHideEvent *) override;
    bool event(QEvent *) override;
    virtual bool shouldForwardEventAfterDismiss(QMouseEvent *) const;

protected Q_SLOTS:
    void updateSize();
    void applicationStateChanged(Qt::ApplicationState state);

private:
    void forwardEventToTransientParent(QMouseEvent *);

    QQuickItem *m_parentItem;
    QPointer<QQuickItem> m_contentItem;
    bool m_mouseMoved;
    bool m_needsActivatedEvent;
    bool m_dismissed;
    bool m_pressed;
};

QT_END_NAMESPACE

#endif // QQUICKPOPUPWINDOW_H
