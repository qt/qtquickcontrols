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

#ifndef QQUICKWRITINGSYSTEMLISTMODEL_P_H
#define QQUICKWRITINGSYSTEMLISTMODEL_P_H

#include <QtCore/qstringlist.h>
#include <QtCore/QAbstractListModel>
#include <QtQml/qqmlparserstatus.h>
#include <QtQml/qjsvalue.h>

QT_BEGIN_NAMESPACE

class QModelIndex;

class QQuickWritingSystemListModelPrivate;

class QQuickWritingSystemListModel : public QAbstractListModel, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY(QStringList writingSystems READ writingSystems NOTIFY writingSystemsChanged)

    Q_PROPERTY(int count READ count NOTIFY rowCountChanged)

public:
    QQuickWritingSystemListModel(QObject *parent = 0);
    ~QQuickWritingSystemListModel();

    enum Roles {
        WritingSystemNameRole = Qt::UserRole + 1,
        WritingSystemSampleRole = Qt::UserRole + 2
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const { return rowCount(QModelIndex()); }

    QStringList writingSystems() const;

    Q_INVOKABLE QJSValue get(int index) const;

    void classBegin() override;
    void componentComplete() override;

Q_SIGNALS:
    void writingSystemsChanged();
    void rowCountChanged() const;

private:
    Q_DISABLE_COPY(QQuickWritingSystemListModel)
    Q_DECLARE_PRIVATE(QQuickWritingSystemListModel)
    QScopedPointer<QQuickWritingSystemListModelPrivate> d_ptr;

};

QT_END_NAMESPACE

#endif // QQUICKWRITINGSYSTEMLISTMODEL_P_H
