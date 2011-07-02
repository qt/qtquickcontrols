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

QWindowItem::QWindowItem(QTopLevelWindow* tlw)
    : _window(tlw ? tlw : new QTopLevelWindow), _positionIsDefined(false)
{
    connect(_window, SIGNAL(visibilityChanged()), this, SIGNAL(visibilityChanged()));
    connect(_window, SIGNAL(windowStateChanged()), this, SIGNAL(windowStateChanged()));
    connect(_window, SIGNAL(sizeChanged(QSize)), this, SLOT(updateSize(QSize)));
    view()->setResizeMode(QDeclarativeView::SizeRootObjectToView);
}

QWindowItem::~QWindowItem()
{
}

bool QWindowItem::eventFilter(QObject *, QEvent *ev)
{
    switch(ev->type()) {
        case QEvent::Resize:
            emit sizeChanged();
            break;
        case QEvent::Move:
            emit positionChanged();
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
}

void QWindowItem::updateSize(QSize newSize)
{
    QDeclarativeItem::setSize(newSize);
    emit sizeChanged();
}

void QWindowItem::setX(int x) {
    _window->move(x, y());
}
void QWindowItem::setY(int y) {
    _window->move(x(), y);
}

void QWindowItem::setHeight(int height) {
    int menuBarHeight = _window->menuBar()->sizeHint().height();
    if (menuBarHeight) menuBarHeight++;
    _window->resize(width(), height+menuBarHeight);
    QDeclarativeItem::setHeight(height);
}

void QWindowItem::setMinimumHeight(int height) {
    int menuBarHeight = _window->menuBar()->sizeHint().height();
    if (menuBarHeight) menuBarHeight++;
    _window->setMinimumHeight(height+menuBarHeight);
}

void QWindowItem::setMaximumHeight(int height) {
    int menuBarHeight = _window->menuBar()->sizeHint().height();
    if (menuBarHeight) menuBarHeight++;
    _window->setMaximumHeight(height+menuBarHeight);
}

void QWindowItem::setWidth(int width) {
    _window->resize(width, height());
    QDeclarativeItem::setWidth(width);
}

void QWindowItem::setTitle(QString title) {
    _window->setWindowTitle(title);
    emit titleChanged();
}

void QWindowItem::setWindowDecoration(bool s) {
    bool visible = _window->isVisible();
    _window->setWindowFlags(s ? _window->windowFlags() & ~Qt::FramelessWindowHint
                          : _window->windowFlags() | Qt::FramelessWindowHint);
    if (visible)
        _window->show();
    emit windowDecorationChanged();
}

void QWindowItem::setModal(bool modal) {
    _window->hide();
    _window->setWindowModality(modal ? Qt::WindowModal : Qt::NonModal);
    _window->show();
    emit modalityChanged();
}
