import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCharts
import QtCharts 2.7

ApplicationWindow {
    id: applicationWindow
    Material.theme: Material.Light
    Material.accent: Material.Blue
    Material.primary: Material.Blue
    width: 400
    minimumWidth: 400
    height: 800
    minimumHeight: 800
    visible: true
    title: qsTr("BLE Health Thermometer")
    property bool disconnect: true
    property int place: 6
    property var places : ["NoTempType", "Armpit","Body","Ear","Finger","GastroInt","Mouth","Rectum","Toe","Tympanum"]
    property var measurnments: []
    property var measurnmentsPlaces: []
    property var measurnmentsTimeStamps: []
    Component.onCompleted: applicationWindow.fetchDataFromThingSpeak()
    signal dataFetched

    function getColorForValue(value) {
        if (value < 25.0) {
            return Qt.rgba(0.2, 0.2, 0.9, 0.5); // Blue for normal temperature
        } else if (value < 30.0) {
            return Qt.rgba(0.9, 0.9, 0.2, 0.5); // Yellow for mild fever
        } else {
            return Qt.rgba(0.9, 0.2, 0.1, 0.5); // Red for high fever
        }
    }

    onDataFetched: {
        console.log("Data successfully fetched from ThingSpeak:");
        console.log("Measurements:", applicationWindow.measurnments);
        console.log("Measurement Places:", applicationWindow.measurnmentsPlaces);
        console.log("Measurement TimeStamps:", applicationWindow.measurnmentsTimeStamps);

        mySeries.clear();
        axisX.categories = applicationWindow.measurnmentsTimeStamps;
        mySeries.append("mes", applicationWindow.measurnments)
        mySeries.at(0).color = Qt.rgba(0.9, 0.2, 0.1, 0.5)

        myCustomChart.measurnments = []
        myCustomChart.measurnments = applicationWindow.measurnments

        myCustomChart.measurnmentsTimeStamps = []
        myCustomChart.measurnmentsTimeStamps = applicationWindow.measurnmentsTimeStamps


    }

    function fetchDataFromThingSpeak(){
        var thingSpeakURL = "https://api.thingspeak.com/channels/2562038/feeds.json?api_key=F0PHP8CNEI5JQGHU&results=10";
        console.log(thingSpeakURL);

        var xhr = new XMLHttpRequest();
        xhr.open("GET", thingSpeakURL, true);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status == 200) {
                    var response = JSON.parse(xhr.responseText);
                    var feeds = response.feeds;

                    // Reset the arrays
                    applicationWindow.measurnments = [];
                    applicationWindow.measurnmentsPlaces = [];
                    applicationWindow.measurnmentsTimeStamps = [];

                    for (var i = 0; i < feeds.length; i++) {
                        var field1 = parseFloat(feeds[i].field1);
                        var field2 = parseInt(feeds[i].field2);
                        var createdAt = feeds[i].created_at;

                        applicationWindow.measurnments.push(Math.round(field1*100)/100);
                        applicationWindow.measurnmentsPlaces.push(field2);
                        applicationWindow.measurnmentsTimeStamps.push(createdAt.substring(11,19))
                    }
                    dataFetched()
                } else {
                    console.error("Error fetching data from ThingSpeak: " + xhr.statusText);
                }
            }
        };

        xhr.send();
    }

    header: ToolBar {
        contentHeight: toolButtonScan.implicitHeight
        Row{
            ToolButton {
                id: toolButtonScan
                text: "\u2630"
                font.pixelSize: Qt.application.font.pixelSize * 1.6
                onClicked: {
                    scanButton.enabled=true;
                    scanButton.text = disconnect ? "Scan" : "Disconnect"
                    drawer.open()
                }
            }
            ToolSeparator {}
            Label{
                id: timeLabel
                y:12
                text: " "
                font.pixelSize: Qt.application.font.pixelSize * 1.5
            }
        }
        Image {
            id: batteryIcon
            source: "icons/batt.png"
            width: 32
            height: 32
            y:8
            anchors.right: parent.right
            anchors.rightMargin: 10
        }
        Label {
            id: battText
            anchors.right: batteryIcon.left
            anchors.rightMargin: 6
            y:16
            text: "---%"
        }
    }
    Drawer {
        id: drawer
        width: 250
        height: applicationWindow.height
        Button {
            id: scanButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width-20
            text: "Scan"
            onClicked: {
                listView.enabled=false
                if(disconnect) {
                    text="Scanning..."
                    enabled = false
                    busyIndicator.running=true
                    bledevice.startScan()
                } else {
                    bledevice.disconnectFromDevice()
                }
            }
        }
        ListView {
            id: listView
            anchors.fill: parent
            anchors.topMargin: 50
            anchors.bottomMargin: 50
            width: parent.width
            clip: true
            model: bledevice.deviceListModel
            delegate: RadioDelegate {
                id: radioDelegate
                text: (index+1)+". "+modelData
                width: listView.width
                onCheckedChanged: {
                    console.log("checked", modelData, index)
                    scanButton.enabled=false;
                    scanButton.text="Connecting to "+modelData
                    listView.enabled = false;
                    bledevice.startConnect(index)
                }
            }
        }
        BusyIndicator {
            id: busyIndicator
            Material.accent: "Blue"
            anchors.centerIn: parent
            running: false
        }
    }
    Gauge {
        id: gaugeTemperature
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        //size: (parent.width < parent.height ? parent.width : parent.height) * 0.8
        width: 300
        height: 300
        colorCircle: "cyan"
        colorBackground: "#808080"
        lineWidth: 0.1*width
        showGlow: false
        quantity: "Temperature"
        unit: "\xB0C"
        from:0
        to:50
        min: 0
        value: 0
    }

    ChartView {
        visible: false
        id: myChart
        title: "Measurement history"
        width: parent.width
        height: parent.height - gaugeTemperature.height - 50
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
        backgroundColor: applicationWindow.color
        legend.visible: false


        BarSeries {
            id: mySeries

            axisX: BarCategoryAxis {
                id: axisX
                labelsAngle: 90
            }
            axisY: ValuesAxis {
                min: 20
                max: 40
            }
        }
    }
    CustomChart{
        id: myCustomChart
        measurnments: applicationWindow.measurnments
        measurnmentsTimeStamps: applicationWindow.measurnmentsTimeStamps
    }

    footer: ToolBar {
        width: parent.width
        Label{
            id: intermediateTemperatureLabel
            anchors.left: parent.left
            anchors.leftMargin: 10
            y:12
            text: " "
            font.pixelSize: Qt.application.font.pixelSize * 1.5
        }

        Image{
            id: placeLabel
            y: 12
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: Qt.resolvedUrl("icons/"+applicationWindow.places[place]+".png")
            width: 30
            height: width
            antialiasing: true

        }
    }
    Connections {
        target: bledevice
        property string apiKEY: "OKM2QW375FLJVMVN"
        function onBatteryLevel(batt) {
            battText.text=+batt+"%"
        }
        function onNewIntermediateTemperature(data) {
            intermediateTemperatureLabel.text = "Intermediate: "+ data[0].toFixed(1) + " \xB0C ";

        }

        function onNewTemperature(data) {
            gaugeTemperature.value = data[0]
            place = data[2]
            console.log("Place: " + place + " " + places[place])
            if(data[0] >= 37.5)
                gaugeTemperature.colorCircle = "red"
            else
                gaugeTemperature.colorCircle = "cyan"

            timeLabel.text = data[1]
            var thingSpeakURL = "https://api.thingspeak.com/update?api_key=" + "OKM2QW375FLJVMVN" + "&field1=" + data[0] +"&field2=" + data[2];
            console.log(thingSpeakURL)
            var xhr = new XMLHttpRequest();
            xhr.open("GET", thingSpeakURL, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status == 200) {
                        console.log("Temperature data successfully sent to ThingSpeak: " + xhr.responseText);
                    } else {
                        console.error("Error sending temperature data to ThingSpeak: " + xhr.statusText);
                    }
                }
            };
            xhr.send();
            applicationWindow.fetchDataFromThingSpeak()
        }
        function onScanningFinished() {
            listView.enabled = true
            scanButton.enabled = true
            scanButton.text = "Scan"
            listView.enabled = true
            busyIndicator.running = false
            scanButton.enabled = true
            console.log("ScanningFinished")
        }
        function onConnectionStart() {
            disconnect = false
            busyIndicator.running = false
            drawer.close()
            console.log("ConnectionStart")
        }
        function onConnectionEnd() {
            disconnect = true
            scanButton.text = "Connection End - Scan again"
            scanButton.enabled = true
            bledevice.resetDeviceListModel()
            console.log("ConnectionEnd")
        }
    }
}
