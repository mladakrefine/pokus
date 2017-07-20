###SUBSETR FANS A POSTS###
# Ve Working Directory musí být jak Likes, tak Posts soubor.
# Pokud pouze 2 rozsahy, tak vyplnit do zbylých dvou rangů smyšlené datum - např. 2666-06-06
######
#   Q1 = 2017-01-01 až 2017-03-31
#   Q2 = 2017-04-01 až 2017-06-30
#   Q3 = 2017-07-01 až 2017-09-30
#   Q4 = 2017-10-01 až 2017-12-31
###

##-1-##
library(dplyr)

#první range
from1 <- as.Date("2016-07-01")
to1 <- as.Date("2016-12-31")


#druhý range
from2 <- as.Date("2017-01-01")
to2 <- as.Date("2017-06-30")

#třetí range
from3 <- as.Date("2666-06-06")
to3 <- as.Date("2666-06-06")

#čtvrtý range
from4 <- as.Date("2666-06-06")
to4 <- as.Date("2666-06-06")

##-2-##
postsFiles <- list.files(pattern = "_posts.csv")
likesFiles <- list.files(pattern = "_likes.csv")

# tvorba složek
dir1 <- paste0(from1, "__", to1)
dir2 <- paste0(from2, "__", to2)
dir3 <- paste0(from3, "__", to3)
dir4 <- paste0(from4, "__", to4)
dir.create(dir1)
dir.create(dir2)
dir.create(dir3)
dir.create(dir4)

##-3-##
for(i in 1:length(postsFiles)) {
  
  dfPosts <- read.csv(postsFiles[i])
  dfLikes <- read.csv(likesFiles[i])
  
  #pro případ, že mám duplicitní posty
  uniqPosts <- dfPosts[!duplicated(dfPosts$id),]
  colnames(uniqPosts)[2] <- "post_id"
  
  #dplyr - left_join
  dfLikes$post_id <- as.character(dfLikes$post_id)
  uniqPosts$post_id <- as.character(uniqPosts$post_id)
  uniqPosts$created_time <- as.Date(uniqPosts$created_time)
  dfLikersDate <- left_join(dfLikes, uniqPosts[,c("post_id", "created_time")],  by = c("post_id"))
  
  # rozsekání Postů na segmenty
  segPosts1 <- uniqPosts[uniqPosts$created_time >= from1 & uniqPosts$created_time <= to1,]
  segPosts2 <- uniqPosts[uniqPosts$created_time >= from2 & uniqPosts$created_time <= to2,]
  segPosts3 <- uniqPosts[uniqPosts$created_time >= from3 & uniqPosts$created_time <= to3,]
  segPosts4 <- uniqPosts[uniqPosts$created_time >= from4 & uniqPosts$created_time <= to4,]
  
  #rozsekání Likerů na segmenty
  segLikes1 <- dfLikersDate[dfLikersDate$created_time >= from1 & dfLikersDate$created_time <= to1,]
  segLikes2 <- dfLikersDate[dfLikersDate$created_time >= from2 & dfLikersDate$created_time <= to2,]
  segLikes3 <- dfLikersDate[dfLikersDate$created_time >= from3 & dfLikersDate$created_time <= to3,]
  segLikes4 <- dfLikersDate[dfLikersDate$created_time >= from4 & dfLikersDate$created_time <= to4,]
  
  #uložení Likes do složek
  file1 <- paste0(from1, "_", to1, "_", likesFiles[i])
  file2 <- paste0(from2, "_", to2, "_", likesFiles[i])
  file3 <- paste0(from3, "_", to3, "_", likesFiles[i])
  file4 <- paste0(from4, "_", to4, "_", likesFiles[i])
  write.csv(segLikes1, paste0(dir1,"/",file1))
  write.csv(segLikes2, paste0(dir2,"/",file2))
  write.csv(segLikes3, paste0(dir3,"/",file3))
  write.csv(segLikes4, paste0(dir4,"/",file4))
  cat("Uloženo: \n")
  print(file1)
  print(file2)
  print(file3)
  print(file4)
  
  #uložení Posts do složek
  file1 <- paste0(from1, "_", to1, "_", postsFiles[i])
  file2 <- paste0(from2, "_", to2, "_", postsFiles[i])
  file3 <- paste0(from3, "_", to3, "_", postsFiles[i])
  file4 <- paste0(from4, "_", to4, "_", postsFiles[i])
  write.csv(segPosts1, paste0(dir1,"/",file1))
  write.csv(segPosts2, paste0(dir2,"/",file2))
  write.csv(segPosts3, paste0(dir3,"/",file3))
  write.csv(segPosts4, paste0(dir4,"/",file4))
  cat("Uloženo: \n")
  print(file1)
  print(file2)
  print(file3)
  print(file4)
}
##-KONEC-##

