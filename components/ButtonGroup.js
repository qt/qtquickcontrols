var self,
    clickHandlers = [], // bindet click handlers (for removing them)
    shadow = [],        // shadow copy of children
    _first,             // holds first index
    _last,              // holds last index
    _direction,
    exclusive;

/**
 * prepares the group behavior for that component
 */

var create = function(that, options) {
    self = that;
    _direction = options.direction || Qt.Horizontal;
    exclusive = self.exclusive|| options.exclusive;
    self.childrenChanged.connect(childrenChanged);
    self.widthChanged.connect(resizeChildren);
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
var destroy = function() {
    self.childrenChanged.disconnect(childrenChanged);
    self.widthChanged.disconnect(resizeChildren);
    cleanup();
}

/**
 * prepare the buttongroup
 */
function build() {
    // copy of children because its not an array. also we need a copy
    shadow = [];
    shadow.length = self.children.length;
    var isCheckedPresent = false;
    for (var i = 0, item; (item = self.children[i]); i++) {
        if (hasChecked(item)) {
            shadow[i] = item;
            _last = i;
            _first = undefined === _first ? i : _first;
            if (item === self.checkedButton) {
                isCheckedPresent = true;
            }
        }
    }
    if (!isCheckedPresent) {
        self.checkedButton = undefined;
    }

    var extraPixels = self.width % shadow.length
    var buttonSize = (self.width-extraPixels) / shadow.length;


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
        }
        if (exclusive && hasChecked(item)) {
            if (item["checkable"]!==undefined) {
                item.checkable = true;
            }
            clickHandlers[i] = function() { checkExclusive(item); }
            item.clicked.connect(clickHandlers[i]);
        }

    });
    resizeChildren();
}

/**
 * cleanup the buttongroup
 */
function cleanup() {
    for (var i = 0, l = shadow.length; i < l; i++) {
        try {
            if (clickHandlers[i]) { shadow[i].clicked.disconnect(clickHandlers[i]); }
        } catch (e) {}
    }
    clickHandlers = [];
}

/**
 * rebuild if buttongroup has changed
 */
function childrenChanged() {
    cleanup();
    build();
}

var resizeChildren = function() {
    if (_direction != Qt.Horizontal) {
        return;
    }

    var extraPixels = self.width % shadow.length
    var buttonSize = (self.width-extraPixels) / shadow.length;
    shadow.forEach(function(item, i) {
        item.width = buttonSize + (extraPixels ? 1 : 0);
        if (extraPixels > 0) {
            extraPixels--;
        }
    });
}

function checkExclusive(item) {
    for (var i = 0, ref; (ref = shadow[i]); i++) {
        ref.checked = item === ref;
    }
    self.checkedButton = item;
}
