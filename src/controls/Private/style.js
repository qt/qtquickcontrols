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

.pragma library

function underlineAmpersands(match, p1, p2, p3) {
    if (p2 === "&")
        return p1.concat(p2, p3)
    return p1.concat("<u>", p2, "</u>", p3)
}

function removeAmpersands(match, p1, p2, p3) {
    return p1.concat(p2, p3)
}

function replaceAmpersands(text, replaceFunction) {
    return text.replace(/([^&]*)&(.)([^&]*)/g, replaceFunction)
}

function stylizeMnemonics(text) {
    return replaceAmpersands(text, underlineAmpersands)
}

function removeMnemonics(text) {
    return replaceAmpersands(text, removeAmpersands)
}
