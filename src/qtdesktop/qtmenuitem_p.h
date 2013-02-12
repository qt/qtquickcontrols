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

#ifndef QTMENUITEM_P_H
#define QTMENUITEM_P_H

#include <QtCore/QObject>
#include <QtCore/QPointF>
#include <QtCore/QPointer>
#include <QtCore/QUrl>

QT_BEGIN_NAMESPACE

class QUrl;
class QPlatformMenuItem;
class QQuickItem;
class QtAction;
class QtMenu;

class QtMenuBase: public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isNative READ isNative CONSTANT)
    Q_PROPERTY(QQuickItem * __visualItem WRITE setVisualItem)

public:
    QtMenuBase(QObject *parent = 0);
    ~QtMenuBase();

    inline QPlatformMenuItem *platformItem() { return m_platformItem; }

    void syncWithPlatformMenu();

    QQuickItem *visualItem() const;
    void setVisualItem(QQuickItem *item);

protected:
    virtual bool isNative() { return m_platformItem != 0; }

private:
    QPlatformMenuItem *m_platformItem;
    QPointer<QQuickItem> m_visualItem;
};

class QtMenuSeparator : public QtMenuBase
{
    Q_OBJECT
public:
    QtMenuSeparator(QObject *parent = 0);
};

class QtMenuItem: public QtMenuBase
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString shortcut READ shortcut WRITE setShortcut NOTIFY shortcutChanged)
    Q_PROPERTY(bool checkable READ checkable WRITE setCheckable NOTIFY checkableChanged)
    Q_PROPERTY(bool checked READ checked WRITE setChecked NOTIFY toggled)
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(QUrl iconSource READ iconSource WRITE setIconSource NOTIFY iconSourceChanged)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)

    Q_PROPERTY(QtAction *action READ action WRITE setAction NOTIFY actionChanged)
    Q_PROPERTY(QtMenu *parentMenu READ parentMenu)

public:
    QtMenuItem(QObject *parent = 0);
    ~QtMenuItem();

    QtAction *action();
    void setAction(QtAction *a);

    QtMenu *parentMenu() const;

    QString text() const;
    void setText(const QString &text);

    QString shortcut() const;
    void setShortcut(const QString &shortcut);

    bool checkable() const;
    void setCheckable(bool checkable);

    bool checked() const;
    void setChecked(bool checked);

    bool enabled() const;
    void setEnabled(bool enabled);

    QUrl iconSource() const;
    void setIconSource(const QUrl &icon);
    QString iconName() const;
    void setIconName(const QString &icon);

Q_SIGNALS:
    void triggered();
    void textChanged();
    void shortcutChanged();
    void checkableChanged();
    void toggled(bool);
    void enabledChanged();

    void iconSourceChanged();
    void iconNameChanged();

    void actionChanged();

public Q_SLOTS:
    void trigger();

protected Q_SLOTS:
    virtual void updateText();
    void updateShortcut();
    void updateChecked();
    void updateEnabled();
    void updateIconName();
    void updateIconSource();
    void bindToAction(QtAction *action);
    void unbindFromAction(QObject *action);

private:
    QtAction *m_action;
};

QT_END_NAMESPACE

#endif //QTMENUITEM_P_H
