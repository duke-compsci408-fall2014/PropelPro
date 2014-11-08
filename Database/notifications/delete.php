<?php

// Create connection
$con = mysqli_connect("localhost", "root", "bitnami", "health_alertdb");

if(mysqli_connect_errno()){
	echo "Failed to connect to MySQL: ". mysqli_connect_errno();
}

//note deleting a doctor also requires a delete from the patient_doctor table
$sql = ""

if($_GET['patient_id']){

	$sql = "DELETE FROM notifications WHERE patient_id = ".$_GET['patient_id']; 
}

if($_GET['patient_id'] && $_GET['stat_id']){
	$sql = "DELETE FROM notifications WHERE patient_id = ".$_GET['patient_id'] . " AND 
											stat_id = ". $_GET['stat_id']; 
}


if($_GET['patient_id'] && $_GET['stat_id'] && $_GET['contact_id']){

$sql = "DELETE FROM notifications WHERE patient_id = ".$_GET['patient_id'] . " AND 
											stat_id = ". $_GET['stat_id'] . " AND
											contact_id = " . $_GET['contact_id']; 
}
if($sql != ""){	
	if($con->query($sql) == TRUE){
		echo "deletion of a notifications is successful\n";

	}else{
		echo "Error: " . $sql . "<br>" . $con->error;
	}
}

mysqli_close($con);
?>
