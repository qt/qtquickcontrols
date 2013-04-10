/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Layouts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QQUICKLAYOUT_P_H
#define QQUICKLAYOUT_P_H

#include <QPointer>
#include <QQuickItem>
#include <private/qquickitem_p.h>

QT_BEGIN_NAMESPACE

class QQuickLayoutAttached;

static const qreal q_declarativeLayoutMaxSize = 10e8;

#if 0 && !defined(QT_NO_DEBUG) && !defined(QT_NO_DEBUG_OUTPUT)
# define quickLayoutDebug QMessageLogger(__FILE__, __LINE__, Q_FUNC_INFO).debug
#else
# define quickLayoutDebug QT_NO_QWARNING_MACRO
#endif

class QQuickLayoutPrivate;
class QQuickLayout : public QQuickItem
{
    Q_OBJECT
public:
    enum SizeHint {
        MinimumSize = 0,
        PreferredSize,
        MaximumSize,
        NSizes
    };

    explicit QQuickLayout(QQuickLayoutPrivate &dd, QQuickItem *parent = 0);
    ~QQuickLayout();

    static QQuickLayoutAttached *qmlAttachedProperties(QObject *object);


    void componentComplete();
    virtual void invalidate(QQuickItem * childItem = 0);
protected:
    bool event(QEvent *e);
    virtual void rearrange(const QSizeF &);

    enum Orientation {
        Vertical = 0,
        Horizontal,
        NOrientations
    };

private:
    bool m_dirty;

    Q_DECLARE_PRIVATE(QQuickLayout)

    friend class QQuickLayoutAttached;
};


class QQuickLayoutPrivate : public QQuickItemPrivate
{
    Q_DECLARE_PUBLIC(QQuickLayout)
};


class QQuickLayoutAttached : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal minimumWidth READ minimumWidth WRITE setMinimumWidth NOTIFY minimumWidthChanged)
    Q_PROPERTY(qreal minimumHeight READ minimumHeight WRITE setMinimumHeight NOTIFY minimumHeightChanged)
    Q_PROPERTY(qreal preferredWidth READ preferredWidth WRITE setPreferredWidth NOTIFY preferredWidthChanged)
    Q_PROPERTY(qreal preferredHeight READ preferredHeight WRITE setPreferredHeight NOTIFY preferredHeightChanged)
    Q_PROPERTY(qreal maximumWidth READ maximumWidth WRITE setMaximumWidth NOTIFY maximumWidthChanged)
    Q_PROPERTY(qreal maximumHeight READ maximumHeight WRITE setMaximumHeight NOTIFY maximumHeightChanged)
    Q_PROPERTY(bool fillHeight READ fillHeight WRITE setFillHeight)
    Q_PROPERTY(bool fillWidth READ fillWidth WRITE setFillWidth)
    Q_PROPERTY(int row READ row WRITE setRow)
    Q_PROPERTY(int column READ column WRITE setColumn)
    Q_PROPERTY(int rowSpan READ rowSpan WRITE setRowSpan)
    Q_PROPERTY(int columnSpan READ columnSpan WRITE setColumnSpan)

public:
    QQuickLayoutAttached(QObject *object);

    qreal minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(qreal width);

    qreal minimumHeight() const { return m_minimumHeight; }
    void setMinimumHeight(qreal height);

    qreal preferredWidth() const { return m_preferredWidth; }
    void setPreferredWidth(qreal width);

    qreal preferredHeight() const { return m_preferredHeight; }
    void setPreferredHeight(qreal width);

    qreal maximumWidth() const { return m_maximumWidth; }
    void setMaximumWidth(qreal width);

    qreal maximumHeight() const { return m_maximumHeight; }
    void setMaximumHeight(qreal height);

    bool fillWidth() const { return m_fillWidth; }
    void setFillWidth(bool fill);
    bool isFillWidthSet() const { return m_isFillWidthSet; }

    bool fillHeight() const { return m_fillHeight; }
    void setFillHeight(bool fill);
    bool isFillHeightSet() const { return m_isFillHeightSet; }

    int row() const { return qMax(m_row, 0); }
    void setRow(int row);
    bool isRowSet() const { return m_row >= 0; }
    int column() const { return qMax(m_column, 0); }
    void setColumn(int column);
    bool isColumnSet() const { return m_column >= 0; }

    int rowSpan() const { return m_rowSpan; }
    void setRowSpan(int span) { m_rowSpan = span; }
    int columnSpan() const { return m_columnSpan; }
    void setColumnSpan(int span) { m_columnSpan = span; }

    bool setChangesNotificationEnabled(bool enabled)
    {
        const bool old = m_changesNotificationEnabled;
        m_changesNotificationEnabled = enabled;
        return old;
    }

signals:
    void minimumWidthChanged();
    void minimumHeightChanged();
    void preferredWidthChanged();
    void preferredHeightChanged();
    void maximumWidthChanged();
    void maximumHeightChanged();
    void fillWidthChanged();
    void fillHeightChanged();

private:
    void invalidateItem();
    QQuickLayout *parentLayout() const;
    QQuickItem *item() const;
private:
    qreal m_minimumWidth;
    qreal m_minimumHeight;
    qreal m_preferredWidth;
    qreal m_preferredHeight;
    qreal m_maximumWidth;
    qreal m_maximumHeight;

    // GridLayout specific properties
    int m_row;
    int m_column;
    int m_rowSpan;
    int m_columnSpan;

    unsigned m_fillWidth : 1;
    unsigned m_fillHeight : 1;
    unsigned m_isFillWidthSet : 1;
    unsigned m_isFillHeightSet : 1;
    unsigned m_changesNotificationEnabled : 1;
    friend class QQuickLayout;
};

inline QQuickLayoutAttached *attachedLayoutObject(QQuickItem *item, bool create = true)
{
    return static_cast<QQuickLayoutAttached *>(qmlAttachedPropertiesObject<QQuickLayout>(item, create));
}

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickLayout)
QML_DECLARE_TYPEINFO(QQuickLayout, QML_HAS_ATTACHED_PROPERTIES)

#endif // QQUICKLAYOUT_P_H
