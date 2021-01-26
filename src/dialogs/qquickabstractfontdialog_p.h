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

#ifndef QQUICKABSTRACTFONTDIALOG_P_H
#define QQUICKABSTRACTFONTDIALOG_P_H

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

#include <QQuickView>
#include <QtGui/qpa/qplatformdialoghelper.h>
#include <QtGui/qfont.h>
#include <qpa/qplatformtheme.h>
#include "qquickabstractdialog_p.h"

QT_BEGIN_NAMESPACE

class QQuickAbstractFontDialog : public QQuickAbstractDialog
{
    Q_OBJECT
    Q_PROPERTY(bool scalableFonts READ scalableFonts WRITE setScalableFonts NOTIFY scalableFontsChanged)
    Q_PROPERTY(bool nonScalableFonts READ nonScalableFonts WRITE setNonScalableFonts NOTIFY nonScalableFontsChanged)
    Q_PROPERTY(bool monospacedFonts READ monospacedFonts WRITE setMonospacedFonts NOTIFY monospacedFontsChanged)
    Q_PROPERTY(bool proportionalFonts READ proportionalFonts WRITE setProportionalFonts NOTIFY proportionalFontsChanged)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QFont currentFont READ currentFont WRITE setCurrentFont NOTIFY currentFontChanged)

public:
    QQuickAbstractFontDialog(QObject *parent = 0);
    virtual ~QQuickAbstractFontDialog();

    QString title() const override;
    bool scalableFonts() const;
    bool nonScalableFonts() const;
    bool monospacedFonts() const;
    bool proportionalFonts() const;
    QFont font() const { return m_font; }
    QFont currentFont() const { return m_currentFont; }

public Q_SLOTS:
    void setVisible(bool v) override;
    void setModality(Qt::WindowModality m) override;
    void setTitle(const QString &t) override;
    void setFont(const QFont &arg);
    void setCurrentFont(const QFont &arg);
    void setScalableFonts(bool arg);
    void setNonScalableFonts(bool arg);
    void setMonospacedFonts(bool arg);
    void setProportionalFonts(bool arg);

Q_SIGNALS:
    void scalableFontsChanged();
    void nonScalableFontsChanged();
    void monospacedFontsChanged();
    void proportionalFontsChanged();
    void fontChanged();
    void currentFontChanged();
    void selectionAccepted();

protected Q_SLOTS:
    void accept() override;

protected:
    QPlatformFontDialogHelper *m_dlgHelper;
    QSharedPointer<QFontDialogOptions> m_options;
    QFont m_font;
    QFont m_currentFont;

    Q_DISABLE_COPY(QQuickAbstractFontDialog)
};

QT_END_NAMESPACE

#endif // QQUICKABSTRACTFONTDIALOG_P_H
