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

/*!
    \qmltype FileDialog
    \instantiates QFileDialogItem
    \inqmlmodule QtDesktop 1.0
    \brief Dialog component for choosing files from a local filesystem.

    FileDialog implements a basic file chooser: it allows the user to select
    existing files and/or directories, or create new filenames.
*/

/*!
    \qmlsignal FileDialog::accepted

    The \a accepted signal is emitted when the user has finished using the
    dialog. You can then inspect the \a filePath or \a filePaths properties to
    get the selection.

    Example:

    \qml
    FileDialog {
        onAccepted: { console.log("Selected file: " + filePath) }
    }
    \endqml
*/

/*!
    \qmlsignal FileDialog::rejected

    The \a rejected signal is emitted when the user has dismissed the dialog,
    either by closing the dialog window or by pressing the Cancel button.
*/

#include "qfiledialogitem.h"

#if QT_VERSION < 0x050000
#include <QGraphicsScene>
#endif

QFileDialogItem::QFileDialogItem():
    _dialog(new QFileDialog),
    _isOpen(false),
    _selectExisting(true),
    _selectMultiple(false),
    _selectFolder(false)
{
    QObject::connect(_dialog, SIGNAL(accepted()), this, SIGNAL(accepted()));
    QObject::connect(_dialog, SIGNAL(rejected()), this, SIGNAL(rejected()));
}

QFileDialogItem::~QFileDialogItem()
{
    delete _dialog;
}

/*!
    \qmlproperty string FileDialog::title

    The title of the dialog window.
*/
void QFileDialogItem::setTitle(QString title)
{
    _dialog->setWindowTitle(title);
    emit titleChanged();
}

/* Intentionally left undocumented, as we might decide to remove it later */
void QFileDialogItem::setModal(bool modal)
{
    bool visible = _dialog->isVisible();
    _dialog->hide();
    _dialog->setWindowModality(modal ? Qt::WindowModal : Qt::NonModal);

    if (visible)
        _dialog->show();
    emit modalityChanged();
}

/*!
    \qmlproperty bool FileDialog::selectExisting

    Whether only existing files or directories can be selected.

    By default, this property is true.
*/
void QFileDialogItem::setSelectExisting(bool selectExisting)
{
    if (selectExisting == _selectExisting) return;
    _selectExisting = selectExisting;

    updateFileMode();

    _dialog->setAcceptMode(selectExisting ?
                           QFileDialog::AcceptOpen : QFileDialog::AcceptSave);

    Q_EMIT selectExistingChanged();
}

/*!
    \qmlproperty bool FileDialog::selectMultiple

    Whether more than one filename can be selected.

    By default, this property is false.
*/
void QFileDialogItem::setSelectMultiple(bool selectMultiple)
{
    if (selectMultiple == _selectMultiple) return;
    _selectMultiple = selectMultiple;

    updateFileMode();

    Q_EMIT selectMultipleChanged();
}

/*!
    \qmlproperty bool FileDialog::selectFolder

    Whether the selected item should be a folder.

    By default, this property is false.
*/
void QFileDialogItem::setSelectFolder(bool selectFolder)
{
    if (selectFolder == _selectFolder) return;
    _selectFolder = selectFolder;

    updateFileMode();

    Q_EMIT selectFolderChanged();
}

void QFileDialogItem::updateFileMode()
{
    QFileDialog::FileMode mode = QFileDialog::AnyFile;

    if (_selectFolder) {
        mode = QFileDialog::Directory;
        _dialog->setOption(QFileDialog::ShowDirsOnly, true);
    } else if (_selectExisting) {
        mode = _selectMultiple ?
            QFileDialog::ExistingFiles : QFileDialog::ExistingFile;
        _dialog->setOption(QFileDialog::ShowDirsOnly, false);
    }
    _dialog->setFileMode(mode);
}

/*!
    \qmlproperty string FileDialog::folder

    The path to the currently selected folder. Setting this property before
    invoking open() will cause the file browser to be initially positioned on
    the specified folder.

    The value of this property is also updated after the dialog is closed.

    By default, this property is false.
*/
void QFileDialogItem::setFolder(const QString &folder)
{
    _dialog->setDirectory(folder);
    Q_EMIT folderChanged();
}

QString QFileDialogItem::folder() const
{
    return _dialog->directory().absolutePath();
}

/*!
    \qmlproperty list<string> FileDialog::nameFilters

    A list of strings to be used as file name filters. Each string can be a
    space-separated list of filters; filters may include the ? and * wildcards.
    The list of filters can also be enclosed in parentheses and a textual
    description of the filter can be provided.

    For example:

    \qml
    FileDialog {
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
    }
    \endqml

    \note Directories are not excluded by filters.
*/
void QFileDialogItem::setNameFilters(const QStringList &nameFilters)
{
    _dialog->setNameFilters(nameFilters);
    Q_EMIT nameFiltersChanged();
}

/*!
    \qmlproperty string FileDialog::filePath

    The path of the file which was selected by the user.

    \note This property is set only if exactly one file was selected. In all
    other cases, it will return an empty string.

    \sa filePaths
*/
QString QFileDialogItem::filePath() const
{
    QStringList files = filePaths();
    return (files.count() == 1) ? files[0] : QString();
}

/*!
    \qmlproperty list<string> FileDialog::filePaths

    The list of file paths which were selected by the user.
*/
QStringList QFileDialogItem::filePaths() const
{
    return _dialog->selectedFiles();
}

void QFileDialogItem::setVisible(bool visible)
{
    if (visible)
        open();
    else
        close();
}

/*!
    \qmlmethod void FileDialog::open()

    Shows the dialog to the user.
*/
void QFileDialogItem::open()
{
#if QT_VERSION < 0x050000
    /* We must set the QtDeclarative scene as parent widget for the
     * QDialog, so that it will be positioned on top of it.
     * This is also necessary for the modality to work.
     */
    if (_dialog->parentWidget() == 0) {
        QList<QGraphicsView *> views = scene()->views();
        if (!views.isEmpty()) {
            _dialog->setParent(views[0], Qt::Dialog);
        }
    }
#endif

    if (!isVisible()) {
        _dialog->show();
        emit visibleChanged();
    }
    _isOpen = true;
}

/*!
    \qmlmethod void FileDialog::close()

    Closes the dialog.
*/
void QFileDialogItem::close()
{
    _isOpen = false;
    _dialog->hide();
    emit visibleChanged();
}

#if QT_VERSION < 0x050000
QVariant QFileDialogItem::itemChange(GraphicsItemChange change,
                                     const QVariant &value)
{
    if (change == QGraphicsItem::QGraphicsItem::ItemVisibleHasChanged) {
        bool visible = value.toBool();

        if (visible && _isOpen) {
            _dialog->show();
        } else {
            _dialog->hide();
        }
        emit visibleChanged();
    }

    return QDeclarativeItem::itemChange(change, value);
}
#endif
