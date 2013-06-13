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

#include "qquickmenupopupwindow_p.h"

#include <qguiapplication.h>
#include <qquickitem.h>
#include <QtGui/QScreen>

QT_BEGIN_NAMESPACE

QQuickMenuPopupWindow::QQuickMenuPopupWindow(QWindow *parent) :
    QQuickWindow(parent), m_mouseMoved(false), m_itemAt(0),
    m_parentItem(0), m_menuContentItem(0)
{
    setFlags(Qt::Popup);
    setModality(Qt::WindowModal);
}

void QQuickMenuPopupWindow::show()
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

    if (m_itemAt) {
        QPointF pos = m_itemAt->position();
        posx -= pos.x();
        posy -= pos.y();
    }

    if (m_menuContentItem) {
        qreal initialWidth = qMax(qreal(1), m_menuContentItem->width());
        qreal initialHeight = qMax(qreal(1), m_menuContentItem->height());
        setGeometry(posx, posy, initialWidth, initialHeight);
    } else {
        setPosition(posx, posy);
    }

    if (!qobject_cast<QQuickMenuPopupWindow *>(transientParent())) // No need for parent menu windows
        if (QQuickWindow *w = qobject_cast<QQuickWindow *>(transientParent()))
            if (QQuickItem *mg = w->mouseGrabberItem())
                mg->ungrabMouse();

    QQuickWindow::show();
    setMouseGrabEnabled(true); // Needs to be done after calling show()
    setKeyboardGrabEnabled(true);
}

void QQuickMenuPopupWindow::setParentItem(QQuickItem *item)
{
    m_parentItem = item;
    if (m_parentItem)
        setParentWindow(m_parentItem->window());
}

void QQuickMenuPopupWindow::setMenuContentItem(QQuickItem *contentItem)
{
    if (!contentItem)
        return;

    contentItem->setParentItem(this->contentItem());
    connect(contentItem, SIGNAL(widthChanged()), this, SLOT(updateSize()));
    connect(contentItem, SIGNAL(heightChanged()), this, SLOT(updateSize()));
    m_menuContentItem = contentItem;
}

void QQuickMenuPopupWindow::setItemAt(QQuickItem *menuItem)
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

void QQuickMenuPopupWindow::setParentWindow(QQuickWindow *parentWindow)
{
    setTransientParent(parentWindow);
    if (parentWindow) {
        connect(parentWindow, SIGNAL(destroyed()), this, SLOT(dismissMenu()));
        if (QQuickMenuPopupWindow *pw = qobject_cast<QQuickMenuPopupWindow *>(parentWindow))
            connect(pw, SIGNAL(menuDismissed()), this, SLOT(dismissMenu()));
    }
}

void QQuickMenuPopupWindow::setGeometry(int posx, int posy, int w, int h)
{
    QWindow *pw = transientParent();
    if (!pw && m_parentItem )
        pw = m_parentItem->window();
    if (!pw)
        pw = this;
    QRect g = pw->screen()->availableVirtualGeometry();

    if (posx + w > g.right()) {
        if (qobject_cast<QQuickMenuPopupWindow *>(transientParent())) {
            // reposition submenu window on the parent menu's left side
            int submenuOverlap = pw->x() + pw->width() - posx;
            posx -= pw->width() + w - 2 * submenuOverlap;
        } else {
            posx = g.right() - w;
        }
    } else {
        posx = qMax(posx, g.left());
    }

    posy = qBound(g.top(), posy, g.bottom() - h);

    QQuickWindow::setGeometry(posx, posy, w, h);
}

void QQuickMenuPopupWindow::dismissMenu()
{
    emit menuDismissed();
    close();
}

void QQuickMenuPopupWindow::updateSize()
{
    QSize contentSize = contentItem()->childrenRect().size().toSize();
    setGeometry(position().x(), position().y(), contentSize.width(), contentSize.height());
}

void QQuickMenuPopupWindow::updatePosition()
{
    QPointF newPos = position() + m_oldItemPos - m_itemAt->position();
    setGeometry(newPos.x(), newPos.y(), width(), height());
}

void QQuickMenuPopupWindow::mouseMoveEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    m_mouseMoved = true;
    if (rect.contains(e->pos()))
        QQuickWindow::mouseMoveEvent(e);
    else
        forwardEventToTransientParent(e);
}

void QQuickMenuPopupWindow::mousePressEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    if (!rect.contains(e->pos()))
        forwardEventToTransientParent(e);
}

void QQuickMenuPopupWindow::mouseReleaseEvent(QMouseEvent *e)
{
    QRect rect = QRect(QPoint(), size());
    if (rect.contains(e->pos())) {
        if (m_mouseMoved) {
            QMouseEvent pe = QMouseEvent(QEvent::MouseButtonPress, e->pos(), e->button(), e->buttons(), e->modifiers());
            QQuickWindow::mousePressEvent(&pe);
            QQuickWindow::mouseReleaseEvent(e);
        }
        m_mouseMoved = true; // Initial mouse release counts as move.
    } else {
        forwardEventToTransientParent(e);
    }
}

void QQuickMenuPopupWindow::forwardEventToTransientParent(QMouseEvent *e)
{
    if (!qobject_cast<QQuickMenuPopupWindow*>(transientParent())
        && ((m_mouseMoved && e->type() == QEvent::MouseButtonRelease)
            || e->type() == QEvent::MouseButtonPress)) {
        // Clicked outside any menu
        dismissMenu();
    } else if (transientParent()) {
        QPoint parentPos = transientParent()->mapFromGlobal(mapToGlobal(e->pos()));
        QMouseEvent pe = QMouseEvent(e->type(), parentPos, e->button(), e->buttons(), e->modifiers());
        QGuiApplication::sendEvent(transientParent(), &pe);
    }
}

QT_END_NAMESPACE
