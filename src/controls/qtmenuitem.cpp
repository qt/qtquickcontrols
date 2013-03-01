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

#include "qtmenuitem_p.h"
#include "qtaction_p.h"
#include "qtmenu_p.h"

#include <QtGui/private/qguiapplication_p.h>
#include <QtGui/qpa/qplatformtheme.h>
#include <QtGui/qpa/qplatformmenu.h>
#include <QtQuick/QQuickItem>

QT_BEGIN_NAMESPACE

QtMenuBase::QtMenuBase(QObject *parent)
    : QObject(parent), m_visible(true),
      m_parentMenu(0), m_visualItem(0)
{
    m_platformItem = QGuiApplicationPrivate::platformTheme()->createPlatformMenuItem();
}

QtMenuBase::~QtMenuBase()
{
    delete m_platformItem;
}

void QtMenuBase::setVisible(bool v)
{
    if (v != m_visible) {
        m_visible = v;

        if (m_platformItem)
            m_platformItem->setVisible(m_visible);

        emit visibleChanged();
    }
}

QtMenu *QtMenuBase::parentMenu() const
{
    return m_parentMenu;
}

void QtMenuBase::setParentMenu(QtMenu *parentMenu)
{
    m_parentMenu = parentMenu;
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
    \ingroup menus
    \brief MenuSeparator provides a separator for your items inside a menu.

    \sa Menu, MenuItem
*/

/*!
    \qmlproperty bool MenuSeparator::visible

    Whether the menu separator should be visible.
*/

QtMenuSeparator::QtMenuSeparator(QObject *parent)
    : QtMenuBase(parent)
{
    if (platformItem())
        platformItem()->setIsSeparator(true);
}

QtMenuText::QtMenuText(QObject *parent)
    : QtMenuBase(parent), m_action(new QtAction(this))
{
    connect(m_action, SIGNAL(enabledChanged()), this, SLOT(updateEnabled()));
    connect(m_action, SIGNAL(textChanged()), this, SLOT(updateText()));
    connect(m_action, SIGNAL(iconNameChanged()), this, SLOT(updateIcon()));
    connect(m_action, SIGNAL(iconNameChanged()), this, SIGNAL(iconNameChanged()));
    connect(m_action, SIGNAL(iconSourceChanged()), this, SLOT(updateIcon()));
    connect(m_action, SIGNAL(iconSourceChanged()), this, SIGNAL(iconSourceChanged()));
}

QtMenuText::~QtMenuText()
{
    delete m_action;
}

bool QtMenuText::enabled() const
{
    return action()->isEnabled();
}

void QtMenuText::setEnabled(bool e)
{
    action()->setEnabled(e);
}

QString QtMenuText::text() const
{
    return m_action->text();
}

void QtMenuText::setText(const QString &t)
{
    m_action->setText(t);
}

QUrl QtMenuText::iconSource() const
{
    return m_action->iconSource();
}

void QtMenuText::setIconSource(const QUrl &iconSource)
{
    m_action->setIconSource(iconSource);
}

QString QtMenuText::iconName() const
{
    return m_action->iconName();
}

void QtMenuText::setIconName(const QString &iconName)
{
    m_action->setIconName(iconName);
}

QIcon QtMenuText::icon() const
{
    return m_action->icon();
}

void QtMenuText::updateText()
{
    if (platformItem()) {
        platformItem()->setText(text());
        syncWithPlatformMenu();
    }
    emit textChanged();
}

void QtMenuText::updateEnabled()
{
    if (platformItem()) {
        platformItem()->setEnabled(enabled());
        syncWithPlatformMenu();
    }
    emit enabledChanged();
}

void QtMenuText::updateIcon()
{
    if (platformItem()) {
        platformItem()->setIcon(icon());
        syncWithPlatformMenu();
    }
    emit __iconChanged();
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
    \qmlproperty bool MenuItem::visible

    Whether the menu item should be visible.
*/

/*!
    \qmlproperty string MenuItem::text

    Text for the menu item. Can be overridden after setting \l action.

    Mnemonics are supported by prefixing the shortcut letter with \&.
    For instance, \c "\&Open" will bind the \c Alt-O shortcut to the
    \c "Open" menu item. Note that not all platforms support mnemonics.
*/

/*!
    \qmlproperty bool MenuItem::enabled

    Whether the menu item is enabled, and responsive to user interaction.
*/

/*!
    \qmlproperty url MenuItem::iconSource

    Sets the icon file or resource url for the \l MenuItem icon.
    Can be overridden after setting \l action.

    \sa iconName, Action::iconSource
*/

/*!
    \qmlproperty string MenuItem::iconName

    Sets the icon name for the \l MenuItem icon. This will pick the icon
    with the given name from the current theme. Can be overridden after
    setting \l action.

    \sa iconSource, Action::iconName
*/

/*! \qmlsignal MenuItem::triggered()

    Emitted when either the menu item or its bound action have been activated.

    \sa trigger(), Action::triggered(), Action::toggled()
*/

/*! \qmlmethod MenuItem::trigger()

    Manually trigger a menu item. Will also trigger the item's bound action.

    \sa triggered(), Action::trigger()
*/

/*!
    \qmlproperty string MenuItem::shortcut

    Shorcut bound to the menu item.

    \sa Action::shortcut
*/

/*!
    \qmlproperty bool MenuItem::checkable

    Whether the menu item can be checked, or toggled.

    \sa checked
*/

/*!
    \qmlproperty bool MenuItem::checked

    If the menu item is checkable, this property reflects its checked state.

    \sa checkable, Action::toggled()
*/

/*! \qmlproperty ExclusiveGroup MenuItem::exclusiveGroup

    If a menu item is checkable, an \l ExclusiveGroup can be attached to it.
    All the menu items sharing the same exclusive group become mutually exclusive
    selectable, meaning that only the last checked menu item will actually be checked.

    \sa checked, checkable
*/

/*! \qmlsignal MenuItem::toggled(checked)

    Emitted whenever a menu item's \c checked property changes.
    This usually happens at the same time as \l triggered().

    \sa checked, triggered(), Action::triggered(), Action::toggled()
*/

/*!
    \qmlproperty Action MenuItem::action

    The action bound to this menu item. Setting this property to a valid
    \l Action will override all the menu item's properties except \l text,
    \l iconSource, and \l iconName.

    In addition, the menu item \c triggered() and \c toggled() signals will not be emitted.
    Instead, the action \c triggered() and \c toggled() signals will be.

    \sa Action
*/

QtMenuItem::QtMenuItem(QObject *parent)
    : QtMenuText(parent), m_boundAction(0)
{
    connect(action(), SIGNAL(triggered()), this, SIGNAL(triggered()));
    connect(action(), SIGNAL(toggled(bool)), this, SLOT(updateChecked()));
    if (platformItem())
        connect(platformItem(), SIGNAL(activated()), this, SLOT(trigger()));
}

QtMenuItem::~QtMenuItem()
{
    unbindFromAction(m_boundAction);
    if (platformItem())
        disconnect(platformItem(), SIGNAL(activated()), this, SLOT(trigger()));
}

void QtMenuItem::setParentMenu(QtMenu *parentMenu)
{
    QtMenuText::setParentMenu(parentMenu);
    connect(this, SIGNAL(triggered()), parentMenu, SLOT(updateSelectedIndex()));
}

void QtMenuItem::bindToAction(QtAction *action)
{
    m_boundAction = action;

    connect(m_boundAction, SIGNAL(destroyed(QObject*)), this, SLOT(unbindFromAction(QObject*)));

    connect(m_boundAction, SIGNAL(triggered()), this, SIGNAL(triggered()));
    connect(m_boundAction, SIGNAL(toggled(bool)), this, SLOT(updateChecked()));
    connect(m_boundAction, SIGNAL(exclusiveGroupChanged()), this, SIGNAL(exclusiveGroupChanged()));
    connect(m_boundAction, SIGNAL(enabledChanged()), this, SLOT(updateEnabled()));
    connect(m_boundAction, SIGNAL(textChanged()), this, SLOT(updateText()));
    connect(m_boundAction, SIGNAL(shortcutChanged(QString)), this, SLOT(updateShortcut()));
    connect(m_boundAction, SIGNAL(checkableChanged()), this, SIGNAL(checkableChanged()));
    connect(m_boundAction, SIGNAL(iconNameChanged()), this, SLOT(updateIcon()));
    connect(m_boundAction, SIGNAL(iconNameChanged()), this, SIGNAL(iconNameChanged()));
    connect(m_boundAction, SIGNAL(iconSourceChanged()), this, SLOT(updateIcon()));
    connect(m_boundAction, SIGNAL(iconSourceChanged()), this, SIGNAL(iconSourceChanged()));

    if (m_boundAction->parent() != this) {
        updateText();
        updateShortcut();
        updateEnabled();
        updateIcon();
        if (checkable())
            updateChecked();
    }
}

void QtMenuItem::unbindFromAction(QObject *o)
{
    if (!o)
        return;

    if (o == m_boundAction)
        m_boundAction = 0;

    QtAction *action = qobject_cast<QtAction *>(o);
    if (!action)
        return;

    disconnect(action, SIGNAL(destroyed(QObject*)), this, SLOT(unbindFromAction(QObject*)));

    disconnect(action, SIGNAL(triggered()), this, SIGNAL(triggered()));
    disconnect(action, SIGNAL(toggled(bool)), this, SLOT(updateChecked()));
    disconnect(action, SIGNAL(exclusiveGroupChanged()), this, SIGNAL(exclusiveGroupChanged()));
    disconnect(action, SIGNAL(enabledChanged()), this, SLOT(updateEnabled()));
    disconnect(action, SIGNAL(textChanged()), this, SLOT(updateText()));
    disconnect(action, SIGNAL(shortcutChanged(QString)), this, SLOT(updateShortcut()));
    disconnect(action, SIGNAL(checkableChanged()), this, SIGNAL(checkableChanged()));
    disconnect(action, SIGNAL(iconNameChanged()), this, SLOT(updateIcon()));
    disconnect(action, SIGNAL(iconNameChanged()), this, SIGNAL(iconNameChanged()));
    disconnect(action, SIGNAL(iconSourceChanged()), this, SLOT(updateIcon()));
    disconnect(action, SIGNAL(iconSourceChanged()), this, SIGNAL(iconSourceChanged()));
}

QtAction *QtMenuItem::action() const
{
    if (m_boundAction)
        return m_boundAction;
    return QtMenuText::action();
}

void QtMenuItem::setBoundAction(QtAction *a)
{
    if (a == m_boundAction)
        return;

    if (m_boundAction) {
        if (m_boundAction->parent() == this)
            delete m_boundAction;
        else
            unbindFromAction(m_boundAction);
    }

    bindToAction(a);
    emit actionChanged();
}

QString QtMenuItem::text() const
{
    QString ownText = QtMenuText::text();
    if (!ownText.isEmpty())
        return ownText;
    return m_boundAction ? m_boundAction->text() : QString();
}

QUrl QtMenuItem::iconSource() const
{
    QUrl ownIconSource = QtMenuText::iconSource();
    if (!ownIconSource.isEmpty())
        return ownIconSource;
    return m_boundAction ? m_boundAction->iconSource() : QUrl();
}

QString QtMenuItem::iconName() const
{
    QString ownIconName = QtMenuText::iconName();
    if (!ownIconName.isEmpty())
        return ownIconName;
    return m_boundAction ? m_boundAction->iconName() : QString();
}

QIcon QtMenuItem::icon() const
{
    QIcon ownIcon = QtMenuText::icon();
    if (!ownIcon.isNull())
        return ownIcon;
    return m_boundAction ? m_boundAction->icon() : QIcon();
}

QString QtMenuItem::shortcut() const
{
    return action()->shortcut();
}

void QtMenuItem::setShortcut(const QString &shortcut)
{
    if (!m_boundAction)
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
    return action()->isCheckable();
}

void QtMenuItem::setCheckable(bool checkable)
{
    if (!m_boundAction)
        action()->setCheckable(checkable);
}

bool QtMenuItem::checked() const
{
    return action()->isChecked();
}

void QtMenuItem::setChecked(bool checked)
{
    if (!m_boundAction)
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
    return action()->exclusiveGroup();
}

void QtMenuItem::setExclusiveGroup(QtExclusiveGroup *eg)
{
    if (!m_boundAction)
        action()->setExclusiveGroup(eg);
}

void QtMenuItem::setEnabled(bool enabled)
{
    if (!m_boundAction)
        action()->setEnabled(enabled);
}

void QtMenuItem::trigger()
{
    action()->trigger();
}

QT_END_NAMESPACE
