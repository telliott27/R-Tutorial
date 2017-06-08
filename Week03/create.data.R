#Clean Dissertation Data
library(RMySQL)
library(forecast)
library(dplyr)
rm(list=ls())
con<-dbConnect(MySQL(),dbname="dissertation",group="rmysql")

rs<-dbSendQuery(con,"SELECT smo_info.*, smos.family_id FROM smo_info
                JOIN smos ON smos.id=smo_id")
smos.data<-fetch(rs,n=-1)

rs<-dbSendQuery(con,"SELECT *, YEAR(date) AS year FROM articles")
articles<-fetch(rs,n=-1)

rs<-dbSendQuery(con,"SELECT talk_info.*, YEAR(articles.date) AS year FROM talk_info
JOIN articles ON talk_info.article_id = articles.id;")
talk.info<-fetch(rs,n=-1)

rs<-dbSendQuery(con,"SELECT term_talk.*, YEAR(articles.date) AS year FROM term_talk
JOIN talk_info ON talk_id = talk_info.id
JOIN articles ON talk_info.article_id = articles.id;")
terms<-fetch(rs,n=-1)

rs<-dbSendQuery(con,"SELECT claim_talk.*, shortclaim AS claim, YEAR(articles.date) AS year, talk_info.article_id, class FROM claim_talk
JOIN talk_info ON talk_id = talk_info.id
JOIN claims ON claim_id = claims.id
JOIN articles ON talk_info.article_id = articles.id;")
claim.talk<-fetch(rs,n=-1)

rs<-dbSendQuery(con,"SELECT * FROM claims")
claims<-fetch(rs,n=-1)

rs<-dbSendQuery(con,"SELECT first_name, last_name, id FROM users")
users<-fetch(rs,n=-1)

dbDisconnect(con)
rm(con,rs,t)

articles$ca_error<-0
articles$ca_error[which(articles$collective==2&articles$collectivetype<1)]<-1

articles$title_error<-0
articles$title_error[which(articles$title=="")]<-1

articles$newspaper_error<-0
articles$newspaper_error[which(articles$newspaper<1|articles$newspaper>3)]<-1

articles$par_error<-0
articles$par_error[is.na(articles$paragraphs)]<-1

articles$arttype_error<-0
articles$arttype_error[which(articles$articletype<1)]<-1

articles$occasion_error<-0
articles$occasion_error[which(articles$occasion<1)]<-1

errors<-articles %>% mutate(total_error=ca_error+title_error+newspaper_error+par_error+arttype_error+occasion_error) %>%
  filter(total_error>0) %>%
  select(article_id,coder,title,date,newspaper,contains("error"))

write.csv(errors,"Cleaning/article_errors.csv",row.names=FALSE)

rm(errors)

#save raw data
save.image("Data/coded_articles.Rdata")

#now remove co-coded articles since I only want one copy
#grab co-coded article IDs that are not master codes
artdrop<-articles %>% group_by(article_id) %>% mutate(numcoded=n(),mincoder=min(coder)) %>%
  filter(numcoded>1&coder!=mincoder) %>% .$id

#drop co-coded articles from different levels of coding
articles<-articles %>% filter(!id%in%artdrop)
claim.talk<-claim.talk %>% filter(!article_id%in%artdrop)
smos.data<-smos.data %>% filter(!article_id%in%artdrop)
talkdrop<-talk.info %>% filter(article_id%in%artdrop) %>% .$id
talk.info<-talk.info %>% filter(!article_id%in%artdrop)
terms<-terms %>% filter(!talk_id%in%talkdrop)

#remove extraneous stuff
rm(artdrop,talkdrop)

#save version of data ready for analysis
save.image("Data/analysis_articles.Rdata")
