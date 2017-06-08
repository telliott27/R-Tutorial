
gss.df<-gss %>% select(year,id,wrkstat,hrs1,hrs2,marital,age,childs,
                       educ,paeduc,maeduc,sex,race,income,polviews,partyid,
                       cappun,gunlaw,homosex,xmarsex)


returnParty<-function(x) {
  theLevels<-levels(x)
  thePartys<-rep(0,length.out=length(theLevels))
  thePartys<-ifelse(grepl("dem",theLevels),1,thePartys)
  thePartys<-ifelse(grepl("rep",theLevels),2,thePartys)
  thePartys<-ifelse(grepl("other",theLevels),3,thePartys)
  thePartys<-ifelse(grepl("independent",theLevels),3,thePartys)
  newx<-rep(0,length.out=length(x))
  for( i in c(1:length(theLevels)) ) {
    newx<-ifelse(x==theLevels[i],thePartys[i],newx)
  }
  newx<-factor(newx,levels=c(1,2,3,0),labels=c("Democrat","Republican","Other","No Data"))
  return(newx)
}


addEven<-function(x) {
  theSum<-0
  for(i in x) {
    if ( i%%2 == 0 ) theSum<-theSum+i
  }
  return(theSum)
}
