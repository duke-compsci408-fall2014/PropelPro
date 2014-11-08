<?php

// Create connection
$con=mysqli_connect("localhost","root","bitnami","health_alertdb");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

//NOTE: write a check to see if the entry is already in the database or not
//Re-discuss if doctor_id should be autoincremented or inputted
//Discuss if doctorPhoneNumber is Unique


//insert a doct into table
$sql = "INSERT INTO contacts (contactName, contactPhoneNumber) 
		VALUES (".$_GET['contactName'].", ".$_GET['contactPhoneNumber'].")";

if ($con->query($sql) == TRUE) {

    echo "New record created in contacts successfully\n";
	$patientID = $_GET['patient_id'];
//updating patients_doctors table
	if($patientID != ""){
		$sqlUpdate = "INSERT INTO patients_contacts (patient_id, contact_id)
			  		  VALUES(".$patientID.", ". $con->insert_id .")";
		if ($con->query($sqlUpdate)) {
   	 		echo "New record in patients_contacts created successfully";
		} else {
    		echo "Error: " . $sql . "<br>" . $con->error ."\n";
    		
    		$sqlUpdate = "DELETE FROM contacts 
    					  WHERE contact_id =" .$con->insert_id;
    		if($con->query($sqlUpdate)){
    			echo "The recently inserted contacts has been removed from the database since patients did not exist";
    		}
		}
	}

} else {
    echo "Error: " . $sql . "<br>" . $con->error;

}
//end of insert doc




mysqli_close($con);

?>
