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
            id:gamewin
            visible:false
            color:Qt.rgba(222,222,222,0)
            anchors.centerIn:parent

            Item{
                anchors.centerIn:parent
                Text{
                    id:winInfo
                    text:"胜利"
                    font.pixelSize:100
                    color:"white"
                    anchors.horizontalCenter:parent.horizontalCenter
                }
                MenuButton{
                    str:"继续"
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top:winInfo.bottom
                    anchors.topMargin:50
                    mouseArea.onClicked:{
                        gamewin.visible=false
                        backButtonClicked()
                        activeLevelFileName=""
                    }
                }
            }

        }

        Rectangle{
            id:gameover
            visible:false
            color:Qt.rgba(222,222,222,0)
            anchors.centerIn:parent

            Item{
                anchors.centerIn:parent
                Text{
                    id:info
                    text:"战败"
                    color:"red"
                    font.pixelSize:100
                    anchors.horizontalCenter:parent.horizontalCenter
                }

                MenuButton{
                    id:again
                    str:"再玩一次"
                    anchors.top:info.bottom
                    anchors.topMargin:30
                    anchors.horizontalCenter:parent.horizontalCenter
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
                    anchors.horizontalCenter:parent.horizontalCenter
                    mouseArea.onClicked:{
                        gameover.visible=false
                        backButtonClicked()
                        activeLevelFileName=""
                    }
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

        Text{
            anchors.centerIn:parent
            text:Controls.setMusic()?"on":"off"
            color:"white"
            font.pixelSize:100
        }

        Connections{
            target:loader.item
            onScoreChanged:{
                if(Controls.setMusic())
                    sound.play()
                score=scores*10
            }
            onLifeChanged:{
                if(Controls.setMusic())
                    sound.play()
                life=lifes
            }
            onGameOver:{
                gameRunning=false
                gameover.visible=true
            }
            onGameWin:{
                gameRunning=false
                gamewin.visible=true
            }
        }
    }
}
