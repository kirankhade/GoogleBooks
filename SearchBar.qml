import QtQuick 2.5
import QtQuick.Controls 1.4

Row {
    spacing: 10

    property alias searchString: searchField.text

    signal searchRequest(string searchString)

    Text {
        id: searchLabel
        font.pixelSize: 12
        text: "Search String"
        anchors.verticalCenter: parent.verticalCenter
    }

    TextField {
        id: searchField
        width: parent.width - searchLabel.width - searchButton.width - 2*parent.spacing
        anchors.verticalCenter: parent.verticalCenter
    }

    Button {
        id: searchButton
        text: "Search"
        anchors.verticalCenter: parent.verticalCenter
        onClicked: searchRequest(searchField.text)
    }
}
