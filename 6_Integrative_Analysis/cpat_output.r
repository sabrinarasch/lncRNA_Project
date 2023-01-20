load("/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/6_Integrative_Analysis/Human_logitModel.RData")
test <- read.table(file="/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/6_Integrative_Analysis/cpat_output.dat",sep="\t",col.names=c("ID","mRNA","ORF","Fickett","Hexamer"))
test$prob <- predict(mylogit,newdata=test,type="response")
attach(test)
output <- cbind("mRNA_size"=mRNA,"ORF_size"=ORF,"Fickett_score"=Fickett,"Hexamer_score"=Hexamer,"coding_prob"=test$prob)
write.table(output,file="/data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/6_Integrative_Analysis/cpat_output",quote=F,sep="\t",row.names=ID)