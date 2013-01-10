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

#include "qtaction_p.h"
#include "qtexclusivegroup_p.h"

#include "qdebug.h"


QtAction::QtAction(QObject *parent)
    : QObject(parent)
    , m_enabled(true)
    , m_checkable(false)
    , m_checked(false)
    , m_exclusiveGroup(0)
{
}

void QtAction::setText(const QString &text)
{
    if (text == m_text)
        return;
    m_text = text;
    emit textChanged();
}

void QtAction::setShortcut(const QString &arg)
{
    if (arg == m_shortcut)
        return;
    m_shortcut = arg;
    emit shortcutChanged(m_shortcut);
}

void QtAction::setIconSource(const QUrl &iconSource)
{
    if (iconSource == m_iconSource)
        return;

    m_iconSource = iconSource;
    emit iconSourceChanged();
}

void QtAction::setIconName(const QString &iconName)
{
    if (iconName == m_iconName)
        return;

    m_iconName = iconName;
    emit iconNameChanged();
}

void QtAction::setToolTip(const QString &arg)
{
    if (m_toolTip != arg) {
        m_toolTip = arg;
        emit toolTipChanged(arg);
    }
}

void QtAction::setEnabled(bool e)
{
    if (e == m_enabled)
        return;
    m_enabled = e;
    emit enabledChanged();
}

void QtAction::setCheckable(bool c)
{
    if (c == m_checkable)
        return;
    m_checkable = c;
    emit checkableChanged();
}

void QtAction::setChecked(bool c)
{
    if (c == m_checked)
        return;
    m_checked = c;
    emit toggled(m_checked);
}

void QtAction::setExclusiveGroup(QtExclusiveGroup *eg)
{
    if (m_exclusiveGroup == eg)
        return;

    if (m_exclusiveGroup)
        m_exclusiveGroup->unregisterCheckable(this);
    m_exclusiveGroup = eg;
    if (m_exclusiveGroup)
        m_exclusiveGroup->registerCheckable(this);

    emit exclusiveGroupChanged();
}
