/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

#ifndef QQUICKACTION_H
#define QQUICKACTION_H

#include <QtCore/qobject.h>
#include <QtCore/qurl.h>
#include <QtCore/qvariant.h>
#include <QtGui/qicon.h>
#include <QtGui/qkeysequence.h>
#include <QtCore/qpointer.h>

QT_BEGIN_NAMESPACE

class QQuickExclusiveGroup1;

class QQuickAction1 : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged RESET resetText)
    Q_PROPERTY(QUrl iconSource READ iconSource WRITE setIconSource NOTIFY iconSourceChanged RESET resetIconSource)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged)
    Q_PROPERTY(QVariant __icon READ iconVariant NOTIFY iconChanged)
    Q_PROPERTY(QString tooltip READ tooltip WRITE setTooltip NOTIFY tooltipChanged RESET resetTooltip)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool checkable READ isCheckable WRITE setCheckable NOTIFY checkableChanged)
    Q_PROPERTY(bool checked READ isChecked WRITE setChecked NOTIFY toggled)

    Q_PROPERTY(QQuickExclusiveGroup1 *exclusiveGroup READ exclusiveGroup WRITE setExclusiveGroup NOTIFY exclusiveGroupChanged)
#ifndef QT_NO_SHORTCUT
    Q_PROPERTY(QVariant shortcut READ shortcut WRITE setShortcut NOTIFY shortcutChanged)
#endif

public:
    explicit QQuickAction1(QObject *parent = 0);
    ~QQuickAction1();

    QString text() const { return m_text; }
    void resetText() { setText(QString()); }
    void setText(const QString &text);

    QVariant shortcut() const;
    void setShortcut(const QVariant &shortcut);

    void setMnemonicFromText(const QString &mnemonic);

    QString iconName() const;
    void setIconName(const QString &iconName);

    QUrl iconSource() const { return m_iconSource; }
    void resetIconSource() { setIconSource(QString()); }
    void setIconSource(const QUrl &iconSource);

    QString tooltip() const { return m_tooltip; }
    void resetTooltip() { setTooltip(QString()); }
    void setTooltip(const QString &tooltip);

    bool isEnabled() const { return m_enabled; }
    void setEnabled(bool e);

    bool isCheckable() const { return m_checkable; }
    void setCheckable(bool c);

    bool isChecked() const { return m_checkable && m_checked; }
    void setChecked(bool c);

    QQuickExclusiveGroup1 *exclusiveGroup() const;
    void setExclusiveGroup(QQuickExclusiveGroup1 *arg);

    QIcon icon() const { return m_icon; }
    QVariant iconVariant() const { return QVariant(m_icon); }
    void setIcon(const QIcon &icon) { m_icon = icon; emit iconChanged(); }

    bool event(QEvent *e) override;

public Q_SLOTS:
    void trigger(QObject *source = 0);

Q_SIGNALS:
    void triggered(QObject *source = 0);
    void toggled(bool checked);

    void textChanged();
    void shortcutChanged(const QVariant &shortcut);

    void iconChanged();
    void iconNameChanged();
    void iconSourceChanged();
    void tooltipChanged(const QString &arg);
    void enabledChanged();
    void checkableChanged();

    void exclusiveGroupChanged();

private:
    QString m_text;
    QUrl m_iconSource;
    QString m_iconName;
    QIcon m_icon;
    bool m_enabled;
    bool m_checkable;
    bool m_checked;
    QPointer<QQuickExclusiveGroup1> m_exclusiveGroup;
    QKeySequence m_shortcut;
    QKeySequence m_mnemonic;
    QString m_tooltip;
};

QT_END_NAMESPACE

#endif // QQUICKACTION_H
