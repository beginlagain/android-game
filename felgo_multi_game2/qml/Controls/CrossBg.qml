import QtQuick 2.0

Item {
    id:item
    height:size
    width:size

    property int size:100
    property int startx:x
    property int starty:y
    property int endx:x
    property int endy:y
    property int durations:10000
    property bool xRun:true
    property bool yRun:true
    property bool picSizeChanges:false
    property string src:""
    property int loop:Animation.Infinite
    property int picSizeTo:0

    NumberAnimation on x{
        from:startx
        to:endx
        duration:durations
        running:xRun
        loops:loop
    }
    NumberAnimation on y{
        from:starty
        to:endy
        duration:durations
        running:yRun
        loops:loop
    }
    Image{
        source:src
        height:item.height
        width:item.width
        NumberAnimation on height{
            running:picSizeChanges
            from:item.height
            to:picSizeTo
            duration:durations
            loops:loop
        }
        NumberAnimation on width{
            running:picSizeChanges
            from:item.width
            to:picSizeTo
            duration:durations
            loops:loop
        }
    }
}
