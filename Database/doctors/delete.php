<?php

include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

if(mysqli_connect_errno()){
	echo "Failed to connect to MySQL: ". mysqli_connect_errno();
}

//note deleting a doctor also requires a delete from the patient_doctor table

$sql = "DELETE FROM patients_doctors WHERE doctor_id = ".$_GET['doctor_id'];

if($con->query($sql) == TRUE){
	echo "deletion of a patients_doctors is successful\n";
	// update patient_doctor table to relect the change
	$sql = "DELETE FROM doctors WHERE doctor_id = ".$_GET['doctor_id']; 
	if($con->query($sql) == TRUE){
		echo "deletion from doctor is successful";
	}else{
			echo "Error: " . $sql . "<br>" . $con->error;
	}

}else{
	echo "Error: " . $sql . "<br>" . $con->error;
}

mysqli_close($con);
?>
