##################################################
# 
# GEB 6895: Tools for Business Intelligence
# 
# Emeli Castellon and Lara Willson
# Term Project
# User and Resort Factors Effect on User Resort Reviews
# 
# 
# November 11, 2019
#
##################################################
# Preparing the Workspace
##################################################

# Clear workspace.

rm(list=ls(all=TRUE))

# Set working directory.

wd_path <- '~/GEB6895/Mirror/GEB6895-mirror/term_project/'  

setwd(wd_path)

# Verify that the path was assigned correctly. 

getwd()

#Import diplyr package
library(dplyr)

##################################################
# Loading the Data and Conducting Initial Assessment
##################################################

#Importing 100 rows of data file

hotel_review <- read.csv('hotel_sample.csv')

#hotel_review <-sample_n(hotel_review, 100, TRUE)

hotel_review <- hotel_review[-c(1)]

# Inspect the contents.

summary(hotel_review)

# Make sure there are no problems with the data. 
# Inspect the dependent variable. 
# Variable is not continuous.

hist(hotel_review[, 'Score'])
summary(hotel_review$Score)
range(hotel_review$Score)
var(hotel_review$Score)
sd(hotel_review$Score)


# Booleans No = 0 & Yes = 1
# Adjusting data types of data to prepare for analysis

hotel_review$User.country = as.character(hotel_review$User.country)
hotel_review$Nr..reviews = as.numeric(hotel_review$Nr..reviews)
hotel_review$Nr..hotel.reviews = as.numeric(hotel_review$Nr..hotel.reviews)
hotel_review$Helpful.votes = as.numeric(hotel_review$Helpful.votes)
hotel_review$Score = as.numeric(hotel_review$Score)
hotel_review$Period.of.stay = as.character(hotel_review$Period.of.stay)
hotel_review$Traveler.type = as.character(hotel_review$Traveler.type)
hotel_review$Pool <- as.integer(ifelse(hotel_review$Pool == 'YES', 1, 0))
hotel_review$Gym <- as.integer(ifelse(hotel_review$Gym == 'YES', 1, 0))
hotel_review$Tennis.court <- as.integer(ifelse(hotel_review$Tennis.court == 'YES', 1, 0))
hotel_review$Spa <- as.integer(ifelse(hotel_review$Spa == 'YES', 1, 0))
hotel_review$Casino <- as.integer(ifelse(hotel_review$Casino == 'YES', 1, 0))
hotel_review$Free.internet <- as.integer(ifelse(hotel_review$Free.internet == 'YES', 1, 0))
hotel_review$Hotel.name = as.character(hotel_review$Hotel.name)
hotel_review$Hotel.stars = as.numeric(hotel_review$Hotel.stars)
hotel_review$Nr..rooms = as.numeric(hotel_review$Nr..rooms)
hotel_review$User.continent = as.character(hotel_review$User.continent)
hotel_review$Member.years = as.numeric(hotel_review$Member.years)
hotel_review$Review.month = as.character(hotel_review$Review.month)
hotel_review$Review.weekday = as.character(hotel_review$Review.weekday)

sapply(hotel_review, class)

# Inspect the content again after data type adjustments.

summary(hotel_review)
summary(hotel_review$Score)

# Inspect the correlations between numeric explanatory variables.

cor(hotel_review[c(2,3,4,5,8:14,15,16,18)])


# Be aware of any explanatory variables that are highly correlated (both positively and negatively) with each other.
### There are a few correlations that seem to have some relevant positive correlations:
### Number of Reviews to Helpful Votes : Which seems obvious as a user increases the number of reviews they leave, they are likely to have more helpful votes simply because there are more oppertunities for their reviews to be marked helpful.
### Number of Reviews to Number of Hotel Reviews : Something to look at - Could this be because an increase in reviews means the hotel is more likely to rebound from a bad scored review? 
### Number of Hotel Reviews to Number of Helpful Votes
### With the numeric variables, there doesn't seem to be any strong correlation - negative or positive that assists in modeling a predictory model for the strength of a score a user will leave.


##################################################
# Estimating a Regression Model
# Model 1: Linear model for hospital choice probability
# Start with a full model that includes all variables.
##################################################

# Estimate a regression model.
lm_model_1 <- lm(data = hotel_review, 
                 formula = Score ~ Nr..reviews + Nr..hotel.reviews + Helpful.votes)

# Output the results to screen.
summary(lm_model_1)

#Calculate the predictions of this model.
hotel_review[, 'HotelReview_prob_lm'] <- predict(lm_model_1)

summary(hotel_review[, 'HotelReview_prob_lm'])

##################################################
# Estimating a Regression Model
# Model 4: Logistic model for hospital choice probability
##################################################

# Estimate a logistic regression model.
# binomial because we are looking at the possibility of one of two options occurring
logit_model_1 <- glm(data = hotel_review, 
                     formula = Score ~ Pool + Gym + Tennis.court + Spa + Casino + Free.internet, 
                     family = 'binomial')

# Output the results to screen.
summary(logit_model_1)

# Calculate the predictions of this model.
# Prevents negative number in the Min.
hosp_choice[, 'HospChoice_prob_logit'] <- predict(logit_model_1, type = 'response')

summary(hosp_choice[, 'HospChoice_prob_logit'])
# Does this look better?

logit_model_2 <- glm(data = hosp_choice, 
                     formula = D ~ DISTANCE +  
                       INCOME  + OLD + OLD*DISTANCE, 
                     family = 'binomial')

# Output the results to screen.
summary(logit_model_2)

# Calculate the predictions of 


##################################################
# End
##################################################