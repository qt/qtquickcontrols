/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
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

#include "qtmenu.h"
#include "qdebug.h"
#include <qapplication.h>
#include <qmenubar.h>
#include <qabstractitemmodel.h>

/*!
    \qmltype Menu
    \instantiates QtMenu
    \inqmlmodule QtDesktop 1.0
    \brief Menu is doing bla...bla...
*/

QtMenu::QtMenu(QQuickItem *parent)
    : QtMenuBase(parent),
      dummy(0),
      m_selectedIndex(0),
      m_highlightedIndex(0),
      m_hasNativeModel(false)
{
    m_qmenu = new QMenu(0);
    connect(m_qmenu, SIGNAL(aboutToHide()), this, SIGNAL(menuClosed()));
}

QtMenu::~QtMenu()
{
    delete m_qmenu;
}

void QtMenu::setText(const QString &text)
{
    m_qmenu->setTitle(text);
    emit textChanged();
}

QString QtMenu::text() const
{
    return m_qmenu->title();
}

void QtMenu::setSelectedIndex(int index)
{
    m_selectedIndex = index;
    QList<QAction *> actionList = m_qmenu->actions();
    if (m_selectedIndex >= 0 && m_selectedIndex < actionList.size())
        m_qmenu->setActiveAction(actionList[m_selectedIndex]);
    emit selectedIndexChanged();
}

void QtMenu::setHoveredIndex(int index)
{
    m_highlightedIndex = index;
    QList<QAction *> actionList = m_qmenu->actions();
    if (m_highlightedIndex >= 0 && m_highlightedIndex < actionList.size())
        m_qmenu->setActiveAction(actionList[m_highlightedIndex]);
    emit hoveredIndexChanged();
}

QQmlListProperty<QtMenuBase> QtMenu::menuItems()
{
    return QQmlListProperty<QtMenuBase>(this, 0, &QtMenu::append_qmenuItem, 0, 0, 0);
}

void QtMenu::showPopup(qreal x, qreal y, int atActionIndex, QQuickWindow * parentWindow)
{

    if (m_qmenu->isVisible())
        return;

    // If atActionIndex is valid, x and y is specified from the
    // the position of the corresponding QAction:
    QAction *atAction = 0;
    if (atActionIndex >= 0 && atActionIndex < m_qmenu->actions().size())
        atAction = m_qmenu->actions()[atActionIndex];

    QPointF screenPosition(mapToScene(QPoint(x, y)));
    QWindow *tw = parentWindow ? parentWindow : window();
    if (tw) {
        screenPosition = tw->mapToGlobal(QPoint(x, y));
        // calling winId forces a QWindow to be created
        // since this needs to be a top-level
        // otherwise windowHandle might return 0
        m_qmenu->winId();
        m_qmenu->windowHandle()->setTransientParent(tw);
    }

    setHoveredIndex(m_selectedIndex);
    m_qmenu->popup(screenPosition.toPoint(), atAction);
}

void QtMenu::hidePopup()
{
    m_qmenu->close();
}

QAction* QtMenu::action()
{
    return m_qmenu->menuAction();
}

Q_INVOKABLE void QtMenu::clearMenuItems()
{
    m_qmenu->clear();
    foreach (QtMenuBase *item, m_qmenuItems) {
        delete item;
    }
    m_qmenuItems.clear();
}

void QtMenu::addMenuItem(const QString &text)
{
    QtMenuItem *menuItem = new QtMenuItem(this);
    menuItem->setText(text);
    m_qmenuItems.append(menuItem);
    m_qmenu->addAction(menuItem->action());

    connect(menuItem->action(), SIGNAL(triggered()), this, SLOT(emitSelected()));
    connect(menuItem->action(), SIGNAL(hovered()), this, SLOT(emitHovered()));

    if (m_qmenu->actions().size() == 1)
        // Inform QML that the selected action (0) now has changed contents:
        emit selectedIndexChanged();
}

void QtMenu::emitSelected()
{
    QAction *act = qobject_cast<QAction *>(sender());
    if (!act)
        return;
    m_selectedIndex = m_qmenu->actions().indexOf(act);
    emit selectedIndexChanged();
}

void QtMenu::emitHovered()
{
    QAction *act = qobject_cast<QAction *>(sender());
    if (!act)
        return;
    m_highlightedIndex = m_qmenu->actions().indexOf(act);
    emit hoveredIndexChanged();
}

QString QtMenu::itemTextAt(int index) const
{
    QList<QAction *> actionList = m_qmenu->actions();
    if (index >= 0 && index < actionList.size())
        return actionList[index]->text();
    else
        return "";
}

QString QtMenu::modelTextAt(int index) const
{
    if (QAbstractItemModel *model = qobject_cast<QAbstractItemModel*>(m_model.value<QObject*>())) {
        return model->data(model->index(index, 0)).toString();
    } else if (m_model.canConvert(QVariant::StringList)) {
        return m_model.toStringList().at(index);
    }
    return "";
}

int QtMenu::modelCount() const
{
    if (QAbstractItemModel *model = qobject_cast<QAbstractItemModel*>(m_model.value<QObject*>())) {
        return model->rowCount();
    } else if (m_model.canConvert(QVariant::StringList)) {
        return m_model.toStringList().count();
    }
    return -1;
}

void QtMenu::append_qmenuItem(QQmlListProperty<QtMenuBase> *list, QtMenuBase *menuItem)
{
    QtMenu *menu = qobject_cast<QtMenu *>(list->object);
    if (menu) {
        menuItem->setParent(menu);
        menu->m_qmenuItems.append(menuItem);
        menu->qmenu()->addAction(menuItem->action());
    }
}

void QtMenu::setModel(const QVariant &newModel) {
    if (m_model != newModel) {

        // Clean up any existing connections
        if (QAbstractItemModel *oldModel = qobject_cast<QAbstractItemModel*>(m_model.value<QObject*>())) {
            disconnect(oldModel, SIGNAL(dataChanged(QModelIndex, QModelIndex)), this, SIGNAL(rebuildMenu()));
        }

        m_hasNativeModel = false;
        m_model = newModel;

        if (QAbstractItemModel *model = qobject_cast<QAbstractItemModel*>(newModel.value<QObject*>())) {
            m_hasNativeModel = true;
            connect(model, SIGNAL(dataChanged(QModelIndex, QModelIndex)), this, SIGNAL(rebuildMenu()));
        } else if (newModel.canConvert(QVariant::StringList)) {
            m_hasNativeModel = true;
        }
        emit modelChanged(m_model);
    }
}
