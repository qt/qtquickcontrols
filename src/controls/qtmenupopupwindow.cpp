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

#include "qtmenupopupwindow_p.h"
#include "qtmenu_p.h"
#include <QtGui/QGuiApplication>
#include <QtCore/QEvent>

QT_BEGIN_NAMESPACE

QtMenuPopupWindow::QtMenuPopupWindow(QWindow *parent) :
    QQuickWindow(parent), m_pressedInside(true), m_itemAt(0)
{
    setFlags(Qt::Popup);
    setModality(Qt::WindowModal);
}

void QtMenuPopupWindow::setMenuContentItem(QQuickItem *contentItem)
{
    if (!contentItem)
        return;

    contentItem->setParentItem(this->contentItem());
    connect(contentItem, SIGNAL(widthChanged()), this, SLOT(updateSize()));
    connect(contentItem, SIGNAL(heightChanged()), this, SLOT(updateSize()));
}

void QtMenuPopupWindow::setItemAt(const QQuickItem *menuItem)
{
    if (m_itemAt) {
        disconnect(m_itemAt, SIGNAL(xChanged()), this, SLOT(updatePosition()));
        disconnect(m_itemAt, SIGNAL(yChanged()), this, SLOT(updatePosition()));
    }

    m_itemAt = menuItem;
    if (menuItem) {
        m_oldItemPos = menuItem->position().toPoint();
        connect(menuItem, SIGNAL(xChanged()), this, SLOT(updatePosition()));
        connect(menuItem, SIGNAL(yChanged()), this, SLOT(updatePosition()));
    }
}

void QtMenuPopupWindow::setParentWindow(QQuickWindow *parentWindow)
{
    setTransientParent(parentWindow);
    if (parentWindow) {
        connect(parentWindow, SIGNAL(destroyed()), this, SLOT(dismissMenu()));
        if (QtMenuPopupWindow *pw = qobject_cast<QtMenuPopupWindow *>(parentWindow))
            connect(this, SIGNAL(menuDismissed()), pw, SLOT(dismissMenu()));
    }
}

void QtMenuPopupWindow::dismissMenu()
{
    close();

    emit menuDismissed();
}

void QtMenuPopupWindow::updateSize()
{
    QSize contentSize = contentItem()->childrenRect().size().toSize();
    setWidth(contentSize.width());
    setHeight(contentSize.height());
}

void QtMenuPopupWindow::updatePosition()
{
    QPointF newPos = position() + m_oldItemPos - m_itemAt->position();
    setPosition(newPos.toPoint());
}

void QtMenuPopupWindow::mouseMoveEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    QWindow *parentMenuWindow = /*qobject_cast<QtMenuPopupWindow*>*/(transientParent());
    if (parentMenuWindow && !rect.contains(e->pos())) {
        forwardEventToTransientParent(e);
    } else {
        QQuickWindow::mouseMoveEvent(e);
    }
}

void QtMenuPopupWindow::mousePressEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    m_pressedInside = rect.contains(e->pos());
    if (m_pressedInside)
        QQuickWindow::mousePressEvent(e);
}

void QtMenuPopupWindow::mouseReleaseEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    if (rect.contains(e->pos()))
        QQuickWindow::mouseReleaseEvent(e);
    else if (!m_pressedInside)
        dismissMenu();
    else
        forwardEventToTransientParent(e);
}

void QtMenuPopupWindow::forwardEventToTransientParent(QMouseEvent *e)
{
    QWindow *parentMenuWindow = /*qobject_cast<QtMenuPopupWindow*>*/(transientParent());
    if (!parentMenuWindow)
        return;
    QPoint parentPos = parentMenuWindow->mapFromGlobal(mapToGlobal(e->pos()));
    QMouseEvent pe = QMouseEvent(e->type(), parentPos, e->button(), e->buttons(), e->modifiers());
    QGuiApplication::sendEvent(parentMenuWindow, &pe);
}

QT_END_NAMESPACE
