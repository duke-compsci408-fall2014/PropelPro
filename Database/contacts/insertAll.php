<?php

include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}


//insert a doct into table
$sql = "INSERT INTO contacts (contactName, contactPhoneNumber) 
		VALUES (".$_GET['contactName'].", ".$_GET['contactPhoneNumber'].")";

if ($con->query($sql) == TRUE) {

	   $patientID = $_GET['patient_id'];
//updating patients_doctors table
	   if($patientID != ""){
          $conId = $con->insert_id;
		  $sqlUpdate = "INSERT INTO patients_contacts (patient_id, contact_id)
		      	  		  VALUES(".$patientID.", ". $conId .")";
		  if ($con->query($sqlUpdate)) {
                //updating notifications
            $statList = array(7,1,6,9);
            echo $conId;

            foreach ($statList as $stat_id){

                    $sql = "INSERT INTO notifications (patient_id, contact_id, stat_id) 
                                VALUES (".$_GET['patient_id'].", '".$conId."', ".$stat_id.")";

                    if ($con->query($sql) == TRUE) {
                    } else {
                        echo "Error: " . $sql . "<br>" . $con->error;
                    }
            }

		  } else {
    		  echo "Error: " . $sqlUpdate . "<br>" . $con->error ."\n";
    		  //remove since insert in to patient_contact failes
    		  $sqlUpdate = "DELETE FROM contacts 
    					  WHERE contact_id =" .$con->insert_id;
    		  if($con->query($sqlUpdate)){
    			 echo "The recently inserted contacts has been removed from the database since patients did not exist";
    		  }else{
                echo "Error: " . $sqlUpdate . "<br>" . $con->error ."\n";
              }
		  }
	   }

    }




mysqli_close($con);

?>
