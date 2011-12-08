/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

#ifndef QTOPLEVELWINDOW_H
#define QTOPLEVELWINDOW_H

#include <QDeclarativeView>
#include <QMainWindow>
#include <QWindowStateChangeEvent>
#include <QDebug>

class QTopLevelWindow : public QMainWindow {
    Q_OBJECT
public:
    QTopLevelWindow();
    ~QTopLevelWindow();

    QGraphicsScene *scene() { return _view->scene(); }
    QDeclarativeView *view() { return _view; }


    void registerChildWindow(QTopLevelWindow* child);
    void hideChildWindows();
    void initPosition();
    void setWindowFlags(Qt::WindowFlags type);

    void center();
    void move(int x, int y);
    void move(const QPoint &);

protected:
    virtual bool event(QEvent *event);

Q_SIGNALS:
    void visibilityChanged();
    void windowStateChanged();
    void sizeChanged(QSize newSize);

private:
    QDeclarativeView *_view;
    bool _positionIsDefined;

};

#endif // QTOPLEVELWINDOW_H
