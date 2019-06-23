import QtQuick 2.0

Item{
    property string src:""
    property alias roll:roll
    property bool picRolling:false
    property int picRollingSpeed:5000
    property alias image:image
    property int size:100


    id:item
    height:size
    width:size

    NumberAnimation on rotation{
        id:roll
        from:0
        to:360
        duration:300000
        loops: Animation.Infinite
    }

    Image{
        id:image
        source:src
        height:200
        width:200
        NumberAnimation on rotation{
            running:picRolling
            from:0
            to:360
            duration:picRollingSpeed
            loops: Animation.Infinite
        }
    }
}
