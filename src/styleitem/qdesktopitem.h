/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

#ifndef QDESKTOPITEM_H
#define QDESKTOPITEM_H

#include <QDesktopWidget>
#include <QtDeclarative>

class QDesktopItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int screenWidth READ screenWidth NOTIFY screenGeometryChanged)
    Q_PROPERTY(int screenHeight READ screenHeight NOTIFY screenGeometryChanged)
    Q_PROPERTY(int availableWidth READ availableWidth NOTIFY availableGeometryChanged)
    Q_PROPERTY(int availableHeight READ availableHeight NOTIFY availableGeometryChanged)
    Q_PROPERTY(int screenCount READ screenCount NOTIFY screenCountChanged)

public:
    QDesktopItem(QObject* obj);

    int screenCount() const;
    Q_INVOKABLE QRect screenGeometry(int screen) const;
    Q_INVOKABLE QRect availableGeometry(int screen) const;
    int screenWidth() const;
    int screenHeight() const;
    int availableWidth() const;
    int availableHeight() const;
    static QDesktopItem *qmlAttachedProperties(QObject *obj);

private:
    QDesktopWidget desktopWidget;

Q_SIGNALS:
    void screenGeometryChanged();
    void availableGeometryChanged();
    void screenCountChanged();
};

QML_DECLARE_TYPEINFO(QDesktopItem, QML_HAS_ATTACHED_PROPERTIES)

#endif // QDesktopItemITEM_H
