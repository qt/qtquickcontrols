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

#include "qtexclusivegroup_p.h"

#include <QtCore/QVariant>
#include <QtCore/qdebug.h>

#define CHECKED_PROPERTY "checked"

QT_BEGIN_NAMESPACE

static const char *checkableSignals[] = {
    CHECKED_PROPERTY"Changed()",
    "toggled(bool)",
    "toggled()",
    0
};

static bool isChecked(const QObject *o)
{
    if (!o) return false;
    QVariant checkedVariant = o->property(CHECKED_PROPERTY);
    return checkedVariant.isValid() && checkedVariant.toBool();
}

/*!
    \qmltype ExclusiveGroup
    \instantiates QtExclusiveGroup
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup containers
    \brief ExclusiveGroup provides a way to declare several checkable controls as mutually exclusive.

    \code
    ExclusiveGroup { id: radioInputGroup }

    Action {
        id: dabRadioInput
        text: "DAB"
        exclusiveGroup: radioInputGroup
    }

    Action {
        id: fmRadioInput
        text: "FM"
        exclusiveGroup: radioInputGroup
    }

    Action {
        id: amRadioInput
        text: "AM"
        exclusiveGroup: radioInputGroup
    }

    \endcode

    Several controls already support \c ExclusiveGroup, e.g. \l MenuItem, \l Button, and \l RadioButton.

    It is possible to add support for \c ExclusiveGroup for an object, or control. It should have a \c checked
    property, and either a \c checkedChanged, \c toggled(), or \c toggled(bool) signal. It also needs
    to be bound with \c ExclusiveGroup::bindCheckable(object) when its \c ExclusiveGroup property is set.
*/

/*!
    \qmlproperty QtObject ExclusiveGroup::current

    The currently selected object.
*/

/*!
    \qmlmethod void ExclusiveGroup::bindCheckable(object)

    Register \c object to the exclusive group.

    You should only need to call this function when creating a component you want to be compatible with \c ExclusiveGroup.

    \sa ExclusiveGroup::unbindCheckable(object)
*/

/*!
    \qmlmethod void ExclusiveGroup::unbindCheckable(object)

    Unregister \c object from the exclusive group.

    You should only need to call this function when creating a component you want to be compatible with \c ExclusiveGroup.

    \sa ExclusiveGroup::bindCheckable(object)
*/

QtExclusiveGroup::QtExclusiveGroup(QObject *parent)
    : QObject(parent)
{
    int index = metaObject()->indexOfMethod("updateCurrent()");
    m_updateCurrentMethod = metaObject()->method(index);
}

void QtExclusiveGroup::setCurrent(QObject * o)
{
    if (m_current == o)
        return;

    if (m_current)
        m_current->setProperty(CHECKED_PROPERTY, QVariant(false));
    m_current = o;
    if (m_current)
        m_current->setProperty(CHECKED_PROPERTY, QVariant(true));
    emit currentChanged();
}

void QtExclusiveGroup::updateCurrent()
{
    QObject *checkable = sender();
    if (isChecked(checkable))
        setCurrent(checkable);
}

void QtExclusiveGroup::bindCheckable(QObject *o)
{
    for (const char **signalName = checkableSignals; *signalName; signalName++) {
        int signalIndex = o->metaObject()->indexOfSignal(*signalName);
        if (signalIndex != -1) {
            QMetaMethod signalMethod = o->metaObject()->method(signalIndex);
            connect(o, signalMethod, this, m_updateCurrentMethod, Qt::UniqueConnection);
            connect(o, SIGNAL(destroyed(QObject*)), this, SLOT(unbindCheckable(QObject*)), Qt::UniqueConnection);
            if (!m_current && isChecked(o))
                setCurrent(o);
            return;
        }
    }

    qWarning() << "QtExclusiveGroup::bindCheckable(): Cannot register" << o;
}

void QtExclusiveGroup::unbindCheckable(QObject *o)
{
    for (const char **signalName = checkableSignals; *signalName; signalName++) {
        int signalIndex = o->metaObject()->indexOfSignal(*signalName);
        if (signalIndex != -1) {
            QMetaMethod signalMethod = o->metaObject()->method(signalIndex);
            if (disconnect(o, signalMethod, this, m_updateCurrentMethod)) {
                disconnect(o, SIGNAL(destroyed(QObject*)), this, SLOT(unbindCheckable(QObject*)));
                break;
            }
        }
    }
}

QT_END_NAMESPACE
