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

#ifndef QTMENUITEM_H
#define QTMENUITEM_H

#include <QtCore/QObject>
#include <QtWidgets/QAction>
#include <QtCore/QUrl>

#include <QtQuick/QQuickItem>

class QtMenuBase: public QQuickItem
{
Q_OBJECT
    Q_PROPERTY(QUrl iconSource READ iconSource WRITE setIconSource NOTIFY iconSourceChanged)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)

public:
    QtMenuBase(QQuickItem *parent = 0) : QQuickItem(parent) {}

    virtual QAction* action() = 0;

    void setIconSource(const QUrl &icon);
    QUrl iconSource() const;

    void setIconName(const QString &icon);
    QString iconName() const;

Q_SIGNALS:
    void iconSourceChanged();
    void iconNameChanged();

private:
    QUrl _iconSource;
    QString _iconName;
};

class QtMenuSeparator : public QtMenuBase
{
    Q_OBJECT
public:
    QtMenuSeparator(QQuickItem *parent = 0);
    ~QtMenuSeparator();
    QAction* action();

private:
    QAction *_action;
};

class QtMenuItem: public QtMenuBase
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged);
    Q_PROPERTY(QString shortcut READ shortcut WRITE setShortcut NOTIFY shortcutChanged)
    Q_PROPERTY(bool checkable READ checkable WRITE setCheckable)
    Q_PROPERTY(bool checked READ checked WRITE setChecked NOTIFY toggled)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

public:
    QtMenuItem(QQuickItem *parent = 0);
    ~QtMenuItem();

    void setText(const QString &text);
    void setShortcut(const QString &shortcut);
    void setCheckable(bool checkable);
    void setChecked(bool checked);
    void setEnabled(bool enabled);

    QString text() const;
    QString shortcut() const;
    bool checkable() const;
    bool checked() const;
    bool enabled() const;

    QAction* action();

Q_SIGNALS:
    void triggered();
    void textChanged();
    void shortcutChanged();
    void toggled(bool);
    void enabledChanged();

private:
    QAction *_action;
};

#endif //QTMENUITEM_H
