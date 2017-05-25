<?php
$sai="1 the mobile is good 1";
//echo $sai;
$b="1the mobile is good1";
$a=trim($sai,$b);
var_dump($a);
  if($a=="-")
  {
	  echo "negative";
  }
  else
  {
	  echo "postive";
  }

?>