/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
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

#include "qtquickcontrolsapplication.h"
#include <QtQml/QQmlApplicationEngine>
#include <QtCore/QElapsedTimer>
#include <functional>

int runBenchmark(std::function<int()> f) {
    {
        QElapsedTimer t;
        t.start();
        int r = f();
        if (r == 0)
            printf("%d,", static_cast<int>(t.elapsed()));
        else
            return r;
    }

    {
        QElapsedTimer t;
        t.start();
        int r = f();
        if (r == 0)
            printf("%d\n", static_cast<int>(t.elapsed()));
        else
            return r;
    }

    return 0;
}


int main(int argc, char *argv[])
{
    QtQuickControlsApplication app(argc, argv);

    auto startup = [&app]() -> int {
        QQmlApplicationEngine engine(QUrl("qrc:/main.qml"));
        QObject::connect(&engine, &QQmlApplicationEngine::quit,
                         QCoreApplication::instance(), &QCoreApplication::quit);
        engine.load(QUrl("qrc:/timer.qml"));
        if (engine.rootObjects().size() != 2)
            return -1;
        return app.exec();
    };

    return runBenchmark(startup);
}
