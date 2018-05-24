import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    property alias model: booksView.model

    ScrollView {
        anchors.fill: parent

        ListView {
            id: booksView
            clip: true
            delegate: booksViewDelegate
        }
    }

    Component {
        id: booksViewDelegate

        Item {
            height: 100
            width: booksView.width-1

            Row {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 10

                Image {
                    id: thumb
                    height: parent.height
                    width: height
                    fillMode: Image.PreserveAspectCrop
                    source: bookThumbnail
                }

                Column {
                    width: parent.width - thumb.width - parent.spacing
                    spacing: 5

                    Text {
                        font.pixelSize: 24
                        text: bookTitle
                        width: parent.width
                        elide: Text.ElideRight
                    }

                    Text {
                        font.pixelSize: 18
                        text: bookAuthors.join(", ")
                        width: parent.width
                        elide: Text.ElideRight
                    }

                    Text {
                        font.pixelSize: 12
                        text: bookDescription
                        width: parent.width
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "black"
            }
        }
    }
}
