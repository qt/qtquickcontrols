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

#ifndef QQUICKDIALOG_P_H
#define QQUICKDIALOG_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#include "qquickabstractmessagedialog_p.h"
#include <QJSValue>

QT_BEGIN_NAMESPACE

class QQuickDialog1 : public QQuickAbstractDialog
{
    Q_OBJECT

    Q_ENUMS(StandardButton)
    Q_FLAGS(StandardButtons)

    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QQuickAbstractDialog::StandardButtons standardButtons READ standardButtons WRITE setStandardButtons NOTIFY standardButtonsChanged)
    Q_PROPERTY(QQuickAbstractDialog::StandardButton clickedButton READ clickedButton NOTIFY buttonClicked)
    Q_PROPERTY(QQuickItem* contentItem READ contentItem WRITE setContentItem DESIGNABLE false)
    Q_CLASSINFO("DefaultProperty", "contentItem")    // Dialog in QML can have only one child

public:
    explicit QQuickDialog1(QObject *parent = 0);
    ~QQuickDialog1();

    StandardButtons standardButtons() const { return m_enabledButtons; }
    StandardButton clickedButton() const { return m_clickedButton; }
    Q_INVOKABLE QJSValue __standardButtonsLeftModel();
    Q_INVOKABLE QJSValue __standardButtonsRightModel();

    QString title() const override { return m_title; }
    void setVisible(bool v) override;

public Q_SLOTS:
    void setTitle(const QString &arg) override;
    void setStandardButtons(StandardButtons buttons);
    void click(QQuickAbstractDialog::StandardButton button);

Q_SIGNALS:
    void titleChanged();
    void standardButtonsChanged();
    void buttonClicked();
    void discard();
    void help();
    void yes();
    void no();
    void apply();
    void reset();

protected:
    QPlatformDialogHelper *helper() override { return 0; }
    void click(QPlatformDialogHelper::StandardButton button, QPlatformDialogHelper::ButtonRole);

protected Q_SLOTS:
    void accept() override;
    void reject() override;

private:
    void updateStandardButtons();

private:
    QString m_title;
    StandardButtons m_enabledButtons;
    StandardButton m_clickedButton;
    QJSValue m_standardButtonsLeftModel;
    QJSValue m_standardButtonsRightModel;
    Q_DISABLE_COPY(QQuickDialog1)
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickDialog1 *)

#endif // QQUICKDIALOG_P_H
