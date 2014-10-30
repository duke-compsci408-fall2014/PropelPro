<?php

// Create connection
$con=mysqli_connect("localhost","root","bitnami","health_alertdb");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

//insert a doct into table
$sql = "INSERT INTO doctors (doctorName, doctorPhoneNumber, doctorAddress) 
		VALUES (".$_GET['doctorName'].", ".$_GET['doctorPhoneNumber'].", ".$_GET['doctorAddress'].")";

if ($con->query($sql) == TRUE) {
    echo "New record created successfully\n";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}
//end of insert doc

$patientID = $_GET['patient_id'];

if($patientID != ""){
$sqlUpdate = "INSERT INTO patients_doctors (patient_id, doctor_id)
			  VALUES(".$patientID.", ". $con->insert_id .")";


if ($con->query($sqlUpdate) == TRUE) {
    echo "New record in patients_doctors created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

}


mysqli_close($con);

?>
