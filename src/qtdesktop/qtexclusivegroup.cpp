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
    \inqmlmodule QtDesktop 1.0
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

    For an object, or control, to be compatible with \c ExclusiveGroup, it should have a \c checked
    property, and either a \c checkedChanged, \c toggled(), or \c toggled(bool) signal. It also needs
    to be registered with \c ExclusiveGroup::registerCheckable(object) when its \c ExclusiveGroup property is set.

    \sa Action, ButtonBehavior
*/

/*!
    \qmlproperty QtObject ExclusiveGroup::current

    The currently selected object.
*/

/*!
    \qmlmethod void ExclusiveGroup::registerCheckable(object)

    Register \c object to the exclusive group.

    You should only need to call this function when creating a component you want to be compatible with \c ExclusiveGroup.

    \sa ExclusiveGroup::unregisterCheckable(object)
*/

/*!
    \qmlmethod void ExclusiveGroup::unregisterCheckable(object)

    Unregister \c object from the exclusive group.

    You should only need to call this function when creating a component you want to be compatible with \c ExclusiveGroup.

    \sa ExclusiveGroup::registerCheckable(object)
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

void QtExclusiveGroup::registerCheckable(QObject *o)
{
    for (const char **signalName = checkableSignals; *signalName; signalName++) {
        int signalIndex = o->metaObject()->indexOfSignal(*signalName);
        if (signalIndex != -1) {
            QMetaMethod signalMethod = o->metaObject()->method(signalIndex);
            connect(o, signalMethod, this, m_updateCurrentMethod, Qt::UniqueConnection);
            connect(o, SIGNAL(destroyed(QObject*)), this, SLOT(unregisterCheckable(QObject*)), Qt::UniqueConnection);
            if (!m_current && isChecked(o))
                setCurrent(o);
            return;
        }
    }

    qWarning() << "QtExclusiveGroup::registerCheckable(): Cannot register" << o;
}

void QtExclusiveGroup::unregisterCheckable(QObject *o)
{
    for (const char **signalName = checkableSignals; *signalName; signalName++) {
        int signalIndex = o->metaObject()->indexOfSignal(*signalName);
        if (signalIndex != -1) {
            QMetaMethod signalMethod = o->metaObject()->method(signalIndex);
            if (disconnect(o, signalMethod, this, m_updateCurrentMethod)) {
                disconnect(o, SIGNAL(destroyed(QObject*)), this, SLOT(unregisterCheckable(QObject*)));
                break;
            }
        }
    }
}

QT_END_NAMESPACE
