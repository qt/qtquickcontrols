/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Layouts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QQUICKSTACKLAYOUT_H
#define QQUICKSTACKLAYOUT_H

#include <qquicklayout_p.h>

class QQuickStackLayoutPrivate;

class QQuickStackLayout : public QQuickLayout
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)

public:
    explicit QQuickStackLayout(QQuickItem *parent = 0);
    int count() const;
    int currentIndex() const;
    void setCurrentIndex(int index);

    void componentComplete() Q_DECL_OVERRIDE;
    QSizeF sizeHint(Qt::SizeHint whichSizeHint) const Q_DECL_OVERRIDE;
    void setAlignment(QQuickItem *item, Qt::Alignment align)  Q_DECL_OVERRIDE;
    void invalidate(QQuickItem *childItem = 0)  Q_DECL_OVERRIDE;
    void updateLayoutItems()  Q_DECL_OVERRIDE;
    void rearrange(const QSizeF &) Q_DECL_OVERRIDE;

    // iterator
    Q_INVOKABLE QQuickItem *itemAt(int index) const Q_DECL_OVERRIDE;
    int itemCount() const Q_DECL_OVERRIDE;
    int indexOf(QQuickItem *item) const;



signals:
    void currentIndexChanged();
    void countChanged();

public slots:

private:
    static void collectItemSizeHints(QQuickItem *item, QSizeF *sizeHints);
    bool shouldIgnoreItem(QQuickItem *item) const;
    Q_DECLARE_PRIVATE(QQuickStackLayout)

    QList<QQuickItem*> m_items;

    typedef struct {
        inline QSizeF &min() { return array[Qt::MinimumSize]; }
        inline QSizeF &pref() { return array[Qt::PreferredSize]; }
        inline QSizeF &max() { return array[Qt::MaximumSize]; }
        QSizeF array[Qt::NSizeHints];
    } SizeHints;

    mutable QVector<SizeHints> m_cachedItemSizeHints;
    mutable QSizeF m_cachedSizeHints[Qt::NSizeHints];
};

class QQuickStackLayoutPrivate : public QQuickLayoutPrivate
{
    Q_DECLARE_PUBLIC(QQuickStackLayout)
public:
    QQuickStackLayoutPrivate() : count(0), currentIndex(-1), explicitCurrentIndex(false) {}
private:
    int count;
    int currentIndex;
    bool explicitCurrentIndex;
};

#endif // QQUICKSTACKLAYOUT_H
