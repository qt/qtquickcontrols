/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Dialogs module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

#include <QtQml/qqmlextensionplugin.h>
#include <QtQml/qqml.h>
#include <QtWidgets/qtwidgetsglobal.h>
#if QT_CONFIG(messagebox)
#include "qquickqmessagebox_p.h"
#endif // QT_CONFIG(messagebox)
#if QT_CONFIG(filedialog)
#include "qquickqfiledialog_p.h"
#endif // QT_CONFIG(filedialog)
#if QT_CONFIG(colordialog)
#include "qquickqcolordialog_p.h"
#endif // QT_CONFIG(colordialog)
#if QT_CONFIG(fontdialog)
#include "qquickqfontdialog_p.h"
#endif // QT_CONFIG(fontdialog)

QT_BEGIN_NAMESPACE

/*!
    \qmlmodule QtQuick.PrivateWidgets 1
    \title QWidget QML Types
    \ingroup qmlmodules
    \brief Provides QML types for certain QWidgets
    \internal

    This QML module contains types which should not be depended upon in Qt Quick
    applications, but are available if the Widgets module is linked. It is
    recommended to load components from this module conditionally, if at all,
    and to provide fallback implementations in case they fail to load.

    \code
    import QtQuick.PrivateWidgets 1.1
    \endcode

    \since 5.1
*/

class QtQuick2PrivateWidgetsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    QtQuick2PrivateWidgetsPlugin(QObject *parent = 0) : QQmlExtensionPlugin(parent) { }
    void registerTypes(const char *uri) override
    {
        Q_ASSERT(QLatin1String(uri) == QLatin1String("QtQuick.PrivateWidgets"));
#if QT_CONFIG(messagebox)
        qmlRegisterType<QQuickQMessageBox>(uri, 1, 1, "QtMessageDialog");
#endif
#if QT_CONFIG(filedialog)
        qmlRegisterType<QQuickQFileDialog>(uri, 1, 0, "QtFileDialog");
#endif
#if QT_CONFIG(colordialog)
        qmlRegisterType<QQuickQColorDialog>(uri, 1, 0, "QtColorDialog");
#endif
#if QT_CONFIG(fontdialog)
        qmlRegisterType<QQuickQFontDialog>(uri, 1, 1, "QtFontDialog");
#endif
    }
};

QT_END_NAMESPACE

#include "widgetsplugin.moc"
