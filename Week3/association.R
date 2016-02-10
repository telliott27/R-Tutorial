set.seed(10281982)
library(dplyr)
library(tidyr)
library(network)

rm(list=ls())
load("chapter5.Rdata")
source("assoc.functions.R")

nRandom<-10000

claims<-claims %>% filter(id>0)

num.articles<-length(articles$id)

article.claim<-claim.talk %>% select(article_id,claim) %>% mutate(present=1) %>% distinct() %>%
  spread(claim,present,fill=0) %>% select(-None)
article.claim<-articles %>% select(article_id=id) %>% left_join(article.claim,by="article_id")
article.claim[is.na(article.claim)]<-0

art.claim<-article.claim %>% select(-article_id)

art.assoc<-makeAssociation(art.claim)

rgraphs<-randomGraphs(art.claim,n=nRandom)

sig<-getSig(art.assoc,rgraphs)

sig.yes<-(sig$pu<0.1)*1
colnames(sig.yes)<-rownames(sig.yes)<-rownames(art.assoc)

art.net<-network(sig.yes)


networks<-list()
networks[["all"]][["twomode"]]<-art.claim
networks[["all"]][["association"]]<-art.assoc
networks[["all"]][["random"]]<-rgraphs
networks[["all"]][["sig"]]<-sig
networks[["all"]][["network"]]<-art.net
networks[["all"]][["network.assoc"]]<-network(networks[["all"]][["association"]])

rm(sig.yes,art.claim,art.assoc,rgraphs,sig,art.net)
time.periods<-list(c(1950,1968),c(1969,1981),c(1982,1989),c(1990,2003),c(2004,2010))


for( i in c(1:length(time.periods))) {
  tp<-time.periods[[i]]
  art<-articles %>% filter(year>=tp[1]&year<=tp[2])
  art.claim<-art %>% select(article_id=id) %>% left_join(article.claim,by="article_id") %>% select(-article_id)
  art.assoc<-makeAssociation(art.claim)
  rgraphs<-randomGraphs(art.claim,n=nRandom)
  sig<-getSig(art.assoc,rgraphs)
  sig.yes<-(sig$pu<0.1)*1
  colnames(sig.yes)<-rownames(sig.yes)<-rownames(art.assoc)
  art.net<-network(sig.yes)
  nm<-as.character(tp[1])
  networks[[nm]][["twomode"]]<-art.claim
  networks[[nm]][["association"]]<-art.assoc
  networks[[nm]][["random"]]<-rgraphs
  networks[[nm]][["sig"]]<-sig
  networks[[nm]][["network"]]<-art.net
  networks[[nm]][["network.assoc"]]<-network(networks[[nm]][["association"]])
}
rm(tp,art,i,sig.yes,art.claim,art.assoc,rgraphs,sig,art.net)

save(networks,file="association.networks.Rdata")

