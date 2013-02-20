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

#include "qtmenuitem_p.h"
#include "qtaction_p.h"
#include "qtmenu_p.h"

#include <QtGui/private/qguiapplication_p.h>
#include <QtGui/qpa/qplatformtheme.h>
#include <QtGui/qpa/qplatformmenu.h>
#include <QtQuick/QQuickItem>

QT_BEGIN_NAMESPACE

QtMenuBase::QtMenuBase(QObject *parent)
    : QObject(parent), m_visualItem(0)
{
    m_platformItem = QGuiApplicationPrivate::platformTheme()->createPlatformMenuItem();
}

QtMenuBase::~QtMenuBase()
{
    delete m_platformItem;
}

void QtMenuBase::syncWithPlatformMenu()
{
    QtMenu *menu = qobject_cast<QtMenu *>(parent());
    if (menu && menu->platformMenu() && platformItem()
        && menu->m_menuItems.contains(this)) // If not, it'll be added later and then sync'ed
        menu->platformMenu()->syncMenuItem(platformItem());
}

QQuickItem *QtMenuBase::visualItem() const
{
    return m_visualItem;
}

void QtMenuBase::setVisualItem(QQuickItem *item)
{
    m_visualItem = item;
}


/*!
    \qmltype MenuSeparator
    \instantiates QtMenuSeparator
    \inqmlmodule QtQuick.Controls 1.0
    \inherits Item
    \ingroup menus
    \brief MenuSeparator provides a separator for your items inside a menu.

    \sa Menu, MenuItem
*/

QtMenuSeparator::QtMenuSeparator(QObject *parent)
    : QtMenuBase(parent)
{
    if (platformItem())
        platformItem()->setIsSeparator(true);
}


/*!
    \qmltype MenuItem
    \instantiates QtMenuItem
    \ingroup menus
    \inqmlmodule QtQuick.Controls 1.0
    \brief MenuItem provides an item to add in a menu or a menu bar.

    \code
    Menu {
        text: "Edit"

        MenuItem {
            text: "Cut"
            shortcut: "Ctrl+X"
            onTriggered: ...
        }

        MenuItem {
            text: "Copy"
            shortcut: "Ctrl+C"
            onTriggered: ...
        }

        MenuItem {
            text: "Paste"
            shortcut: "Ctrl+V"
            onTriggered: ...
        }
    }
    \endcode

    \sa MenuBar, Menu, MenuSeparator, Action
*/

/*!
    \qmlproperty string MenuItem::text

    Text for the menu item.
*/

/*!
    \qmlproperty string MenuItem::shortcut

    Shorcut bound to the menu item.

    \sa Action::shortcut
*/

/*!
    \qmlproperty bool MenuItem::checkable

    Whether the menu item can be toggled.

    \sa checked
*/

/*!
    \qmlproperty bool MenuItem::checked

    If the menu item is checkable, this property reflects its checked state.

    \sa chekcable, Action::toggled()
*/

/*!
    \qmlproperty url MenuItem::iconSource

    \sa iconName, Action::iconSource
*/

/*!
    \qmlproperty string MenuItem::iconName

    \sa iconSource, Action::iconName
*/

/*!
    \qmlproperty Action MenuItem::action

    The action bound to this menu item.

    \sa Action
*/

/*! \qmlsignal MenuItem::triggered()

    Emitted when either the menu item or its bound action have been activated.

    \sa trigger(), Action::triggered(), Action::toggled()
*/

/*! \qmlmethod MenuItem::trigger()

    Manually trigger a menu item. Will also trigger the item's bound action.

    \sa triggered(), Action::trigger()
*/

QtMenuItem::QtMenuItem(QObject *parent)
    : QtMenuBase(parent), m_action(0)
{ }

QtMenuItem::~QtMenuItem()
{
    unbindFromAction(m_action);
}

void QtMenuItem::bindToAction(QtAction *action)
{
    m_action = action;

    if (platformItem()) {
        connect(platformItem(), SIGNAL(activated()), m_action, SLOT(trigger()));
    }

    connect(m_action, SIGNAL(destroyed(QObject*)), this, SLOT(unbindFromAction(QObject*)));

    connect(m_action, SIGNAL(triggered()), this, SIGNAL(triggered()));
    connect(m_action, SIGNAL(toggled(bool)), this, SLOT(updateChecked()));
    connect(m_action, SIGNAL(exclusiveGroupChanged()), this, SIGNAL(exclusiveGroupChanged()));
    connect(m_action, SIGNAL(enabledChanged()), this, SLOT(updateEnabled()));
    connect(m_action, SIGNAL(textChanged()), this, SLOT(updateText()));
    connect(m_action, SIGNAL(shortcutChanged(QString)), this, SLOT(updateShortcut()));
    connect(m_action, SIGNAL(checkableChanged()), this, SIGNAL(checkableChanged()));
    connect(m_action, SIGNAL(iconNameChanged()), this, SLOT(updateIconName()));
    connect(m_action, SIGNAL(iconSourceChanged()), this, SLOT(updateIconSource()));

    if (m_action->parent() != this) {
        updateText();
        updateShortcut();
        updateEnabled();
        updateIconName();
        updateIconSource();
        if (checkable())
            updateChecked();
    }
}

void QtMenuItem::unbindFromAction(QObject *o)
{
    if (!o)
        return;

    if (o == m_action)
        m_action = 0;

    QtAction *action = qobject_cast<QtAction *>(o);
    if (!action)
        return;

    if (platformItem()) {
        disconnect(platformItem(), SIGNAL(activated()), action, SLOT(trigger()));
    }

    disconnect(action, SIGNAL(destroyed(QObject*)), this, SLOT(unbindFromAction(QObject*)));

    disconnect(action, SIGNAL(triggered()), this, SIGNAL(triggered()));
    disconnect(action, SIGNAL(toggled(bool)), this, SLOT(updateChecked()));
    disconnect(action, SIGNAL(exclusiveGroupChanged()), this, SIGNAL(exclusiveGroupChanged()));
    disconnect(action, SIGNAL(enabledChanged()), this, SLOT(updateEnabled()));
    disconnect(action, SIGNAL(textChanged()), this, SLOT(updateText()));
    disconnect(action, SIGNAL(shortcutChanged(QString)), this, SLOT(updateShortcut()));
    disconnect(action, SIGNAL(checkableChanged()), this, SIGNAL(checkableChanged()));
    disconnect(action, SIGNAL(iconNameChanged()), this, SLOT(updateIconName()));
    disconnect(action, SIGNAL(iconSourceChanged()), this, SLOT(updateIconSource()));
}

QtAction *QtMenuItem::action()
{
    if (!m_action)
        bindToAction(new QtAction(this));
    return m_action;
}

void QtMenuItem::setAction(QtAction *a)
{
    if (a == m_action)
        return;

    if (m_action) {
        if (m_action->parent() == this)
            delete m_action;
        else
            unbindFromAction(m_action);
    }

    bindToAction(a);
    emit actionChanged();
}

QtMenu *QtMenuItem::parentMenu() const
{
    return qobject_cast<QtMenu *>(parent());
}

QString QtMenuItem::text() const
{
    return m_action ? m_action->text() : QString();
}

void QtMenuItem::setText(const QString &text)
{
    action()->setText(text);
}

void QtMenuItem::updateText()
{
    if (platformItem()) {
        platformItem()->setText(text());
        syncWithPlatformMenu();
    }
    emit textChanged();
}

QString QtMenuItem::shortcut() const
{
    return m_action ? m_action->shortcut() : QString();
}

void QtMenuItem::setShortcut(const QString &shortcut)
{
    action()->setShortcut(shortcut);
}

void QtMenuItem::updateShortcut()
{
    if (platformItem()) {
        platformItem()->setShortcut(QKeySequence(shortcut()));
        syncWithPlatformMenu();
    }
    emit shortcutChanged();
}

bool QtMenuItem::checkable() const
{
    return m_action ? m_action->isCheckable() : false;
}

void QtMenuItem::setCheckable(bool checkable)
{
    action()->setCheckable(checkable);
}

bool QtMenuItem::checked() const
{
    return m_action ? m_action->isChecked() : false;
}

void QtMenuItem::setChecked(bool checked)
{
    action()->setChecked(checked);
}

void QtMenuItem::updateChecked()
{
    bool checked = this->checked();
    if (platformItem()) {
        platformItem()->setChecked(checked);
        syncWithPlatformMenu();
    }
    emit toggled(checked);
}

QtExclusiveGroup *QtMenuItem::exclusiveGroup() const
{
    return m_action ? m_action->exclusiveGroup() : 0;
}

void QtMenuItem::setExclusiveGroup(QtExclusiveGroup *eg)
{
    action()->setExclusiveGroup(eg);
}

bool QtMenuItem::enabled() const
{
    return m_action ? m_action->isEnabled() : false;
}

void QtMenuItem::setEnabled(bool enabled)
{
    action()->setEnabled(enabled);
}

void QtMenuItem::updateEnabled()
{
    if (platformItem()) {
        platformItem()->setEnabled(enabled());
        syncWithPlatformMenu();
    }
    emit enabledChanged();
}

QUrl QtMenuItem::iconSource() const
{
    return m_action ? m_action->iconSource() : QUrl();
}

void QtMenuItem::setIconSource(const QUrl &iconSource)
{
    action()->setIconSource(iconSource);
}

void QtMenuItem::updateIconSource()
{
    if (platformItem()) {
        platformItem()->setIcon(m_action->icon());
        syncWithPlatformMenu();
    }
    emit iconSourceChanged();
}

QString QtMenuItem::iconName() const
{
    return m_action ? m_action->iconName() : QString();
}

void QtMenuItem::setIconName(const QString &iconName)
{
    action()->setIconName(iconName);
}

void QtMenuItem::updateIconName()
{
    if (platformItem()) {
        platformItem()->setIcon(m_action->icon());
        syncWithPlatformMenu();
    }
    emit iconNameChanged();
}

void QtMenuItem::trigger()
{
    if (m_action)
        m_action->trigger();
}

QT_END_NAMESPACE
