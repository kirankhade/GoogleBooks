import QtQuick 2.5
import QtQuick.Controls 1.4 as QtQuickControls1
import QtQuick.Controls 2.0 as QtQuickControls2


PathView {
    id: coverFlowView
    width: 550; height: 300
    currentIndex: -1
    pathItemCount: 6
    clip: true

    Keys.onLeftPressed: coverFlowView.decrementCurrentIndex()
    Keys.onRightPressed: coverFlowView.incrementCurrentIndex()

    onActiveFocusChanged: {
        if(!coverFlowView.currentIndex)
            currentIndex = -1
    }

    delegate: Item {
        id: coverFlowViewItem
        width: height; height: coverFlowView.height
        scale: PathView.itemScale === undefined? 0 : PathView.itemScale
        opacity: PathView.itemOpacity === undefined? 0 : PathView.itemOpacity
        z: PathView.itemZ === undefined? 0 : PathView.itemZ
        property bool inFocus: PathView.itemScale > 0.6
        property real angle: PathView.itemAngle === undefined? 0 : PathView.itemAngle

        transform: Rotation {
            origin.x: coverFlowViewItem.width/2
            origin.y: coverFlowViewItem.height/2
            angle: coverFlowViewItem.angle
            axis { x: 0; y: 1; z: 0 }
        }

        Rectangle {
            id: bookCoverArtArea
            height: parent.height - 4
            width: height*0.74
            anchors.horizontalCenter: parent.horizontalCenter
            color: bookCoverArt.status === Image.Ready ? "black" : "lightgray"

            Image {
                id: bookCoverArt
                anchors.fill: parent
                anchors.margins: 1.5
                source: bookThumbnail
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }
    }

    path: Path {
        // "Start zone"
        startX: -25
        startY: coverFlowView.height / 2
        PathAttribute { name: "itemZ"; value: 0 }
        PathAttribute { name: "itemAngle"; value: 70 }
        PathAttribute { name: "itemScale"; value: 0.25 }
        PathAttribute { value: 0.3; name: "itemOpacity" }

        // Just before middle
        PathLine { x: coverFlowView.width * 0.35; y: coverFlowView.height / 2;  }
        PathAttribute { name: "itemZ"; value: 50 }
        PathAttribute { name: "itemAngle"; value: 45 }
        PathAttribute { name: "itemScale"; value: 0.55 }
        PathAttribute { value: 0.6; name: "itemOpacity" }
        PathPercent { value: 0.40 }

        // Middle
        PathLine { x: coverFlowView.width * 0.5; y: coverFlowView.height / 2;  }
        PathAttribute { name: "itemZ"; value: 100 }
        PathAttribute { name: "itemAngle"; value: 0 }
        PathAttribute { name: "itemScale"; value: 1.0 }
        PathAttribute { value: 1; name: "itemOpacity" }

        // Just after middle
        PathLine { x: coverFlowView.width * 0.65; y: coverFlowView.height / 2; }
        PathAttribute { name: "itemZ"; value: 50 }
        PathAttribute { name: "itemAngle"; value: -45 }
        PathAttribute { name: "itemScale"; value: 0.55 }
        PathAttribute { value: 0.6; name: "itemOpacity" }
        PathPercent { value: 0.60 }

        // Final stop
        PathLine { x: coverFlowView.width + 25; y: coverFlowView.height / 2; }
        PathAttribute { name: "itemZ"; value: 0 }
        PathAttribute { name: "itemAngle"; value: -70 }
        PathAttribute { name: "itemScale"; value: 0.25 }
        PathAttribute { value: 0.3; name: "itemOpacity" }
        PathPercent { value: 1.0 }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(!coverFlowView.activeFocus)
                coverFlowView.forceActiveFocus()
        }
    }
}

