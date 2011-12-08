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

#ifndef QWindowItem_H
#define QWindowItem_H

#include "qtoplevelwindow.h"

#include <QtGui/QApplication>
#include <QDeclarativeItem>
#include <QDeclarativeView>
#include <QMenuBar>


class QWindowItem : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(int x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(int y READ y WRITE setY NOTIFY yChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY sizeChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY sizeChanged)
    Q_PROPERTY(int minimumHeight READ minimumHeight WRITE setMinimumHeight NOTIFY minimumHeightChanged)
    Q_PROPERTY(int maximumHeight READ maximumHeight WRITE setMaximumHeight NOTIFY maximumHeightChanged)
    Q_PROPERTY(int minimumWidth READ minimumWidth WRITE setMinimumWidth NOTIFY minimumWidthChanged)
    Q_PROPERTY(int maximumWidth READ maximumWidth WRITE setMaximumWidth NOTIFY maximumWidthChanged)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged)
    Q_PROPERTY(bool windowDecoration READ windowDecoration WRITE setWindowDecoration NOTIFY windowDecorationChanged)
    Q_PROPERTY(bool modal READ modal WRITE setModal NOTIFY modalityChanged)
    Q_PROPERTY(bool deleteOnClose READ deleteOnClose WRITE setDeleteOnClose NOTIFY deleteOnCloseChanged)
    Q_PROPERTY(Qt::WindowState windowState READ windowState WRITE setWindowState NOTIFY windowStateChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    QWindowItem();
    ~QWindowItem();

    QTopLevelWindow *window() { return _window; }
    QDeclarativeView *view() { return _window->view(); }
    int x() const { return _window->x(); }
    int y() const { return _window->y(); }
    int height() const { return _window->height(); }
    int minimumHeight() const { return _window->minimumHeight(); }
    int maximumHeight() const { return _window->maximumHeight(); }
    int width() const { return _window->width(); }
    int minimumWidth() const { return _window->minimumWidth(); }
    int maximumWidth() const { return _window->maximumWidth(); }
    bool isVisible() const { return _window->isVisible(); }
    bool windowDecoration() const { return !(_window->windowFlags() & Qt::FramelessWindowHint); }
    Qt::WindowState windowState() const { return static_cast<Qt::WindowState>(static_cast<int>(_window->windowState()) & ~Qt::WindowActive); }
    QString title() const { return _window->windowTitle(); }
    bool deleteOnClose() const { return _deleteOnClose; }
    bool modal() const { return _window->isModal(); }

    void setX(int x);
    void setY(int y);
    void setHeight(int height);
    void setMinimumHeight(int height);
    void setMaximumHeight(int height);
    void setWidth(int width);
    void setMinimumWidth(int width) { _window->setMinimumWidth(width); }
    void setMaximumWidth(int width) { _window->setMaximumWidth(width); }
    void setVisible(bool visible);
    void setWindowDecoration(bool s);
    void setWindowState(Qt::WindowState state) { _window->setWindowState(state); }
    void setTitle(QString title);
    void setModal(bool modal);
    void setDeleteOnClose(bool close);

public Q_SLOTS:
    void close();

protected:
    bool eventFilter(QObject *, QEvent *ev);
    void updateParentWindow();
    void registerChildWindow(QWindowItem* child);
    void componentComplete();

protected Q_SLOTS:
    void updateSize(QSize newSize);
    void center();
    void moveWindow(int x, int y, int lx, int ly);

Q_SIGNALS:
    void sizeChanged();
    void xChanged();
    void yChanged();
    void visibleChanged();
    void windowDecorationChanged();
    void windowStateChanged();
    void minimumHeightChanged();
    void minimumWidthChanged();
    void maximumHeightChanged();
    void maximumWidthChanged();
    void titleChanged();
    void modalityChanged();
    void deleteOnCloseChanged();

private:
    QTopLevelWindow *_window;
    bool _complete;
    bool _positionIsDefined;
    bool _delayedVisible;
    bool _deleteOnClose;
    int _x;
    int _y;
};

#endif // QWindowItem_H
