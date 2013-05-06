/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import "Private/StackView.js" as JSArray

/*!
    \qmltype StackView
    \inherits Item
    \ingroup views
    \inqmlmodule QtQuick.Controls 1.0
    \since QtQuick.Controls 1.0

    \brief Provides a stack-based navigation model.

    StackView implements a stack-based navigation model. You use this view when you
    have a set of interlinked information pages for the user to browse.
    Items are pushed onto the stack as the user navigates deeper into the material, and
    popped off again when he chooses to go back.

    \section1 Using StackView in an Application
    Using the StackView in the application is typically a simple matter of adding
    the StackView as a child of a Window. The stack is usually
    anchored to the edges of the window, except at the top or bottom where it might
    be anchored to a status bar, or some other similar UI component.
    The stack can then be used by invoking its navigation methods. The first item
    to show in the StackView is commonly loaded assigning it to \l initialItem.

    \section1 Basic Navigation
    There are three primary navigation operations in StackView: push(), pop() and
    replace (you replace by specifying argument \c replace to push()).
    These correspond to classic stack operations where "push" adds an item to the
    top of a stack, "pop" removes the top item from the stack, and "replace" is like a
    pop followed by a push in that it replaces the topmost item on the stack with
    a new item (but the applied transtition might be different). The topmost item
    in the stack corresponds to the one that is \l{StackView::currentItem} {current},
    i.e. the one that is visible on
    screen. That means that "push" is the logical equivalent of navigating forward or
    deeper into the application, "pop" is the equivalent of navigation back and
    "replace" is the equivalent of replacing the current item with a different item.

    Sometimes it is necessary to go back more than a single step in the stack, e.g.
    to return to a "main" item or some kind of section item in the application.
    For this use case, pop() can be provided with a item to pop to. This is called
    an "unwind" operation as the stack gets unwound to the specified item. If the
    item is not found then the stack unwinds until there is only a single item in
    the stack, which becomes the current item. To explicitly unwind to the bottom
    of the stack it is recommended to use \l{pop()} {pop(null)}, though technically any
    non-existent item will do.

    Given the stack [A, B, C]:

    \list
    \li \l{push()}{push(D)} => [A, B, C, D] - "push" transition animation between C and D
    \li pop() => [A, B] - "pop" transition animation between C and B
    \li \l{push()}{push(D, replace)} => [A, B, D] - "replace" transition between C and D
    \li \l{pop()}{pop(A)} => [A] - "pop" transition between C and A
    \endlist

    Note that when the stack is empty, a push() will not perform a
    transition animation because there is nothing to transition from (which will
    typically happend during application start-up). A pop() on a stack with
    depth 1 or 0 is a no-operation. If removing all items from the stack is
    needed, a separate function clear() is available.

    Calling push() returns the item that was pushed onto the stack.
    Calling pop() returns the item that was popped off the stack. When pop() is
    called in an unwind operation the top-most item (the first item that was
    popped, which will also be the one transitioning out) is returned.

    \section1 Deep Linking
    Deep linking means launching an application into a particular state. For example
    a Newspaper application could be launched into showing a particular article,
    bypassing the front item (and possible a section item) that would normally have
    to be navigated through to get to the article in question. In terms of StackView, deep
    linking means the ability to modify the state of the stack so that
    you e.g. push a set of items to the top of the stack, or that you completely reset
    the stack to a given state.

    The API for deep linking in StackView is the same as for basic navigation. If
    you push an array instead of a single item then all the items in that array will
    be pushed onto the stack. The transition animation, however, will be conducted as
    if only the last item in the array was pushed onto the stack. The normal semantics
    of push() apply for deep linking, meaning that push() adds whatever you push onto
    the stack. Note also that only the last item in the array will actually be loaded.
    The rest will be lazy loaded as needed when entering
    the screen upon subsequent calls to pop (or when requesting the item by using \a get).

    This gives us the following result, given the stack [A, B, C]:

    \list
    \li \l{push()}{push([D, E, F])} => [A, B, C, D, E, F] - "push" transition animation between C and F
    \li \l{push()}{push([D, E, F], replace)} => [A, B, D, E, F] - "replace" transition animation between C and F
    \li clear(); \l{push()}{push([D, E, F])} => [D, E, F] - no transition animation (since the stack was empty)
    \endlist

    \section1 Pushing items

    An item you push onto the StackView can be either an Item, a URL, a
    string with a URL, or a Component. To push it, you assign it
    to a property "item" inside a property list, and send it as argument to \l{StackView::push}{push}:

    \code
    stackView.push({item: yourItem})
    \endcode

    The list can contain several properties that controls how the item should be pushed:
    \list
    \li \c item: This property is required, and holds the item you want to push.
    \li \c properties: You can set a property list of QML properties that should be assigned
        to the item upon push. These properties will be copied into the item at the
        time the item is loaded, or about to become the current item (normally upon push).
    \li \c immediate: Set this property to \c true to skip transition effects. When pushing
        an array, you only need to set this property on the first element to make the
        whole operation immediate.
    \li \c replace: Set this property to replace the current item on the stack. When pushing
        an array, you only need to set this property on the first element to replace
        as many elements on the stack as inside the array.
    \li \c destroyOnPop: Set this property to be explicit to whether or not StackView should
        destroy the item when its popped off the stack. By default (if \a destroyOnPop is
        not specified), StackView will destroy items pushed as components or URLs. Items
        not destroyed will be reparented back to the original parents they had before being
        pushed onto the stack, and hidden. If you need to set this property, do it with
        care, so that items are not leaked.
    \endlist

    If the only argument needed is "item", you can also, as a short-hand
    notation, do:

    \code
    stackView.push(yourItem).
    \endcode

    You can push several items in one go by using an array of property lists. This is
    optimizing compared to pushing items one by one, since StackView then can load only the
    last item in the list. The rest will be loaded as they are about to become
    the current item (which happends when the stack is popped). The following example shows how
    to push an array of items:

    \code
    stackView.push([{item: yourItem1}, {item: yourItem2}])
    \endcode

    If inline items are pushed, the item gets re-parented into an internal
    container in the StackView. When the item is later popped off, it gets
    re-parented back to its original owner. If, however, an item is pushed
    as a component or a URL, the actual item will be created as a item from that component. This
    happens automatically when the item is about to become the current item in the stack. Ownership
    over the item will then normally be taken by the StackView. It will as such automatically
    destroy the item when it is later popped off. The component that declared the item, by
    contrast, remains in the ownership of the application and is not destroyed by the stack.
    You can override this behavior if needed by explicitly setting "destroyOnPop" in the list
    argument given to push.

    If you specify the \c properties property to push, these properties will be copied into
    the item at the time the item is loaded (in case of a component or URL), or instead when
    its about to become the current item (in case of an inline item). This normally happens when
    the item is pushed. The following example shows how this can be done:

    \code
    stackView.push({item: someItem, properties: {fgcolor: "red", bgcolor: "blue"}});
    \endcode

    Note that if an item is declared inside another item that is destroyed - even if a component
    was used - that child item also gets destroyed.
    This follows normal Qt parent-child destruction rules but sometimes comes as a surprise
    for developers. In practice this means that if you declare a item B as a child of
    item A and then do a replace from item A to item B, then item B will be destroyed when
    item A was destroyed (as it was popped off the stack) and the application will effectively
    be switching to a item that has been destroyed.

    \section1 Lifecycle
    An items lifecycle in the StackView goes from instantiation to inactive, activating, active,
    deactivating, inactive, and when no longer needed, destruction.
    It can move any number of times between inactive and active. When an item is activated,
    it's visible on the screen and is considered to be the current item. An item
    in a StackView that is not visible is not activated, even if the item is currently the
    top-most item in the stack. When the stack becomes visible the item that is top-most gets
    activated. Likewise if the stack is then hidden, the top-most item would be deactivated.
    Popping the item off the top of the stack at this point would not result in further
    deactivation since the item is not active.

    There is an attached \l{Stack::status}{Stack.status} property that tracks the lifecycle. The value of status is
    an enumeration with values \c Stack.Inactive, \c Stack.Activating, \c Stack.Active
    and \c Stack.Deactivating. Combined with the normal \c Component.onComplete and
    \c Component.onDestruction signals the entire lifecycle is thus:

    \list
    \li Created: Component.onCompleted()
    \li Activating: Stack.onStatusChanged (Stack.status is Stack.Activating)
    \li Acivated: Stack.onStatusChanged (Stack.status is Stack.Active)
    \li Deactivating: Stack.onStatusChanged (Stack.status is Stack.Deactivating)
    \li Deactivated: Stack.onStatusChanged (Stack.status is Stack.Inactive)
    \li Destruction: Component.onDestruction()
    \endlist

    \section1 Finding items
    Sometimes it is necessary to search for a item, e.g. in order to unwind the stack to
    an item to which the application does not have a reference. This is facilitated using a
    function find() in StackView. The find() function takes a callback function as its
    only argument. The callback gets invoked for each item in the stack (starting at the top).
    If the callback returns true then it signals that a match has been found and the find()
    function returns that item. If the callback fails to return true (i.e. no match is found)
    then find() returns \c null.

    The code below searches for an item in the stack that has a name "foo" and then unwinds to
    that item. Note that since find() returns null if no item is found and since pop unwinds to
    the bottom of the stack if null is given as the target item, the code works well even in the
    case that no matching item was found.

    \code
    stackView.pop(stackView.find(function(item) {
        return item.name == "foo";
    }));
    \endcode

    You can also get to a item in the stack using get(index). You should use
    this function if your item depends on another item in the stack, as the function will
    ensure that the item at the given index gets loaded before it is returned.

    \code
    previousItem = stackView.get(myItem.Stack.index - 1));
    \endcode

    \section1 Transitions

    A transition is performed whenever a item is pushed or popped, and consists of
    two items: enterItem and exitItem. The StackView itself will never move items
    around, but instead delegate the job to an external animation set provided
    by the style or the application developer. How items should visually enter and leave the stack
    (and the geometry they should end up with) is therefore completely controlled from the outside.

    When the transition starts, the StackView will search for a transition that
    matches the operation executed. There are three transitions to choose
    from: pushTransition, popTransition, and replaceTransition. Each implements how
    enterItem should animate in, and exitItem out. The transitions are
    collected inside a StackViewDelegate object assigned to
    \l {StackView::delegate}{delegate}. By default, popTransition and
    replaceTransition will be the same as pushTransition, unless you set them
    to something else.

    A simple fade transition could be implemented as:

    \qml
    StackView {
        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
            }

            property Component pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                }
                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }
    }
    \endqml

    PushTransition needs to inherit from StackViewTransition, which is a ParallelAnimation that
    contains the properties \c enterItem and \c exitItem. You set the target of your
    inner animations to those items. Since the same items instance can be pushed several
    times to a StackView, you should always override
    \l {StackViewDelegate::transitionFinished(properties)}{StackViewDelegate.transitionFinished(properties)}.
    Implement this function to reset any properties animated on the exitItem so that later
    transitions can expect the items to be in a default state.

    A more complex example could look like the following. Here, the items slides in lying on the side before
    they are rotated up in an upright position:

    \qml
    StackView {
        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.x = 0
                properties.exitItem.rotation = 0
            }

            property Component pushTransition: StackViewTransition {
                SequentialAnimation {
                    ScriptAction {
                        script: enterItem.rotation = 90
                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "x"
                        from: enterItem.width
                        to: 0
                    }
                    PropertyAnimation {
                        target: enterItem
                        property: "rotation"
                        from: 90
                        to: 0
                    }
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: -exitItem.width
                }
            }
        }
    }
    \endqml

    \section2 Advanced usage

    When the StackView needs a new transition, it first calls
    \l {StackViewDelegate::getTransition(properties)}{StackViewDelegate.getTransition(properties)}.
    The base implementation of this function just looks for a property named \c properties.name inside
    itself (root), which is how it finds \c {property Component pushTransition} in the examples above.

    \code
    function getTransition(properties)
    {
        return root[properties.name]
    }
    \endcode

    You can override this function for your delegate if you need extra logic to decide which
    transition to return. You could for example introspect the items, and return different animations
    depending on the their internal state. StackView will expect you to return a Component that
    contains a StackViewTransition, or a StackViewTransition directly. The former is easier, as StackView will
    then create the transition and later destroy it when it's done, while avoiding any sideeffects
    caused by the transition being alive long after it ran. Returning a StackViewTransition directly
    can be useful if you need to write some sort of transition caching for performance reasons.
    As an optimization, you can also return \c null to signal that you just want to show/hide the items
    immediately without creating or running any transitions. You can also override this function if
    you need to alter the items in any way before the transition starts.

    \c properties contains the properties that will be assigned to the StackViewTransition before
    it runs. In fact, you can add more properties to this object during the call
    if you need to initialize additional properties of your custom StackViewTransition when the returned
    component is instanciated.

    The following example shows how you can decide run-time which animation to use:

    \qml
    StackViewDelegate {
        function getTransition(properties)
        {
            return (properties.enterItem.Stack.index % 2) ? horizontalTransition : verticalTransition
        }

        function transitionFinished(properties)
        {
            properties.exitItem.x = 0
            properties.exitItem.y = 0
        }

        property Component horizontalTransition: StackViewTransition {
            PropertyAnimation {
                target: enterItem
                property: "x"
                from: target.width
                to: 0
                duration: 300
            }
            PropertyAnimation {
                target: exitItem
                property: "x"
                from: 0
                to: target.width
                duration: 300
            }
        }

        property Component verticalTransition: StackViewTransition {
            PropertyAnimation {
                target: enterItem
                property: "y"
                from: target.height
                to: 0
                duration: 300
            }
            PropertyAnimation {
                target: exitItem
                property: "y"
                from: 0
                to: target.height
                duration: 300
            }
        }
    }
    \endqml
*/

Item {
    id: root

    /*! \qmlproperty int StackView::depth
        \readonly
        The number of items currently pushed onto the stack.
    */
    readonly property alias depth: root.__depth

    /*! \qmlproperty Item StackView::currentItem
        \readonly
        The currently top-most item in the stack.
    */
    readonly property alias currentItem: root.__currentItem

    /*! The first \l item that should be shown when the StackView is created.
        \a initialItem can take same value as the first argument to \l{StackView::push()}
        {StackView.push()}. Note that this is just a convenience for writing
        \c{Component.onCompleted: stackView.push(myInitialItem)}

        Examples:

        \list
        \li initialItem: Qt.resolvedUrl("MyItem.qml")
        \li initialItem: myItem
        \li initialItem: {"item" : Qt.resolvedUrl("MyRectangle.qml"), "properties" : {"color" : "red"}}
        \endlist
        \sa push
    */
    property var initialItem: null

    /*! \readonly
        \a busy is \c true if a transition is running, and \c false otherwise. */
    readonly property bool busy: __currentTransition !== null

    /*! The transitions to use when pushing or popping items.
        For better understanding on how to apply custom transitions, read \l{Transitions}.
        \sa {Stack::transitions}{Stack.transitions} */
    property StackViewDelegate delegate: StackViewSlideDelegate {}

    /*! Pushes an item onto the stack. The function takes a property list as argument, which
        should contain one or more of the following properties:
        \list
        \li \c item: This property is required, and holds the item you want to push.
        \li \c properties: You can set a property list of QML properties that should be assigned
            to the item upon push. These properties will be copied into the item at the
            time the item is loaded (in case of a component or URL), or else the first time it
            becomes the current item (normally upon push).
        \li \c immediate: Set this property to \c true to skip transition effects. When pushing
            an array, you only need to set this property on the first element to make the
            whole operation immediate.
        \li \c replace: Set this property to replace the current item on the stack. When pushing
            an array, you only need to set this property on the first element to replace
            as many elements on the stack as inside the array.
        \li \c destroyOnPop: Set this property to be explicit to whether or not StackView should
            destroy the item when its popped off the stack. By default (if \a destroyOnPop is
            not specified), StackView will destroy items pushed as components or URLs. Items
            not destroyed will be reparented back to the original parents they had before being
            pushed onto the stack, and hidden. If you need to set this property, do it with
            care, so that items are not leaked.
        \endlist

        You can also push an array of items (property lists) if you need to push several items
        in one go. A transition will then only occur between the current item and the last
        item in the list. The other items will be deferred loaded until needed.

        Examples:
        \list
        \li stackView.push({item:anItem})
        \li stackView.push({item:aURL, immediate: true, replace: true})
        \li stackView.push({item:aRectangle, properties:{color:"red"}})
        \li stackView.push({item:aComponent, properties:{color:"red"}})
        \li stackView.push({item:aComponent.createObject(), destroyOnPop:true})
        \li stackView.push([{item:anitem, immediate:true}, {item:aURL}])
        \endlist

        Note: If the only argument needed is "item", you can also, as a short-hand
        notation, do: \c{stackView.push(anItem)}.

        Returns the item that became current.

        \sa initialItem
        \sa {Pushing items}
    */
    function push(item) {
        // Note: we support two different APIs in this function; The old meego API, and
        // the new "property list" API. Hence the reason for hiding the fact that you
        // can pass more arguments than shown in the signature:
        if (__recursionGuard(true))
            return
        var properties = arguments[1]
        var immediate = arguments[2]
        var replace = arguments[3]
        var arrayPushed = (item instanceof Array)
        var firstItem = arrayPushed ? item[0] : item
        immediate = (immediate || JSArray.stackView.length === 0)

        if (firstItem && firstItem.item && firstItem.hasOwnProperty("x") === false) {
            // Property list API used:
            immediate = immediate || firstItem.immediate
            replace = replace || firstItem.replace
        }

        // Create, and push, a new javascript object, called "element", onto the stack.
        // This element contains all the information necessary to construct the item, and
        // will, after loaded, also contain the loaded item:
        if (arrayPushed) {
            if (item.length === 0)
                return
            var outElement = replace ? JSArray.pop() : JSArray.current()
            for (var i=0; i<item.length; ++i)
                JSArray.push({itemComponent:item[i], loaded: false, index: __depth, properties: properties});
        } else {
            outElement = replace ? JSArray.pop() : JSArray.current()
            JSArray.push({itemComponent:item, loaded: false, index: __depth, properties: properties})
        }

        var currentElement = JSArray.current()
        var transition = {
            inElement: currentElement,
            outElement: outElement,
            immediate: immediate,
            replace: replace,
            push: true
        }
        __performTransition(transition)
        __recursionGuard(false)
        return __currentItem
    }

    /*! Pops one or more items off the stack. The function takes a property list as argument
        which can contain one or more of the following properties:
        \list
        \li \c item: If specified, all items down to (but not including) \a item will be
            popped off. if \a item is \c null, all items down to (but not including) the
            first item will be popped. If not specified, only the current item will be
            popped.
        \li \c immediate: Set this property to \c true to skip transition effects.
        \endlist

        Examples:
        \list
        \li stackView.pop()
        \li stackView.pop({item:someItem, immediate: true})
        \li stackView.pop({immediate: true})
        \li stackView.pop(null)
        \endlist

        Note: If the only argument needed is "item", you can also, as a short-hand
        notation, do: \c{stackView.pop(anItem)}.

        Returns the item that was popped off
        \sa clear()
    */
    function pop(item) {
        if (__depth <= 1)
            return null
        if (item && item.hasOwnProperty("x") === false) {
            // Property list API used:
            var immediate = (item.immediate === true)
            item = item.item
        } else {
            immediate = (arguments[1] === true)
        }

        if (item === __currentItem)
            return

        if (__recursionGuard(true))
            return

        var outElement = JSArray.pop()
        var inElement = JSArray.current()

        if (__depth > 1 && item !== undefined && item !== inElement.item) {
            // Pop from the top until we find 'item', and return the corresponding
            // element. Skip all non-loaded items (except the first), since no one
            // has any references to such items anyway:
            while (__depth > 1 && !JSArray.current().loaded)
                JSArray.pop()
            inElement = JSArray.current()
            while (__depth > 1 && item !== inElement.item) {
                JSArray.pop()
                __cleanup(inElement)
                while (__depth > 1 && !JSArray.current().loaded)
                    JSArray.pop()
                inElement = JSArray.current()
            }
        }

        var transition = {
            inElement: inElement,
            outElement: outElement,
            immediate: immediate,
            replace: false,
            push: false
        }
        __performTransition(transition)
        __recursionGuard(false)
        return outElement.item;
    }

    /*! Remove all items from the stack. No animations will be applied. */
    function clear() {
        if (__recursionGuard(true))
            return
        if (__currentTransition)
            __currentTransition.animation.complete()
        __currentItem = null
        var count = __depth
        for (var i=0; i<count; ++i) {
            var element = JSArray.pop()
            if (element.item)
                __cleanup(element);
        }
        __recursionGuard(false)
    }

    /*! Search for a specific item inside the stack. \a func will
        be called for each item in the stack (with the item as argument)
        until the function returns true. Return value will be the item found. E.g:
        find(function(item, index) { return item.isTheOne })
        Set \a onlySearchLoadedItems to \c true to not load items that are
        not loaded into memory */
    function find(func, onlySearchLoadedItems) {
        for (var i=__depth-1; i>=0; --i) {
            var element = JSArray.stackView[i];
            if (onlySearchLoadedItems !== true)
                __loadElement(element)
            else if (!element.item)
                continue
            if (func(element.item))
                return element.item
        }
        return null;
    }

    /*! Returns the item at position \a index in
        the stack. If \a dontLoad is true, the
        item will not be forced to load (and \c null
        will be returned if not yet loaded) */
    function get(index, dontLoad)
    {
        if (index < 0 || index >= JSArray.stackView.length)
            return null
        var element = JSArray.stackView[index]
        if (dontLoad !== true) {
            __loadElement(element)
            return element.item
        } else if (element.item) {
            return element.item
        } else {
            return null
        }
    }

    /*! Immediately completes any ongoing transition.
        /sa Animation.complete
      */
    function completeTransition()
    {
        if (__recursionGuard(true))
            return
        if (__currentTransition)
            __currentTransition.animation.complete()
        __recursionGuard(false)
    }

    /********* DEPRECATED API *********/

    /*! \internal
        \deprecated Use Push() instead */
    function replace(item, properties, immediate) {
        push(item, properties, immediate, true)
    }

    /********* PRIVATE API *********/

    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    /*! \internal The currently top-most item on the stack. */
    property Item __currentItem: null
    /*! \internal The number of items currently pushed onto the stack. */
    property int __depth: 0
    /*! \internal Stores the transition info while a transition is ongoing */
    property var __currentTransition: null
    /*! \internal Stops the user from pushing items while preparing a transition */
    property bool __guard: false

    Component.onCompleted: {
        if (initialItem)
            push(initialItem)
    }

    Component.onDestruction: {
        if (__currentTransition)
            __currentTransition.animation.complete()
        __currentItem = null
    }

    /*! \internal */
    function __recursionGuard(use)
    {
        if (use && __guard) {
            console.warn("Warning: StackView: You cannot push/pop recursively!")
            console.trace()
            return true
        }
        __guard = use
    }

    /*! \internal */
    function __loadElement(element)
    {
        if (element.loaded) {
            if (!element.item) {
                element.item = invalidItemReplacement.createObject(root)
                element.item.text = "\nError: The item has been deleted outside StackView!"
            }
            return
        }
        if (!element.itemComponent) {
            element.item = invalidItemReplacement.createObject(root)
            element.item.text = "\nError: Invalid item (item was 'null'). "
                    + "This might indicate that the item was deleted outside StackView!"
            return
        }

        var comp = __resolveComponent(element.itemComponent, element)

        // Assign properties to item:
        if (!element.properties)
            element.properties = {}

        if (comp.hasOwnProperty("createObject")) {
            if (comp.status === Component.Error) {
                element.item = invalidItemReplacement.createObject(root)
                element.item.text = "\nError: Could not load: " + comp.errorString()
            } else {
                element.item = comp.createObject(root, element.properties)
                // Destroy items we create unless the user specified something else:
                if (!element.hasOwnProperty("destroyOnPop"))
                    element.destroyOnPop = true
            }
        } else {
            // comp is already an Item, so just reparent it into the StackView:
            element.item = comp
            element.originalParent = parent
            element.item.parent = root
            for (var prop in element.properties) {
                if (element.item.hasOwnProperty(prop))
                    element.item[prop] = element.properties[prop];
            }
            // Do not destroy items we didn't create, unless the user specified something else:
            if (!element.hasOwnProperty("destroyOnPop"))
                element.destroyOnPop = false
        }

        element.item.Stack.__index = element.index
        element.item.Stack.__stackView = root
        // Let item fill all available space by default:
        element.item.width = Qt.binding(function() { return root.width })
        element.item.height = Qt.binding(function() { return root.height })
        element.loaded = true
    }

    /*! \internal */
    function __resolveComponent(unknownObjectType, element)
    {
        // We need this extra resolve function since we dont really
        // know what kind of object the user pushed. So we try to
        // figure it out by inspecting the object:
        if (unknownObjectType.hasOwnProperty("createObject")) {
            return unknownObjectType
        } else if (typeof unknownObjectType == "string") {
            return Qt.createComponent(unknownObjectType)
        } else if (unknownObjectType.hasOwnProperty("x")) {
            return unknownObjectType
        } else if (unknownObjectType.hasOwnProperty("item")) {
            // INVARIANT: user pushed a JS-object
            element.properties = unknownObjectType.properties
            if (!unknownObjectType.item)
                unknownObjectType.item = invalidItemReplacement
            if (unknownObjectType.hasOwnProperty("destroyOnPop"))
                element.destroyOnPop = unknownObjectType.destroyOnPop
            return __resolveComponent(unknownObjectType.item, element)
        } else {
            // We cannot determine the type, so assume its a URL:
            return Qt.createComponent(unknownObjectType)
        }
    }

    /*! \internal */
    function __cleanup(element) {
        // INVARIANT: element has been removed from JSArray. Destroy its
        // item, or reparent it back to the parent it had before it was pushed:
        var item = element.item
        if (element.destroyOnPop) {
            item.destroy()
        } else {
            // Mark the item as no longer part of the StackView. It
            // might reenter on pop if pushed several times:
            item.visible = false
            __setStatus(item, Stack.Inactive)
            item.Stack.__stackView = null
            item.Stack.__index = -1
            if (element.originalParent)
                item.parent = element.originalParent
        }
    }

    /*! \internal */
    function __setStatus(item, status) {
        item.Stack.__status = status
    }

    /*! \internal */
    function __performTransition(transition)
    {
        // Animate item in "outElement" out, and item in "inElement" in. Set a guard to protect
        // the user from pushing new items on signals that will fire while preparing for the transition
        // (e.g Stack.onCompleted, Stack.onStatusChanged, Stack.onIndexChanged etc). Otherwise, we will enter
        // this function several times, which causes the items to be half-way updated.
        if (__currentTransition)
            __currentTransition.animation.complete()
        __loadElement(transition.inElement)

        transition.name = transition.replace ? "replaceTransition" : (transition.push ? "pushTransition" : "popTransition")
        var enterItem = transition.inElement.item
        transition.enterItem = enterItem

        // Since an item can be pushed several times, we need to update its properties:
        enterItem.parent = root
        enterItem.Stack.__stackView = root
        enterItem.Stack.__index = transition.inElement.index
        __currentItem = enterItem

        if (!transition.outElement) {
            // A transition consists of two items, but we got just one. So just show the item:
            enterItem.visible = true
            __setStatus(enterItem, Stack.Activating)
            __setStatus(enterItem, Stack.Active)
            return
        }

        var exitItem = transition.outElement.item
        transition.exitItem = exitItem
        if (enterItem === exitItem)
             return

        if (root.delegate) {
            transition.properties = {
                "name":transition.name,
                "enterItem":transition.enterItem,
                "exitItem":transition.exitItem,
                "immediate":transition.immediate }
            var anim = root.delegate.getTransition(transition.properties)
            if (anim.createObject) {
                anim = anim.createObject(null, transition.properties)
                anim.runningChanged.connect(function(){ if (anim.running === false) anim.destroy() })
            }
            transition.animation = anim
        }

        if (!transition.animation) {
            console.warn("Warning: StackView: no", transition.name, "found!")
            return
        }
        if (enterItem.anchors.fill || exitItem.anchors.fill)
            console.warn("Warning: StackView: cannot transition an item that is anchored!")

        __currentTransition = transition
        __setStatus(exitItem, Stack.Deactivating)
        enterItem.visible = true
        __setStatus(enterItem, Stack.Activating)
        transition.animation.runningChanged.connect(animationFinished)
        transition.animation.start()
        // NB! For empty animations, "animationFinished" is already
        // executed at this point, leaving __animation === null:
        if (transition.immediate === true && transition.animation)
            transition.animation.complete()
    }

    /*! \internal */
    function animationFinished()
    {
        if (!__currentTransition || __currentTransition.animation.running)
            return

        __currentTransition.animation.runningChanged.disconnect(animationFinished)
        __currentTransition.exitItem.visible = false
        __setStatus(__currentTransition.exitItem, Stack.Inactive);
        __setStatus(__currentTransition.enterItem, Stack.Active);
        __currentTransition.properties.animation = __currentTransition.animation
        root.delegate.transitionFinished(__currentTransition.properties)

        if (!__currentTransition.push || __currentTransition.replace)
            __cleanup(__currentTransition.outElement)

        __currentTransition = null
    }

    /*! \internal */
    property Component invalidItemReplacement: Component {
        Text {
            width: parent.width
            height: parent.height
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }
}
