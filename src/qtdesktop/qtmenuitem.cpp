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

#include "qtmenuitem.h"

void QtMenuBase::setIconSource(const QUrl &icon)
{
    _iconSource = icon;
    if (_iconName.isEmpty())
        action()->setIcon(QIcon(icon.toLocalFile()));
    else
        action()->setIcon(QIcon::fromTheme(_iconName, QIcon(_iconSource.toLocalFile())));

    emit iconSourceChanged();
}

QUrl QtMenuBase::iconSource() const
{
    return _iconSource;
}

void QtMenuBase::setIconName(const QString &icon)
{
    _iconName = icon;
    action()->setIcon(QIcon::fromTheme(_iconName, QIcon(_iconSource.toLocalFile())));

    emit iconNameChanged();
}

QString QtMenuBase::iconName() const
{
    return _iconName;
}

/*!
    \qmltype MenuItem
    \instantiates QtMenuSeparator
    \inqmlmodule QtDesktop 1.0
    \brief MenuItem is doing bla...bla...
*/

QtMenuSeparator::QtMenuSeparator(QQuickItem *parent)
    : QtMenuBase(parent), _action(new QAction(this))
{
    _action->setSeparator(true);
}

QtMenuSeparator::~QtMenuSeparator()
{
}

QAction * QtMenuSeparator::action()
{
    return _action;
}

/*!
    \qmltype MenuItem
    \instantiates QtMenuItem
    \inqmlmodule QtDesktop 1.0
    \brief MenuItem is doing bla...bla...
*/

QtMenuItem::QtMenuItem(QQuickItem *parent)
    : QtMenuBase(parent), _action(new QAction(this))
{
    connect(_action, SIGNAL(triggered()), this, SIGNAL(triggered()));
    connect(_action, SIGNAL(toggled(bool)), this, SIGNAL(toggled(bool)));
    connect(_action, SIGNAL(changed()), this, SIGNAL(enabledChanged()));
}

QtMenuItem::~QtMenuItem()
{
}

void QtMenuItem::setText(const QString &text)
{
    _action->setText(text);
    emit textChanged();
}

void QtMenuItem::setShortcut(const QString &shortcut)
{
    _action->setShortcut(QKeySequence(shortcut));
    emit shortcutChanged();
}

void QtMenuItem::setCheckable(bool checkable)
{
    _action->setCheckable(checkable);
}

void QtMenuItem::setChecked(bool checked)
{
    _action->setChecked(checked);
}

void QtMenuItem::setEnabled(bool enabled)
{
    _action->setEnabled(enabled);
}

QString QtMenuItem::text() const
{
    return _action->text();
}

QString QtMenuItem::shortcut() const
{
    return _action->shortcut().toString();
}

bool QtMenuItem::checkable() const
{
    return _action->isCheckable();
}

bool QtMenuItem::checked() const
{
    return _action->isChecked();
}

bool QtMenuItem::enabled() const
{
    return _action->isEnabled();
}

QAction * QtMenuItem::action()
{
    return _action;
}
