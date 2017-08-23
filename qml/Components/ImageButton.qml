import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
    id: button

    signal clicked
    property var btSize: 81
    property alias text: label.text
    property alias source: image.source

    Layout.fillWidth: btSize === 0
    Layout.preferredWidth: btSize > 0 ? btSize : 81
    Layout.preferredHeight: btSize > 0 ? btSize : 81

    onClicked: app.playSoundEffect ("click.wav")

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
    }

    ColumnLayout {
        spacing: app.spacing
        anchors.centerIn: parent

        SvgImage {
            id: image
            fillMode: Image.Pad
            verticalAlignment: Image.AlignVCenter
            horizontalAlignment: Image.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: label
            Layout.preferredWidth: btSize
            font.pixelSize: btSize === 0 ? 12 : 14
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
