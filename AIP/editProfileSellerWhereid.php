<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$id = $_GET['id'];	
		$name = $_GET['name'];
		$firstName = $_GET['firstName'];
		$lastName = $_GET['lastName'];
		$name_store = $_GET['name_store'];
		$details = $_GET['details'];
		$email = $_GET['email'];
		$phone = $_GET['phone'];
		$avater = $_GET['avater'];
		$profile_store = $_GET['profile_store'];
				
							
		$sql = "UPDATE `user` SET `name` = '$name', `firstName` = '$firstName', `lastName` = '$lastName', `name_store` = '$name_store', `details` = '$details', `email` = '$email', `phone` = '$phone', `avater` = '$avater', `profile_store` = '$profile_store' WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Kimochiii";
   
}

	mysqli_close($link);
?>