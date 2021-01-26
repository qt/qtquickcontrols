/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Dialogs module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

#include "qquickabstractmessagedialog_p.h"
#include <QtGui/qpa/qplatformdialoghelper.h>

QT_BEGIN_NAMESPACE

QQuickAbstractMessageDialog::QQuickAbstractMessageDialog(QObject *parent)
    : QQuickAbstractDialog(parent)
    , m_dlgHelper(0)
    , m_options(QMessageDialogOptions::create())
    , m_clickedButton(NoButton)
{
}

QQuickAbstractMessageDialog::~QQuickAbstractMessageDialog()
{
}

void QQuickAbstractMessageDialog::setVisible(bool v)
{
    if (helper() && v)
        m_dlgHelper->setOptions(m_options);
    if (v)
        m_clickedButton = NoButton;
    QQuickAbstractDialog::setVisible(v);
}

void QQuickAbstractMessageDialog::setTitle(const QString &arg)
{
    if (arg != m_options->windowTitle()) {
        m_options->setWindowTitle(arg);
        emit titleChanged();
    }
}

void QQuickAbstractMessageDialog::setText(const QString &arg)
{
    if (arg != m_options->text()) {
        m_options->setText(arg);
        emit textChanged();
    }
}

void QQuickAbstractMessageDialog::setInformativeText(const QString &arg)
{
    if (arg != m_options->informativeText()) {
        m_options->setInformativeText(arg);
        emit informativeTextChanged();
    }
}

void QQuickAbstractMessageDialog::setDetailedText(const QString &arg)
{
    if (arg != m_options->detailedText()) {
        m_options->setDetailedText(arg);
        emit detailedTextChanged();
    }
}

void QQuickAbstractMessageDialog::setIcon(QQuickAbstractMessageDialog::Icon icon)
{
    if (static_cast<int>(icon) != static_cast<int>(m_options->icon())) {
        m_options->setIcon(static_cast<QMessageDialogOptions::Icon>(icon));
        emit iconChanged();
    }
}

QUrl QQuickAbstractMessageDialog::standardIconSource()
{
    switch (m_options->icon()) {
    case QMessageDialogOptions::Information:
        return QUrl("images/information.png");
        break;
    case QMessageDialogOptions::Warning:
        return QUrl("images/warning.png");
        break;
    case QMessageDialogOptions::Critical:
        return QUrl("images/critical.png");
        break;
    case QMessageDialogOptions::Question:
        return QUrl("images/question.png");
        break;
    default:
        return QUrl();
        break;
    }
}

void QQuickAbstractMessageDialog::setStandardButtons(StandardButtons buttons)
{
    if (buttons != m_options->standardButtons()) {
        m_options->setStandardButtons(static_cast<QPlatformDialogHelper::StandardButtons>(static_cast<int>(buttons)));
        emit standardButtonsChanged();
    }
}

void QQuickAbstractMessageDialog::click(QPlatformDialogHelper::StandardButton button, QPlatformDialogHelper::ButtonRole role)
{
    setVisible(false);
    m_clickedButton = static_cast<StandardButton>(button);
    emit buttonClicked();
    switch (role) {
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
        qWarning("unhandled MessageDialog button %d with role %d", (int)button, (int)role);
    }
}

void QQuickAbstractMessageDialog::click(QQuickAbstractDialog::StandardButton button)
{
    click(static_cast<QPlatformDialogHelper::StandardButton>(button),
        static_cast<QPlatformDialogHelper::ButtonRole>(
            QPlatformDialogHelper::buttonRole(static_cast<QPlatformDialogHelper::StandardButton>(button))));
}

QT_END_NAMESPACE
