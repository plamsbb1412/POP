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
		$nameProduct = $_GET['nameProduct'];
		$price = $_GET['price'];
		$priceSpecial = $_GET['priceSpecial'];
		$image = $_GET['image'];			
							
		$sql = "UPDATE `product` SET `nameProduct` = '$nameProduct', `price` = '$price', `priceSpecial` = '$priceSpecial', `image` = '$image' WHERE id = '$id'";

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