import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
Control {
    id: control
    property real size: 200
    property real ringWidth: size/4
    readonly property color color: Qt.hsva(mousearea.angle, 1.0, 1.0, 1.0)
    height: size
    width: size
    signal valueChanged(color newColor)
    Rectangle {
        id: chosenRing
        anchors.centerIn: control
        width: control.width
        height: control.height
        radius: width/2
    }
    ConicalGradient {
        width: control.width
        height: control.height
        anchors.centerIn: control
        angle: 0
        source: chosenRing
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.hsva(0.0, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.1; color: Qt.hsva(0.1, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.2; color: Qt.hsva(0.2, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.3; color: Qt.hsva(0.3, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.4; color: Qt.hsva(0.4, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.5; color: Qt.hsva(0.5, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.6; color: Qt.hsva(0.6, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.7; color: Qt.hsva(0.7, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.8; color: Qt.hsva(0.8, 1.0, 1.0, 1.0) }
            GradientStop { position: 0.9; color: Qt.hsva(0.9, 1.0, 1.0, 1.0) }
            GradientStop { position: 1.0; color: Qt.hsva(1.0, 1.0, 1.0, 1.0) }
        }
    }
    Rectangle {
        id: centerRing
        anchors.centerIn: control
        width: control.width - control.ringWidth
        height: control.height - control.ringWidth
        radius: width/2
        color: control.color
        border {
            width: 5
            color: Qt.lighter(control.color)
        }
    }
    Rectangle {
        id: indicator
        width: control.ringWidth /2
        height: width
        radius: width/2
        x: (control.width- width)/2
        y: 0
        color: Qt.darker(control.color)
        border {
            width: mousearea.containsPress ? 10 : 5
            color: Qt.lighter(control.color)
            Behavior on width { NumberAnimation { duration: 50 } }
        }
        transform: Rotation {
            angle: mousearea.angle * 360
            origin.x: indicator.width/2
            origin.y: control.height/2 - indicator.y
            onAngleChanged: {
                control.valueChanged(control.color)
            }
        }
    }
    MouseArea {
        id: mousearea
        anchors.fill: parent
        property real angle: 0
        onClicked: {
            angle = 0.5 + Math.atan2(parent.width/2 - mouseX, mouseY - parent.height/2) / (2*Math.PI)
        }
        onPositionChanged: {
            angle = 0.5 + Math.atan2(parent.width/2 - mouseX, mouseY - parent.height/2) / (2*Math.PI)
        }
    }
}
