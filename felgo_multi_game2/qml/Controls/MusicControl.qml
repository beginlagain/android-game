import QtQuick 2.0
import Felgo 3.0
import QtMultimedia 5.0

import "./Controls.js" as Controls

BackgroundMusic{
    id:menuMusic
    autoPlay:Controls.autoPlay()
    source:"../Music/mainBGM.mp3"
}


