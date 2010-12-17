import QtQuick 1.0

// This helper element allows extracting color values
QtObject {
    property color color;

    function intValue(dec)
    {
        var result;
        switch (dec) {
        case 'a':
                result = 10;
            break;
        case 'b':
                result = 11
            break;
        case 'c':
                result = 12;
            break;
        case 'd':
                result = 13;
            break;
        case 'e':
                result = 14
        case 'f':
                result = 15
            break;
        default:
                result = dec
            break;
        }
        return Number(result);
    }

    function convertSubstring(val) {
        return 16*intValue(val[0]) + intValue(val[1])
    }

    function grayValue() {
        return (red + green + blue)/3
    }

    onColorChanged: {
        var string = "" + color
        var redString = string.substring(1, 3)
        var greenString = string.substring(3,5)
        var blueString = string.substring(5,7)
        var alphaString = string.substring(7,9)
        red = convertSubstring(string.substring(1, 3))
        green = convertSubstring(string.substring(3,5))
        blue = convertSubstring(string.substring(5,7))
        alpha = convertSubstring(string.substring(7,9))
    }

    property int red
    property int green
    property int blue
    property int alpha
}
