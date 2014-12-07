<?php

include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

//check if it in database
$sql = "SELECT *
        FROM bounds 
        WHERE patient_id = ".$_GET['patient_id'];

if($_GET['stat_id']){
    $sql = $sql ." AND stat_id = ". $_GET['stat_id'];
}


// Check if there are results
if ($result = mysqli_query($con, $sql)){
	if($result->fetch_object()){
	//if there is a result - update call
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

	}else{
		//insert call
		echo "I am here";

		$sqlInsert = "INSERT INTO bounds (patient_id, stat_id, statLowerBound, statUpperBound) 
			VALUES (".$_GET['patient_id'].", ".$_GET['stat_id'].", ".$_GET['statLowerBound'].", ".$_GET['statUpperBound'].")";

		if ($con->query($sqlInsert) == TRUE) {
    		echo "New record created successfully";
		} else {
   			echo "Error: " . $sqlInsert . "<br>" . $con->error;
		}
	}

}



mysqli_close($con);

?>