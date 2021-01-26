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

#ifndef QQUICKPLATFORMFILEDIALOG_P_H
#define QQUICKPLATFORMFILEDIALOG_P_H

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

#include "qquickfiledialog_p.h"

QT_BEGIN_NAMESPACE

class QQuickPlatformFileDialog1 : public QQuickFileDialog
{
    Q_OBJECT

public:
    QQuickPlatformFileDialog1(QObject *parent = 0);
    virtual ~QQuickPlatformFileDialog1();
    void setModality(Qt::WindowModality m) override;
    QList<QUrl> fileUrls() const override;

protected:
    QPlatformFileDialogHelper *helper() override;
    void accept() override;

    Q_DISABLE_COPY(QQuickPlatformFileDialog1)
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickPlatformFileDialog1 *)

#endif // QQUICKPLATFORMFILEDIALOG_P_H
