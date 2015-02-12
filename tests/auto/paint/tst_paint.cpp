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

#include <QtTest>
#include <QtQml>
#include <QtQuick>

class tst_Paint : public QObject
{
    Q_OBJECT

private slots:
    void bounds_data();
    void bounds();
};

void tst_Paint::bounds_data()
{
    QTest::addColumn<QString>("name");

    QTest::newRow("CircularGauge") << "CircularGauge";
    QTest::newRow("Dial") << "Dial";
    QTest::newRow("Gauge") << "Gauge";
    QTest::newRow("PieMenu") << "PieMenu";
    QTest::newRow("DelayButton") << "DelayButton";
    QTest::newRow("ToggleButton") << "ToggleButton";
    QTest::newRow("Tumbler") << "Tumbler";
}

void tst_Paint::bounds()
{
    QFETCH(QString, name);

    QQmlEngine engine;
    QQmlComponent component(&engine);
    component.setData(QStringLiteral("import QtQuick.Extras 1.2; %1 { }").arg(name).toUtf8(), QUrl());
    QQuickItem *control = qobject_cast<QQuickItem*>(component.create());
    QVERIFY(control);

    const int w = control->width();
    const int h = control->height();
    QVERIFY(w > 0);
    QVERIFY(h > 0);

    static const int margin = 10;
    static const QColor bg = Qt::yellow;

    QQuickWindow window;
    window.setColor(bg);
    window.resize(w + 2 * margin, h + 2 * margin);
    control->setParentItem(window.contentItem());
    control->setPosition(QPoint(margin, margin));
    window.create();
    window.show();

    QTest::qWaitForWindowExposed(&window);

    const QRect bounds(margin, margin, w, h);
    const QImage image = window.grabWindow();

    for (int x = 0; x < image.width(); ++x) {
        for (int y = 0; y < image.height(); ++y) {
            if (!bounds.contains(x, y)) {
                const QByteArray msg = QString("painted outside bounds (%1,%2 %3x%4) at (%5,%6)").arg(bounds.x()).arg(bounds.y()).arg(bounds.width()).arg(bounds.height()).arg(x).arg(y).toUtf8();
                const QColor px = image.pixel(x, y);
                QVERIFY2(px == bg, msg);
            }
        }
    }
}

QTEST_MAIN(tst_Paint)

#include "tst_paint.moc"
