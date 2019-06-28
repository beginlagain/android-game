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
                text:"如需帮助, 请访问:"+helpUrl
                font.pixelSize:50
                color:"white"
            }
            Text{
                id:contact
                anchors.top:help.bottom
                anchors.topMargin:50
                text:"联系我们:\n"+contactUrl
                font.pixelSize:50
                color:"red"
            }
            Text{
                id:copyright
                anchors.top:contact.bottom
                anchors.topMargin:50
                text:"版权所有:重庆师范大学计算机与信息科学学院"
                font.pixelSize:50
                color:"blue"
            }
            Text{
                id:setsume
                anchors.top:copyright.bottom
                anchors.topMargin:50
                text:"说明:这是一个打飞机游戏\n"
                     +"\t滑动屏幕控制您的飞机,不断躲避子弹或陨石\n"
                     +"\t飞机会自动射击,不需要您特别操作\n"
                     +"\t您的飞机有指定数量生命值,当生命值归零\n"
                     +"\t游戏结束,尽量不消耗生命值游戏下去吧!\n"
                font.pixelSize:50
                color:"white"
            }
            Text{
                id:thanks
                anchors.top:setsume.bottom
                anchors.topMargin:50
                text:"祝您游戏愉快!"
                font.pixelSize:90
                color:"white"
            }
        }

        MenuButton{
            id:backbutton
            str:"返回"
            fontSize:90
            anchors.right:rect.right
            anchors.top:rect.top
            anchors.topMargin:20
            mouseArea.onClicked:backButtonClicked()
        }

        MenuButton{
            id:openHelp
            str:"打开帮助界面"
            fontSize:90
            anchors.bottom:openContact.top
            anchors.bottomMargin:50
            width:rect.width
            mouseArea.onClicked:Qt.openUrlExternally(helpUrl)
        }
        MenuButton{
            id:openContact
            str:"联系我们"
            fontSize:90
            anchors.bottom:rect.bottom
            anchors.bottomMargin:50
            width:rect.width
            mouseArea.onClicked:Qt.openUrlExternally(contactUrl)
        }
    }
}
