import QtQuick 2.0

import "../Controls/Controls.js" as Controls

Item{
    property string src : "../Image/21.png"
    property int time:50
    property alias timer:timer

    Item {
        id:rect
        width: parent.width
        height: parent.height
        //radius: 10
        visible:true
    }
    Image{
        id:background1
        source:src
        height:rect.height
        width:rect.width
    }
    Image{
        id:background2
        source:src
        width:rect.width
        height:rect.height
        y:rect.y-background2.height
    }
    Timer{
        id:timer
        repeat:true
        running:true
        interval: time
        onTriggered:Controls.bgrun()
    }
}
