/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
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
