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

#ifndef QQUICKQFONTDIALOG_P_H
#define QQUICKQFONTDIALOG_P_H

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

#include "../dialogs/qquickabstractfontdialog_p.h"

QT_BEGIN_NAMESPACE

class QQuickQFontDialog : public QQuickAbstractFontDialog
{
    Q_OBJECT

public:
    QQuickQFontDialog(QObject *parent = 0);
    virtual ~QQuickQFontDialog();

protected:
    QPlatformFontDialogHelper *helper() override;

    Q_DISABLE_COPY(QQuickQFontDialog)
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickQFontDialog *)

#endif // QQUICKQFONTDIALOG_P_H
