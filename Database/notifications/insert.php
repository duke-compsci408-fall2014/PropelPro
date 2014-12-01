<?php

// Create connection
$con=mysqli_connect("localhost","root","bitnami","health_alertdb");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if($_GET['textsOn'] && $_GET['callsOn']){

$sql = "INSERT INTO notifications (patient_id, contact_id, stat_id, callsOn, textsOn) 
		VALUES (".$_GET['patient_id'].", ".$_GET['contact_id'].", ".$_GET['stat_id'].", ".$_GET['callsOn']. ", ". $_GET['textsOn'].")";

}else{

$sql = "INSERT INTO notifications (patient_id, contact_id, stat_id) 
		VALUES (".$_GET['patient_id'].", ".$_GET['contact_id'].", ".$_GET['stat_id'].")";
}
if ($con->query($sql) == TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);

?>