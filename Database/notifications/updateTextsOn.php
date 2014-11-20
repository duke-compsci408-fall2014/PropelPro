<?php

// Create connection
$con=mysqli_connect("localhost","root","bitnami","health_alertdb");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}


$sql = "UPDATE notifications
		SET textsOn = ".$_GET['textOn']." 
		WHERE patient_id = ".$_GET['patient_id']. 
		"AND contact_id = ".$_GET['contact_id'].
		"AND stat_id = " .$_GET['stat_id'] ;


if ($con->query($sql) == TRUE) {
    echo "updated record successfully\n";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);

?>