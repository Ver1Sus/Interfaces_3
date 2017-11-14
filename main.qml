import QtQuick 2.6
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import io.qt.examples.backend 1.0



import "js.js" as JScript


Window {
    id:root
    visible: true
    height:640
    width:480

    color:"#587B8E"
    title: qsTr("Hello World")
//    property string serverHost: "http://192.168.0.103/static/"
        property string serverHost: "http://192.168.43.58//static/"
//    property string serverHost: "http://local1host/static/"
    property int duration: 300
    property string userName: ""
    property int  userId: 0



    BackEnd {
            id: backend
        }


    Component.onCompleted: {
        //--- преавторизация используя куки. Если предавторизация не прошла,
            //-- то вызывается окно 'forms.qml'
        JScript.preAuth(backend.getCookie, "components.qml")



    }


    /*

      Qsetting - сохранение куки для автоматический аутетнтификации без ввода пароля
      Кнопка выход для сброса этой переменной чтобы войти другим пользователем
      все на пост-запросах построить

     */

}
