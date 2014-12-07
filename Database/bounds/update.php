<?php

include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

if(mysqli_connect_errno()){
	echo "Fail to connect to MySQL: ". mysqli_connect_errno();
}

$sql = "UPDATE bounds
		SET statLowerBound = ".$_GET['statLowerBound'].",
			statUpperBound = ".$_GET['statUpperBound']."
		WHERE patient_id = ".$_GET['patient_id']."
		AND stat_id = ".$_GET['stat_id'];

if ($con->query($sql)){
	echo "Updated record succesfully\n";
}else{
	echo "Error: " . $sql . "<br>" . $con->error;

}

mysqli_close($con);

?>