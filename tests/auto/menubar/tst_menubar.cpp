/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Copyright (C) 2015 Cucchetto Filippo <filippocucchetto@gmail.com>
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

#include <qtest.h>
#include "../shared/util.h"
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickWindow>
#include <QtQml/QQmlApplicationEngine>
#include <QSignalSpy>
#include <QTest>
#include "qquickmenupopupwindow_p.h"
#include "qquickpopupwindow_p.h"
#include "qquickmenu_p.h"

#define WAIT_TIME 500


class tst_menubar : public QQmlDataTest
{
    Q_OBJECT

private slots:
    void initTestCase()
    {
        QQmlDataTest::initTestCase();
    }

    void init();
    void cleanup();

    void testParentMenuForPopupsOutsideMenuBar();
    void testParentMenuForPopupsInsideMenuBar();
    void testClickMenuBarSubMenu();
    void testClickMenuBarRootMenu();

private:
    void moveOnPos(QObject *window, const QPoint &point);
    void moveOnPos(const QPoint &point);
    void clickOnPos(QObject *window, const QPoint &point);
    void clickOnPos(const QPoint &point);

    QQmlApplicationEngine *m_engine;
    QQuickWindow *m_window;
    QObject *m_menuBar;
};

bool waitForRendering(QQuickWindow* window, int timeout = WAIT_TIME)
{
    QSignalSpy signalSpy(window, SIGNAL(frameSwapped()));
    return signalSpy.wait(timeout);
}

void tst_menubar::moveOnPos(QObject *window, const QPoint &point)
{
    qApp->sendEvent(window, new QMouseEvent(QEvent::MouseMove,
                                            point,
                                            Qt::NoButton,
                                            Qt::NoButton,
                                            0));
}

void tst_menubar::moveOnPos(const QPoint &point)
{
    QPoint global = m_window->mapToGlobal(point);
    QWindow *focusWindow = qApp->focusWindow();
    moveOnPos(focusWindow, focusWindow->mapFromGlobal(global));
}

void tst_menubar::clickOnPos(QObject *window, const QPoint &point)
{
    qApp->sendEvent(window, new QMouseEvent(QEvent::MouseButtonPress,
                                            point,
                                            Qt::LeftButton,
                                            Qt::NoButton,
                                            0));

    qApp->sendEvent(window, new QMouseEvent(QEvent::MouseButtonRelease,
                                            point,
                                            Qt::LeftButton,
                                            Qt::NoButton,
                                            0));
}

void tst_menubar::clickOnPos(const QPoint &point)
{
    QPoint global = m_window->mapToGlobal(point);
    QWindow *focusWindow = qApp->focusWindow();
    clickOnPos(focusWindow, focusWindow->mapFromGlobal(global));
}

void tst_menubar::init()
{
    m_engine = new QQmlApplicationEngine();
    m_engine->load(testFileUrl("WindowWithMenuBar.qml"));
    QVERIFY(m_engine->rootObjects().length() > 0);

    m_window = qobject_cast<QQuickWindow*>(m_engine->rootObjects().at(0));
    QVERIFY(m_window);
    QVERIFY(QTest::qWaitForWindowExposed(m_window));
    QVERIFY(m_window->contentItem());

    m_menuBar = m_window->findChildren<QObject*>("menuBar").first();
    QVERIFY(m_menuBar);
}

void tst_menubar::cleanup()
{
    m_window = 0;
    delete m_engine;
    m_engine = 0;
}

void tst_menubar::testClickMenuBarRootMenu()
{
    QObject* fileMenu = m_menuBar->findChildren<QObject*>("fileMenu").first();
    QVERIFY(fileMenu);
    QCOMPARE(fileMenu->property("__popupVisible").toBool(), false);

    // Clicking two times should open and close
    {
        clickOnPos(QPoint(5,5));
        QTest::qWait(WAIT_TIME);
        QCOMPARE(fileMenu->property("__popupVisible").toBool(), true);

        clickOnPos(QPoint(5,5));
        QTest::qWait(WAIT_TIME);;
        QCOMPARE(fileMenu->property("__popupVisible").toBool(), false);
    }

    // Clicking outside should close the menu as well
    {
        clickOnPos(QPoint(5,5));
        QTest::qWait(WAIT_TIME);
        QCOMPARE(fileMenu->property("__popupVisible").toBool(), true);

        clickOnPos(QPoint(300,300));
        QTest::qWait(WAIT_TIME);;
        QCOMPARE(fileMenu->property("__popupVisible").toBool(), false);
    }
}

void tst_menubar::testClickMenuBarSubMenu()
{
    QObject *fileMenu = m_menuBar->findChildren<QObject*>("fileMenu").first();
    QVERIFY(fileMenu);
    QCOMPARE(fileMenu->property("__popupVisible").toBool(), false);

    clickOnPos(QPoint(5,5));
    QTest::qWait(WAIT_TIME);
    QCOMPARE(fileMenu->property("__popupVisible").toBool(), true);

    QQuickItem* fileMenuContentItem = fileMenu->property("__contentItem").value<QQuickItem*>();
    QVERIFY(fileMenuContentItem);

    QObject* actionsSubMenu = fileMenu->findChildren<QObject*>("actionsSubMenu").first();
    QVERIFY(actionsSubMenu);
    QCOMPARE(actionsSubMenu->property("visible").toBool(), true);
    QCOMPARE(actionsSubMenu->property("__popupVisible").toBool(), false);

    QQuickItem* actionsSubMenuContentItem = actionsSubMenu->property("__contentItem").value<QQuickItem*>();
    QVERIFY(actionsSubMenuContentItem);

    // Click on a submenu should open it
    clickOnPos(QPoint(5,25));
    QTest::qWait(WAIT_TIME);
    QCOMPARE(actionsSubMenu->property("__popupVisible").toBool(), true);

    // Click on a submenu should not close the popup
    clickOnPos(QPoint(5,25));
    QTest::qWait(WAIT_TIME);
    QCOMPARE(actionsSubMenu->property("__popupVisible").toBool(), true);

    // Click outside should close the popup
    clickOnPos(QPoint(100,100));
    QTest::qWait(WAIT_TIME);
    QCOMPARE(actionsSubMenu->property("__popupVisible").toBool(), false);
}

void tst_menubar::testParentMenuForPopupsOutsideMenuBar()
{
    waitForRendering(m_window);
    QCOMPARE(qApp->focusWindow() == m_window, true);
    moveOnPos(QPoint(50,50));
    clickOnPos(QPoint(50,50));
    QTest::qWait(500);
    QCOMPARE(qApp->focusWindow() == m_window, false);

    QQuickMenuPopupWindow *window = dynamic_cast<QQuickMenuPopupWindow*>(qApp->focusWindow());
    QVERIFY(window);

    QObject *contextMenu = m_window->findChildren<QObject*>("contextMenu").first();
    QVERIFY(contextMenu);

    QCOMPARE(contextMenu, window->menu());
}

void tst_menubar::testParentMenuForPopupsInsideMenuBar()
{
    waitForRendering(m_window);
    QCOMPARE(qApp->focusWindow() == m_window, true);
    moveOnPos(QPoint(5,5));
    clickOnPos(QPoint(5,5));
    QTest::qWait(500);
    QCOMPARE(qApp->focusWindow() == m_window, false);

    QQuickMenuPopupWindow *window = dynamic_cast<QQuickMenuPopupWindow*>(qApp->focusWindow());
    QVERIFY(window);

    QObject *fileMenu = m_window->findChildren<QObject*>("fileMenu").first();
    QVERIFY(fileMenu);

    QCOMPARE(fileMenu, window->menu());
}


QTEST_MAIN(tst_menubar)

#include "tst_menubar.moc"
