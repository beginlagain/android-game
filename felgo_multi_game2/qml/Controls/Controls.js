function bgrun()
{
    if(gameRunning){
        background1.y++
        background2.y++
        if(background1.y===rect.height)
            background1.y=-background1.height
        if(background2.y===rect.height)
            background2.y=-background2.height
    }
}

function setMusic()
{
    return mainWindow.musicstate
}

function autoPlay()
{
    return mainWindow.autoplay
}

function getPosition(from,to)
{
    from.x=to.x
    from.y=to.y
}

function gameRun()
{
    return gameRunning
}

function picrun()
{
    if(gameRunning){
        y--
    }
}

function inScreen(item)
{
    if(item.x<=0) item.x=0
    else if(item.y<=0) item.y=0
    else if(item.y>=1920) item.y=1920
    else if(item.x>=1080) item.x=1080
}

function setLevel(fileName,title) {
    gameScene.activeLevelFileName = fileName
    gameScene.activeLevelName=title
}

function resetLevel()
{
        gameScene.life=3
        gameScene.gameRunning=false
        gameScene.score=0
        gameScene.countdown=4
}

function getRandom(min,max)
{
     min = Math.ceil(min);
     max = Math.floor(max);
     return Math.floor(Math.random() * (max - min + 1)) + min;
}

function resetGame(level)
{
    level.playerlife=3
    level.enemyDestroyed=0
    level.oil=30
    level.twoBullt=false
    level.time=100
}
