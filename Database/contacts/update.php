<?php

include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}


$sql = "UPDATE contacts
		SET contactName = ".$_GET['contactName'].",
		 	contactPhoneNumber = ".$_GET['contactPhoneNumber']."
		WHERE contact_id = ".$_GET['contact_id'];


if ($con->query($sql) == TRUE) {
    echo "updated record successfully\n";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);

?>