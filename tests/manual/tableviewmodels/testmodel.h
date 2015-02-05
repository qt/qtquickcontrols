/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
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

#ifndef TESTMODEL_H
#define TESTMODEL_H

#include <QAbstractListModel>

class TestObject : public QObject
{
  Q_OBJECT
  Q_PROPERTY(int value READ value CONSTANT)
public:
  TestObject(int value) : m_value(value) {}
  int value() const { return m_value; }
private:
  int m_value;
};

class TestModel : public QAbstractListModel
{
  Q_OBJECT
public:
  explicit TestModel(QObject *parent = 0);

  enum {
    TestRole = Qt::UserRole + 1
  };

  QVariant data(const QModelIndex &index, int role) const;
  int rowCount(const QModelIndex &parent) const { Q_UNUSED(parent); return 10; }

  QHash<int, QByteArray> roleNames() const;
};

#endif // TESTMODEL_H
