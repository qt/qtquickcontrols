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

#ifndef QQUICKFONTLISTMODEL_P_H
#define QQUICKFONTLISTMODEL_P_H

#include <QtCore/qstringlist.h>
#include <QtCore/QAbstractListModel>
#include <QtGui/qpa/qplatformdialoghelper.h>
#include <QtQml/qqmlparserstatus.h>
#include <QtQml/qjsvalue.h>

QT_BEGIN_NAMESPACE

class QModelIndex;

class QQuickFontListModelPrivate;

class QQuickFontListModel : public QAbstractListModel, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY(QString writingSystem READ writingSystem WRITE setWritingSystem NOTIFY writingSystemChanged)

    Q_PROPERTY(bool scalableFonts READ scalableFonts WRITE setScalableFonts NOTIFY scalableFontsChanged)
    Q_PROPERTY(bool nonScalableFonts READ nonScalableFonts WRITE setNonScalableFonts NOTIFY nonScalableFontsChanged)
    Q_PROPERTY(bool monospacedFonts READ monospacedFonts WRITE setMonospacedFonts NOTIFY monospacedFontsChanged)
    Q_PROPERTY(bool proportionalFonts READ proportionalFonts WRITE setProportionalFonts NOTIFY proportionalFontsChanged)

    Q_PROPERTY(int count READ count NOTIFY rowCountChanged)

public:
    QQuickFontListModel(QObject *parent = 0);
    ~QQuickFontListModel();

    enum Roles {
        FontFamilyRole = Qt::UserRole + 1
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const { return rowCount(QModelIndex()); }

    QString writingSystem() const;
    void setWritingSystem(const QString& writingSystem);

    bool scalableFonts() const;
    bool nonScalableFonts() const;
    bool monospacedFonts() const;
    bool proportionalFonts() const;

    Q_INVOKABLE QJSValue get(int index) const;
    Q_INVOKABLE QJSValue pointSizes();

    void classBegin() override;
    void componentComplete() override;

public Q_SLOTS:
    void setScalableFonts(bool arg);
    void setNonScalableFonts(bool arg);
    void setMonospacedFonts(bool arg);
    void setProportionalFonts(bool arg);

Q_SIGNALS:
    void scalableFontsChanged();
    void nonScalableFontsChanged();
    void monospacedFontsChanged();
    void proportionalFontsChanged();
    void writingSystemChanged();
    void rowCountChanged() const;

protected:
    void updateFamilies();

private:
    Q_DISABLE_COPY(QQuickFontListModel)
    Q_DECLARE_PRIVATE(QQuickFontListModel)
    QScopedPointer<QQuickFontListModelPrivate> d_ptr;

};

QT_END_NAMESPACE

#endif // QQUICKFONTLISTMODEL_P_H
