var self,
    clickHandlers = [], // bindet click handlers (for removing them)
    shadow = [],        // shadow copy of children
    visibleButtons,
    _first,             // holds first index
    _last,              // holds last index
    _direction,
    exclusive;

/**
 * prepares the group behavior for that component
 */

function create(that, options) {
    self = that;
    _direction = options.direction || Qt.Horizontal;
    exclusive = self.exclusive|| options.exclusive;
    self.childrenChanged.connect(childrenChanged);
//    self.widthChanged.connect(resizeChildren);
    build();
}

// fun is taken from qt-components
// "duck-typing" to identify the Buttons, find a better way to do it :-P
function isButton(item) {
    if (item && item["__position"] !== undefined)
        return true;
    return false;
}

function hasChecked(item) {
    if (item && item["checked"] !== undefined)
        return true;
    return false;
}

/**
 * Destroy behavior for that component
 */
function destroy() {
    self.childrenChanged.disconnect(childrenChanged);
//    self.widthChanged.disconnect(resizeChildren);
    cleanup();
}

/**
 * prepare the buttongroup
 */
function build() {
    // copy of children because its not an array. also we need a copy
    shadow = [];
    shadow.length = self.children.length;
    visibleButtons = 0;
    _first = undefined;
    _last = 0;
    var isCheckedPresent = false;
    for (var i = 0, item; (item = self.children[i]); i++) {
        if (hasChecked(item)) {
            shadow[i] = item;
            if (item.visible) {
                if (_first === undefined)
                    _first = i;
                _last = i;
                visibleButtons = visibleButtons + 1;
            }
            if (item === self.checkedButton) {
                isCheckedPresent = true;
            }
        }
    }
    if (!isCheckedPresent) {
        self.checkedButton = undefined;
    }

    shadow.forEach(function(item, i) {
        if (isButton(item) ) {
            item.__position = _first===_last ?
                                        "only":
                             _first === i ?
                                        (_direction == Qt.Horizontal ? "leftmost" : "top")  :
                             _last === i ?
                                        (_direction == Qt.Horizontal ? "rightmost" : "bottom") :
                                        (_direction == Qt.Horizontal ? "h_middle": "v_middle"); // middle

            if (self.width > 0) { // fixed: ASGARD-18
                if (_direction == Qt.Vertical) {
                    item.anchors.left = self.left
                    item.anchors.right = self.right
                }
            }
            item.visibleChanged.connect(childrenChanged);
        }
        if (exclusive && hasChecked(item)) {
            if (item["checkable"]!==undefined) {
                item.checkable = true;
            }
            clickHandlers[i] = function() { checkExclusive(item); }
            item.clicked.connect(clickHandlers[i]);
        }

    });
}

/**
 * cleanup the buttongroup
 */
function cleanup() {
    shadow.forEach(function(item, i) {
        if (item) {
            if (clickHandlers[i])
                item.clicked.disconnect(clickHandlers[i]);
            if (isButton(shadow[i]))
                item.visibleChanged.disconnect(childrenChanged);
        }
    });
    clickHandlers = [];
}

/**
 * rebuild if buttongroup has changed
 */
function childrenChanged() {
    cleanup();
    build();
}

function resizeChildren() {
    if (_direction != Qt.Horizontal)
        return;

    console.log("resizeChildren");
    var extraPixels = self.width % visibleButtons;
    var buttonSize = (self.width - extraPixels) / visibleButtons;
    shadow.forEach(function(item, i) {
        if (!item || !item.visible)
            return;
        item.width = buttonSize + (extraPixels > 0 ? 1 : 0);
        if (extraPixels > 0)
            extraPixels--;
    });
}

function checkExclusive(item) {
    for (var i = 0, ref; (ref = shadow[i]); i++) {
        ref.checked = item === ref;
    }
    self.checkedButton = item;
}
