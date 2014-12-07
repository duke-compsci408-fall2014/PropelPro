<?php
 
include('../ConnectionInfo.php');

// Create connection
$con=mysqli_connect($host,$username,$password,$database);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$sql = "SELECT ".$_GET['attribute'] ." 
        FROM patients";

if($_GET['patient_id']){
    $sql = $sql . " WHERE patient_id = ".$_GET['patient_id'];
}

// Check if there are results
if ($result = mysqli_query($con, $sql))
{
    // If so, then create a results array and a temporary one
    // to hold the data
    $resultArray = array();
    $tempArray = array();

    // Loop through each row in the result set
    while($row = $result->fetch_object())
    {
        // Add each row into our results array
        $tempArray = $row;
        array_push($resultArray, $tempArray);
    }

    // Finally, encode the array to JSON and output the results
    if(empty($resultArray)){

        //added the unknow patient id
        $sql = "INSERT INTO patients(patient_id, patientName) 
                VALUES (".$_GET['patient_id'].", '[unknown]' )";

        if ($con->query($sql) == TRUE) {
         // echo "New record created successfully";

         //retrive the unknown patient id again
        $sqlretrieve = "SELECT ".$_GET['attribute'] ." 
        FROM patients";

        if($_GET['patient_id']){
            $sqlretrieve = $sqlretrieve . " WHERE patient_id = ".$_GET['patient_id'];
        }
	

        // Check if there are results
        if ($result = mysqli_query($con, $sqlretrieve)){
             // If so, then create a results array and a temporary one
            // to hold the data
            $resultArray = array();
            $tempArray = array();
	
            // Loop through each row in the result set
            while($row = $result->fetch_object())
            {
        // Add each row into our results array 
	       $tempArray = $row;
                array_push($resultArray, $tempArray);
            }
//	echo "after while";
        // Finally, encode the array to JSON and output the results
                if(empty($resultArray)){
                    echo "something has gone wrong, cant retrive the patient id". $_GET['patient_id'];
                
            }else{
//		echo "here in json";
                echo json_encode($resultArray);
            }
        } 
        
	} else {
          echo "Error: " . $sql . "<br>" . $con->error;
        }

    }else{
        echo json_encode($resultArray);
    }
}

// Close connections
mysqli_close($result);
mysqli_close($con);
?>
