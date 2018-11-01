

library(rtweet)
library(tidyverse)

#' 
#' @param seed_accounts: a vector of seed accounts screen_name(s)
#' @param export_tweets_path: a character string to a file path, 
#' it will be used to export the seed accounts timeline if it is not null.
#' @param propagation_threshold: the min number of retweets to propagate its 
#' auother to the seed accounts lable. 
#' @param export_retweeters_path: a character string to a file path, 
#' it will be used to export the new propagated accounts
#' @return A tweeters acocunts (user_id, screen_id) and number of 
#' retweets (n) of seed accounts timelines tweets
#' 
get_propagated_accounts <- function(seed_accounts, 
                                    export_tweets_path = NULL, 
                                    propagation_threshold = 10,
                                    export_retweeters_path = NULL){
  
  message("Collecting seed accounts tweets...")
  tweets <- seed_accounts %>%
    get_timeline(n = 3200)
  
  num_of_tweets <- nrow(tweets)
  message(paste(num_of_tweets, " tweets have been colected."))
  
  if(!is.null(export_tweets_path)) {
    message("Exporting tweets to a csv file...")
    tweets %>%
      select(status_id, screen_name, text) %>%
      write_csv(export_tweets_path)
  }
  
  message("Collecting retweeters of each tweet")
  all_retweeters <- NULL
  progress_bar <- txtProgressBar(min = 0, max = num_of_tweets, style = 3)
  
  for(i in 1:num_of_tweets) {
    retweeters <- NULL
    retweeters <- get_retweeters(tweets$status_id[i])

    if(is.null(retweeters)) { # There is no retweeters for the current tweet
      setTxtProgressBar(progress_bar, i)
      next
    }
    
    #Keeping the map between tweeter-retweeters
    retweeters <- retweeters %>%
      mutate(tweeter_screen_name = tweets$screen_name[i])
    
    # Adding retweeters of current tweet to all_retweeters
    if(is_null(all_retweeters)) {
      all_retweeters <- retweeters
    }else {
      all_retweeters <- all_retweeters %>% rbind(retweeters)
    }
    setTxtProgressBar(progress_bar, i)
  }
  
  if(is.null(all_retweeters)) {
    message("No re-tweeters founds.")
  }else {
    all_retweeters <- all_retweeters %>% 
      group_by(user_id,tweeter_screen_name) %>%
      tally() %>%
      filter(n >= propagation_threshold) %>%
      arrange(desc(n)) %>%
      mutate(screen_name = lookup_users(user_id)$screen_name) %>%
      select(user_id, screen_name, tweeter_screen_name, n)
    message(paste(nrow(all_retweeters), " retweeters above the threshold have been found..."))
  }
  
  
  if(!is.null(export_retweeters_path)) {
    message("Exporting new propagated accounts to a csv file...")
    all_retweeters %>%
      write_csv(export_retweeters_path)
  }
  
  return(all_retweeters)
}