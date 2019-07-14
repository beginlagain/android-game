import Felgo 3.0
import QtQuick 2.0

import "../Controls"

Scene {     //游戏选择界面
    id:scene
    opacity:0
    visible:opacity>0
    enabled:visible
    //信号
    signal backButtonClicked()
    signal levelPressed(string selectedLevel,string title)
    signal cardMoved()

    Rectangle{      //背景
        id:rect
        height:200
        width:200
        color:"#e1e1e1"
        anchors.fill:parent

        Image{
            anchors.fill:rect
            source:"../Images/blackhole.jpg"
        }

        Text{
            text:qsTr("Choose a level")
            font.pixelSize:100
            color:"yellow"
            anchors.horizontalCenter:rect.horizontalCenter
            anchors.top:backbutton.bottom
            anchors.topMargin:50
        }
        MenuButton{
            id:backbutton
            str:qsTr("Back")
            fontSize:90
            anchors.right:rect.right
            anchors.top:rect.top
            anchors.topMargin:20
            mouseArea.onClicked:backButtonClicked()
        }

        Grid {          //展示可选项
            anchors.centerIn: parent
            spacing: 30
            columns: 5
            rows:4
            MenuButton {
                str: "1"
                fontSize:200
                mouseArea.onClicked: {
                    levelPressed("Level1.qml",qsTr("星际穿越"))
                }
            }
            MenuButton {
                str: "2"
                fontSize:200
                mouseArea.onClicked: {
                    levelPressed("Level2.qml",qsTr("星际争霸"))
                }
            }
            MenuButton {
                str: "3"
                fontSize:200
                mouseArea.onClicked: {
                    levelPressed("Level3.qml",qsTr("Boss战"))
                }
            }
            Repeater {
                model: 12
                MenuButton {
                    str: "?"
                    fontSize:200
                }
            }
        }
    }
}
