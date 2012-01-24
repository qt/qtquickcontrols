/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
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

#include "qtmenu.h"
#include "qdebug.h"
#include <qapplication.h>
#include <qmenubar.h>
#include <qabstractitemmodel.h>
#include "qtoplevelwindow.h"

QtMenu::QtMenu(QObject *parent)
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

QDeclarativeListProperty<QtMenuBase> QtMenu::menuItems()
{
    return QDeclarativeListProperty<QtMenuBase>(this, 0, &QtMenu::append_qmenuItem);
}

void QtMenu::showPopup(qreal x, qreal y, int atActionIndex)
{
    if (m_qmenu->isVisible())
        return;

    // If atActionIndex is valid, x and y is specified from the
    // the position of the corresponding QAction:
    QAction *atAction = 0;
    if (atActionIndex >= 0 && atActionIndex < m_qmenu->actions().size())
        atAction = m_qmenu->actions()[atActionIndex];

    // x,y are in view coordinates, QMenu expects screen coordinates
    // ### activeWindow hack
    int menuBarHeight = 0;
    QWidget *window = QApplication::activeWindow();
    QTopLevelWindow *tw = qobject_cast<QTopLevelWindow*>(window);
    if (tw) {
        QMenuBar *menuBar = tw->menuBar();
        menuBarHeight = menuBar->height();
    }

    QPoint screenPosition = window->mapToGlobal(QPoint(x, y+menuBarHeight));

    setHoveredIndex(m_selectedIndex);
    m_qmenu->popup(screenPosition, atAction);
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

void QtMenu::append_qmenuItem(QDeclarativeListProperty<QtMenuBase> *list, QtMenuBase *menuItem)
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
