<?php

if(isset($_GET['review3']))
{
	$review = $_GET['review3'];
	//$mobile = $_GET['mobile'];
	echo $review;
	//echo "/n";
	//echo $mobile;
	//$mobilerev = $review . ' ' . $mobile;
	$myfile = file_put_contents('mobilereviews.txt', $review.PHP_EOL , FILE_APPEND | LOCK_EX);
}
?>