import QtQuick 2.0
import Felgo 3.0

import "../Controls"

Scene {
    id:scene
    opacity:0
    visible:opacity>0
    enabled:visible

    property string helpUrl:"https://www.baidu.com/"
    property string contactUrl:"https://github.com/beginlagain/android-game/"


    signal backButtonClicked()

    Rectangle{
        id:rect
        anchors.fill:scene
        height:200
        width:200
        color:"#39c5bb"

        CrossBg{
            id:bg
            x:0
            y:0
            height:rect.height
            width:rect.width
            endy:-height
            src:"../Images/space.jpg"
        }
        CrossBg{
            id:bg2
            x:0
            y:height
            height:rect.height
            width:rect.width
            endy:0
            src:"../Images/space.jpg"
        }

        Item{
            id:info
            anchors.top:backbutton.bottom
            anchors.topMargin:50
            Text{
                id:help
                text:"If you need help, please click: "+helpUrl
                font.pixelSize:50
                color:"white"
            }
            Text{
                id:contact
                anchors.top:help.bottom
                anchors.topMargin:50
                text:"Contact:\n"+contactUrl
                font.pixelSize:50
                color:"red"
            }
            Text{
                id:copyright
                anchors.top:contact.bottom
                anchors.topMargin:50
                text:"Copyright: CQNU"
                font.pixelSize:50
                color:"blue"
            }
            Text{
                id:setsume
                anchors.top:copyright.bottom
                anchors.topMargin:50
                text:"Usage: It's a little flighting game\n"
                     +"\tyuo can drag you plane to escape from stones and other planes\n"
                     +"\tyour plane will shot automatically that allows you to control it more easier\n"
                     +"\twhen your plane's life chanegd into 0, it's game over\n"

                font.pixelSize:50
                color:"white"
            }
            Text{
                id:thanks
                anchors.top:setsume.bottom
                anchors.topMargin:50
                text:"Have fun playing!"
                font.pixelSize:90
                color:"white"
            }
        }

        MenuButton{
            id:backbutton
            str:"Back"
            fontSize:90
            anchors.right:rect.right
            anchors.top:rect.top
            anchors.topMargin:20
            mouseArea.onClicked:backButtonClicked()
        }

        MenuButton{
            id:openHelp
            str:"Help"
            fontSize:90
            anchors.bottom:openContact.top
            anchors.bottomMargin:50
            width:rect.width
            mouseArea.onClicked:Qt.openUrlExternally(helpUrl)
        }
        MenuButton{
            id:openContact
            str:"Contact us"
            fontSize:90
            anchors.bottom:rect.bottom
            anchors.bottomMargin:50
            width:rect.width
            mouseArea.onClicked:Qt.openUrlExternally(contactUrl)
        }
    }
}
