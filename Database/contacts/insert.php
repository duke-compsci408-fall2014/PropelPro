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
if($_GET['repeat'] !=""){
    // get the contact id
    $sql = "SELECT contact_id
            FROM contacts
            WHERE contactName =".$_GET['contactName']. "AND contactPhoneNumber =".$_GET['contactPhoneNumber'];
    
    if ($result = mysqli_query($con, $sql)) {
    // output data of each row
        $contactID = "";
        // var_dump($result);
    // Loop through each row in the result set
         while($row = $result->fetch_object())
        {
        // Add each row into our results array
            // if($row->contact_id){
              $contactID = $row->contact_id;
            // }
        }
        //updating notifications

        $sql = "INSERT INTO notifications (patient_id, contact_id, stat_id, callsOn, textsOn) 
                VALUES (".$_GET['patient_id'].", '".$contactID."', ".$_GET['stat_id'].", ".$_GET['callsOn']. ", ". $_GET['textsOn'].")";
        echo $sql;

        if ($con->query($sql) == TRUE) {
            echo "New record created successfully";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }


    } else {
        echo "Error: " . $sql . "<br>" . $con->error ."\n";

        echo "contact_id does not exist";
    }
    echo "repeated insert";

}else{

//insert a doct into table
$sql = "INSERT INTO contacts (contactName, contactPhoneNumber) 
		VALUES (".$_GET['contactName'].", ".$_GET['contactPhoneNumber'].")";

if ($con->query($sql) == TRUE) {

        echo "New record created in contacts successfully\n";
	   $patientID = $_GET['patient_id'];
//updating patients_doctors table
	   if($patientID != ""){
          $conId = $con->insert_id;
		  $sqlUpdate = "INSERT INTO patients_contacts (patient_id, contact_id)
		      	  		  VALUES(".$patientID.", ". $conId .")";
		  if ($con->query($sqlUpdate)) {
   	 	      	echo "New record in patients_contacts created successfully\n";
                //updating notifications
                if($_GET['stat_id']){
                    if($_GET['textsOn'] && $_GET['callsOn']){

                        $sql = "INSERT INTO notifications (patient_id, contact_id, stat_id, callsOn, textsOn) 
                                VALUES (".$_GET['patient_id'].", '".$conId."', ".$_GET['stat_id'].", ".$_GET['callsOn']. ", ". $_GET['textsOn'].")";

                    }else{

                        $sql = "INSERT INTO notifications (patient_id, contact_id, stat_id) 
                                VALUES (".$_GET['patient_id'].", '".$conId."', ".$_GET['stat_id'].")";
                    }
                    if ($con->query($sql) == TRUE) {
                        echo "New record created successfully";
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

    } else {
         echo "Error: " . $sql . "<br>" . $con->error;

    }
//end of insert doc

}


mysqli_close($con);

?>
