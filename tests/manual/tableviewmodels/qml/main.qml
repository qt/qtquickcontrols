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

import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
  width: 360
  height: 600

  ListModel {
    id: model_listmodel
    ListElement { value: "A" }
    ListElement { value: "B" }
    ListElement { value: "C" }
  }

  Column {
    anchors { left: parent.left; right: parent.right }
    TableView {
      model: model_listmodel // qml
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        role: "value"
        width: 100
      }
    }
    TableView {
      model: 3 // qml
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        width: 100
      }
    }
    TableView {
      model: ["A", "B", "C"] // qml
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        width: 100
      }
    }
    TableView {
      model: Item { x: 10 } // qml
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        role: "x"
        width: 100
      }
    }
    TableView {
      model: model_qobjectlist // c++
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        role: "value"
        width: 100
      }
    }
    TableView {
      model: model_qaim // c++
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        role: "test"
        width: 100
      }
    }
    TableView {
      model: model_qstringlist // c++
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        width: 100
      }
    }
    TableView {
      model: model_qobject // c++
      anchors { left: parent.left; right: parent.right }
      height: 70
      TableViewColumn {
        role: "value"
        width: 100
      }
    }
  }
}
