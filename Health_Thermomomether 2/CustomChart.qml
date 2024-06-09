import QtQuick

Rectangle {
    id: root
    width: parent.width
    height: parent.height - gaugeTemperature.height - 50
    color: "transparent"

    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    property var measurnments: []
    property var measurnmentsTimeStamps: []
    property alias minValue: row.minValue
    property alias maxValue: row.maxValue

    Text{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: "Temperature history"
        font.weight: Font.Bold
        font.pixelSize: 24
    }

    Row{
        id: row
        width: parent.width - 20
        height: parent.height - 80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: (width - 250)/9

        property double minValue: 20
        property double maxValue: 40
        Repeater{
            id: repeater
            model: root.measurnments
            delegate: Rectangle{
                anchors.bottom: parent.bottom
                color: row.getColorForValue(measurnments[index])
                width: 25
                height: {
                    var scaledHeight = row.mapValue(measurnments[index], row.minValue, row.maxValue, 0, row.height)
                    scaledHeight = Math.max(0, Math.min(row.height, scaledHeight))
                    return scaledHeight
                }
                Text{
                    text: root.measurnments[index]
                    anchors.bottom: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text{
                    text: root.measurnmentsTimeStamps[index] || ""
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: 90
                    font.pixelSize: 12
                }

            }

        }
        function getColorForValue(value) {
            if (value < 25.0) {
                return Qt.rgba(0.2, 0.2, 0.9, 1); // Blue for normal temperature
            } else if (value < 30.0) {
                return Qt.rgba(0.9, 0.9, 0.2, 1); // Yellow for mild fever
            } else {
                return Qt.rgba(0.9, 0.2, 0.1, 1); // Red for high fever
            }
        }
        function mapValue(value, fromLow, fromHigh, toLow, toHigh) {
            return (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
        }
    }
    Rectangle{
        width: parent.width
        height: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        color: "purple"
        Text{
            text: row.minValue + "°C"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.bottom
            font.pixelSize: 16
        }
    }
    Rectangle{
        width: parent.width
        height: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        color: "purple"
        Text{
            text: row.maxValue + "°C"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.top
            font.pixelSize: 16
        }
    }



}
