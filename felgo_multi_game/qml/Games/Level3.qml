import QtQuick 2.0
import Felgo 3.0
import "../Controls/"
import "../Controls/Controls.js" as Controls

Item {
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

    property bool enemy4Found :false

    property bool enemy3Found :false

    property bool enemy5Found :false

    property int muteki:0

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
            MultiResolutionImage{
                id:playerImage
                width:100
                height:100
                source:pic+"playerplane.png"
                opacity:muteki>0?0.5:1
            }
            x:300
            y:580
            BoxCollider{
                 anchors.fill:playerImage
                 collisionTestingOnlyMode: true
                 fixture.onBeginContact: {
                     var collider = other.getBody().target
                     if(collider.entityType==="enemy1"||collider.entityType==="enemy2"||collider.entityType==="enemy3"||collider.enetityType==="enemy4"&&muteki==0){
                         playerlife--
                         psDuration=10000
                         lifeChanged(playerlife)
                         collider.removeEntity()
                         if(playerlife===0){
                              removeEntity()
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
                PropertyAnimation on y{
                    from:wy
                    to:-shotImage.height
                    duration: 0.5*psDuration*(wy+shotImage.height)/(scene.height+shotImage.height)
                }

                CircleCollider{
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
                    width: 30
                    height: 30
                }
                x:utils.generateRandomValueBetween(0, scene.width)
                NumberAnimation on y{
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
                }
                x:utils.generateRandomValueBetween(0, scene.width)
                NumberAnimation on y{
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
                            playerlife++
                            lifeChanged(playerlife)

                        }
                    }
                }
            }
         }
//enemy
        Component{
            id:enemy3shot
            EntityBase{
                entityType: "enemy3shot"
                MultiResolutionImage{
                    id:enemy3shotImage
                    source: pic+"enemy4-2bullet.png"
                }
                property int e3x
                property int e3y
                property int playerX
                property int playerY
                NumberAnimation on x{
                    from:e3x
                    to:playerX
                    duration: 10000
                }
                NumberAnimation on y{
                    from:e3y
                    to:playerY
                    duration: 10000
                }
                CircleCollider{
                    anchors.fill:enemy3shotImage
                    collisionTestingOnlyMode: true
                    fixture.onBeginContact: {
                        var collider = other.getBody().target
                        if(collider.entityType==="player"&&muteki==0){
                            playerlife--
                            lifeChanged(playerlife)
                            removeEntity()
                            if(playerlife===0){
                                collider.removeEntity()
                                gameOver()
                            }
                            else muteki=3
                        }
                    }
                }
            }
         }
        Component{
            id:enemy4
            EntityBase{
                entityType: "enemy4"
                MultiResolutionImage{
                    id:enemy4Image
                    source: pic+"enemy4.png"
                    height:250
                    width:250
                }
                x:scene.width/2
                NumberAnimation on y{
                    from:0
                    to:scene.height
                    duration: utils.generateRandomValueBetween(150000,200000)
                }
                Component.onCompleted: {
                    enemy4Found=true
                }
                Timer{
                    id:addenemy4shot
                    running: enemy4Found==true
                    repeat: true
                    interval: 12000
                    property int e4Sy:0
                    property int e4Sx:0
                    onTriggered: {
                        for(var i=0;i<7;i++){
                            for(var j=0;j<10;j++){
                               entityManager.createEntityFromComponentWithProperties(enemy4shot,{"e4Sx":-e4Sx-scene.width/2,"e4Sy":e4Sy,"e4x":x+enemy4Image.width/2,"e4y":y})
                                entityManager.createEntityFromComponentWithProperties(enemy4shot,{"e4Sx":e4Sx+scene.width*1.5,"e4Sy":e4Sy,"e4x":x+enemy4Image.width/2,"e4y":y})
                                e4Sx+=200
                                e4Sy+=50
                            }
                            e4Sx=0
                            e4Sy+=50
                        }
                        e4Sx=0
                        e4Sy=0
                        for(i=0;i<5;i++){
                            for(j=0;j<10;j++){
                                entityManager.createEntityFromComponentWithProperties(enemy4shot,{"e4Sx":e4Sx,"e4Sy":e4Sy+scene.height,"e4x":x,"e4y":y})
                                entityManager.createEntityFromComponentWithProperties(enemy4shot,{"e4Sx":-e4Sx,"e4Sy":e4Sy+scene.height,"e4x":x,"e4y":y})
                                e4Sx+=50
                                e4Sy+=100
                            }
                            e4Sy=0
                            e4Sx+=50
                        }
                    }
                }
                Timer{
                    id:addenemy4selfShot
                    running: enemy4Found==true
                    repeat: true
                    interval: 5000
                    property int e4x: x
                    property int e4y: y
                    property int playerY: scene.height
                    property int playerX: (playerY-y)*(player.x-x)/(player.y-y)+x
                    onTriggered:{
                        entityManager.createEntityFromComponentWithProperties(enemy3shot,{"e3x":e4x+enemy4Image.width/2,"e3y":e4y+enemy4Image.height,"playerX":playerX,"playerY":playerY})

                    }
                }
                Timer{
                    id:addEnemyFive
                    running: enemy4Found==true
                    repeat: false
                    interval: 15000
                    onTriggered: {
                        entityManager.createEntityFromComponentWithProperties(enemy5,{"e5x":x+200})
                        entityManager.createEntityFromComponentWithProperties(enemy5,{"e5x":x-200})
                    }
                }
                BoxCollider{
                    property int enemy4Life:500
                    anchors.fill: enemy4Image
                    collisionTestingOnlyMode: true
                    fixture.onBeginContact: {
                        var collider = other.getBody().target
                        if(collider.entityType==="shot"){
                            enemy4Life--
                            collider.removeEntity()
                            if(enemy4Life===0){
                                removeEntity()
                                enemyDestroyed++
                                scoreChanged(enemyDestroyed)
                                gameWin()
                            }
                        }
                    }
                }
            }
        }
        Component{
            id:enemy4shot
            EntityBase{
                entityType: "enemy4shot"
                MultiResolutionImage{
                    id:enemy4shotImage
                    source: pic+"/enemy4bullet.png"
                }
                property int e4x
                property int e4y
                property int e4Sx
                property int e4Sy
                NumberAnimation on x{
                    from:e4x
                    to:e4Sx
                    duration: 50000
                }
                NumberAnimation on y{
                    from:e4y
                    to:e4Sy
                    duration: 50000
                }
                CircleCollider{
                    anchors.fill: enemy4shotImage
                    collisionTestingOnlyMode: true
                    fixture.onBeginContact: {
                        var collider = other.getBody().target
                        if(collider.entityType==="player"&&muteki==0){
                            playerlife--
                            lifeChanged(playerlife)
                            removeEntity()
                            if(playerlife===0){
                                collider.removeEntity()
                                gameOver()
                            }
                            else muteki=3
                        }
                    }
                }
            }
        }
        Component{
            id:enemy5
            EntityBase{
                entityType: "enemy5"
                MultiResolutionImage{
                    id:enemy5Image
                    source: pic+"enemy5.png"
                    width:200
                    height:200
                }
                property int e5x
                x:e5x
                NumberAnimation on y{
                    from:0
                    to:scene.height
                    duration: utils.generateRandomValueBetween(150000,200000)
                }
                Component.onCompleted: {
                    enemy5Found=true
                }
                Timer{
                    id:addenemy5shot
                    running: enemy5Found==true
                    repeat: true
                    interval: 10000
                    property int e5Sy:0
                    property int e5Sx:0
                    property int e5Sx2:0
                    property int e5Sy2: 0
                    onTriggered: {
                        for(var i=0;i<5;i++){
                            e5Sx2=0
                            e5Sy2=0

                               entityManager.createEntityFromComponentWithProperties(enemy5shot,{"e5Sx":e5Sx,"e5Sy":e5Sy,"e5x":x+e5Sx2-enemy5Image.width/2,"e5y":y+e5Sy2+enemy5Image.height})
                                entityManager.createEntityFromComponentWithProperties(enemy5shot,{"e5Sx":scene.width-e5Sx,"e5Sy":e5Sy,"e5x":x-e5Sx2+enemy5Image.width/2,"e5y":y-e5Sy2+enemy5Image.height})
                            e5Sy+=scene.height/4
                        }
                    }
                }
                BoxCollider{
                    property int enemy5Life:utils.generateRandomValueBetween(15,20)
                    anchors.fill: enemy5Image
                    collisionTestingOnlyMode: true
                    fixture.onBeginContact: {
                        var collider = other.getBody().target
                        if(collider.entityType==="shot"){
                            enemy5Life--
                            collider.removeEntity()
                            if(enemy5Life===0){
                                removeEntity()
                                enemyDestroyed++
                            }
                        }
                    }
                }
            }
        }
        Component{
            id:enemy5shot
            EntityBase{
                entityType: "enemy5shot"
                MultiResolutionImage{
                    id:enemy5shotImage
                    source: pic+"enemy4bullet.png"
                }
                property int e5x
                property int e5y
                property int e5Sx
                property int e5Sy
                NumberAnimation on x{
                    from:e5x
                    to:e5Sx-enemy5shotImage.width
                    duration: 100000
                }
                NumberAnimation on y{
                    from:e5y
                    to:e5Sy
                    duration: 100000
                }
                BoxCollider{
                    anchors.fill: enemy5shotImage
                    collisionTestingOnlyMode: true
                    fixture.onBeginContact: {
                        var collider = other.getBody().target
                        if(collider.entityType==="player"&&muteki==0){
                            playerlife--
                            lifeChanged(playerlife)
                            removeEntity()
                            if(playerlife===0){
                                collider.removeEntity()
                                gameOver()
                            }
                            else muteki=3
                        }
                    }
                }
            }
        }
    }

    Timer{
        id:playershot
        running: scene.visible==true
        repeat: true
        interval: 200
        onTriggered: selfShot()

    }
    Timer{
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
        id:addEnemyFive
        running: scene.visible==true
        repeat: false
        interval: 5000
        onTriggered: addEnemy4()
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
    function addEnemy4(){
        entityManager.createEntityFromComponent(enemy4)
    }


}
