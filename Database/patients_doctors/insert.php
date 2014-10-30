<?php

// Create connection
$con=mysqli_connect("localhost","root","bitnami","health_alertdb");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$sql = "INSERT INTO patients_doctors(patient_id, doctor_id) 
		VALUES (".$_GET['patient_id'].", ".$_GET['doctor_id'].")";

if ($con->query($sql) == TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);

?>