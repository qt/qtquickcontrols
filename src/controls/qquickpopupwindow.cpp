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

#include "qquickpopupwindow_p.h"

#include <qguiapplication.h>
#include <qpa/qwindowsysteminterface.h>
#include <QtQuick/qquickitem.h>

QT_BEGIN_NAMESPACE

QQuickPopupWindow::QQuickPopupWindow() :
    QQuickWindow(), m_parentItem(0), m_contentItem(0),
    m_mouseMoved(false), m_needsActivatedEvent(true),
    m_dismissed(false)
{
    setFlags(Qt::Popup);
    setModality(Qt::ApplicationModal);
}

void QQuickPopupWindow::show()
{
    qreal posx = x();
    qreal posy = y();
    if (QQuickWindow *parentWindow = qobject_cast<QQuickWindow *>(transientParent())) {
        if (m_parentItem) {
            QPointF pos = m_parentItem->mapToItem(parentWindow->contentItem(), QPointF(posx, posy));
            posx = pos.x();
            posy = pos.y();
        }

        if (parentWindow->parent()) {
            // If the parent window is embedded in another window, the offset needs to be relative to
            // its top-level window container, or to global coordinates, which is the same in the end.
            QPoint parentWindowOffset = parentWindow->mapToGlobal(QPoint());
            posx += parentWindowOffset.x();
            posy += parentWindowOffset.y();
        } else {
            posx += parentWindow->geometry().left();
            posy += parentWindow->geometry().top();
        }
    }

    if (m_contentItem) {
        qreal initialWidth = qMax(qreal(1), m_contentItem->width());
        qreal initialHeight = qMax(qreal(1), m_contentItem->height());
        setGeometry(posx, posy, initialWidth, initialHeight);
    } else {
        setPosition(posx, posy);
    }

    if (!qobject_cast<QQuickPopupWindow *>(transientParent())) // No need for parent menu windows
        if (QQuickWindow *w = qobject_cast<QQuickWindow *>(transientParent()))
            if (QQuickItem *mg = w->mouseGrabberItem())
                mg->ungrabMouse();

    QQuickWindow::show();
    setMouseGrabEnabled(true); // Needs to be done after calling show()
    setKeyboardGrabEnabled(true);
}

void QQuickPopupWindow::setParentItem(QQuickItem *item)
{
    m_parentItem = item;
    if (m_parentItem)
        setTransientParent(m_parentItem->window());
}

void QQuickPopupWindow::setPopupContentItem(QQuickItem *contentItem)
{
    if (!contentItem)
        return;

    contentItem->setParentItem(this->contentItem());
    connect(contentItem, SIGNAL(widthChanged()), this, SLOT(updateSize()));
    connect(contentItem, SIGNAL(heightChanged()), this, SLOT(updateSize()));
    m_contentItem = contentItem;
}

void QQuickPopupWindow::updateSize()
{
    QSize contentSize = popupContentItem()->childrenRect().size().toSize();
    setGeometry(x(), y(), contentSize.width(), contentSize.height());
}

void QQuickPopupWindow::dismissPopup()
{
    m_dismissed = true;
    emit popupDismissed();
    close();
}

void QQuickPopupWindow::mouseMoveEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    m_mouseMoved = true;
    if (rect.contains(e->pos()))
        QQuickWindow::mouseMoveEvent(e);
    else
        forwardEventToTransientParent(e);
}

void QQuickPopupWindow::mousePressEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    if (rect.contains(e->pos()))
        QQuickWindow::mousePressEvent(e);
    else
        forwardEventToTransientParent(e);
}

void QQuickPopupWindow::mouseReleaseEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    if (rect.contains(e->pos())) {
        if (m_mouseMoved) {
            QMouseEvent pe = QMouseEvent(QEvent::MouseButtonPress, e->pos(), e->button(), e->buttons(), e->modifiers());
            QQuickWindow::mousePressEvent(&pe);
            if (!m_dismissed)
                QQuickWindow::mouseReleaseEvent(e);
        }
        m_mouseMoved = true; // Initial mouse release counts as move.
    } else {
        forwardEventToTransientParent(e);
    }
}

void QQuickPopupWindow::forwardEventToTransientParent(QMouseEvent *e)
{
    if (!qobject_cast<QQuickPopupWindow*>(transientParent())
        && ((m_mouseMoved && e->type() == QEvent::MouseButtonRelease)
            || e->type() == QEvent::MouseButtonPress)) {
        // Clicked outside any popup
        dismissPopup();
    } else if (transientParent()) {
        QPoint parentPos = transientParent()->mapFromGlobal(mapToGlobal(e->pos()));
        QMouseEvent pe = QMouseEvent(e->type(), parentPos, e->button(), e->buttons(), e->modifiers());
        QGuiApplication::sendEvent(transientParent(), &pe);
    }
}

void QQuickPopupWindow::exposeEvent(QExposeEvent *e)
{
    if (isExposed() && m_needsActivatedEvent) {
        m_needsActivatedEvent = false;
        QWindowSystemInterface::handleWindowActivated(this, Qt::PopupFocusReason);
    } else if (!isExposed() && !m_needsActivatedEvent) {
        m_needsActivatedEvent = true;
        if (QWindow *tp = transientParent())
            QWindowSystemInterface::handleWindowActivated(tp, Qt::PopupFocusReason);
    }
    QQuickWindow::exposeEvent(e);
}

void QQuickPopupWindow::hideEvent(QHideEvent *e)
{
    if (QWindow *tp = !m_needsActivatedEvent ? transientParent() : 0) {
        m_needsActivatedEvent = true;
        QWindowSystemInterface::handleWindowActivated(tp, Qt::PopupFocusReason);
    }

    QQuickWindow::hideEvent(e);
}

QT_END_NAMESPACE
