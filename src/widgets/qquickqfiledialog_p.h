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

#ifndef QQUICKQFILEDIALOG_P_H
#define QQUICKQFILEDIALOG_P_H

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

#include <QtWidgets/qtwidgetsglobal.h>

#if QT_CONFIG(filedialog)

#include <QFileDialog>
#include "../dialogs/qquickabstractfiledialog_p.h"

QT_BEGIN_NAMESPACE

class QQuickQFileDialog : public QQuickAbstractFileDialog
{
    Q_OBJECT

public:
    QQuickQFileDialog(QObject *parent = 0);
    virtual ~QQuickQFileDialog();

    QList<QUrl> fileUrls() const override;

protected:
    QPlatformFileDialogHelper *helper() override;

    Q_DISABLE_COPY(QQuickQFileDialog)
};

class QFileDialogHelper : public QPlatformFileDialogHelper
{
    Q_OBJECT
public:
    QFileDialogHelper();

    bool defaultNameFilterDisables() const override { return true; }
    void setDirectory(const QUrl &dir) override { m_dialog.setDirectoryUrl(dir); }
    QUrl directory() const override { return m_dialog.directoryUrl(); }
    void selectFile(const QUrl &f) override { m_dialog.selectUrl(f); }
    QList<QUrl> selectedFiles() const override;
    void setFilter() override;
    void selectNameFilter(const QString &f) override { m_dialog.selectNameFilter(f); }
    QString selectedNameFilter() const override { return m_dialog.selectedNameFilter(); }
    void exec() override { m_dialog.exec(); }
    bool show(Qt::WindowFlags f, Qt::WindowModality m, QWindow *parent) override;
    void hide() override { m_dialog.hide(); }

private Q_SLOTS:
    void currentChanged(const QString& path);
    void directoryEntered(const QString& path);
    void fileSelected(const QString& path);
    void filesSelected(const QStringList& paths);

private:
    QFileDialog m_dialog;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickQFileDialog *)

#endif // QT_CONFIG(filedialog)

#endif // QQUICKQFILEDIALOG_P_H
