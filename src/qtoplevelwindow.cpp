/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
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
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qtoplevelwindow.h"

#include <QDesktopWidget>
#if QT_VERSION >= 0x050000
#include <QtWidgets/QMenuBar>
#endif

QTopLevelWindow::QTopLevelWindow()
#if QT_VERSION < 0x050000
    : QMainWindow(), _view(new QDeclarativeView), _positionIsDefined(false) {
#else
    : QQuickView(), _menuBar(new QMenuBar), _positionIsDefined(false) {
#endif

    setVisible(false);
    // Ensure that we have a default size, otherwise an empty window statement will
    // result in no window
//    resize(QSize(100, 100));
#if QT_VERSION < 0x050000
    _view->setBackgroundBrush(palette().window());
    setCentralWidget(_view);
#endif
}

#if QT_VERSION >= 0x050000
QMenuBar *QTopLevelWindow::menuBar()
{
    return _menuBar;
}
#endif


QTopLevelWindow::~QTopLevelWindow()
{
    foreach (QTopLevelWindow* child, findChildren<QTopLevelWindow*>())
        child->setParent(0);
    //we need this to break the parental loop of QWindowItem and QTopLevelWindow
#if QT_VERSION < 0x050000
    _view->scene()->setParent(0);
#endif
}

void QTopLevelWindow::registerChildWindow(QTopLevelWindow* child)
{
    child->setParent(this);
}

void QTopLevelWindow::hideChildWindows()
{
    foreach (QTopLevelWindow* child, findChildren<QTopLevelWindow*>()) {
        child->hide();
    }
}

void QTopLevelWindow::initPosition()
{
    if (!_positionIsDefined)
        center();
    foreach (QTopLevelWindow* child, findChildren<QTopLevelWindow*>()) {
        child->initPosition();
    }
}

void QTopLevelWindow::center()
{
    QPoint parentCenter;
#if QT_VERSION < 0x050000
    if (parentWidget())
        parentCenter = parentWidget()->geometry().center();
    else
#endif
        parentCenter = QDesktopWidget().screenGeometry().center();
    QRect thisGeometry = geometry();
    thisGeometry.moveCenter(parentCenter);
    setGeometry(thisGeometry);
}

void QTopLevelWindow::move(int x, int y)
{
    qDebug("a %d, %d", x, y);
    move(QPoint(x,y));
}

void QTopLevelWindow::move(const QPoint &point)
{
    _positionIsDefined = true;
#if QT_VERSION < 0x050000
    QMainWindow::move(point);
#else
    QQuickView::setPos(point);
#endif
}

void QTopLevelWindow::setWindowFlags(Qt::WindowFlags type)
{
#if QT_VERSION < 0x050000
    QWidget::setWindowFlags(type | Qt::Window);
#else
    QQuickView::setWindowFlags(type | Qt::Window);
#endif
}

