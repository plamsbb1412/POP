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
				
		$name = $_GET['name'];
		$firstName = $_GET['firstName'];
		$lastName = $_GET['lastName'];
		$student_id = $_GET['student_id'];
		$email = $_GET['email'];
		$phone = $_GET['phone'];
		$sex = $_GET['sex'];
		$type = $_GET['type'];
		$username = $_GET['username'];
		$password = $_GET['password'];
		$avater = $_GET['avater'];
		
							
		$sql = "INSERT INTO `user`(`id`, `name`, `firstName`, `lastName`, `student_id`, `email`, `phone`, `sex`, `type`, `username`, `password`, `avater`) VALUES (Null,'$name','$firstName','$lastName','$student_id','$email','$phone','$sex','$type','$username','$password','$avater')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	mysqli_close($link);
?>