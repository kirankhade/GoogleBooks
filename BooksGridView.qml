import QtQuick 2.5

GridView {
    id: gridView
    property int columns: Math.floor(width/165)
    cellWidth: gridView.width / columns
    cellHeight: 200
    clip: true
    delegate: Item {
        width: gridView.cellWidth
        height: gridView.cellHeight

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            border { width: 1; color: "lightgray" }
        }

        Column {
            id: delegateContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Rectangle {
                id: bookCoverArt
                height: 110; width: 80
                anchors.horizontalCenter: parent.horizontalCenter
                color: "black"

                Image {
                    anchors.fill: parent
                    anchors.margins: 1.5
                    source: bookThumbnail
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                }
            }

            Text {
                font.pixelSize: 18
                text: bookTitle
                width: parent.width
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                font.pixelSize: 12
                color: "gray"
                text: bookDescription
                width: parent.width
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                font.pixelSize: 14
                color: "brown"
                text: bookAuthors.join(", ")
                width: parent.width
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
