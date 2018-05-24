import QtQuick 2.6
import QtQuick.Controls 1.4

Item {
    width: 640
    height: 480

    SearchBar {
        id: searchBar
        spacing: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        searchString: booksModel.searchString
        onSearchRequest: booksModel.searchString = searchString
    }

    Item {
        anchors.left: parent.left
        anchors.top: searchBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        ExclusiveGroup {
            id: viewOptionsGroup
        }

        Row {
            id: viewOptionsRow
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            RadioButton {
                id: listViewRadio
                text: "List View"
                checked: true
                exclusiveGroup: viewOptionsGroup
                onCheckedChanged: {
                    if(checked)
                        viewLoader.sourceComponent = listViewComponent
                }
            }

            RadioButton {
                id: gridViewRadio
                text: "Grid View"
                exclusiveGroup: viewOptionsGroup
                onCheckedChanged: {
                    if(checked)
                        viewLoader.sourceComponent = gridViewComponent
                }
            }

            RadioButton {
                id: coverflowRadio
                text: "Coverflow View"
                exclusiveGroup: viewOptionsGroup
                onCheckedChanged: {
                    if(checked)
                        viewLoader.sourceComponent = coverFlowViewComponent
                }
            }
        }

        Loader {
            id: viewLoader
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: viewOptionsRow.bottom
            anchors.bottom: parent.bottom
            active: true
            sourceComponent: listViewComponent
        }

        Component {
            id: listViewComponent

            BooksListView {
                model: booksModel
                Component.onCompleted: {
                    console.log("BooksListView.onCompleted")
                }
                Component.onDestruction: {
                    console.log("BooksListView.onDestruction")
                }
            }
        }

        Component {
            id: gridViewComponent

            ScrollView {
                BooksGridView {
                    model: booksModel
                }

                Component.onCompleted: {
                    console.log("BooksGridView.onCompleted")
                }
                Component.onDestruction: {
                    console.log("BooksGridView.onDestruction")
                }
            }
        }

        Component {
            id: coverFlowViewComponent

            BooksCoverflowView {
                model: booksModel

                Component.onCompleted: {
                    console.log("BooksCoverflowView.onCompleted")
                }
                Component.onDestruction: {
                    console.log("BooksCoverflowView.onDestruction")
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "gray"
        opacity: 0.5
        visible: booksModel.busy

        BusyIndicator {
            anchors.centerIn: parent
            running: booksModel.busy
        }

        MouseArea {
            anchors.fill: parent
        }
    }
}
