import Felgo 3.0
import QtQuick 2.0

import "./Controls/Controls.js" as Controls
import "./Controls"
import "./Windows"

GameWindow {        //应用窗口
    id: gameWindow
    state:"menu"
    activeScene:mainWindow
    screenWidth: 1080
    screenHeight: 1920
//    fullscreen:true

    MainWindow{         //主界面
        id:mainWindow
        anchors.fill:parent
        onGameButtonClicked:gameWindow.state="gamelevel"
        onAboutButtonClicked:gameWindow.state="aboutscene"
        onScoreButtonClicked:gameWindow.state="scorescene"
    }

    GameLevel{          //游戏选择界面
        id:gameLevel
        anchors.fill:parent
        onBackButtonClicked:gameWindow.state="menu"
        onLevelPressed: {
            Controls.resetLevel()
            Controls.setLevel(selectedLevel,title)
            gameWindow.state = "gamescene"
        }
    }

    GameScene{          //游戏界面
        id:gameScene
         anchors.fill:parent
        onBackButtonClicked:gameWindow.state="gamelevel"
    }

    AboutScene{
        id:aboutScene
         anchors.fill:parent
        onBackButtonClicked:gameWindow.state="menu"
    }

    ScoreScene{
        id:scoreScene
        anchors.fill:parent
        onBackButtonClicked:gameWindow.state="menu"
    }

    //界面切换
    states:[
        State{
            name:"gamelevel"
            PropertyChanges{target:gameLevel;opacity:1}
            PropertyChanges{target:gameWindow;activeScene:gameLevel}
        },
        State{
            name:"menu"
            PropertyChanges{target:mainWindow;opacity:1}
            PropertyChanges{target:gameWindow;activeScene:mainWindow}
        },
        State{
            name:"gamescene"
            PropertyChanges{target:gameScene;opacity:1}
            PropertyChanges{target:gameWindow;activeScene:gameScene}
        },
        State{
            name:"aboutscene"
            PropertyChanges{target:aboutScene;opacity:1}
            PropertyChanges{target:gameWindow;activeScene:aboutScene}
        },
        State{
            name:"scorescene"
            PropertyChanges{target:scoreScene;opacity:1}
            PropertyChanges{target:gameWindow;activeScene:scoreScene}
        }
    ]
    }

