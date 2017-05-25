POS<- function(a){
	s <-as.String(a)
	sent_token_annotator <-Maxent_Sent_Token_Annotator()
	word_token_annotator <-Maxent_Word_Token_Annotator()
	a2 <-annotate(s, list(sent_token_annotator, word_token_annotator))
	pos_tag_annotator <-Maxent_POS_Tag_Annotator()
	a3 <-annotate(s, pos_tag_annotator, a2)
	a3w <-subset(a3, type == "word")
	tags <-sapply(a3w$features, '[[', "POS")
	x <-sprintf("%s",tags)
	return(x)
}