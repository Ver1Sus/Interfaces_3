import QtQuick 2.6
import QtQuick.Window 2.2
import QtMultimedia 5.6
import "js.js" as JScript

//import QtWebView 1.1

Window {
    id:root
    visible: true
    height:640
    width:480
    title: qsTr("Hello World")
    property string serverHost: "http://192.168.0.103/static/"
    property int duration: 300
    property string userName: "a"
    property int  userId: 1




   //-------------------------- список всех-----------
   Rectangle{
       x:0; y:0
       width: parent.width
       height: parent.height

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
               text: qsTr("Favorites")
               font.pointSize: 11
               verticalAlignment: Text.AlignVCenter
               horizontalAlignment: Text.AlignHCenter
           }

           MouseArea{
               anchors.fill: parent
               onClicked: getFavorite(userId)
               onDoubleClicked: requestURL("test.php?json-dbase=1")
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
                   property string jsonValue: modelData.value
                   property string jsonType: modelData.type
                   property string jsonTitle: modelData.title
                   property string jsonId: modelData.id

                   width: root.width
                   height: root.height*0.9


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
                           color: "#dfaadf"
                           Text {
                               id:imagetext
                               text: qsTr(modelData.title)
                           }
                           Image {
                               y: imagetext.height
                               source: serverHost+modelData.value
                           }
                           MouseArea{
                               anchors.fill: parent
                               onDoubleClicked: addRemoveFavorite(jsonId)
                           }
                       }
                   }

                   Component{
                       id: audioDelegate
                       Rectangle{
                           color: "#0f0adf"
                           SoundEffect {
                                   id: music
                                   source: serverHost+modelData.value
                               }

                           Text {
                               text: qsTr(modelData.title)
                           }
                           MouseArea {
                                       anchors.fill: parent
                                       onClicked: music.play()
                                       onDoubleClicked: addRemoveFavorite(jsonId)

                                   }
                       }
                   }

                   Component{
                       id:webDelegate
                       Rectangle{
                           color: "#efaa00"
                           Text {
                               text: qsTr(modelData.title+"\n"+modelData.value)
                           }
                           MouseArea{
                               anchors.fill: parent
                               onDoubleClicked: {
                                   addRemoveFavorite(jsonId)
                               }
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
                           Text {
                              id:videoText
                              color: "white"
                              text: qsTr(modelData.title)
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
                                   addRemoveFavorite(jsonId)
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
                       color: "#0faa0f"
                       Text {
                           color: "white"
                           text: qsTr(jsonTitle + "\n" + jsonValue)
                       }
                       MouseArea{
                           anchors.fill: parent
                           onDoubleClicked: addRemoveFavorite(jsonId)
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
                       duration: root.duration
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

           requestURL("test.php?json-dbase=1")
//           getFavorite(1)

       }

   }


   ///------ функции за пределами лоадера не видтяся почему-то
   function addRemoveFavorite(id_item){

        console.log("Add item "+id_item+" to favorite of user: "+userName+" ("+userId+")");

       var xhr = new XMLHttpRequest();
       xhr.open("GET", serverHost+"test.php?add_remove_favorites=1&user_id="+userId+"&item_id="+id_item);
        var result = xhr.send();
   }

   function requestURL(url) {
           var xhr = new XMLHttpRequest();
           xhr.onreadystatechange = function() {
               if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                   print('HEADERS_RECEIVED')
               } else if(xhr.readyState === XMLHttpRequest.DONE) {
                   print('DONE')

                   var json = JSON.parse(xhr.responseText.toString())
                   view.model = json.items

//                       for(var i=0; i<json.items.length; i++) {
//                           // iterate of the items array entries
//                           print(json.items[i].title + " - title") // title of picture
//                           print(json.items[i].type + " - type") // url of thumbnail
//                           print(json.items[i].value + " - value") // url of thumbnail
//                           print(" ") // url of thumbnail
//                       }
               }
               return json
           }
       print("----start----")
       xhr.open("GET", serverHost+url);
       var result = xhr.send();

       return result
   }

   function getFavorite(user_id) {
           var xhr = new XMLHttpRequest();
           xhr.onreadystatechange = function() {
               if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                   print('HEADERS_RECEIVED')
               } else if(xhr.readyState === XMLHttpRequest.DONE) {
                   print('DONE')

                   var json = JSON.parse(xhr.responseText.toString())
                   view.model = json.items

//                   for(var i=0; i<json.items.length; i++) {
//                       // iterate of the items array entries
//                       print(json.items[i].title + " - title") // title of picture
//                       print(json.items[i].type + " - type") // url of thumbnail
//                       print(json.items[i].value + " - value") // url of thumbnail
//                       print(" ") // url of thumbnail
//                   }
               }
               return json
           }
       print("----start----")
       xhr.open("GET", serverHost+"test.php?favorites=1&user_id="+user_id);
       var result = xhr.send();

       return result
   }


/*

   Rectangle{
       id: forText
       width: parent.width; height: parent.height
       y: parent.height - 50
       z:2
       color: "#aeaadd"

       Rectangle{
           id: forTextBack
           color: "#fecadd"
           width:root.width * 0.3; height: root.height*0.1

           NumberAnimation {
               id: forText_SlideDown
               target: forText
               properties: "y"
               to: root.height - 40
               duration: root.duration
           }


           Text {
               text: qsTr("< BACK")
           }
           MouseArea{
               anchors.fill: parent
               onClicked: forText_SlideDown.restart()
           }
       }

       ///--------------------------------LOADER-------------------
       Loader {
           id: pageLoader
           y: forTextBack.height

       }

       ////--------------------------container form ----------
       Text {
           id: forText_Text
           y: forTextBack.height
           text: qsTr("aa")
           z:5
       }
       Image {
           id: forImage
           y: forTextBack.height
           z:-1
           source: ""
       }


   }


*/











}
