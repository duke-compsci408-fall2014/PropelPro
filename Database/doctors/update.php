<?php

include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}


$sql = "UPDATE doctors
		SET doctorName = ".$_GET['doctorName'].",
		 	doctorPhoneNumber = ".$_GET['doctorPhoneNumber'].", 
		 	doctorAddress = ".$_GET['doctorAddress']."
		WHERE doctor_id = ".$_GET['doctor_id'];


if ($con->query($sql) == TRUE) {
    echo "updated record successfully\n";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);

?>