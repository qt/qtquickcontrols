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

#include "qtstack_p.h"

QT_BEGIN_NAMESPACE

/*!
    \qmltype Stack
    \instantiates QtStack
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup views
    \brief Provides attached properties for items pushed onto a PageStack.

    The Stack attached property provides information when an item becomes
    active or inactive through the \l{Stack::status}{Stack.status} property.
    Status will be \c Stack.Activating when an item is transitioning into
    being the current item on the screen, and \c Stack.Active once the
    transition stops. When it leaves the screen, it will be
    \c Stack.Deactivating, and then \c Stack.Inactive.

    \sa PageStack
*/

QtStack::QtStack(QObject *object)
    : QObject(object),
      m_index(-1),
      m_status(Inactive),
      m_pageStack(0),
      m_delegate(0)
{
}

QtStack *QtStack::qmlAttachedProperties(QObject *object)
{
    return new QtStack(object);
}

/*!
    \readonly
    \qmlproperty int Stack::index

    This property holds the index of the item inside \l{pageStack}{PageStack},
    so that \l{PageStack::get()}{pageStack.get(index)} will return the item itself.
    If \l{Stack::pageStack}{pageStack} is \c null, \a index will be \c -1.
*/
int QtStack::index() const
{
    return m_index;
}

void QtStack::setIndex(int index)
{
    if (m_index != index) {
        m_index = index;
        emit indexChanged();
    }
}

/*!
    \readonly
    \qmlproperty enumeration Stack::status

    This property holds the status of the item. It can have one of the following values:
    \list
    \li \c Stack.Inactive: the item is not visible
    \li \c Stack.Activating: the item is transitioning into becoming an active item on the stack
    \li \c Stack.Active: the item is on top of the stack
    \li \c Stack.Deactivating: the item is transitioning into becoming inactive
    \endlist
*/
QtStack::Status QtStack::status() const
{
    return m_status;
}

void QtStack::setStatus(Status status)
{
    if (m_status != status) {
        m_status = status;
        emit statusChanged();
    }
}

/*!
    \readonly
    \qmlproperty PageStack Stack::pageStack

    This property holds the PageStack the item is in. If the item is not inside
    a PageStack, \a pageStack will be \c null.
*/
QQuickItem *QtStack::pageStack() const
{
    return m_pageStack;
}

void QtStack::setPageStack(QQuickItem *pageStack)
{
    if (m_pageStack != pageStack) {
        m_pageStack = pageStack;
        emit pageStackChanged();
    }
}

/*!
    \qmlproperty delegate Stack::delegate

    This property can be set to override the default animations used
    during a page transition. To better understand how to use this
    property, refer to the \l{PageStack#Transitions}{transition documentation} in PageStack.
    \sa {PageStack::animations}{PageStack.animations}
*/
QObject *QtStack::delegate() const
{
    return m_delegate;
}

void QtStack::setdelegate(QObject* delegate)
{
    if (m_delegate != delegate) {
        m_delegate = delegate;
        emit delegateChanged();
    }
}

QT_END_NAMESPACE
