import Felgo 3.0
import QtQuick 2.0
import "../Controls"

import "../Controls/Controls.js" as Controls

Scene {         //游戏界面
    id:scene
    opacity:0
    visible:opacity>0
    enabled:visible

    signal backButtonClicked()

    property alias loader:loader
    property string activeLevelFileName:""
    property string activeLevelName
    property int countdown: 4
    property int score: 0
    property int life:3
    property bool gameRunning: false

    Rectangle {
        id:rect
        height:200
        width:200
        anchors.fill: parent
        color: "#dd94da"
        Loader {
            id: loader
            source: "../Games/" + activeLevelFileName
            anchors.fill:parent
            onLoaded: {
               countdown=4
            }
        }

        Rectangle{
            id:gameover
            visible:false
            color:Qt.rgba(222,222,222,0)
            anchors.centerIn:parent

            Text{
                text:"战败"
                color:"red"
                font.pixelSize:100
                anchors.centerIn:parent
            }

            MenuButton{
                id:again
                str:"再玩一次"
                mouseArea.onClicked:{
                    gameover.visible=false
                    Controls.resetLevel()
                    //backButtonClicked
                    Controls.setLevel(activeLevelFileName,activeLevelName)
                    loader.reload="../Games/" + activeLevelFileName
                }
            }
            MenuButton{
                str:"退出"
                anchors.top:again.bottom
                anchors.topMargin:20
                mouseArea.onClicked:{
                    gameover.visible=false
                    backButtonClicked()
                    activeLevelFileName=""
                }
            }
        }

        MenuButton{
            id:backbutton
            str:"返回"
            fontSize:90
            anchors.right:rect.right
            anchors.top:rect.top
            anchors.topMargin:20
            enabled:gameRunning
            mouseArea.onClicked:{
                backButtonClicked()
                activeLevelFileName=""
            }
        }
//        MenuButton{
//            id:backbutton
//            str:"菜单"
//            fontSize:90
//            anchors.right:rect.right
//            anchors.top:rect.top
//            anchors.topMargin:20
//            enabled:gameRunning
//            mouseArea.onClicked:{
//                gameRunning=false
//                gameMenu.visible=true
//            }
//        }

//        GameMenu{
//            id:gameMenu
//            onLeaveClicked:{
//                gameMenu.visible=false
//                backButtonClicked()
//                activeLevelFileName=""
//            }
//        }

        Text{
            id:levelName
            text:activeLevelName
            color:"white"
            font.pixelSize:70
            anchors.left:parent.left
            anchors.leftMargin:10
            anchors.top:parent.top
            anchors.topMargin:10
        }

        Text{
            id:scoreborad
            text:"得分:"+score
            color:"white"
            font.pixelSize:70
            anchors.horizontalCenter:rect.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:10
        }
        Text{
            id:lifeborad
            text:"生命值:"+life
            font.pixelSize:60
            color:"white"
            anchors.top:levelName.bottom
            anchors.topMargin:10
            anchors.leftMargin:10
        }

        Text {
            id:countdownInfo
            visible:countdown>0
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 70
            text: countdown>1?"警告:敌军还有"+(countdown-1)+"秒到达战场":"出战!"
        }

        Timer {
            repeat: true
            running: countdown > 0
            onTriggered: {
                countdown--
                if(countdown==0) gameRunning=true
            }
        }

        Connections{
            target:loader.item
            onScoreChanged:score=scores*10
            onLifeChanged:life=lifes
            onGameOver:gameover.visible=true
        }
    }
}
