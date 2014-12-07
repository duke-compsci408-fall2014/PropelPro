<?php

include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

if(mysqli_connect_errno()){
	echo "Failed to connect to MySQL: ". mysqli_connect_errno();
}

//note deleting a doctor also requires a delete from the patient_doctor table

$sql = "DELETE FROM stats WHERE stat_id = ".$_GET['stat_id']; 

if($con->query($sql) == TRUE){
	echo "deletion of a stats is successful\n";

		//update bounds
	$sql = "DELETE FROM bounds WHERE stat_id = ".$_GET['stat_id'];
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
