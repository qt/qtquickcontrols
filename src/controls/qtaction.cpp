/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qtaction_p.h"
#include "qtexclusivegroup_p.h"

#include <private/qguiapplication_p.h>
#include <qqmlfile.h>

QT_BEGIN_NAMESPACE

/*!
    \qmltype Action
    \instantiates QtAction
    \inqmlmodule QtQuick.Controls 1.0
    \brief Action provides an abstract user interface action that can be bound to items

    \sa MenuItem, ExclusiveGroup
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
    \qmlproperty string Action::tooltip
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
    setMnemonicFromText(QString());
}

void QtAction::setText(const QString &text)
{
    if (text == m_text)
        return;
    m_text = text;
    setMnemonicFromText(m_text);
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

void QtAction::setMnemonicFromText(const QString &text)
{
    QKeySequence sequence = QKeySequence::mnemonic(text);
    if (m_mnemonic == sequence)
        return;

    if (!m_mnemonic.isEmpty())
        QGuiApplicationPrivate::instance()->shortcutMap.removeShortcut(0, this, m_mnemonic);

    m_mnemonic = sequence;

    if (!m_mnemonic.isEmpty()) {
        Qt::ShortcutContext context = Qt::WindowShortcut;
        QGuiApplicationPrivate::instance()->shortcutMap.addShortcut(this, m_mnemonic, context, qShortcutContextMatcher);
    }
}

void QtAction::setIconSource(const QUrl &iconSource)
{
    if (iconSource == m_iconSource)
        return;

    m_iconSource = iconSource;
    if (m_iconName.isEmpty() || m_icon.isNull()) {
        QString fileString = QQmlFile::urlToLocalFileOrQrc(iconSource);
        m_icon = QIcon(fileString);

        emit iconChanged();
    }
    emit iconSourceChanged();
}

QString QtAction::iconName() const
{
    return m_iconName;
}

void QtAction::setIconName(const QString &iconName)
{
    if (iconName == m_iconName)
        return;
    m_iconName = iconName;
    m_icon = QIcon::fromTheme(m_iconName, QIcon(QQmlFile::urlToLocalFileOrQrc(m_iconSource)));
    emit iconNameChanged();
    emit iconChanged();
}

void QtAction::setTooltip(const QString &arg)
{
    if (m_tooltip != arg) {
        m_tooltip = arg;
        emit tooltipChanged(arg);
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
        m_exclusiveGroup->unbindCheckable(this);
    m_exclusiveGroup = eg;
    if (m_exclusiveGroup)
        m_exclusiveGroup->bindCheckable(this);

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
    if (!m_enabled)
        return;

    if (m_checkable && !(m_checked && m_exclusiveGroup))
        setChecked(!m_checked);

    emit triggered();
}

QT_END_NAMESPACE
