<?php

// Create connection
$con = mysqli_connect("localhost", "root", "bitnami", "health_alertdb");

if(mysqli_connect_errno()){
	echo "Failed to connect to MySQL: ". mysqli_connect_errno();
}

//note deleting a doctor also requires a delete from the patient_doctor table

$sql = "DELETE FROM patients_contacts WHERE contact_id = ".$_GET['contact_id'];

if($con->query($sql) == TRUE){
	echo "deletion of a patients_contacts is successful\n";
	// update patient_doctor table to relect the change
	$sql = "DELETE FROM contacts WHERE contact_id = ".$_GET['contact_id']; 
	if($con->query($sql) == TRUE){
		echo "deletion from contacts is successful";
	}else{
			echo "Error: " . $sql . "<br>" . $con->error;
	}

}else{
	echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);
?>
