# Sabrina's Personal Project: Identifying non-mutual followers on Instagram
# Motive: Most users pay 7,99 for this service and I would rather not.

install.packages("rvest")
install.packages("dplyr")

library(rvest)
library(dplyr)
library(stringr)

# Link to HTML file in my laptop (Replace with your file path)
followers_file <- "~/instagram-project/followers_and_following/followers_1.html"
followings_file <- "~/instagram-project/followers_and_following/following.html"

# The function the extracts the username from the HTML file (I used inspect on Google Chrome to analyse the data structure)
extract_usernames <- function(file_path) {
  # Read the HTML file
  html_content <- read_html(file_path)
  
  # Extract the text within <a> tags that contain href attributes pointing to Instagram profiles
  usernames <- html_content %>% 
    html_nodes("a[href*='https://www.instagram.com/']") %>% 
    html_text(trim = TRUE) %>%
    unique()
  
  return(usernames)
}

# Extract followers and followings usernames
followers <- extract_usernames(followers_file)
followings <- extract_usernames(followings_file)

# Convert to data frames
followers_df <- data.frame(username = followers, stringsAsFactors = FALSE)
followings_df <- data.frame(username = followings, stringsAsFactors = FALSE)

# Save followers and followings data frames to CSV files
write.csv(followers_df, "followers.csv", row.names = FALSE)
write.csv(followings_df, "followings.csv", row.names = FALSE)

# Find users who are not following you back
not_following_back <- setdiff(followings_df$username, followers_df$username)

# Convert the not following back users to a data frame
not_following_back_df <- data.frame(username = not_following_back, stringsAsFactors = FALSE)

# Save the not following back users to a CSV file
write.csv(not_following_back_df, "not_following_back.csv", row.names = FALSE)

# Print the results
cat("Users who you are following but are not following you back:\n")
print(not_following_back)

# To view in alphabetical order
nfb_az <- sort(not_following_back)
nfb_az_df <- data.frame(username = nfb_az, stringsAsFactors = FALSE)
write.csv(nfb_az_df, "nfb_az.csv", row.names = FALSE)

cat("Users who you are following but are not following you back (sorted alphabetically):\n")
print(nfb_az)
