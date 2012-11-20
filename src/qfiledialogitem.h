/****************************************************************************
**
** Copyright (C) 2012 Alberto Mardegan <info@mardy.it>
** Contact: http://www.qt-project.org/
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

#ifndef QFILEDIALOGITEM_H
#define QFILEDIALOGITEM_H

#include <QApplication>
#if QT_VERSION < 0x050000
#include <QDeclarativeItem>
#include <QDeclarativeView>
#else
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickView>
#endif
#include <QFileDialog>

#if QT_VERSION < 0x050000
class QFileDialogItem : public QDeclarativeItem
#else
class QFileDialogItem : public QQuickItem
#endif
{
    Q_OBJECT
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged)
    Q_PROPERTY(bool modal READ modal WRITE setModal NOTIFY modalityChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(bool selectExisting READ selectExisting \
               WRITE setSelectExisting NOTIFY selectExistingChanged)
    Q_PROPERTY(bool selectMultiple READ selectMultiple \
               WRITE setSelectMultiple NOTIFY selectMultipleChanged)
    Q_PROPERTY(bool selectFolder READ selectFolder \
               WRITE setSelectFolder NOTIFY selectFolderChanged)
    Q_PROPERTY(QString folder READ folder WRITE setFolder NOTIFY folderChanged)
    Q_PROPERTY(QStringList nameFilters READ nameFilters \
               WRITE setNameFilters NOTIFY nameFiltersChanged)
    Q_PROPERTY(QString filePath READ filePath NOTIFY accepted)
    Q_PROPERTY(QStringList filePaths READ filePaths NOTIFY accepted)

public:
    QFileDialogItem();
    ~QFileDialogItem();

    bool isVisible() const { return _dialog->isVisible(); }
    QString title() const { return _dialog->windowTitle(); }
    bool modal() const { return _dialog->isModal(); }
    bool selectExisting() const { return _selectExisting; }
    bool selectMultiple() const { return _selectMultiple; }
    bool selectFolder() const { return _selectFolder; }
    QString folder() const;
    QStringList nameFilters() const { return _dialog->nameFilters(); }
    QString filePath() const;
    QStringList filePaths() const;

    void setVisible(bool visible);
    void setTitle(QString title);
    void setModal(bool modal);
    void setSelectExisting(bool selectExisting);
    void setSelectMultiple(bool selectMultiple);
    void setSelectFolder(bool selectFolder);
    void setFolder(const QString &folder);
    void setNameFilters(const QStringList &nameFilters);

public Q_SLOTS:
    void open();
    void close();

Q_SIGNALS:
    void titleChanged();
    void modalityChanged();
    void accepted();
    void rejected();
    void selectExistingChanged();
    void selectMultipleChanged();
    void selectFolderChanged();
    void folderChanged();
    void nameFiltersChanged();
    void visibleChanged();

protected:
#if QT_VERSION < 0x050000
    QVariant itemChange(GraphicsItemChange change, const QVariant &value);
#endif

private:
    void updateFileMode();

private:
    QFileDialog *_dialog;
    bool _isOpen;
    bool _selectExisting;
    bool _selectMultiple;
    bool _selectFolder;
};

#endif // QFILEDIALOGITEM_H
