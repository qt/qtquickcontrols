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

import QtQuick 2.0
import QtDesktop 1.0
import QtDesktop.Private 1.0
import "Private/PageStack.js" as JSArray

/*!
    \qmlclass QtDesktop.PageStack
    \inherits Item
    \inqmlmodule QtDesktop

    \brief The central component for building page-based applications

    PageStack implements a stack-based navigation model for an application.
    A stack-based navigation model means that "pages" (discrete views of information)
    are pushed onto a stack as the user navigates
    deeper into the application page hierarchy. Similarily, the user can return back to
    previous pages at a later point, which from a stack point of view means popping pages from the
    top of the stack and re-activating them (make them visible on screen).

    Pages can - but do not have to - use \l{Page} as the root item.
    \l{Page} defines a contract for how the page and the page stack works together.
    Namely the page can be notified when it becomes active or inactive
    through the \l{Page::status} {Page.status} property. Status will be
    \c PageStatus.Activating when a
    page is transitioning into being the current page on screen, and \c PageStatus.Active
    once the transition stops. When it leaves the screen, it will be
    \c PageStatus.Deactivating, and then \c PageStatus.Inactive. When the page is
    inactive, it will be hidden.

    \section1 Using PageStack in an Application
    Using the PageStack in the application is typically a simple matter of adding
    the PageStack as a child to e.g the applications top-level
    \l{http://doc.qt.nokia.com/latest/qml-item.html} {Item}. The stack is usually
    anchored to the edges of the window, except at the top or bottom where it might
    be anchored to a status bar, or some other similar UI component.
    The stack can then be used by invoking its navigation methods. The first page
    to show in the PageStack is commonly loaded assigning it to \l initialPage.

    \section1 Basic Navigation
    There are three primary navigation operations in PageStack: push(), pop() and
    replace (you replace by specifying argument \c replace to push()).
    These correspond to classic stack operations where "push" adds a page to the
    top of a stack, "pop" removes the top page from the stack, and "replace" is like a
    pop followed by a push in that it replaces the topmost page on the stack with
    a new page (but the applied transtition might be different). The topmost page
    in the stack corresponds to the one that is \l{PageStack::currentPage} {current},
    i.e. the one that is visible on
    screen. That means that "push" is the logical equivalent of navigating forward or
    deeper into the application, "pop" is the equivalent of navigation back and
    "replace" is the equivalent of replacing the current page with a different page.

    Sometimes it is necessary to go back more than a single step in the stack, e.g.
    to return to a "main" page or some kind of section page in the application.
    For this use case, pop() can be provided with a page to pop to. This is called
    an "unwind" operation as the stack gets unwound to the specified page. If the
    page is not found then the stack unwinds until there is only a single page in
    the stack, which becomes the current page. To explicitly unwind to the bottom
    of the stack it is recommended to use \l{pop()} {pop(null)}, though technically any
    non-existent page will do.

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
    depth 1 or 0 is a no-operation. If removing all pages from the stack is
    needed, a separate function clear() is available.

    Calling push() returns the page that was pushed onto the stack.
    Calling pop() returns the page that was popped off the stack. When pop() is
    called in an unwind operation the top-most page (the first page that was
    popped, which will also be the one transitioning out) is returned.

    \section1 Deep Linking
    Deep linking means launching an application into a particular state. For example
    a Newspaper application could be launched into showing a particular article,
    bypassing the front page (and possible a section page) that would normally have
    to be navigated through to get to the article in question. In terms of page
    stacks deep linking means the ability to modify the state of the stack so that
    you e.g. push a set of pages to the top of the stack, or that you completely reset
    the stack to a given state.

    The API for deep linking in PageStack is the same as for basic navigation. If
    you push an array instead of a single page then all the pages in that array will
    be pushed onto the stack. The transition animation, however, will be conducted as
    if only the last page in the array was pushed onto the stack. The normal semantics
    of push() apply for deep linking, meaning that push() adds whatever you push onto
    the stack. Note also that only the last item in the array will actually be loaded
    (in case of a \l{http://doc.qt.nokia.com/latest/qml-url.html}{URL} or
    \l{http://doc.qt.nokia.com/latest/qml-component.html}{Component}).
    The rest will be lazy loaded as needed when entering
    the screen upon subsequent calls to pop (or when requesting the page by using \a get).

    This gives us the following result, given the stack [A, B, C]:

    \list
    \li \l{push()}{push([D, E, F])} => [A, B, C, D, E, F] - "push" transition animation between C and F
    \li \l{push()}{push([D, E, F], replace)} => [A, B, D, E, F] - "replace" transition animation between C and F
    \li clear(); \l{push()}{push([D, E, F])} => [D, E, F] - no transition animation (since the stack was empty)
    \endlist

    \section1 Pushing pages

    A page you push onto the PageStack can be either a \l Page, a \l{http://doc.qt.nokia.com/latest/qml-url.html}{URL}, a
    string with a URL, an \l{http://doc.qt.nokia.com/latest/qml-item.html}{Item}, or a
    \l{http://doc.qt.nokia.com/latest/qml-component.html}{Component}. To push it, you assign it
    to a property "page" inside a property list, and send it as argument to \l{PageStack::push}{push}:

    \code
    pageStack.push({page: yourPage})
    \endcode

    The list can contain several properties that controls how the page should be pushed:
    \list
    \li \c page: This property is required, and holds the page you want to push.
    \li \c properties: You can set a property list of QML properties that should be assigned
        to the page upon push. These properties will be copied into the page at the
        time the page is loaded, or about to become the current page (normally upon push).
    \li \c immediate: Set this property to \c true to skip transition effects. When pushing
        an array, you only need to set this property on the first element to make the
        whole operation immediate.
    \li \c replace: Set this property to replace the current page on the stack. When pushing
        an array, you only need to set this property on the first element to replace
        as many elements on the stack as inside the array.
    \li \c destroyOnPop: Set this property to be explicit to whether or not PageStack should
        destroy the page when its popped off the stack. By default (if \a destroyOnPop is
        not specified), PageStack will destroy pages pushed as components or URLs. Pages
        not destroyed will be reparented back to the original parents they had before being
        pushed onto the stack, and hidden. If you need to set this property, do it with
        care, so that pages are not leaked.
    \endlist

    If the only argument needed is "page", you can also, as a short-hand
    notation, do:

    \code
    pageStack.push(yourPage).
    \endcode

    You can push several pages in one go by using an array of property lists. This is
    optimizing compared to pushing pages one by one, since PageStack then can load only the
    last page in the list. The rest will be loaded as they are about to become
    the current page (which happends when the stack is popped). The following example shows how
    to push an array of pages:

    \code
    pageStack.push([{page: yourPage1}, {page: yourPage2}])
    \endcode

    If inline pages/items are pushed, the page gets re-parented into an internal
    container in the PageStack. When the page is later popped off, it gets
    re-parented back to its original owner. If, however, a page is pushed
    as a component or a URL, the actual page will be created as a page from that component. This
    happens automatically when the page is about to become the current page in the stack. Ownership
    over the item will then normally be taken by the PageStack. It will as such automatically
    destroy the page when it is later popped off. The component that declared the page, by
    contrast, remains in the ownership of the application and is not destroyed by the page stack.
    You can override this behavior if needed by explicitly setting "destroyOnPop" in the list
    argument given to push.

    If you specify the \c properties property to push, these properties will be copied into
    the page at the time the page is loaded (in case of a component or URL), or instead when
    its about to become the current page (in case of an inline item). This normally happends when
    the page is pushed. The following example shows how this can be done:

    \code
    pageStack.push({page: examplePage, properties: {fgcolor: "red", bgcolor: "blue"}});
    \endcode

    Note that if a page is declared in an item that is destroyed - even if a component
    was used - then that page also gets destroyed.
    This follows normal Qt parent-child destruction rules but sometimes comes as a surprise
    for developers. In practice this means that if you declare a page B as a child of
    page A and then do a replace from page A to page B, then page B will be destroyed when
    page A was destroyed (as it was popped off the stack) and the application will effectively
    be switching to a page that has been destroyed.

    \section1 Lifecycle
    The page lifecycle goes from instantiation to inactive, activating, active, deactivating,
    inactive, and when no longer needed, destruction.
    It can move any number of times between inactive and active. When a page is activated,
    it's visible on the screen and is considered to be the current item. A page
    in a page stack that is not visible is not activated, even if the page is currently the
    top-most page in the stack. When the stack becomes visible the page that is top-most gets
    activated. Likewise if the page stack is then hidden the top-most page would be deactivated.
    Popping the page off the top of the stack at this point would not result in further
    deactivation since the page is not active.

    There is a \l{Page::status}{status} property that tracks the lifecycle. The value of status is
    an enumeration with values \c PageStatus.Inactive, \c PageStatus.Activating, \c PageStatus.Active
    and \c PageStatus.Deactivating. Combined with the normal \c Component.onComplete and
    \c Component.onDestruction signals the entire lifecycle is thus:

    \list
    \li Created: Component.onCompleted()
    \li Activating: onStatusChanged (status is PageStatus.Activating)
    \li Acivated: onStatusChanged (status is PageStatus.Active)
    \li Deactivating: onStatusChanged (status is PageStatus.Deactivating)
    \li Deactivated: onStatusChanged (status is PageStatus.Inactive)
    \li Destruction: Component.onDestruction()
    \endlist

    \section1 Finding Pages
    Sometimes it is necessary to search for a page, e.g. in order to unwind the stack to
    a page to which the application does not have a reference. This is facilitated using a
    function find() in the page stack. The find() function takes a callback function as its
    only argument. The callback gets invoked for each page in the stack (starting at the top).
    If the callback returns true then it signals that a match has been found and the find()
    function returns that page. If the callback fails to return true (i.e. no match is found)
    then find() returns \c null.

    The code below searches for a page in the stack that has a name "foo" and then unwinds to
    that page. Note that since find() returns null if no page is found and since pop unwinds to
    the bottom of the stack if null is given as the target page, the code works well even in the
    case that no matching page was found.

    \code
    pageStack.pop(pageStack.find(function(page) {
        return page.name == "foo";
    }));
    \endcode

    You can also get to a page in the page stack using get(index). You should use
    this function if your page depends on another page in the stack, as the function will
    ensure that the page at the given index gets loaded before it is returned.

    \code
    previousPage = pageStack.get(myPage.index - 1));
    \endcode

    \section1 Transitions

    A transition is performed whenever a page is pushed or popped, and consists of
    two pages: enterPage and exitPage. The pagestack itself will never move pages
    around, but instead delegate the job to an external animation set by the style
    or the application developer. How pages should visually enter and leave the stack
    is therefore completely controlled from the outside.

    When the transition starts, the pagestack will search for an animation that
    matches the operation executed. There are three animations to choose
    from: pushAnimation, popAnimation, and replaceAnimation. Each implements how
    enterPage should animate in, and exitPage out. The animations are
    collected inside a PageTransition object assigned to
    \l {PageStack::pageTransition}{pageTransition}. By default, popAnimation and
    replaceAnimation will be the same as PushAnimation, unless you set them
    to something else.

    A simple fade transition could be implemented as:

    \qml
    PageStack {
        pageTransition: PageTransition {
            function cleanupAnimation(properties)
            {
                properties.exitPage.opacity = 1
            }

            property Component pushAnimation: PageAnimation {
                PropertyAnimation {
                    target: enterPage
                    property: "opacity"
                    from: 0
                    to: 1
                }
                PropertyAnimation {
                    target: exitPage
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }
    }
    \endqml

    PushAnimation needs to inherit from PageAnimation, which is a ParallelAnimation that
    contains the properties \c enterPage and \c exitPage. You set the target of your
    inner animations to those pages. Since the same page instance can be pushed several
    times to a pagestack, and since pages also can override transitions, your PageTransition
    always need to override
    \l {PageTransition::cleanupAnimation(properties)}{PageTransition.cleanupAnimation(properties)}.
    Implement this function to reset any properties animated on the exitPage so that later
    transitions can expect the pages to be in a default state.

    A more complex example could look like the following. Here, the pages slides in lying on the side before
    they are rotated up in an upright position:

    \qml
    PageStack {
        pageTransition: PageTransition {
            function cleanupAnimation(properties)
            {
                properties.exitPage.x = 0
                properties.exitPage.rotation = 0
            }

            property Component pushAnimation: PageAnimation {
                SequentialAnimation {
                    ScriptAction {
                        script: enterPage.rotation = 90
                    }
                    PropertyAnimation {
                        target: enterPage
                        property: "x"
                        from: enterPage.width
                        to: 0
                    }
                    PropertyAnimation {
                        target: enterPage
                        property: "rotation"
                        from: 90
                        to: 0
                    }
                }
                PropertyAnimation {
                    target: exitPage
                    property: "x"
                    from: 0
                    to: -exitPage.width
                }
            }
        }
    }
    \endqml

    A single Page can also override the transition to use when itself is pushed or popped. This can
    be done by just assigning another PageTransition object to \l{Page::pageTransition}{Page.pageTransition}.

    \section2 Advanced usage

    After PageStack finds the correct transition to use (it first checks
     \l{Page::pageTransition}{Page.pageTransition}, then \l {PageStack::pageTransition}{pageTransition})
    it calls \l {PageTransition::getAnimation(properties)}{PageTransition.getAnimation(properties)}.
    The base implementation of this function just looks for a property named \c properties.name inside
    itself (root), which is how it finds \c {property Component pushAnimation} in the examples above.

    \code
    function getAnimation(properties)
    {
        return root[properties.name]
    }
    \endcode

    You can override this function for your transition if you need extra logic to decide which
    animation to run. You could for example introspect the pages, and return different animations
    depending on the their internal state. PageStack will expect you to return a Component that
    contains a PageAnimation, or a PageAnimation directly. The former is easier, as PageStack will
    then create the animation and later destroy it when it's done, while avoiding any sideeffects
    caused by the animation being alive long after it ran. Returning a PageAnimation directly
    can be useful if you need to write some sort of animation caching for performance reasons.
    As an optimization, you can also return \c null to signal that you just want to show/hide the pages
    immediately without creating or running any animations.

    \c properties contains the same properties that will be assigned to the PageAnimation object by
    PageStack. In fact, you can add more properties to this object during the call
    if you need to initialize additional properties of your custom PageAnimation when the returned
    component is instanciated.

    The following example shows how you can decide run-time which animation to use:

    \qml
    PageTransition {
        function getAnimation(properties)
        {
            return (properties.enterPage.index % 2) ? horizontalAnimation : verticalAnimation
        }

        function cleanupAnimation(properties)
        {
            properties.exitPage.x = 0
            properties.exitPage.y = 0
        }

        property Component horizontalAnimation: PageAnimation {
            PropertyAnimation {
                target: enterPage
                property: "x"
                from: target.width
                to: 0
                duration: 300
            }
            PropertyAnimation {
                target: exitPage
                property: "x"
                from: 0
                to: target.width
                duration: 300
            }
        }

        property Component verticalAnimation: PageAnimation {
            PropertyAnimation {
                target: enterPage
                property: "y"
                from: target.height
                to: 0
                duration: 300
            }
            PropertyAnimation {
                target: exitPage
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

    /*! \qmlproperty int QtQuickComponents.Mt1.0::PageStack::depth
        \readonly
        The number of pages currently pushed onto the stack.
    */
    readonly property alias depth: root.__depth

    /*! \qmlproperty Item QtQuickComponents.Mt1.0::PageStack::currentPage
        \readonly
        The currently top-most page in the stack.
    */
    readonly property alias currentPage: root.__currentPage

    /*! The first \l Page that should be shown when the PageStack is created.
        \a initialPage can take same value as the first argument to \l{PageStack::push()}
        {PageStack.push()}. Note that this is just a convenience for writing
        \c{Component.onCompleted: pageStack.push(myInitialPage)}

        Examples:

        \list
        \li initialPage: Qt.resolvedUrl("MyPage.qml")
        \li initialPage: myItem
        \li initialPage: {"page" : Qt.resolvedUrl("MyPage.qml"), "properties" : {"color" : "red"}}
        \endlist
        \sa push
    */
    property variant initialPage: null

    /*! \readonly
        \a busy is \c true if a page transition is running, and \c false otherwise. */
    readonly property bool busy: __currentTransition !== null

    /*! The animations to use for page transitions.
        For better understanding on how to apply custom page transitions, read \l{Transitions}.
        \sa {Page::animations}{Page.transitions} */
    property PageTransition pageTransition: PageSlideTransition {}

    /*! Pushes a page onto the stack. The function takes a property list as argument, which
        should contain one or more of the following properties:
        \list
        \li \c page: This property is required, and holds the page you want to push.
            It can be a \l Page, a \l{http://doc.qt.nokia.com/latest/qml-url.html}{URL}, a string with a
            URL, an \l{http://doc.qt.nokia.com/latest/qml-item.html}{Item}, a
            \l{http://doc.qt.nokia.com/latest/qml-component.html}{Component}.
        \li \c properties: You can set a property list of QML properties that should be assigned
            to the page upon push. These properties will be copied into the page at the
            time the page is loaded (in case of a component or URL), or else the first time it
            becomes the current page (normally upon push).
        \li \c immediate: Set this property to \c true to skip transition effects. When pushing
            an array, you only need to set this property on the first element to make the
            whole operation immediate.
        \li \c replace: Set this property to replace the current page on the stack. When pushing
            an array, you only need to set this property on the first element to replace
            as many elements on the stack as inside the array.
        \li \c destroyOnPop: Set this property to be explicit to whether or not PageStack should
            destroy the page when its popped off the stack. By default (if \a destroyOnPop is
            not specified), PageStack will destroy pages pushed as components or URLs. Pages
            not destroyed will be reparented back to the original parents they had before being
            pushed onto the stack, and hidden. If you need to set this property, do it with
            care, so that pages are not leaked.
        \endlist

        You can also push an array of pages (property lists) if you need to push several pages
        in one go. A transition will then only occur between the current page and the last
        page in the list. The other pages will be deferred loaded until needed.

        Examples:
        \list
        \li pageStack.push({page:aPage})
        \li pageStack.push({page:aURL, immediate: true, replace: true})
        \li pageStack.push({page:aRectangle, properties:{color:"red"}})
        \li pageStack.push({page:aComponent, properties:{color:"red"}})
        \li pageStack.push({page:aComponent.createObject(), destroyOnPop:true})
        \li pageStack.push([{page:aPage, immediate:true}, {page:aURL}])
        \endlist

        Note: If the only argument needed is "page", you can also, as a short-hand
        notation, do: \c{pageStack.push(aPage)}.

        Returns the page that became current.

        \sa initialPage
        \sa {Pushing pages}
    */
    function push(page) {
        // Note: we support two different APIs in this function; The old meego API, and
        // the new "property list" API. Hence the reason for hiding the fact that you
        // can pass more arguments than shown in the signature:
        if (__recursionGuard(true))
            return
        var properties = arguments[1]
        var immediate = arguments[2]
        var replace = arguments[3]
        var arrayPushed = (page instanceof Array)
        var firstPage = arrayPushed ? page[0] : page
        immediate = (immediate || JSArray.pageStack.length === 0)

        if (firstPage && firstPage.page && firstPage.hasOwnProperty("x") === false) {
            // Property list API used:
            immediate = immediate || firstPage.immediate
            replace = replace || firstPage.replace
        }

        // Create, and push, a new javascript object, called "element", onto the stack.
        // This element contains all the information necessary to construct the page, and
        // will, after loaded, also contain the loaded page:
        if (arrayPushed) {
            if (page.length === 0)
                return
            var outElement = replace ? JSArray.pop() : JSArray.current()
            for (var i=0; i<page.length; ++i)
                JSArray.push({"pageComponent" : page[i], loaded: false, index: __depth, properties: properties});
        } else {
            outElement = replace ? JSArray.pop() : JSArray.current()
            JSArray.push({"pageComponent" : page, loaded: false, index: __depth, properties: properties})
        }

        var currentElement = JSArray.current()
        var transition = {
            inElement: currentElement,
            outElement: outElement,
            transitionElement: currentElement,
            immediate: immediate,
            replace: replace,
            push: true
        }
        __performPageTransition(transition)
        __recursionGuard(false)
        return __currentPage
    }

    /*! Pops one or more pages off the stack. The function takes a property list as argument
        which can contain one or more of the following properties:
        \list
        \li \c page: If specified, all pages down to (but not including) \a page will be
            popped off. if \a page is \c null, all pages down to (but not including) the
            first page will be popped. If not specified, only the current page will be
            popped.
        \li \c immediate: Set this property to \c true to skip transition effects.
        \endlist

        Examples:
        \list
        \li pageStack.pop()
        \li pageStack.pop({page:somePage, immediate: true})
        \li pageStack.pop({immediate: true})
        \li pageStack.pop(null)
        \endlist

        Note: If the only argument needed is "page", you can also, as a short-hand
        notation, do: \c{pageStack.pop(aPage)}.

        Returns the page that was popped off
        \sa clear()
    */
    function pop(page) {
        if (__depth <= 1)
            return null
        if (page && page.hasOwnProperty("x") === false) {
            // Property list API used:
            var immediate = (page.immediate === true)
            page = page.page
        } else {
            immediate = (arguments[1] === true)
        }

        if (page === __currentPage)
            return

        if (__recursionGuard(true))
            return

        var outElement = JSArray.pop()
        var transitionElement = outElement
        var inElement = JSArray.current()

        if (__depth > 1 && page !== undefined && page !== inElement.page) {
            // Pop from the top until we find 'page', and return the corresponding
            // element. Skip all non-loaded pages (except the first), since no one
            // has any references to such pages anyway:
            while (__depth > 1 && !JSArray.current().loaded)
                JSArray.pop()
            inElement = JSArray.current()
            while (__depth > 1 && page !== inElement.page) {
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
            transitionElement: transitionElement,
            immediate: immediate,
            replace: false,
            push: false
        }
        __performPageTransition(transition)
        __recursionGuard(false)
        return outElement.page;
    }

    /*! Remove all pages from the stack. No animations will be applied. */
    function clear() {
        if (__recursionGuard(true))
            return
        if (__currentTransition)
            __currentTransition.animation.complete()
        __currentPage = null
        var count = __depth
        for (var i=0; i<count; ++i) {
            var element = JSArray.pop()
            if (element.page)
                __cleanup(element);
        }
        __recursionGuard(false)
    }

    /*! Search for a specific page inside the stack. \a func will
        be called for each page in the stack (with the page as argument)
        until the function returns true. Return value will be the page found. E.g:
        find(function(page, index) { return page.isTheOne })
        Set \a onlySearchLoadedPages to \c true to not load pages that are
        not loaded into memory */
    function find(func, onlySearchLoadedPages) {
        for (var i=__depth-1; i>=0; --i) {
            var element = JSArray.pageStack[i];
            if (onlySearchLoadedPages !== true)
                __loadElement(element)
            else if (!element.page)
                continue
            if (func(element.page))
                return element.page
        }
        return null;
    }

    /*! Returns the page at position \a index in
        the page stack. If \a dontLoad is true, the
        page will not be forced to load (and \c null
        will be returned if not yet loaded) */
    function get(index, dontLoad)
    {
        if (index < 0 || index >= JSArray.pageStack.length)
            return null
        var element = JSArray.pageStack[index]
        if (dontLoad !== true) {
            __loadElement(element)
            return element.page
        } else if (element.page) {
            return element.page
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
    function replace(page, properties, immediate) {
        push(page, properties, immediate, true)
    }

    /********* PRIVATE API *********/

    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    /*! \internal The currently top-most page in the stack. */
    property Item __currentPage: null
    /*! \internal The number of pages currently pushed onto the stack. */
    property int __depth: 0
    /*! \internal Stores the transition info while a transition is ongoing */
    property var __currentTransition: null
    /*! \internal Stops the user from pushing pages while preparing a transition */
    property bool __guard: false

    /*! \internal */
    Component.onCompleted: {
        if (initialPage)
            push(initialPage)
    }

    /*! \internal */
    Component.onDestruction: {
        if (__currentTransition)
            __currentTransition.animation.complete()
        __currentPage = null
    }

    /*! \internal */
    function __recursionGuard(use)
    {
        if (use && __guard) {
            console.warn("Warning: PageStack: You cannot push/pop recursively!")
            console.trace()
            return true
        }
        __guard = use
    }

    /*! \internal */
    function __loadElement(element)
    {
        if (element.loaded) {
            if (!element.page) {
                element.page = invalidPageReplacement.createObject(root)
                element.page.text = "\nError: The page has been deleted outside PageStack!"
            }
            return
        }
        if (!element.pageComponent) {
            element.page = invalidPageReplacement.createObject(root)
            element.page.text = "\nError: Invalid page (page was 'null'). "
                    + "This might indicate that the page was deleted outside PageStack!"
            return
        }

        var comp = __resolvePageComponent(element.pageComponent, element)

        // Assign properties to Page:
        if (!element.properties)
            element.properties = {}
        element.properties.__index = element.index
        element.properties.__pageStack = root

        if (comp.hasOwnProperty("createObject")) {
            if (comp.status === Component.Error) {
                element.page = invalidPageReplacement.createObject(root)
                element.page.text = "\nError: Could not load: " + comp.errorString()
            } else {
                element.page = comp.createObject(root, element.properties)
                // Destroy pages we create unless the user specified something else:
                if (!element.hasOwnProperty("destroyOnPop"))
                    element.destroyOnPop = true
            }
        } else {
            // comp is already an Item, so just reparent it into the pagestack:
            element.page = comp
            element.originalParent = parent
            element.page.parent = root
            for (var prop in element.properties) {
                if (element.page.hasOwnProperty(prop))
                    element.page[prop] = element.properties[prop];
            }
            // Do not destroy pages we didn't create, unless the user specified something else:
            if (!element.hasOwnProperty("destroyOnPop"))
                element.destroyOnPop = false
        }

        delete element.properties.__index
        delete element.properties.__pageStack
        element.loaded = true
    }

    /*! \internal */
    function __resolvePageComponent(unknownObjectType, element)
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
        } else if (unknownObjectType.hasOwnProperty("page")) {
            // INVARIANT: user pushed a JS-object
            element.properties = unknownObjectType.properties
            if (!unknownObjectType.page)
                unknownObjectType.page = invalidPageReplacement
            if (unknownObjectType.hasOwnProperty("destroyOnPop"))
                element.destroyOnPop = unknownObjectType.destroyOnPop
            return __resolvePageComponent(unknownObjectType.page, element)
        } else {
            // We cannot determine the type, so assume its a URL:
            return Qt.createComponent(unknownObjectType)
        }
    }

    /*! \internal */
    function __cleanup(element) {
        // INVARIANT: element has been removed from JSArray. Destroy its
        // page, or reparent it back to the parent it had before it was pushed:
        var page = element.page
        if (element.destroyOnPop) {
            page.destroy()
        } else {
            // Mark the page as no longer part of the PageStack. It
            // might reenter on pop if pushed several times:
            page.visible = false
            __setPageStatus(page, PageStatus.Inactive)
            if (page.hasOwnProperty("__pageStack"))
                page.__pageStack = null
            if (page.hasOwnProperty("__index"))
                page.__index = -1
            if (element.originalParent)
                page.parent = element.originalParent
        }
    }

    /*! \internal */
    function __setPageStatus(page, status) {
        if (page.hasOwnProperty("__status"))
            page.__status = status
    }

    /*! \internal */
    function __performPageTransition(transition)
    {
        // Animate page in "outElement" out, and page in "inElement" in. Set a guard to protect
        // the user from pushing new pages on signals that will fire while preparing for the transition
        // (e.g Page.onCompleted, Page.onStatusChanged, Page.onIndexChanged etc). Otherwise, we will enter
        // this function several times, which causes the pages to be half-way updated.
        if (__currentTransition)
            __currentTransition.animation.complete()
        __loadElement(transition.inElement)

        transition.name = transition.replace ? "replaceAnimation" : (transition.push ? "pushAnimation" : "popAnimation")
        var enterPage = transition.inElement.page
        transition.enterPage = enterPage

        // Since a page can be pushed several times, we need to update its properties:
        enterPage.parent = root
        if (enterPage.hasOwnProperty("__pageStack"))
            enterPage.__pageStack = root
        if (enterPage.hasOwnProperty("__index"))
            enterPage.__index = transition.inElement.index
        __currentPage = enterPage

        if (!transition.outElement) {
            // A transition consists of two pages, but we got just one. So just show the page:
            enterPage.visible = true
            __setPageStatus(enterPage, PageStatus.Activating)
            __setPageStatus(enterPage, PageStatus.Active)
            return
        }

        var exitPage = transition.outElement.page
        transition.exitPage = exitPage
        if (enterPage === exitPage)
             return

        __searchForAnimationIn(transition.transitionElement.page, transition)
        if (!transition.animation)
            __searchForAnimationIn(root, transition)
        if (!transition.animation) {
            console.warn("Warning: PageStack: no", transition.name, "found!")
            return
        }

        if (enterPage.anchors.fill || exitPage.anchors.fill)
            console.warn("Warning: PageStack: cannot transition a page that is anchored!")

        __currentTransition = transition
        __setPageStatus(exitPage, PageStatus.Deactivating)
        enterPage.visible = true
        __setPageStatus(enterPage, PageStatus.Activating)
        transition.animation.runningChanged.connect(animationFinished)
        transition.animation.start()
        // NB! For empty animations, "animationFinished" is already
        // executed at this point, leaving __animation === null:
        if (transition.immediate === true && transition.animation)
            transition.animation.complete()
    }

    /*! \internal */
    function __searchForAnimationIn(obj, transition)
    {
        var t = obj.pageTransition
        if (t) {
            transition.pageTransition = t
            transition.properties = {
                "name":transition.name,
                "enterPage":transition.enterPage,
                "exitPage":transition.exitPage,
                "immediate":transition.immediate }
            var anim = t.getAnimation(transition.properties)
            if (anim.createObject) {
                anim = anim.createObject(null, transition.properties)
                anim.runningChanged.connect(function(){ if (anim.running === false) anim.destroy() })
            }
            transition.animation = anim
        }
    }

    /*! \internal */
    function animationFinished()
    {
        if (!__currentTransition || __currentTransition.animation.running)
            return

        __currentTransition.animation.runningChanged.disconnect(animationFinished)
        __currentTransition.exitPage.visible = false
        __setPageStatus(__currentTransition.exitPage, PageStatus.Inactive);
        __setPageStatus(__currentTransition.enterPage, PageStatus.Active);
        __currentTransition.properties.animation = __currentTransition.animation
        __currentTransition.pageTransition.cleanupAnimation(__currentTransition.properties)

        if (!__currentTransition.push || __currentTransition.replace)
            __cleanup(__currentTransition.outElement)

        __currentTransition = null
    }

    /*! \internal */
    property Component invalidPageReplacement: Component {
        Text {
            width: parent.width
            height: parent.height
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }
}

