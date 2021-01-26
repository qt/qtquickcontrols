/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

#ifndef PLUGIN_H
#define PLUGIN_H

#include <QtQml/qqmlextensionplugin.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmlengine.h>

#ifndef QT_NO_TRANSLATION
#include <QtCore/qtranslator.h>
#endif

QT_BEGIN_NAMESPACE

class QtQuickControls1Plugin: public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    QtQuickControls1Plugin(QObject *parent = 0);
    void registerTypes(const char *uri) override;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
private:
    QString fileLocation() const;
    bool isLoadedFromResource() const;
#ifndef QT_NO_TRANSLATION
    QTranslator m_translator;
#endif
};

QT_END_NAMESPACE

#endif // PLUGIN_H
