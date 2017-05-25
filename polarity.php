<html>
<head>
<style>
.loader {
	position: fixed;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 9999;
	background: url('img/buffering.gif') 50% 50% no-repeat rgb(249,249,249);
}
</style>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript">
$(window).load(function() {
	$(".loader").fadeOut("slow");
})
</script>
</head>
<body>
<div class="loader"></div>

<?php
//print("Sentiment of the sentence entered\t");
//echo $_GET['review1'];
if(isset($_GET['review']))
{
	$review = $_GET['review'];
	exec("Rscript Sentiment.R \"$review\" ",$response);
	$b="[1]";
	$a=trim($response[0],$b);
	echo $a;
	echo $review;
}
?>
</body>
</html>
