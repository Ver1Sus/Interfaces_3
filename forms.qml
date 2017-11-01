import QtQuick 2.0
import QtQuick.Controls 2.2
import "js.js" as JScript

Item {
    Text {
            id: usernamelabel
            x: root.width*0.1
            y: root.height*0.1
            height: root.height*0.03
            width: root.width*0.8
            horizontalAlignment: Text.AlignHCenter
            text: "Username"
        }

        TextField {
            id: username
            x: root.width*0.1
            anchors.top: usernamelabel.bottom
            text:"a"
            height: root.height*0.05
            horizontalAlignment: Text.AlignHCenter
            width: root.width*0.8
        }

        Text {
            id: passwordlabel
            x: root.width*0.1
            height: root.height*0.03
            width: root.width*0.8
            text: "Password"
            anchors.top: username.bottom
            horizontalAlignment: Text.AlignHCenter

        }

        TextField {
            id: passw
            x: root.width*0.1
            height: root.height*0.05
            width: root.width*0.8
            text:"a"
            echoMode: TextInput.Password
            anchors.top: passwordlabel.bottom
            horizontalAlignment: Text.AlignHCenter

        }

        Button {
            id: loginbtn
            x: root.width*0.3
            height: root.height*0.05
            width: root.width*0.4
            text: "login"
            anchors.top: passw.bottom
            onClicked: {
                errorText.text="";
                JScript.checkAndLoad("components.qml")
            }
        }
        Text {
            id: errorText
            color:"red"
            text: qsTr("")
            x: root.width*0.3
            height: root.height*0.05
            width: root.width*0.4
            horizontalAlignment: Text.AlignHCenter
            anchors.top: loginbtn.bottom
        }





}
