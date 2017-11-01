import QtQuick 2.0
import QtMultimedia 5.6
import "js.js" as JScript

Item {
    //-------------------------- список всех-----------
   id: listViewItem
        x:0; y:0
        width: parent.width
        height: parent.height
    Rectangle{
     anchors.fill: parent
     color:"#587B8E"
     z:0
    }

        //---------------- Для отображения фаворитов
        Rectangle{
            id: headerText
            z:4;x:0;y:0
            color: "#FFF7BC"
            width: parent.width
            height: parent.height*0.05

            Text {
 //               z:5; x:0; y:0
                anchors.fill: parent
                color:"black"
                text: qsTr("Favorites of user: "+ userName)
                font.pointSize: 11
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea{
                anchors.fill: parent
                onClicked: JScript.getFavorite(userId)
                onDoubleClicked: JScript.requestURL()
            }
        }

        ////----------- сама вьюха которая заполняется json-ом
        ListView {
            id:view
            anchors.fill: parent
            anchors.topMargin: headerText.height
            spacing: 4
            clip: true
            snapMode: ListView.SnapOneItem
            orientation: ListView.Horizontal
            delegate:
                Loader{
                    id: loaderId
                    x:400; y:0
                    property int  favorWidth: listViewItem.height*0.03
                    property int  favorHeight: listViewItem.height*0.03
                    property string jsonValue: modelData.value
                    property string jsonType: modelData.type
                    property string jsonTitle: modelData.title
                    property string jsonId: modelData.id
                    property string jsonFavor: modelData.favor

                    width: listViewItem.width
                    height: listViewItem.height*0.9



                    sourceComponent:
                        switch(modelData.type){
                            case "Text": return textDelegate
                            case "Image": return imageDelegate
                            case "Web": return webDelegate
                            case "Video": return videoDelegate
                            case "Audio": return audioDelegate
                            default: return emptyDelegate
                        }


             //---------------компоненты пошли тут всякие вот
                    Component{
                        id: imageDelegate
                        Rectangle{
                            color: "#D3BAD3"
                            //---- кнопочка с избранным
                            Rectangle{
                                id: imageDelegate_favor
                                anchors.right: parent.right
                                anchors.top: parent.top
                                color:
                                    if(jsonFavor == "1") return "yellow"
                                    else return "white"
                                width: favorWidth
                                height: favorHeight

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("a")
                                        if (imageDelegate_favor.color == "#ffffff")
                                            imageDelegate_favor.color = "yellow"
                                        else imageDelegate_favor.color = "white"

                                        JScript.addRemoveFavorite(jsonId)
                                    }
                                }

                            }
                            //--- заголовок
                            Text {
                                id:imagetext
                                text: qsTr("Image: "+modelData.title)
                            }
                            //--- сама пикча
                            Image {
                                y: imagetext.height
                                source: serverHost+modelData.value
                            }
                        }
                    }

                    Component{
                        id: audioDelegate
                        Rectangle{
                            color: "#87A0DB"
                            //---- кнопочка с избранным
                            Rectangle{
                                id: audioDelegate_favor
                                anchors.right: parent.right
                                anchors.top: parent.top
                                z:5
                                color:
                                    if(jsonFavor == "1") return "yellow"
                                    else return "white"
                                width: favorWidth
                                height: favorHeight
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if (audioDelegate_favor.color == "#ffffff")
                                            audioDelegate_favor.color = "yellow"
                                        else audioDelegate_favor.color = "white"
                                        JScript.addRemoveFavorite(jsonId)
                                    }
                                }

                            }
                            SoundEffect {
                                    id: music
                                    source: serverHost+modelData.value
                                }

                            Text {
                                text: qsTr("Audio: "+modelData.title)
                            }
                            Image{
                                id: audio_img
                                width: parent.width/4
                                height: parent.width/4
                                x:parent.width*0.4
                                y:parent.height*0.4
                                source: "./btn_play.png"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    music.play()
                                }

                            }
                        }
                    }

                    Component{
                        id:webDelegate
                        Rectangle{
                            color: "#EABEBB"
                            //---- кнопочка с избранным
                            Rectangle{
                                id: webDelegate_favor
                                anchors.right: parent.right
                                anchors.top: parent.top
                                color:
                                    if(jsonFavor == "1") return "yellow"
                                    else return "white"
                                width: favorWidth
                                height: favorHeight

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if (webDelegate_favor.color == "#ffffff")
                                            webDelegate_favor.color = "yellow"
                                        else webDelegate_favor.color = "white"
                                        JScript.addRemoveFavorite(jsonId)

                                    }
                                }
                            }
                            Text {
                                text: qsTr("WEB: "+modelData.title+"\n"+modelData.value)
                            }


     //                            WebView {
     //                                id: webView
     //                                anchors.fill: parent
     //                                url: modelData.value
     //                                onLoadingChanged: {
     //                                    if (loadRequest.errorString)
     //                                        console.error(loadRequest.errorString);
     //                                }
     //                            }
                        }
                    }

                    Component{
                        id: videoDelegate
                        Rectangle{
                            color: "#000"
                            //---- кнопочка с избранным
                            Rectangle{
                                id: videoDelegate_favor
                                anchors.right: parent.right
                                anchors.top: parent.top
                                color:
                                    if(jsonFavor == "1") return "yellow"
                                    else return "white"
                                width: favorWidth
                                height: favorHeight
                                z:5

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if (videoDelegate_favor.color == "#ffffff")
                                            videoDelegate_favor.color = "yellow"
                                        else videoDelegate_favor.color = "white"
                                        player.stop()
                                        JScript.addRemoveFavorite(jsonId)
                                    }
                                }
                            }
                            Text {
                               id:videoText
                               color: "white"
                               text: qsTr("Video: "+modelData.title)
                           }
                            Image{
                                width: parent.width/4
                                height: parent.width/4
                                x:parent.width*0.4
                                y:parent.height*0.4
                                source: "./btn_play.png"
                            }
                            MediaPlayer {
                                    id: player
                                    source: serverHost+modelData.value
                                }
                            VideoOutput {
                                    anchors.fill: parent
                                    source: player
                                }

                            MouseArea{
                                anchors.fill: parent

                                onClicked: {
                                    player.play();
                                }
                                onDoubleClicked: {
                                    player.stop()
                                }

                            }
                        }
                    }


                    Component{
                        id: emptyDelegate
                        Rectangle{
                            color: "#afddaf"
                            Text {
                                text: qsTr(modelData.title)
                            }
                        }
                    }

                }


             //---- а этот отдельно от всех, не потому что он особенный, а потом что надо вообще все в отдельный файл вынести
            Component {
                    id: textDelegate
                    Rectangle {
                        color: "#8BA5A0"
                        //---- кнопочка с избранным
                        Rectangle{
                            id: textDelegate_favor
                            anchors.right: parent.right
                            anchors.top: parent.top
                            color:
                                if(jsonFavor == "1") return "yellow"
                                else return "white"
                            width: favorWidth
                            height: favorHeight

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    if (textDelegate_favor.color == "#ffffff")
                                        textDelegate_favor.color = "yellow"
                                    else textDelegate_favor.color = "white"
                                    JScript.addRemoveFavorite(jsonId)
                                }
                            }
                        }
                        Text {
                            color: "white"
                            text: qsTr("Text: "+jsonTitle + "\n" + jsonValue)
                        }
                    }
                }


    /*

        csv файлы

        сначала форма авторизацией - отправка логина пароля,
        проверка и редирект на 200 ОК если совпдают пароли

        onURLchange - подгрузить json

        если вернулось 200 ОК, то подгрузить json и вывести

      */

        }


    /*
        GridView {
            id: view
            anchors.fill: parent
            cellWidth: parent.width/view.count
            cellHeight: parent.height/4
            delegate:
                Rectangle {
                width: view.cellWidth
                height: view.cellHeight
                border.color: "#000"
 //                color: modelData.value
                Text {
                    text: qsTr(modelData.title + ":\n" + modelData.value)
                }

                MouseArea{
                    anchors.fill: parent


                    NumberAnimation {
                        id: forText_SlideUp
                        target: forText
                        properties: "y"
                        to: 0
                        duration: listViewItem.duration
                    }

                    onClicked:{
                        forText_Text.text = modelData.value
                        onClicked: forText_SlideUp.restart()
                       // pageLoader.source = value+".qml"
                        forImage.z = -1
                        var type = modelData.type.toString()

                        if (type == "Text"){
                            console.log("text")
                        }
                        else if(type == "Image")
                        {
                            console.log("img")
                            forImage.z = 5
                            forText_Text.text=""
                            forImage.source = serverHost+modelData.value
                        }
                        else if(type == "Web")
                        {
                            console.log("web")
                            forText_Text.text="can't use WebEngineView, Qt version 5.9"
                            //pageLoader.source = "changeItem.qml"

                        }
                    }
                }

            }
        }

 */








        Component.onCompleted: {
 //         requestURL("test.php?json=1")
            console.log("test.php?json-dbase=1&user_id="+root.userId)
            JScript.requestURL()
 //           JScript.getFavorite(1)

        }




}
