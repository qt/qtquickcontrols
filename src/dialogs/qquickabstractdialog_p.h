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

#ifndef QQUICKABSTRACTDIALOG_P_H
#define QQUICKABSTRACTDIALOG_P_H

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

#include <QtQml/qqml.h>
#include <QQuickView>
#include <QtGui/qpa/qplatformdialoghelper.h>
#include <qpa/qplatformtheme.h>

QT_BEGIN_NAMESPACE

class QQuickAbstractDialog : public QObject
{
    Q_OBJECT
    // TODO move the enum to QQuickDialog1 at the same time that QQuickMessageDialog inherits from it
    Q_ENUMS(StandardButton)
    Q_FLAGS(StandardButtons)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibilityChanged)
    Q_PROPERTY(Qt::WindowModality modality READ modality WRITE setModality NOTIFY modalityChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(bool isWindow READ isWindow CONSTANT)
    Q_PROPERTY(int x READ x WRITE setX NOTIFY geometryChanged)
    Q_PROPERTY(int y READ y WRITE setY NOTIFY geometryChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY geometryChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY geometryChanged)
    Q_PROPERTY(int __maximumDimension READ __maximumDimension NOTIFY __maximumDimensionChanged)

public:
    QQuickAbstractDialog(QObject *parent = 0);
    virtual ~QQuickAbstractDialog();

    bool isVisible() const { return m_visible; }
    Qt::WindowModality modality() const { return m_modality; }
    virtual QString title() const = 0;
    QQuickItem* contentItem() { return m_contentItem; }

    int x() const;
    int y() const;
    int width() const;
    int height() const;
    int __maximumDimension() const;

    virtual void setVisible(bool v);
    virtual void setModality(Qt::WindowModality m);
    virtual void setTitle(const QString &t) = 0;
    void setContentItem(QQuickItem* obj);
    bool isWindow() const { return m_hasNativeWindows; }

    enum StandardButton {
        NoButton           = QPlatformDialogHelper::NoButton,
        Ok                 = QPlatformDialogHelper::Ok,
        Save               = QPlatformDialogHelper::Save,
        SaveAll            = QPlatformDialogHelper::SaveAll,
        Open               = QPlatformDialogHelper::Open,
        Yes                = QPlatformDialogHelper::Yes,
        YesToAll           = QPlatformDialogHelper::YesToAll,
        No                 = QPlatformDialogHelper::No,
        NoToAll            = QPlatformDialogHelper::NoToAll,
        Abort              = QPlatformDialogHelper::Abort,
        Retry              = QPlatformDialogHelper::Retry,
        Ignore             = QPlatformDialogHelper::Ignore,
        Close              = QPlatformDialogHelper::Close,
        Cancel             = QPlatformDialogHelper::Cancel,
        Discard            = QPlatformDialogHelper::Discard,
        Help               = QPlatformDialogHelper::Help,
        Apply              = QPlatformDialogHelper::Apply,
        Reset              = QPlatformDialogHelper::Reset,
        RestoreDefaults    = QPlatformDialogHelper::RestoreDefaults,
        NButtons
    };
    Q_DECLARE_FLAGS(StandardButtons, StandardButton)

public Q_SLOTS:
    void open() { setVisible(true); }
    void close() { setVisible(false); }
    void setX(int arg);
    void setY(int arg);
    void setWidth(int arg);
    void setHeight(int arg);

Q_SIGNALS:
    void visibilityChanged();
    void geometryChanged();
    void modalityChanged();
    void titleChanged();
    void accepted();
    void rejected();
    void __maximumDimensionChanged();

protected Q_SLOTS:
    void decorationLoaded();
    virtual void accept();
    virtual void reject();
    void visibleChanged(bool v);
    void windowGeometryChanged();
    void minimumWidthChanged();
    void minimumHeightChanged();
    void implicitHeightChanged();

protected:
    virtual QPlatformDialogHelper *helper() = 0;
    QQuickWindow *parentWindow();

protected:
    QQuickWindow *m_parentWindow;
    bool m_visible;
    Qt::WindowModality m_modality;

protected: // variables and methods for pure-QML implementations only
    void setDecorationDismissBehavior();

    QQuickItem *m_contentItem;
    QWindow *m_dialogWindow;
    QQuickItem *m_windowDecoration;
    bool m_hasNativeWindows;
    QRect m_sizeAspiration;
    bool m_hasAspiredPosition;
    bool m_visibleChangedConnected;
    bool m_dialogHelperInUse;

    QQmlComponent *m_decorationComponent = nullptr;
    static QUrl m_decorationComponentUrl;

    friend class QtQuick2DialogsPlugin;

    Q_DISABLE_COPY(QQuickAbstractDialog)
};

Q_DECLARE_OPERATORS_FOR_FLAGS(QQuickAbstractDialog::StandardButtons)

QT_END_NAMESPACE

#endif // QQUICKABSTRACTDIALOG_P_H
