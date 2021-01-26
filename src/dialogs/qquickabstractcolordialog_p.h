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

#ifndef QQUICKABSTRACTCOLORDIALOG_P_H
#define QQUICKABSTRACTCOLORDIALOG_P_H

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
#include <qpa/qplatformtheme.h>
#include "qquickabstractdialog_p.h"

QT_BEGIN_NAMESPACE

class QQuickAbstractColorDialog : public QQuickAbstractDialog
{
    Q_OBJECT
    Q_PROPERTY(bool showAlphaChannel READ showAlphaChannel WRITE setShowAlphaChannel NOTIFY showAlphaChannelChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QColor currentColor READ currentColor WRITE setCurrentColor NOTIFY currentColorChanged)
    Q_PROPERTY(qreal currentHue READ currentHue NOTIFY currentColorChanged)
    Q_PROPERTY(qreal currentSaturation READ currentSaturation NOTIFY currentColorChanged)
    Q_PROPERTY(qreal currentLightness READ currentLightness NOTIFY currentColorChanged)
    Q_PROPERTY(qreal currentAlpha READ currentAlpha NOTIFY currentColorChanged)

public:
    QQuickAbstractColorDialog(QObject *parent = 0);
    virtual ~QQuickAbstractColorDialog();

    QString title() const override;
    bool showAlphaChannel() const;
    QColor color() const { return m_color; }
    QColor currentColor() const { return m_currentColor; }
    qreal currentHue() const { return m_currentColor.hslHueF(); }
    qreal currentSaturation() const { return m_currentColor.hslSaturationF(); }
    qreal currentLightness() const { return m_currentColor.lightnessF(); }
    qreal currentAlpha() const { return m_currentColor.alphaF(); }

public Q_SLOTS:
    void setVisible(bool v) override;
    void setModality(Qt::WindowModality m) override;
    void setTitle(const QString &t) override;
    void setColor(QColor arg);
    void setCurrentColor(QColor currentColor);
    void setShowAlphaChannel(bool arg);

Q_SIGNALS:
    void showAlphaChannelChanged();
    void colorChanged();
    void currentColorChanged();
    void selectionAccepted();

protected Q_SLOTS:
    void accept() override;

protected:
    QPlatformColorDialogHelper *m_dlgHelper;
    QSharedPointer<QColorDialogOptions> m_options;
    QColor m_color;
    QColor m_currentColor;

    Q_DISABLE_COPY(QQuickAbstractColorDialog)
};

QT_END_NAMESPACE

#endif // QQUICKABSTRACTCOLORDIALOG_P_H
