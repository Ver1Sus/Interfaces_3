<?php


$mysql = new mysqli('localhost','***','***','study');

if(isset($_POST['test'])){

	echo "testing zone";


}


if(isset($_GET['test'])){
	echo $_GET['test'];
	echo md5('91db564a');
	echo strlen(md5('fjnch4jd'));

	$cookieHash = md5(uniqid(rand(),true));
   		$cookieHash = substr($cookieHash,0,8);

   		echo "<br>".md5($cookieHash);
}


//------ предварительная авторизация. Если имеется такой md5(хэш) то вернуть id юзера
if(isset($_POST['cookieName'])){
	$cookieName = $_POST['cookieName'];
	$result = $mysql->query("SELECT id, login FROM users WHERE cookieHash='".md5($cookieName)."'");

	$row = $result->fetch_array();
	echo '{"user_id":"'.$row ['id'].'", "user_name":"'.$row['login'].'"}';

}



if(isset($_POST['json'])){

	$json = '{
 "items":[
	{
	"title":"Item2",
        "type":"Image",
	"value":"11.jpg"
	},
	{
	"title":"Item42",
        "type":"Text",
	"value":"TextZone"
        },
        {
	"title":"Item2",
	"type":"Web",
	"value":"WebText"
        },
		
	{
	"title":"Item1",
        "type":"Image",
	"value":"11.jpg"
	},
	{
	"title":"Item2",
        "type":"Text",
	"value":"TextZone"
        },
        {
	"title":"Item2",
	"type":"Web",
	"value":"WebText"
        }
 ]}';

 	echo $json;

}


///---- вернуть список всех элементов. Если у указанного пользоваоталя элемент фаворитный, то столбик favor = 1, иначе 0
if(isset($_POST['json-dbase']) and isset($_POST['user_id']) ){
	
	$user_id = $_POST['user_id'];
	// $result = $mysql->query("SELECT * FROM itm_list");

	$result = $mysql->query("SELECT *, CASE WHEN tbl_item.id IN 
				(SELECT in_item FROM favorites WHERE id_user=$user_id) 
				THEN 1 
				ELSE 0 END AS favor 
			FROM itm_list AS tbl_item");





	$row_count =  $result->num_rows;

	$json = '{"items":[';
	$subRow = "";
	for ($i = 0; $i < $row_count; $i++){

		$row = $result->fetch_array();

		$subRow = '{"id":"'.$row['id'].'",
					"title":"'.($row['title']).'", 
					"type":"'.$row['type'].'", 
					"value":"'.$row['value'].'",
					"favor":"'.$row['favor'].'"},';
		$json .= $subRow;
	}

	$json = rtrim($json,',')."]}";
	echo $json;
}



//---------- вернуть список фаворитов у выбранного пользователя
// if(isset($_POST['favorites']) and isset($_POST['user_id'])){
if(isset($_POST['favorites']) and isset($_POST['user_id'])){
	$result = $mysql->query("SELECT *, 1 as favor FROM itm_list as tbl_item
			left join favorites as tbl_favor on tbl_item.id = tbl_favor.in_item
			where tbl_item.id = tbl_favor.in_item and tbl_favor.id_user = ".$_POST['user_id']);

	$row_count =  $result->num_rows;

	$json = '{"items":[';
	$subRow = "";
	for ($i = 0; $i < $row_count; $i++){

		$row = $result->fetch_array();

		$subRow = '{"id":"'.$row['id'].'",
					"title":"'.($row['title']).'", 
					"type":"'.$row['type'].'", 
					"value":"'.$row['value'].'",
					"favor":"'.$row['favor'].'"},';
		$json .= $subRow;
	}

	$json = rtrim($json,',')."]}";
	echo $json;
}




///--- добавить пользователю новый элемент фаворита, или удалить его
if(isset($_POST['add_remove_favorites']) and isset($_POST['user_id']) and isset($_POST['item_id'])){

	///---- лень делать процедуру, поэтому проверку на наличие делаем тут
	$result = $mysql->query("select exists(select * from favorites where id_user=".$_POST['user_id']." and in_item= ".$_POST['item_id'].")");
	
	$row = $result->fetch_array();


	if ($row[0] == "1"){
		$result = $mysql->query("delete from favorites where id_user=".$_POST['user_id']." and in_item=".$_POST['item_id']);
	}
	else{
		$result = $mysql->query("insert into favorites values(".$_POST['user_id'].", ".$_POST['item_id'].")");
	}
	

}


//----------- авторизация, вернуть id записи, если норм, и 0 если нет такой учетки
if(isset($_POST['auth']) and isset($_POST['userName']) and isset($_POST['pass'])){

	$result = $mysql->query("select id from users where login=\"".$_POST['userName']."\" and passw= \"".$_POST['pass']."\"");

	$row = $result->fetch_array();

	//---- Если авторизация прошла - генерируем новый куки и возвращаем клиенту, чтобы сохранить его, а в базу сохраняем его хэш
	if($row [0] > 0){
		$cookieHash = md5(uniqid(rand(),true));
   		$cookieHash = substr($cookieHash,0,15);
   		$mysql->query("UPDATE users SET  cookieHash=\"".md5($cookieHash)."\" WHERE id=".$row [0]);
   	}

	echo '{"user_id":"'.$row [0].'", "cookieHash":"'.$cookieHash.'"}';

	
	// if (strlen($row[0]) > 0)
	// 	echo $row[0];
	// else
	// 	echo "0";
	

}






$mysql->close();


?>
