<?php

// Create connection
$con = mysqli_connect("localhost", "root", "bitnami", "health_alertdb");

if(mysqli_connect_errno()){
	echo "Failed to connect to MySQL: ". mysqli_connect_errno();
}

//note deleting a doctor also requires a delete from the patient_doctor table

$sql = "DELETE FROM notifications WHERE patient_id = ".$_GET['patient_id']; 

if($_GET['recipientPhoneNumber']){
	$sql = $sql . " AND recipientPhoneNumber = " .$_GET['recipientPhoneNumber'];
}


if($con->query($sql) == TRUE){
	echo "deletion of a notifications is successful\n";

}else{
	echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);
?>
