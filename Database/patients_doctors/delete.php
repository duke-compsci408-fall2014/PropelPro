<?php

// Create connection
$con = mysqli_connect("localhost", "root", "bitnami", "health_alertdb");

if(mysqli_connect_errno()){
	echo "Failed to connect to MySQL: ". mysqli_connect_errno();
}

//note deleting a doctor also requires a delete from the patient_doctor table

$sql = "DELETE FROM patients_doctors WHERE patient_id = ".$_GET['patient_id']; 

if($_GET['doctor_id']){
	$sql = $sql . " AND doctor_id = " .$_GET['doctor_id'];
}


if($con->query($sql) == TRUE){
	echo "deletion of a patients_doctors is successful\n";

}else{
	echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);
?>