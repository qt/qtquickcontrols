/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the examples of the Qt Toolkit.
**
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
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOTgall
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/


#include "qwindowitem.h"
#include "qtoplevelwindow.h"

#include <QTimer>

QWindowItem::QWindowItem()
    : _window(new QTopLevelWindow), _positionIsDefined(false), _delayedVisible(false), _deleteOnClose(true), _x(0), _y(0)
{
    connect(_window, SIGNAL(visibilityChanged()), this, SIGNAL(visibleChanged()));
    connect(_window, SIGNAL(windowStateChanged()), this, SIGNAL(windowStateChanged()));
    connect(_window, SIGNAL(sizeChanged(QSize)), this, SLOT(updateSize(QSize)));

    view()->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    _window->installEventFilter(this);
}

QWindowItem::~QWindowItem()
{
    delete _window;
}

bool QWindowItem::eventFilter(QObject *, QEvent *ev)
{
    switch(ev->type()) {
    case QEvent::Close:
        ev->ignore();
        if (_deleteOnClose)
            deleteLater();
        else
            _window->hide();
        return true;
    case QEvent::Resize:
        emit sizeChanged();
        emit widthChanged();
        emit heightChanged();
        break;

    case QEvent::Move:
        emit xChanged();
        emit yChanged();
        break;

    default:
        break;
    }
    return false;
}

void QWindowItem::registerChildWindow(QWindowItem *child) {
    _window->registerChildWindow(child->window());
}

void QWindowItem::updateParentWindow() {
    QDeclarativeItem *p = parentItem();
    while (p) {
        if (QWindowItem *w = qobject_cast<QWindowItem*>(p)) {
            w->registerChildWindow(this);
            return;
        }
        p = p->parentItem();
    }
}

void QWindowItem::componentComplete()
{
    updateParentWindow();
    _window->scene()->addItem(this);
    if (!_window->parentWidget())
        _window->initPosition();

    QDeclarativeItem::componentComplete();

    if (_delayedVisible) {
        setVisible(true);
    }
}

void QWindowItem::updateSize(QSize newSize)
{
    QDeclarativeItem::setSize(newSize);
    emit sizeChanged();
}

void QWindowItem::center()
{
    _window->center();
}

void QWindowItem::setX(int x)
{
    _x = x;
    _window->move(x, _y);
}
void QWindowItem::setY(int y)
{
    _y = y;
    _window->move(_x, y);
}

void QWindowItem::moveWindow(int x,int y, int lx, int ly)
{
    QPoint p = _window->mapToGlobal(QPoint(x,y));
    p.setX(p.x() - lx);
    p.setY(p.y() - ly);
    _window->move(p);
}

void QWindowItem::setHeight(int height)
{
    int menuBarHeight = _window->menuBar()->sizeHint().height();
    if (menuBarHeight) menuBarHeight++;
    _window->resize(width(), height+menuBarHeight);
    QDeclarativeItem::setHeight(_window->height());
}

void QWindowItem::setMinimumHeight(int height)
{
    int menuBarHeight = _window->menuBar()->sizeHint().height();
    if (menuBarHeight) menuBarHeight++;
    _window->setMinimumHeight(height+menuBarHeight);
}

void QWindowItem::setMaximumHeight(int height)
{
    int menuBarHeight = _window->menuBar()->sizeHint().height();
    if (menuBarHeight) menuBarHeight++;
    _window->setMaximumHeight(height+menuBarHeight);
}

void QWindowItem::setWidth(int width)
{
    _window->resize(width, height());
    QDeclarativeItem::setWidth(_window->width());
}

void QWindowItem::setTitle(QString title)
{
    _window->setWindowTitle(title);
    emit titleChanged();
}

void QWindowItem::setVisible(bool visible)
{
    _window->setWindowFlags(_window->windowFlags() | Qt::Window);
    if (visible) {
        if (isComponentComplete()) {
            // avoid flickering when showing the widget,
            // by passing the event loop at least once
            QTimer::singleShot(1, _window, SLOT(show()));
        } else {
            _delayedVisible = true;
        }
    } else {
        _window->hide();
    }
}

void QWindowItem::setWindowDecoration(bool s)
{
    bool visible = _window->isVisible();


    _window->setWindowFlags(s ? _window->windowFlags() & ~Qt::FramelessWindowHint
                              : _window->windowFlags() | Qt::FramelessWindowHint);
    if (visible)
        _window->show();
    emit windowDecorationChanged();
}

void QWindowItem::setModal(bool modal)
{
    bool visible = _window->isVisible();
    _window->hide();
    _window->setWindowModality(modal ? Qt::WindowModal : Qt::NonModal);

    if (visible)
        _window->show();
    emit modalityChanged();
}

void QWindowItem::setDeleteOnClose(bool deleteOnClose)
{
    if (deleteOnClose == _deleteOnClose)
        return;
    _deleteOnClose = deleteOnClose;
    emit deleteOnCloseChanged();
}

void QWindowItem::close()
{
    if (_deleteOnClose)
        deleteLater();
    else
        _window->hide();
}
