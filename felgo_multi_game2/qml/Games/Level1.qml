import QtQuick 2.0
import Felgo 3.0
import "../Controls/"

import "../Controls/Controls.js" as Controls

Item{
    id:level1
    RunningBg{
        id:bg
        src:"../Images/space.jpg"
        time:5
        anchors.fill:parent
    }


    signal scoreChanged(int scores)
    signal lifeChanged(int lifes)
    signal gameOver()
    signal gameWin()

    property bool gameRun:Controls.gameRun()

    property int enemyDestroyed:0

    property int playerlife:3

    property int psDuration: 10000

    property bool twoBullt:false

    property string pic:"../Images/Games/"

    property int time:100

    property int oil:30

    property int muteki:0

    /***************************************/

    EntityManager{
        id:entityManager
        entityContainer:scene
    }
    Scene{
        id:scene
        x:0
        y:0
        anchors.fill: parent
        PhysicsWorld {debugDrawVisible: false}
//player


        EntityBase{
            id:player
            entityType: "player"
            width:150
            height:150
            MultiResolutionImage{
                width:player.width
                height:player.height
                id:playerImage
                source: pic+"playerplane.png"
                opacity:muteki>0?0.5:1
            }

            x:300
            y:580
            BoxCollider{
                 anchors.fill:playerImage
                 collisionTestingOnlyMode: true
                 fixture.onBeginContact: {
                     var collider = other.getBody().target
                     if(collider.entityType==="enemy1"&&muteki==0){
                         playerlife--
                         psDuration=10000
                         collider.removeEntity()
                         lifeChanged(playerlife)
                         if(playerlife===0){
                              //removeEntity()
                             gameOver()
                         }
                         else muteki=3
                     }
                 }
             }
         }
        MouseArea{
            enabled:gameRun
            anchors.fill:scene
            drag.target: player
            onPositionChanged:Controls.inScreen(player)
         }

         Component{
            id:shot
            EntityBase{
                entityType: "shot"
                MultiResolutionImage{
                    id:shotImage
                    source: pic+"bullet.png"
                }
                property int wx
                property int wy

                x:wx

                NumberAnimation on y{
                    running:Controls.gameRun()
                    from:wy
                    to:-shotImage.height
                    duration: 0.5*psDuration*(wy+shotImage.height)/(scene.height+shotImage.height)
                }

                BoxCollider{
                    anchors.fill: shotImage
                    collisionTestingOnlyMode: true
                }
            }
         }
//props
         Component{
              id:props
               EntityBase{
                 entityType: "props"
                 MultiResolutionImage{
                    id:propsImage
                    source: pic+"supply1.png"
                    width: 25
                    height: 25
                  }
                  x:utils.generateRandomValueBetween(0, scene.width)
                  NumberAnimation on y{
                    running:gameRun
                    from:0
                    to:scene.height
                    duration:utils.generateRandomValueBetween(10000,50000)
                   }
                         BoxCollider{
                             anchors.fill: propsImage
                             collisionTestingOnlyMode: true
                             fixture.onBeginContact: {
                                 var collider = other.getBody().target
                                 if(collider.entityType==="player"){
                                     removeEntity()
                                     if(psDuration>2000){
                                         psDuration-=2000
                                     }else if(psDuration===2000){
                                         twoBullt=true
                                     }
                                 }
                             }
                         }
                     }
                  }
                  Component{
                     id:props2
                     EntityBase{
                         entityType: "props2"
                         MultiResolutionImage{
                             id:props2Image
                             source: pic+"supply2.png"
                             width:30
                             height:30
                         }
                         x:utils.generateRandomValueBetween(0, scene.width)
                         NumberAnimation on y{
                             running:gameRun
                             from:0
                             to:scene.height
                             duration: utils.generateRandomValueBetween(10000,50000)
                         }
                         BoxCollider{
                             anchors.fill: props2Image
                             collisionTestingOnlyMode: true
                             fixture.onBeginContact: {
                                 var collider = other.getBody().target
                                 if(collider.entityType==="player"){
                                     removeEntity()
                                     oil+=20
                                     playerlife++
                                     lifeChanged(playerlife)
                                 }
                             }
                         }
                     }
                  }
//enemy
         Component{
            id:enemy1
            EntityBase{
                entityType:"enemy1"

                MultiResolutionImage{
                    id:enemy1Image
                    source: pic+"enemy1.png"
                    height:150
                    width:150
                }
                x: utils.generateRandomValueBetween(0, scene.width)
                NumberAnimation on y{
                    running:Controls.gameRun()
                    from:0
                    to:scene.height
                    duration: utils.generateRandomValueBetween(10000,50000)
                }
                BoxCollider{
                    property int enemyLife1: 5
                    anchors.fill: enemy1Image
                    collisionTestingOnlyMode: true
                    fixture.onBeginContact: {
                        var collied = other.getBody().target
                        if(collied.entityType==="shot"){
                            enemyLife1--
                            collied.removeEntity()
                            if(enemyLife1<=0){
                                removeEntity()
                                enemyDestroyed++
                                scoreChanged(enemyDestroyed)
                            }
                        }
                    }
                }
            }
        }
    }
    Timer{
        id:playershot
        running: Controls.gameRun()
        repeat: true
        interval: 200
        onTriggered: selfShot()

    } Timer{
        id:addProps
        running: scene.visible==true
        repeat: true
        interval: 17000
        onTriggered: {
            entityManager.createEntityFromComponent(props)
        }
    }
    Timer{
        id:addProps2
        running: scene.visible==true
        repeat: true
        interval: 20000
        onTriggered: {
            entityManager.createEntityFromComponent(props2)
        }
    }
    Timer{
        id:addtowBullt
        running: twoBullt==true
        repeat: true
        interval: 300
        onTriggered: {
            var playerX=player.x
            var playerY=player.y
            entityManager.createEntityFromComponentWithProperties(shot,{"wx":playerX+playerImage.width/2+3,"wy":playerY-1})
            entityManager.createEntityFromComponentWithProperties(shot,{"wx":playerX+playerImage.width/2-17,"wy":playerY-1})
        }
    }
    Timer{
        id:addEnemyF
        running:  Controls.gameRun()//scene.visible==true
        repeat: true
        interval: 1000
        onTriggered: addEnemy1()
    }

    Timer{
        id:distance
        running:gameRun&&time>0&&oil>0
        onTriggered:{loader.item
            oil--
            time--
            if(oil<=0) gameOver()
            if(time<=0) gameWin()
        }
    }

    Text{
        id:cd
        text:qsTr("Distance:")+time
        color:"white"
        font.pixelSize:60
        y:300
    }
    Text{
        id:oils
        text:qsTr("Oil:")+oil
        color:"white"
        font.pixelSize:60
        anchors.top:cd.bottom
    }

    Timer{
        id:mutekitime
        running:muteki>0
        interval:1000
        onTriggered:muteki--
    }

    function selfShot(){
        var offset = Qt.point(player.x,player.y)
        var realX = offset.x
        var realY = offset.y
        entityManager.createEntityFromComponentWithProperties(shot,{"wy":realY,"wx":realX+playerImage.width/2-7})
    }
    function addEnemy1(){
        entityManager.createEntityFromComponent(enemy1)
    }
}

