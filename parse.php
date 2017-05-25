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
//echo $_POST['review2'];

	/* $review = $_GET['review2'];
	//echo $review;
	//echo(getcwd());
	exec("Rscript ptrees.R \"$review\" 2>&1",$response);
	print_r($response); */
	
		//echo file_get_contents( "trees.txt", PHP_EOL ); // get the contents, and echo it out.
		echo '<pre>' . nl2br( file_get_contents('C:/xampp/htdocs/MARS/trees.txt') ). '</pre>';
		/* 
		$fh = fopen("trees.txt", 'r');
		$pageText = fread($fh, 25000);
		echo nl2br($pageText); */
?>
</body>
</html>