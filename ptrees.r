library(NLP)
library(openNLP)
library(rJava)
library(openNLPmodels.en)
args<-commandArgs(TRUE)
review<-args[1]
ptree<-function(s){
		sent_token_annotator <- Maxent_Sent_Token_Annotator()
		word_token_annotator <- Maxent_Word_Token_Annotator()
		a2 <- annotate(review, list(sent_token_annotator, word_token_annotator))
		parse_annotator <- Parse_Annotator()
		p <- parse_annotator(s, a2)
		ptexts <- sapply(p$features,`[[`, "parse")
		#ptexts
		ptrees <- lapply(ptexts, Tree_parse)
}
ptrees<-ptree(review)
ptrees
capture.output(ptrees,file="trees.txt")
