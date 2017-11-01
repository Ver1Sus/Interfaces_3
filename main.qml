import QtQuick 2.6
import QtQuick.Window 2.2
import "js.js" as JScript

//import QtWebView 1.1

Window {
    id:root
    visible: true
    height:640
    width:480
    color:"#587B8E"
    title: qsTr("Hello World")
    property string serverHost: "http://192.168.0.101/static/"
//        property string serverHost: "http://192.168.43.58//static/"
    property int duration: 300
    property string userName: "a"
    property int  userId: 0


    Component.onCompleted: {
        JScript.createWindows("forms.qml")
    }


}
