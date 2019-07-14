import QtQuick 2.0
import Felgo 3.0
import QtMultimedia 5.0
import "../Controls/Controls.js" as Controls
import "../Controls"

Scene {     //主界面
    id: scene
    opacity:0
    visible:opacity>0
    enabled:visible

    property bool autoplay:false
    property bool musicstate:autoplay

    //点击游戏信号
    signal gameButtonClicked()
    signal aboutButtonClicked()
    signal scoreButtonClicked()
    signal setButtonClicked()
    signal musicChanged()

    //背景
    Rectangle{
        anchors.fill:parent
        width:100
        height:100
        id:rect
        color:"black"

        Image{
            id:background
            source:"../Images/blackhole.jpg"
            width:2048
            height:2048
            anchors.centerIn:parent
            NumberAnimation on rotation{
                from:0
                to:360
                duration:160000
            }
            opacity:0.8
        }

        CrossBg{
                id:rocket
                x:-300
                y:1300
                endy:0
                endx:1920
                size:300
                durations:4000
                picSizeChanges:true
                picSizeTo:0
                src:"../Images/rocket.png"
        }
        CrossBg{
                id:rocket2
                x:200
                y:2920
                endy:0
                size:300
                durations:4000
                picSizeChanges:true
                picSizeTo:30
                src:"../Images/rocket2.png"
        }
            CrossBg{
                id:ufo
                x:1920
                y:2000
                endx:0
                endy:450
                size:400
                durations:4000
                picSizeChanges:true
                src:"../Images/ufo.png"
            }

        CrossBg{
            id:stone
            x:300
            y:0
            endy:2500
            RollingBg{
                size:600
                src:"../Images/stone.png"
                picRolling:true
                roll.duration:7000
            }
            durations:5000
        }
            RollingBg{
                size:600
                x:200
                y:500
                src:"../Images/spaceman.png"
                picRolling:true
                picRollingSpeed:200000
                roll.duration:180000
            }


        RollingBg{
            id:star
            x:200
            y:1030
            size:500
            src:"../Images/star.png"
            picRolling:true
            roll.duration:10000
        }

        RollingBg{
            id:cloud
            x:100
            y:100
            size:1000
            src:"../Images/cloud.png"
            image.opacity:0.7
            image.height:500
            image.width:500
        }

        RollingBg{
            id:cloud2
            x:400
            y:300
            size:1800
            src:"../Images/cloud.png"
            image.opacity:0.6
            image.height:800
            image.width:800
        }

        RollingBg{
            id:cloud3
            x:70
            y:600
            size:2400
            src:"../Images/cloud.png"
            image.opacity:0.7
            image.height:1000
            image.width:1000
            roll.from:360
            roll.to:0
        }
        RollingBg{
           id:cloud4
            x:0
            y:0
            height:400
            width:400
            src:"../Images/cloud.png"
            image.opacity:0.6
            image.height:500
            image.width:500
            roll.from:360
            roll.to:0
        }
        RollingBg{
           id:cloud5
            x:0
            y:700
            height:400
            width:400
            src:"../Images/cloud.png"
            image.opacity:0.6
            image.height:500
            image.width:500
            roll.from:360
            roll.to:0
        }

            Image{
                id:title
                anchors.horizontalCenter:rect.horizontalCenter
                anchors.bottom:gamebutton.top
                anchors.bottomMargin:40
                height:300
                width:800
                source:"../Images/title.png"
                opacity:0.6
            }
            MenuButton{
                id:gamebutton
                str:qsTr("  START  ")
                anchors.bottom:scorebutton.top
                anchors.bottomMargin:100
                anchors.horizontalCenter:rect.horizontalCenter
                mouseArea.onClicked:gameButtonClicked()
            }
            MenuButton{
                id:scorebutton
                str:qsTr("  Score  ")
                anchors.centerIn:rect

                paddingHorizontal:70
                mouseArea.onClicked:scoreButtonClicked()
            }
            MenuButton{
                id:setbutton
                str:qsTr("Music:")+(musicstate?" on ":" off")
                anchors.horizontalCenter:rect.horizontalCenter
                anchors.top:scorebutton.bottom
                anchors.topMargin:100
                mouseArea.onClicked:{
                    musicChanged()
                    if(musicstate) {
                        musicControl.stop()
                        musicstate=false
                    }
                    else {
                        musicstate=true
                        musicControl.play()
                    }
                }
            }
            MenuButton{
                id:aboutbutton
                str:qsTr("About us ")
                anchors.horizontalCenter:rect.horizontalCenter
                anchors.top:setbutton.bottom
                anchors.topMargin:100
                mouseArea.onClicked:aboutButtonClicked()
            }

            MusicControl{
                id:musicControl
                enabled:musicstate
            }
        }
}
