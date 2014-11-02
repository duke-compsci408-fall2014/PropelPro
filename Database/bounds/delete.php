<?php

$con = mysqli_connect("localhost", "root", "bitnami", "health_alertdb");

if(mysqli_connect_errno()){
	echo "Fail to connect to MySQL: ". mysqli_connect_errno();
}

$sql = "DELETE FROM bounds WHERE patient_id = ". $_GET['patient_id'] . "AND stat_id = ". $_GET['stat_id'];

if($con->query($sql) == TRUE){
	echo "Successful in deleting the entry from bounds table\n";
}else{
	echo "Error: " . $sql . "<br>". $con->error;
}

mysqli_close($con);



?> 
