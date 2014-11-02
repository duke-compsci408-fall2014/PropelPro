<?php

// Create connection
$con = mysqli_connect("localhost", "root", "bitnami", "health_alertdb");

if(mysqli_connect_errno()){
	echo "Failed to connect to MySQL: ". mysqli_connect_errno();
}

//note deleting a doctor also requires a delete from the patient_doctor table

$sql = "DELETE FROM patients WHERE patient_id = ".$_GET['patient_id']; 

if($con->query($sql) == TRUE){
	echo "deletion of a patient is successful\n";
	// update patient_doctor table to relect the change
	$sql = "DELETE FROM patients_doctors WHERE patient_id = ".$_GET['patient_id'];
	if($con->query($sql) == TRUE){
		echo "deletion from patients_doctors is successful";
	}else{
			echo "Error: " . $sql . "<br>" . $con->error;
	}
	//update notifications
	$sql = "DELETE FROM notifications WHERE patient_id = ".$_GET['patient_id'];
	if($con->query($sql) == TRUE){
		echo "deletion from notifications is successful";
	}else{
			echo "Error: " . $sql . "<br>" . $con->error;
	}
		//update bounds
	$sql = "DELETE FROM bounds WHERE patient_id = ".$_GET['patient_id'];
	if($con->query($sql) == TRUE){
		echo "deletion from bounds is successful";
	}else{
			echo "Error: " . $sql . "<br>" . $con->error;
	}

}else{
	echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);
?>
