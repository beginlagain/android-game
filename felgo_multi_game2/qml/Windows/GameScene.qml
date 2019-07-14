import Felgo 3.0
import QtQuick 2.0
import "../Controls"

import "../Controls/Controls.js" as Controls

Scene {         //游戏界面
    id:gameScene
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
                    text:qsTr("YOU WIN!")
                    font.pixelSize:100
                    color:"white"
                    anchors.horizontalCenter:parent.horizontalCenter
                }
                MenuButton{
                    str:qsTr("Continue")
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
                    text:qsTr("YOU LOSE")
                    color:"red"
                    font.pixelSize:100
                    anchors.horizontalCenter:parent.horizontalCenter
                }

                MenuButton{
                    id:again
                    str:qsTr("PLAY AGAIN")
                    anchors.top:info.bottom
                    anchors.topMargin:30
                    anchors.horizontalCenter:parent.horizontalCenter
                    mouseArea.onClicked:{
                        gameover.visible=false
                        Controls.resetLevel()
                        Controls.resetGame(loader.item)
                        //backButtonClicked
//                        Controls.setLevel(activeLevelFileName,activeLevelName)
//                        loader.reload="../Games/" + activeLevelFileName
                    }
                }
                MenuButton{
                    str:qsTr("Back")
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
            str:qsTr("Back")
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
            text:qsTr("Score:")+score
            color:"white"
            font.pixelSize:70
            anchors.horizontalCenter:rect.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:10
        }
        Text{
            id:lifeborad
            text:qsTr("Life:")+life
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
            font.pixelSize:countdown>1? 80:100
            text: countdown>1?qsTr("WARNING! ")+(countdown-1):qsTr("START!")
        }

        Timer {
            repeat: true
            running: countdown > 0
            onTriggered: {
                countdown--
                if(countdown==0) gameRunning=true
            }
        }

//        Text{
//            anchors.centerIn:parent
//            text:Controls.setMusic()?"on":"off"
//            color:"white"
//            font.pixelSize:100
//        }

        Connections{
            target:loader.item
            onScoreChanged:{
                score=scores*10
            }
            onLifeChanged:{
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
