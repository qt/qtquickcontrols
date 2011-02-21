var self;
var clickHandlers = [];
var visibleButtons = [];
var nonVisibleButtons = [];
var direction;
var exclusive;

function create(that, options) {
    self = that;
    direction = options.direction || Qt.Horizontal;
    exclusive = self.exclusive|| options.exclusive;
    self.childrenChanged.connect(rebuild);
//    self.widthChanged.connect(resizeChildren);
    build();
}

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

function destroy() {
    self.childrenChanged.disconnect(rebuild);
//    self.widthChanged.disconnect(resizeChildren);
    cleanup();
}

function build() {
    visibleButtons = [];
    nonVisibleButtons = [];

    for (var i = 0, item; (item = self.children[i]); i++) {
        if (!hasChecked(item))
            continue;

        item.visibleChanged.connect(rebuild); // Not optimal, but hardly a bottleneck in your app
        if (!item.visible) {
            nonVisibleButtons.push(item);
            continue;
        }
        visibleButtons.push(item);

        if (exclusive && hasChecked(item)) {
            if (item["checkable"]!==undefined) {
                item.checkable = true;
            }
            clickHandlers[i] = checkExclusive(item);
            item.clicked.connect(clickHandlers[i]);
        }
    }

    if (self.checkedButton && !self.checkedButton.visible)
        self.checkedButton = undefined;

    var nrButtons = visibleButtons.length;
    if (nrButtons == 0)
        return;

    if (nrButtons == 1) {
        finishButton(visibleButtons[0], "only");
    } else {
        finishButton(visibleButtons[0], direction == Qt.Horizontal ? "leftmost" : "top");
        for (var i = 1; i < nrButtons - 1; i++)
            finishButton(visibleButtons[i], direction == Qt.Horizontal ? "h_middle": "v_middle");
        finishButton(visibleButtons[nrButtons - 1], direction == Qt.Horizontal ? "rightmost" : "bottom");
    }
}

function finishButton(button, position) {
    if (isButton(button)) {
        button.__position = position;
        if (direction == Qt.Vertical) {
            button.anchors.left = self.left
            button.anchors.right = self.right
        }
    }
}

function cleanup() {
    visibleButtons.forEach(function(item, i) {
        if (clickHandlers[i])
            item.clicked.disconnect(clickHandlers[i]);
        item.visibleChanged.disconnect(rebuild);
    });
    clickHandlers = [];

    nonVisibleButtons.forEach(function(item, i) {
        item.visibleChanged.disconnect(rebuild);
    });
}

function rebuild() {
    cleanup();
    build();
}

function resizeChildren() {
    if (direction != Qt.Horizontal)
        return;

    var extraPixels = self.width % visibleButtons;
    var buttonSize = (self.width - extraPixels) / visibleButtons;
    visibleButtons.forEach(function(item, i) {
        if (!item || !item.visible)
            return;
        item.width = buttonSize + (extraPixels > 0 ? 1 : 0);
        if (extraPixels > 0)
            extraPixels--;
    });
}

function checkExclusive(item) {
    var button = item;
    return function() {
        for (var i = 0, ref; (ref = visibleButtons[i]); i++) {
            ref.checked = button === ref;
        }
        self.checkedButton = button;
    }
}
