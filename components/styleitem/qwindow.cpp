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


#include "qwindow.h"

QWindow::QWindow() : _window(new DeclarativeWindow) {
    connect(_window, SIGNAL(visibilityChanged()), this, SIGNAL(visibilityChanged()));
    connect(_window, SIGNAL(windowStateChanged()), this, SIGNAL(windowStateChanged()));
}

bool QWindow::eventFilter(QObject *, QEvent *ev) {
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

QDeclarativeListProperty<QObject> QWindow::data()
{
    return QDeclarativeListProperty<QObject>(_window->scene(), 0, data_append, data_count, data_at, data_clear);
}

void QWindow::data_append(QDeclarativeListProperty<QObject> *prop, QObject *o)
{
    QGraphicsObject *graphicsObject = qobject_cast<QGraphicsObject *>(o);
    if (graphicsObject) {
        static_cast<QGraphicsScene *>(prop->object)->addItem(graphicsObject);
    }
}

static inline int children_count_helper(QDeclarativeListProperty<QObject> *prop)
{
    return prop->object->children().count();
}

static inline QObject *children_at_helper(QDeclarativeListProperty<QObject> *prop, int index)
{
    return prop->object->children().at(index);
}

static inline void children_clear_helper(QDeclarativeListProperty<QObject> *prop)
{
    QList<QObject *> list = prop->object->children();
    foreach (QObject *o, list) {
        if (QGraphicsObject * go = qobject_cast<QGraphicsObject *>(o)) {
            go->setParentItem(0);
        }
    }
}

int QWindow::data_count(QDeclarativeListProperty<QObject> *prop)
{
    return children_count_helper(prop);
}

QObject *QWindow::data_at(QDeclarativeListProperty<QObject> *prop, int i)
{
    return children_at_helper(prop, i);
}

void QWindow::data_clear(QDeclarativeListProperty<QObject> *prop)
{
    const QObjectList children = prop->object->children();
        for (int index = 0; index < children.count(); index++)
            children.at(index)->setParent(0);
    children_clear_helper(prop);
}


