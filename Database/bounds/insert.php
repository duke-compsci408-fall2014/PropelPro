<?php

// Create connection
$con=mysqli_connect("localhost","root","bitnami","health_alertdb");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$sql = "INSERT INTO bounds (patient_id, stat_id, statLowerBound, statUpperBound) 
		VALUES (".$_GET['patient_id'].", ".$_GET['stat_id'].", ".$_GET['statLowerBound'].", ".$_GET['statUpperBound'].")";

if ($con->query($sql) == TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);

?>