import QtQuick 2.0
import Felgo 3.0

import "../Controls/Controls.js" as Controls
import "../Controls"

Scene{
    id:scene
    opacity:0
    visible:opacity>0
    enabled:visible

    signal backButtonClicked()


    Rectangle{
        id: rect
        height:200
        width:200
        color:"#e2e2e2"
        anchors.fill:parent

        Image{
            id:background
            anchors.fill:parent
            source:"../Images/blackhole.jpg"
        }

        //        ShiningBg{
        //            id:bg
        //            anchors.centerIn:parent
        //        }

        MenuButton{
            id:backbutton
            str:qsTr("Back")
            fontSize:90
            anchors.right:rect.right
            anchors.top:rect.top
            anchors.topMargin:20
            mouseArea.onClicked:backButtonClicked()
        }

    }
}
