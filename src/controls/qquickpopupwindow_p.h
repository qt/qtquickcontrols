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

#ifndef QQUICKPOPUPWINDOW_H
#define QQUICKPOPUPWINDOW_H

#include <QtCore/QPointer>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickwindow.h>

QT_BEGIN_NAMESPACE

class QQuickPopupWindow : public QQuickWindow
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem *popupContentItem READ popupContentItem WRITE setPopupContentItem)
    Q_CLASSINFO("DefaultProperty", "popupContentItem")
    Q_PROPERTY(QQuickItem *parentItem READ parentItem WRITE setParentItem)

public:
    QQuickPopupWindow();

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
    void mousePressEvent(QMouseEvent *) Q_DECL_OVERRIDE;
    void mouseReleaseEvent(QMouseEvent *) Q_DECL_OVERRIDE;
    void mouseMoveEvent(QMouseEvent *) Q_DECL_OVERRIDE;
    void exposeEvent(QExposeEvent *) Q_DECL_OVERRIDE;
    void hideEvent(QHideEvent *) Q_DECL_OVERRIDE;
    bool event(QEvent *) Q_DECL_OVERRIDE;
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
};

QT_END_NAMESPACE

#endif // QQUICKPOPUPWINDOW_H
