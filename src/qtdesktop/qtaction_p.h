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

#ifndef QTACTION_H
#define QTACTION_H

#include <QtCore/QObject>
#include <QtCore/QUrl>
#include <QtGui/QIcon>
#include <QtGui/qkeysequence.h>

QT_BEGIN_NAMESPACE

class QtExclusiveGroup;

class QtAction : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QUrl iconSource READ iconSource WRITE setIconSource NOTIFY iconSourceChanged)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)
    Q_PROPERTY(QString toolTip READ tooltip WRITE setToolTip NOTIFY toolTipChanged)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool checkable READ isCheckable WRITE setCheckable NOTIFY checkableChanged)
    Q_PROPERTY(bool checked READ isChecked WRITE setChecked DESIGNABLE isCheckable NOTIFY toggled)

    Q_PROPERTY(QtExclusiveGroup *exclusiveGroup READ exclusiveGroup WRITE setExclusiveGroup NOTIFY exclusiveGroupChanged)
#ifndef QT_NO_SHORTCUT
    Q_PROPERTY(QString shortcut READ shortcut WRITE setShortcut NOTIFY shortcutChanged)
    Q_PROPERTY(QString mnemonic READ mnemonic WRITE setMnemonic NOTIFY mnemonicChanged)
#endif

public:
    explicit QtAction(QObject *parent = 0);
    ~QtAction();

    QString text() const { return m_text; }
    void setText(const QString &text);

    QString shortcut() const;
    void setShortcut(const QString &shortcut);

    QString mnemonic() const;
    void setMnemonic(const QString &mnemonic);

    QString iconName() const { return m_iconName; }
    void setIconName(const QString &iconName);

    QUrl iconSource() const { return m_iconSource; }
    void setIconSource(const QUrl &iconSource);

    QString tooltip() const { return m_toolTip; }
    void setToolTip(const QString &toolTip);

    bool isEnabled() const { return m_enabled; }
    void setEnabled(bool e);

    bool isCheckable() const { return m_checkable; }
    void setCheckable(bool c);

    bool isChecked() const { return m_checked; }
    void setChecked(bool c);

    QtExclusiveGroup *exclusiveGroup() const { return m_exclusiveGroup; }
    void setExclusiveGroup(QtExclusiveGroup * arg);

    bool event(QEvent *e);

public Q_SLOTS:
    void trigger();
    void hover() { emit hovered(); }

Q_SIGNALS:
    void triggered();
    void hovered();
    void toggled(bool);

    void textChanged();
    void shortcutChanged(QString shortcut);
    void mnemonicChanged(QString mnemonic);

    void iconNameChanged();
    void iconSourceChanged();
    void toolTipChanged(QString arg);
    void enabledChanged();
    void checkableChanged();

    void exclusiveGroupChanged();

private:
    QString m_text;
    QUrl m_iconSource;
    QString m_iconName;
    bool m_enabled;
    bool m_checkable;
    bool m_checked;
    QtExclusiveGroup *m_exclusiveGroup;
    QKeySequence m_shortcut;
    QKeySequence m_mnemonic;
    QString m_toolTip;
};

QT_END_NAMESPACE

#endif // QTACTION_H
