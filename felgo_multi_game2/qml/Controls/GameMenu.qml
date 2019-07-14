import QtQuick 2.0


Item{
     id:menu
     visible:false
     width:500
     height:700
     anchors.centerIn:parent

     signal leaveClicked()

     MenuButton{
        id:back
        str:qsTr("Back")
        fontSize:110
        mouseArea.onClicked:{
            menu.visible=false
            gameRunning=true
        }
     }
     MenuButton{
         id:leave
         anchors.top:back.bottom
         anchors.topMargin:60
        str:qsTr("Quit")
        fontSize:110
        mouseArea.onClicked:leaveClicked()
     }
     MenuButton{
         id:set
         anchors.top:leave.bottom
         anchors.topMargin:60
        str:qsTr("Music")
        fontSize:110
        mouseArea.onClicked:musicSet.visible=true
     }
//     Rectangle{
//         id:musicSet
//         visible:false
//         color:Qt.rgba(255,255,255,1)
//         anchors.centerIn:parent
//        height:parent.height
//        width:parent.width
//        MenuButton{
//            id:musicSwitch
//            str:"音乐开关"
//            anchors.top:musicSet.top
//            anchors.topMargin:60
//            anchors.horizontalCenter:parent
//            fontSize:110
//            //mouseArea.onClicked:musicSet.visible=false
//        }
//        MenuButton{
//            str:"返回"
//            anchors.top:musicSwitch.bottom
//            anchors.topMargin:60
//            anchors.horizontalCenter:parent
//            fontSize:110
//            mouseArea.onClicked:musicSet.visible=false
//        }
//     }
}
