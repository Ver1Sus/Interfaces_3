function createWindows(qmlname) {
    var component = Qt.createComponent(qmlname);
    console.log("Create window:", component.status, component.errorString());
    var c = component.createObject(root, {"x": 0, "y": 0});
}



///------ добавить или удалить итем из списка фаворитов текущего пользователя
function addRemoveFavorite(id_item){

    console.log("Add item "+id_item+" to favorite of user: "+userName+" ("+userId+")");

    var xhr = new XMLHttpRequest();
    xhr.open("GET", serverHost+"test.php?add_remove_favorites=1&user_id="+userId+"&item_id="+id_item);
    var result = xhr.send();
}

//----- строит поный список всех элементов
function requestURL() {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED')
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            print('DONE all load')

            var json = JSON.parse(xhr.responseText.toString())
            view.model = json.items

        }
        return json
    }
    print("----start----")
    xhr.open("GET", serverHost+"test.php?json-dbase=1&user_id="+root.userId);
    var result = xhr.send();

    return result
}


//--- строит список только фаворитных элементов
function getFavorite(user_id) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED')
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            print('DONE load favorite')

            var json = JSON.parse(xhr.responseText.toString())
            view.model = json.items

//               for(var i=0; i<json.items.length; i++) {
//                   // iterate of the items array entries
//                   print(json.items[i].title + " - title") // title of picture
//                   print(json.items[i].type + " - type") // url of thumbnail
//                   print(json.items[i].value + " - value") // url of thumbnail
//                   print(" ") // url of thumbnail
//               }
        }
        return json
    }
    print("----start----")
    xhr.open("GET", serverHost+"test.php?favorites=1&user_id="+user_id);
    var result = xhr.send();

    return result
}


//----- аутентификация пользователя
function checkAndLoad(qmlname) {
    var userNameText = username.text
    var passwText = passw.text
    console.log(serverHost+"test.php?auth=1&userName="+userNameText+"&pass="+passwText)

    var xhr = new XMLHttpRequest();
    xhr.open("GET", serverHost+"test.php?auth=1&userName="+userNameText+"&pass="+passwText);
    xhr.send();

    //---- запускается во вемя вызова xhr.send();
    xhr.onreadystatechange = function(){
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED')
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            print('DONE auth')
            var json = JSON.parse(xhr.responseText.toString())
            var result = json.user_id

            //---- если вернулся не пустой id - значит можно открыть доступ
            if (result > 0){
                console.log("user = "+result)
                root.userId = result;
                root.userName = userNameText;

                var component = Qt.createComponent(qmlname);
                console.log("Component Status:", component.status, component.errorString());
                var c = component.createObject(root, {"x": 0, "y": 0});
            }
            else{
                errorText.text = "Invalid login/pasword"
            }

        }
        return json
    }
}
