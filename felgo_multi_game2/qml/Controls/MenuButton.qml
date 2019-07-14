import QtQuick 2.0
import QtQuick.Controls 2.7

Rectangle {
    id:menubutton
    property int paddingHorizontal:20
    property string str:qsTr("Button")
    property alias mouseArea:mouseArea
    property int fontSize:90
    property string colors:"#c3b5e8"

    width:buttonText.width+paddingHorizontal*2
    height:buttonText.height
    color:colors
    radius:20

    Text{
        id:buttonText
        anchors.centerIn:parent
        font.pixelSize:fontSize
        color:"white"
        text:str
    }
    MouseArea{
        id:mouseArea
        anchors.fill:menubutton
        onPressed:menubutton.opacity=0.5
        onReleased:menubutton.opacity=1
    }
}
