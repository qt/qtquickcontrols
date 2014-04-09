/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtQuick.Dialogs module of the Qt Toolkit.
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

#include "qquickdialog_p.h"
#include <QQuickItem>
#include <QQmlEngine>
#include <QStandardPaths>
#include <private/qguiapplication_p.h>

QT_BEGIN_NAMESPACE

/*!
    \qmltype Dialog
    \instantiates QQuickDialog
    \inqmlmodule QtQuick.Dialogs
    \ingroup qtquick-visual
    \brief A generic QtQuick dialog wrapper with standard buttons
    \since 5.3

    Dialog provides an item with a platform-tailored button box for a dialog.
    The \l implementation Item is the default property (the only allowed child
    element).
*/

/*!
    \qmlsignal QtQuick::Dialogs::Dialog::accepted

    This signal is emitted by \l accept().

    The corresponding handler is \c onAccepted.
*/

/*!
    \qmlsignal QtQuick::Dialogs::Dialog::rejected

    This signal is emitted by \l reject().

    The corresponding handler is \c onRejected.
*/

/*!
    \class QQuickDialog
    \inmodule QtQuick.Dialogs
    \internal

    The QQuickDialog class represents a container for arbitrary
    dialog contents.

    \since 5.3
*/

/*!
    Constructs a dialog wrapper with parent window \a parent.
*/
QQuickDialog::QQuickDialog(QObject *parent)
    : QQuickAbstractDialog(parent)
{
    connect(this, SIGNAL(buttonClicked()), this, SLOT(clicked()));
}


/*!
    Destroys the dialog wrapper.
*/
QQuickDialog::~QQuickDialog()
{
}

QJSValue QQuickDialog::__standardButtonsLeftModel()
{
    updateStandardButtons();
    return m_standardButtonsLeftModel;
}

QJSValue QQuickDialog::__standardButtonsRightModel()
{
    updateStandardButtons();
    return m_standardButtonsRightModel;
}

void QQuickDialog::updateStandardButtons()
{
    if (m_standardButtonsRightModel.isUndefined()) {
        QJSEngine *engine = qmlEngine(this);
        // Managed objects so no need to destroy any existing ones
        m_standardButtonsLeftModel = engine->newArray();
        m_standardButtonsRightModel = engine->newArray();
        int i = 0;

        QPlatformTheme *theme = QGuiApplicationPrivate::platformTheme();
        QPlatformDialogHelper::ButtonLayout layoutPolicy =
            static_cast<QPlatformDialogHelper::ButtonLayout>(theme->themeHint(QPlatformTheme::DialogButtonBoxLayout).toInt());
        const int *buttonLayout = QPlatformDialogHelper::buttonLayout(Qt::Horizontal, layoutPolicy);
        QJSValue *model = &m_standardButtonsLeftModel;
        for (int r = 0; buttonLayout[r] != QPlatformDialogHelper::EOL; ++r) {
            quint32 role = (buttonLayout[r] & ~QPlatformDialogHelper::Reverse);
            // Keep implementation in sync with that in QDialogButtonBoxPrivate::layoutButtons()
            // to the extent that QtQuick supports the same features
            switch (role) {
            case QPlatformDialogHelper::Stretch:
                model = &m_standardButtonsRightModel;
                i = 0;
                break;
            // TODO maybe: case QPlatformDialogHelper::AlternateRole:
            default: {
                    for (int e = QPlatformDialogHelper::LowestBit; e <= QPlatformDialogHelper::HighestBit; ++e) {
                        quint32 standardButton = 1 << e;
                        quint32 standardButtonRole = QPlatformDialogHelper::buttonRole(
                            static_cast<QPlatformDialogHelper::StandardButton>(standardButton));
                        if ((m_enabledButtons & standardButton) && standardButtonRole == role) {
                            QJSValue o = engine->newObject();
                            o.setProperty("text", theme->standardButtonText(standardButton));
                            o.setProperty("standardButton", standardButton);
                            o.setProperty("role", role);
                            model->setProperty(i++, o);
                        }
                   }
                } break;
            }
        }
    }
}

void QQuickDialog::setTitle(const QString &arg)
{
    if (m_title != arg) {
        m_title = arg;
        emit titleChanged();
    }
}

void QQuickDialog::setStandardButtons(StandardButtons buttons)
{
    m_enabledButtons = buttons;
    m_standardButtonsLeftModel = QJSValue();
    m_standardButtonsRightModel = QJSValue();
    emit standardButtonsChanged();
}

/*!
    \qmlproperty bool Dialog::visible

    This property holds whether the dialog is visible. By default this is false.
*/

/*!
    \qmlproperty QObject Dialog::implementation

    The QML object which implements the dialog contents. Should be an \l Item.
*/

void QQuickDialog::click(QPlatformDialogHelper::StandardButton button, QPlatformDialogHelper::ButtonRole role)
{
    setVisible(false);
    m_clickedButton = static_cast<StandardButton>(button);
    emit buttonClicked();
    switch (role) {
    case QPlatformDialogHelper::AcceptRole:
        emit accept();
        break;
    case QPlatformDialogHelper::RejectRole:
        emit reject();
        break;
    case QPlatformDialogHelper::DestructiveRole:
        emit discard();
        break;
    case QPlatformDialogHelper::HelpRole:
        emit help();
        break;
    case QPlatformDialogHelper::YesRole:
        emit yes();
        break;
    case QPlatformDialogHelper::NoRole:
        emit no();
        break;
    case QPlatformDialogHelper::ApplyRole:
        emit apply();
        break;
    case QPlatformDialogHelper::ResetRole:
        emit reset();
        break;
    default:
        qWarning("unhandled MessageDialog button %d with role %d", (int)button, (int)role);
    }
}

void QQuickDialog::click(QQuickAbstractDialog::StandardButton button)
{
    click(static_cast<QPlatformDialogHelper::StandardButton>(button),
        static_cast<QPlatformDialogHelper::ButtonRole>(
            QPlatformDialogHelper::buttonRole(static_cast<QPlatformDialogHelper::StandardButton>(button))));
}

void QQuickDialog::clicked() {
    switch (QPlatformDialogHelper::buttonRole(static_cast<QPlatformDialogHelper::StandardButton>(m_clickedButton))) {
    case QPlatformDialogHelper::AcceptRole:
        accept();
        break;
    case QPlatformDialogHelper::RejectRole:
        reject();
        break;
    case QPlatformDialogHelper::DestructiveRole:
        emit discard();
        break;
    case QPlatformDialogHelper::HelpRole:
        emit help();
        break;
    case QPlatformDialogHelper::YesRole:
        emit yes();
        break;
    case QPlatformDialogHelper::NoRole:
        emit no();
        break;
    case QPlatformDialogHelper::ApplyRole:
        emit apply();
        break;
    case QPlatformDialogHelper::ResetRole:
        emit reset();
        break;
    default:
        qWarning("StandardButton %d has no role", m_clickedButton);
    }
}

void QQuickDialog::accept() {
    // enter key is treated like OK
    if (m_clickedButton == NoButton)
        m_clickedButton = Ok;
    QQuickAbstractDialog::accept();
}

void QQuickDialog::reject() {
    // escape key is treated like cancel
    if (m_clickedButton == NoButton)
        m_clickedButton = Cancel;
    QQuickAbstractDialog::reject();
}

QT_END_NAMESPACE
