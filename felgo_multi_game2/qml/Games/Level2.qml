import QtQuick 2.0
import Felgo 3.0
import "../Controls/"
import "../Controls/Controls.js" as Controls

Item{
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

    property bool enemy4Found :false

    property bool enemy3Found :false

    property bool enemy5Found :false

    property int time:100

    property int oil:30

    property int muteki:0


    property string pic:"../Images/Games/"


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
                id:playerImage
                width:player.width
                height:player.height
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
                     if((collider.entityType==="enemy1"||collider.entityType==="enemy2"||collider.entityType==="enemy3"||collider.enetityType==="enemy5")&&muteki==0){
                         playerlife--
                         psDuration=10000
                         collider.removeEntity()
                         lifeChanged(playerlife)
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
                PropertyAnimation on y{
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
                    width:30
                    height:30
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
                            oil+=20
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
                    width:150
                    height:150
                }
                x: utils.generateRandomValueBetween(0, scene.width)
                NumberAnimation on y{
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
                                if(enemyLife1===0){
                                    removeEntity()
                                    enemyDestroyed++
                                    scoreChanged(enemyDestroyed)
                                }

                        }
                    }
                }
            }
         }
         Component{
            id:enemy2
            EntityBase{
                entityType: "enemy2"
                MultiResolutionImage{
                    id:enemy2Image
                    source: pic+"enemy2.png"
                    width:150
                    height:150
                }
                x: utils.generateRandomValueBetween(0, scene.width)
                NumberAnimation on y{
                    from:0
                    to:scene.height
                    duration: utils.generateRandomValueBetween(40000,50000)
                }
                property int ny: y
                Component.onCompleted: {
                    for(var i=0;i<4;i++){
                        var realDuration = scene.height-ny
                        entityManager.createEntityFromComponentWithProperties(enemy2shot,{"e2x":x+enemy2Image.width/2,"e2y":ny+enemy2Image.height,"realD":realDuration})
                        y+=50
                    }
                    ny=0
                }
                BoxCollider{
                    property int enemy2Life : utils.generateRandomValueBetween(3, 5)
                    anchors.fill: enemy2Image
                    collisionTestingOnlyMode: true

                    fixture.onBeginContact: {
                        var collide = other.getBody().target
                        if(collide.entityType==="shot"){
                            enemy2Life--
                            collide.removeEntity()
                            if(enemy2Life===0){
                                removeEntity()
                                enemyDestroyed+=2
                                scoreChanged(enemyDestroyed)
                            }
                        }
                    }
                }
            }
         }

         Component{
            id:enemy2shot
            EntityBase{
                entityType: "enemy2shot"
                MultiResolutionImage{
                    id:enemy2shotImage
                    source: pic+"enemy4bullet.png"
                }
                property int e2x
                property int e2y
                property int realD
                x:e2x
                NumberAnimation on y {
                    from:e2y
                    to:scene.height
                    duration:realD*10
                }

                CircleCollider{
                    anchors.fill: enemy2shotImage
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
            id:enemy3
            EntityBase{
                entityType: "enemy3"
                MultiResolutionImage{
                    id:enemy3Image
                    source: pic+"enemy3.png"
                    width:150
                    height:150
                }
                x: utils.generateRandomValueBetween(0, scene.width)
                NumberAnimation on y{
                    from:0
                    to:scene.height
                    duration:utils.generateRandomValueBetween(60000,70000)
                }
                Component.onCompleted: {
                    enemy3Found=true
                }
                Timer{
                    id:addenemy3selfshot
                    running:enemy3Found==true
                    repeat: true
                    interval: 10000
                    property int playerY:scene.height
                    property int playerX:(playerY-y)*(player.x-x)/(player.y-y)+x
                    //property int  realD
                    onTriggered: {
                        for(var i=0;i<5;i++){

                            entityManager.createEntityFromComponentWithProperties(enemy3shot,{"e3x":x+enemy3Image.width/2,"e3y":y+enemy3Image.height,"playerX":playerX,"playerY":playerY})
                            playerY+=50
                            playerX=(playerY-y)*(player.x-x)/(player.y-y)+x
                    }
                    }
                }
                BoxCollider{
                    property int enemy3Life: utils.generateRandomValueBetween(5, 7)
                    anchors.fill: enemy3Image
                    collisionTestingOnlyMode: true
                    fixture.onBeginContact: {
                        var collider = other.getBody().target
                        if(collider.entityType==="shot"){
                            enemy3Life--
                            collider.removeEntity()
                            if(enemy3Life===0){
                                removeEntity()
                                enemyDestroyed+=3
                                scoreChanged(enemyDestroyed)
                            }
                        }
                    }
                }
            }
         }
        Component{
            id:enemy3shot
            EntityBase{
                entityType: "enemy3shot"
                MultiResolutionImage{
                    id:enemy3shotImage
                    source: pic+"enemy4bullet.png"
                }
                property int e3x
                property int e3y
                property int playerX
                property int playerY

                NumberAnimation on x{
                    from:e3x
                    to:playerX
                    duration: 50000
                }
                NumberAnimation on y{
                    from:e3y
                    to:playerY
                    duration: 50000
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
            id:enemy5
            EntityBase{
                entityType: "enemy5"
                MultiResolutionImage{
                    id:enemy5Image
                    source: pic+"enemy5.png"
                    width:200
                    height:200
                }
                x:utils.generateRandomValueBetween(0, scene.width)
                NumberAnimation on y{
                    from:0
                    to:scene.height
                    duration: utils.generateRandomValueBetween(150000,200000)
                }
               // property int e4Sy:0
               // property int e4Sx:0
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

                               entityManager.createEntityFromComponentWithProperties(enemy5shot,{"e5Sx":e5Sx-30,"e5Sy":e5Sy,"e5x":x+e5Sx2-enemy5Image.width/2,"e5y":y+e5Sy2+enemy5Image.height})
                                entityManager.createEntityFromComponentWithProperties(enemy5shot,{"e5Sx":scene.width-e5Sx+20,"e5Sy":e5Sy,"e5x":x-e5Sx2+enemy5Image.width/2,"e5y":y-e5Sy2+enemy5Image.height})
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
                                enemyDestroyed+5
                                scoreChanged(enemyDestroyed)
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
                    to:e5Sx
                    duration: 100000
                }
                NumberAnimation on y{
                    from:e5y
                    to:e5Sy
                    duration: 100000
                }
                CircleCollider{
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
        interval: 15000
        onTriggered: {
            entityManager.createEntityFromComponent(props)
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
        id:addProps1
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
            id:addEnemyF
            running: scene.visible==true
            repeat: true
            interval: 10000
            onTriggered: addEnemy1()
        }
    Timer{
        id:addEnemyS
        running: scene.visible==true
        repeat: true
        interval: 8000
        onTriggered:addEnemy2()
    }
    Timer{
        id:addEnemyT
        running: scene.visible==true
        repeat: true
        interval: 15000
        onTriggered:addEnemy3()
    }
    Timer{
        id:addEnemyFive
        running: scene.visible==true
        repeat: false
        interval: 20000
        onTriggered: addEnemy5()
    }

    Timer{
        id:distance
        running:gameRun&&time>0&&oil>0
        onTriggered:{
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
        text:qsTr("Oil")+oil
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
    function addEnemy2(){
        entityManager.createEntityFromComponent(enemy2)
    }
    function addEnemy3(){
        entityManager.createEntityFromComponent(enemy3)
    }
    function addEnemy5(){
        entityManager.createEntityFromComponent(enemy5)
    }
}
