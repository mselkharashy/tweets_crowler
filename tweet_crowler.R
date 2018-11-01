
## list of packages required
list.of.packages = c("rtweet", "tidyverse")
new.packages = list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
rm(list.of.packages); rm(new.packages)


library(rtweet)
library(tidyverse)

keywords <- c("iphonex", "iphone", "apple", "ios")

tweets <- keywords %>%
  paste(collapse = " OR ") %>%
  search_tweets(n = 1000,  lang = "en")

save_as_csv(tweets,file_name = "./dashboard_app/tweets.csv")
  
tweets <- read_twitter_csv("./dashboard_app/tweets.csv")


#---------------------------------------------------------
users <- c("VoteBH", "Bh_Elections", "bna_ar",
           "bahdiplomatic", "moi_bahrain", "ALAYAM")

# tweets <- users %>%
#   #paste(collapse = " OR ") %>%
#   get_timeline(n = 3200)
# 
# tweets %>%
#   select(status_id, screen_name, text) %>%
#   write_csv("initial_6_pro_gov_seed_timeline_tweets.csv")
# 
# all_retweeters = NULL
# 
# for(i in 1:nrow(tweets)) {
#   print(paste("Iteration # ", i))
#   print(paste("Retriving the retweeters of status: ", tweets$text[i]))
#   
#   retweeters <- NULL
#   retweeters <- get_retweeters(tweets$status_id[i])
#   
#   if(is.null(retweeters)) {
#     print("There is no retweeters for this status")
#     next
#   }
#   
#   print(paste("It has ", nrow(retweeters), " retweeters"))
#   print("Adding them to all_retweeters")
#   
#   if(is_null(all_retweeters)) {
#     all_retweeters <- retweeters
#   }else {
#     all_retweeters <- all_retweeters %>% rbind(retweeters)
#   }
#   print(paste("All retweeters count: ", nrow(all_retweeters)))
#   print("----------------------------------------------------")
# }
# 
# all_retweeters %>% 
#   group_by(user_id) %>%
#   tally() %>%
#   filter(n > 10) %>%
#   mutate(screen_name = lookup_users(user_id)$screen_name) %>%
#   ggplot(aes(x = reorder(screen_name, n), y = n)) + 
#   geom_col() + theme_minimal() +
#   coord_flip()
# 
# all_retweeters %>% 
#   group_by(user_id) %>%
#   tally() %>%
#   filter(n > 10) %>%
#   mutate(screen_name = lookup_users(user_id)$screen_name) %>%
#   arrange(desc(n)) %>%
#   select(user_id, screen_name, n) %>%
#   write_csv("top_retweeters_of_initial_6_pro_gov_accounts.csv")
# 
# # Find the users who write tweets that contains one of the seed names.
# tweets %>%
#   filter(is_retweet) %>%
#   filter(!screen_name %in% users) %>%
#   filter(retweet_screen_name %in% users) %>%
#   select(retweet_screen_name, screen_name, text) %>%
# 
# 
#  group_by(screen_name) %>%
#   tally() %>%
#   arrange(desc(n)) %>%

source("accounts_label_propagation.R")

pro_gov_seed = c("bah_news", "alfarooo8", "Deertybhr", "BHRdefense", "3ajil_bh",
                 "_alkhalifa", "Newscom_news", "malarab1", "MohamedMubarak2", "FawwazBH",
                 "tamamabusafi", "tamamabusafi", "alzayani_hisham", "CSB_BH", "MoeBahrain",
                 "Bahrain_Works", "southerngov_bh", "MOH_Bahrain", "Humoodalkhalifa", "AbdullaRAK",
                 "Saeed_AlHamad", "SameeraRajab", "sawsanalshaer", "f_alshaikh", "Talhassan",
                 "alra9id", "fawaz_alkhalifa", "Alwatan_Live", "EbrAhimAlshAik1", "maysayousif",
                 "KhalidAlkhayat", "nalhamer", "Khaled_Bin_Ali", "khalidalkhalifa", "ManamaPress", 
                 "iScrat")

pro_election_but_not_pro_gov_seed = c("ebrahimsharif", "YusufAlJamri", "manamavoice1", 
                                      "nsfadala", "EbrAhimAlshAik1")

new_pro_election_but_not_pro_gov_accounts <- get_propagated_accounts(pro_election_but_not_pro_gov_seed,
                                          export_tweets_path = "pro_election_but_not_pro_gov_tweets.csv", 
                                          export_retweeters_path = "pro_election_but_not_pro_gov_new_retweeters.csv",
                                          propagation_threshold = 3)

new_pro_gov_accounts <- get_propagated_accounts(pro_gov_seed,
                                                export_tweets_path = "pro_gov_tweets.csv", 
                                                export_retweeters_path = "pro_gov_new_retweeters.csv",
                                                propagation_threshold = 3)

#-------------------------------
opposit_gov_seed = c("ALYARADHI", "ealsaegh", "MaythamAlsalman", "Ahrar_e_Jidhafs", "BH_14DETAINEES",
                     "FreeDumistan", "TubliOnline", "AlekerNews", "karranah14", "Malkiya_youth",
                     "MoosaAkrawi", "binmrajab", "AMushaima", "EBOHumanRights", "FatiimaHalwachi",
                     "LuaLuaTV", "Media_Karbabad", "Hamad254454", "BirdBahrain_", "ADHRB",
                     "BahrainRights", "NABEELRAJAB", "SAIDYOUSIF", "MARYAMALKHAWAJA", "14FebTV",
                     "ALWEFAQ", "aibahrain", "14FebRevolution", "SanabisNews", "KarranahNews",
                     "NewsDaih", "JidhafsNews", "juffair14media", "MahazzaMedia", "SamaheejVoice", 
                     "wahat_almaameer", "shababshahrakan", "sehla_news", "SadadEvents", "DurazMirror", 
                     "DurazYouth", "R14Feb", "AlsehlaNews", "a7rarqurayah", "Adamnabeel")


new_opposit_gov_accounts <- get_propagated_accounts(opposit_gov_seed,
                                                export_tweets_path = "opposit_gov_tweets.csv", 
                                                export_retweeters_path = "opposit_gov_new_retweeters.csv",
                                                propagation_threshold = 3)
