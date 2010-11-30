import Qt 4.7

Item {
    id: adjoiningVisual
    property int adjoins: 0    // use enum Qt::DockWidgetArea? see http://doc.trolltech.com/4.7/qt.html#DockWidgetArea-enum
    property Item styledItem
    property Component styling

//    Qt::LeftDockWidgetArea	0x1
//    Qt::RightDockWidgetArea	0x2
//    Qt::TopDockWidgetArea	0x4
//    Qt::BottomDockWidgetArea	0x8

    Item {
        anchors.fill: parent

        AdjoiningCorner { corner: "TopLeftCorner"; adjoining: topLeftAdjoining(); styledItem: adjoiningVisual.styledItem }
        AdjoiningCorner { corner: "TopRightCorner"; adjoining: topRightAdjoining(); styledItem: adjoiningVisual.styledItem }
        AdjoiningCorner { corner: "BottomLeftCorner"; adjoining: bottomLeftAdjoining(); styledItem: adjoiningVisual.styledItem }
        AdjoiningCorner { corner: "BottomRightCorner"; adjoining: bottomRightAdjoining(); styledItem: adjoiningVisual.styledItem }
    }

    function topLeftAdjoining() {
        var adjoining = 0;
        if(adjoins&0x01) adjoining |= Qt.Horizontal;
        if(adjoins&0x04) adjoining |= Qt.Vertical;
        return adjoining;
    }

    function topRightAdjoining() {
        var adjoining = 0;
        if(adjoins&0x02) adjoining |= Qt.Horizontal;
        if(adjoins&0x04) adjoining |= Qt.Vertical;
        return adjoining;
    }

    function bottomLeftAdjoining() {
        var adjoining = 0;
        if(adjoins&0x01) adjoining |= Qt.Horizontal;
        if(adjoins&0x08) adjoining |= Qt.Vertical;
        return adjoining;
    }

    function bottomRightAdjoining() {
        var adjoining = 0;
        if(adjoins&0x02) adjoining |= Qt.Horizontal;
        if(adjoins&0x08) adjoining |= Qt.Vertical;
        return adjoining;
    }
}
