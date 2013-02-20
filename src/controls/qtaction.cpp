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

#include <QtGui/private/qguiapplication_p.h>

QT_BEGIN_NAMESPACE

/*!
    \qmltype Action
    \instantiates QtAction
    \inqmlmodule QtQuick.Controls 1.0
    \brief Action provides an abstract user interface action that can be bound to items

    \sa MenuItem, Menu, ExclusiveGroup
*/

/*!
    \qmlproperty string Action::text
*/

/*!
    \qmlproperty url Action::iconSource
*/

/*!
    \qmlproperty string Action::iconName
*/

/*!
    \qmlproperty string Action::toolTip
*/

/*!
    \qmlproperty bool Action::enabled
*/

/*!
    \qmlproperty bool Action::checkable
*/

/*!
    \qmlproperty bool Action::checked

*/

/*!
    \qmlproperty ExclusiveGroup Action::exclusiveGroup

    \sa ExclusiveGroup
*/

/*!
    \qmlproperty string Action::shortcut
*/

/*!
    \qmlproperty string Action::mnemonic
*/

QtAction::QtAction(QObject *parent)
    : QObject(parent)
    , m_enabled(true)
    , m_checkable(false)
    , m_checked(false)
    , m_exclusiveGroup(0)
{
}

QtAction::~QtAction()
{
    setShortcut(QString());
    setMnemonic(QString());
}

void QtAction::setText(const QString &text)
{
    if (text == m_text)
        return;
    m_text = text;
    emit textChanged();
}

bool qShortcutContextMatcher(QObject *, Qt::ShortcutContext)
{
    // the context matching is only interesting for non window-wide shortcuts
    // it might be interesting to check for the action's window being active
    // we currently only support the window wide focus so we can safely ignore this
    return true;
}

QString QtAction::shortcut() const
{
    return m_shortcut.toString(QKeySequence::NativeText);
}

void QtAction::setShortcut(const QString &arg)
{
    QKeySequence sequence = QKeySequence::fromString(arg);
    if (sequence == m_shortcut)
        return;

    if (!m_shortcut.isEmpty())
        QGuiApplicationPrivate::instance()->shortcutMap.removeShortcut(0, this, m_shortcut);

    m_shortcut = sequence;

    if (!m_shortcut.isEmpty()) {
        Qt::ShortcutContext context = Qt::WindowShortcut;
        QGuiApplicationPrivate::instance()->shortcutMap.addShortcut(this, m_shortcut, context, qShortcutContextMatcher);
    }
    emit shortcutChanged(shortcut());
}

QString QtAction::mnemonic() const
{
    return m_mnemonic.toString(QKeySequence::NativeText);
}

void QtAction::setMnemonic(const QString &mnem)
{
    QKeySequence sequence = QKeySequence::mnemonic(mnem);
    if (m_mnemonic == sequence)
        return;

    if (!m_mnemonic.isEmpty())
        QGuiApplicationPrivate::instance()->shortcutMap.removeShortcut(0, this, m_mnemonic);

    m_mnemonic = sequence;

    if (!m_mnemonic.isEmpty()) {
        Qt::ShortcutContext context = Qt::WindowShortcut;
        QGuiApplicationPrivate::instance()->shortcutMap.addShortcut(this, m_mnemonic, context, qShortcutContextMatcher);
    }
    emit mnemonicChanged(mnemonic());
}

void QtAction::setIconSource(const QUrl &iconSource)
{
    if (iconSource == m_iconSource)
        return;

    m_iconSource = iconSource;
    QString iconName = m_icon.name();
    m_icon = QIcon(m_iconSource.toLocalFile());
    if (!iconName.isEmpty())
        m_icon = QIcon::fromTheme(iconName, m_icon);

    emit iconSourceChanged();
    emit iconChanged();
}

QString QtAction::iconName() const
{
    return m_icon.name();
}

void QtAction::setIconName(const QString &iconName)
{
    if (iconName == m_icon.name())
        return;

    m_icon = QIcon::fromTheme(iconName, QIcon(m_iconSource.toLocalFile()));
    emit iconNameChanged();
    emit iconChanged();
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

bool QtAction::event(QEvent *e)
{
    if (!m_enabled)
        return false;

    if (e->type() != QEvent::Shortcut)
        return false;

    QShortcutEvent *se = static_cast<QShortcutEvent *>(e);

    Q_ASSERT_X(se->key() == m_shortcut || se->key() == m_mnemonic,
               "QtAction::event",
               "Received shortcut event from incorrect shortcut");
    if (se->isAmbiguous()) {
        qWarning("QtAction::event: Ambiguous shortcut overload: %s", se->key().toString(QKeySequence::NativeText).toLatin1().constData());
        return false;
    }

    trigger();

    return true;
}

void QtAction::trigger()
{
    if (m_checkable)
        setChecked(!m_checked);

    emit triggered();
}

QT_END_NAMESPACE
