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

import QtQuick 2.2

/*!
        \qmltype StackViewDelegate
        \inqmlmodule QtQuick.Controls
        \ingroup controls
        \since 5.1

        \brief A delegate used by StackView for loading transitions.

        See the documentation for the \l {StackView} component.

*/
QtObject {
    id: root

    /*!
        \qmlmethod Transition StackViewDelegate::getTransition(properties)

        The base implementation of this function just looks for a property named
        \a {properties}.name inside itself and returns it.
        \sa {Transitions}
    */
    function getTransition(properties)
    {
        return root[properties.name]
    }

    /*!
        \qmlmethod void StackViewDelegate::transitionFinished(properties)

        Handles the completion of a transition for \a properties. The base
        implementation of this function is empty.

        \sa {Transitions}
    */
    function transitionFinished(properties)
    {
    }

    /*!
        \qmlproperty Component StackViewDelegate::pushTransition

        The transition used on push operation.
    */
    property Component pushTransition: StackViewTransition {}
    /*!
        \qmlproperty Component StackViewDelegate::popTransition

        The transition used on pop operation.
        Unless set, the popTransition is the same as pushTransition
    */
    property Component popTransition: root["pushTransition"]
    /*!
        \qmlproperty Component StackViewDelegate::replaceTransition

        The transition used on replace operation.
        Unless set, the replaceTransition is the same as pushTransition
    */
    property Component replaceTransition: root["pushTransition"]
}
