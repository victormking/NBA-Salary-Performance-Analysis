library(broom)
library(ggplot2)
library(tidyverse)
library(readxl)
library(car)
library(carat)
library(lmtest)
library(sandwich)
library(tidyr)
library(dplyr)
library(readr)
library(dynlm)
library(stats)
library(scales)
library(cluster)
library(factoextra)
library(caret)
library(rpart)
library(rpart.plot)
library(officer)
library(rvg)
library(randomForest)

nba_fantasy <- read.csv("621 - Gambling/Group Project 3/nba_project3_data.csv")
head(nba_fantasy)

view(nba_fantasy)

model_dk <- lm(draftp ~ draftsal, data = nba_fantasy)
summary(model_dk)

model_fd <- lm(fanp ~ fansal, data = nba_fantasy)
summary(model_fd)

model_yh <- lm(yahp ~ yahsal, data = nba_fantasy)
summary(model_yh)

# Ensure all necessary columns are free from NAs before fitting the model
nba_fantasy <- nba_fantasy %>% 
  filter(!is.na(draftsal) & !is.na(draftp))

# Now fit your model
model_dk <- lm(draftp ~ draftsal, data = nba_fantasy)

# Since we've ensured there are no NAs, this should now work without row mismatch
nba_fantasy$draft_residuals <- residuals(model_dk)

# Calculate the undervalued/overvalued status
nba_fantasy$draft_undervalued <- ifelse(nba_fantasy$draft_residuals > 0, "Undervalued", "Overvalued")

# Checking the first few rows to confirm
head(nba_fantasy$draft_undervalued)

nba_fantasy$draft_residuals <- residuals(model_dk)
nba_fantasy$draft_undervalued <- ifelse(nba_fantasy$draft_residuals > 0, "Undervalued", "Overvalued")

str(nba_fantasy)

nba_fantasy$draftsal <- as.numeric(as.character(nba_fantasy$draftsal))

nba_fantasy$draftsal[!sapply(nba_fantasy$draftsal, is.numeric)]
view(nba_fantasy)

unique(nba_fantasy$draftsal)

nba_fantasy$draftsal <- gsub("[^0-9.]", "", as.character(nba_fantasy$draftsal))  # Remove all non-numeric except period
nba_fantasy$draftsal <- as.numeric(nba_fantasy$draftsal)

sum(is.na(nba_fantasy$draftsal))  # How many NAs are still there?
head(nba_fantasy$draftsal)   

nba_fantasy <- nba_fantasy[!is.na(nba_fantasy$draftsal), ]


summary(nba_fantasy$draftsal)

# yansal

unique(nba_fantasy$yahsal)

nba_fantasy$yahsal <- gsub("[^0-9.]", "", as.character(nba_fantasy$yahsal))  # Remove all non-numeric except period
nba_fantasy$yahsal <- as.numeric(nba_fantasy$yahsal)

# fansal

unique(nba_fantasy$fansal)

nba_fantasy$fansal <- gsub("[^0-9.]", "", as.character(nba_fantasy$fansal))  # Remove all non-numeric except period
nba_fantasy$fansal <- as.numeric(nba_fantasy$fansal)


# Histogram of salaries across different platforms
ggplot(nba_fantasy, aes(x = draftsal)) + geom_histogram(bins = 30, fill = "blue") + ggtitle("DraftKings Salary Distribution")
ggplot(nba_fantasy, aes(x = fansal)) + geom_histogram(bins = 30, fill = "green") + ggtitle("FanDuel Salary Distribution")
ggplot(nba_fantasy, aes(x = yahsal)) + geom_histogram(bins = 30, fill = "red") + ggtitle("Yahoo Salary Distribution")

# Scatter plots to explore relationships between salary and performance
ggplot(nba_fantasy, aes(x = draftsal, y = draftp)) + geom_point() + geom_smooth(method = "lm") + ggtitle("DraftKings Salary vs Performance")
ggplot(nba_fantasy, aes(x = fansal, y = fanp)) + geom_point() + geom_smooth(method = "lm") + ggtitle("FanDuel Salary vs Performance")
ggplot(nba_fantasy, aes(x = yahsal, y = yahp)) + geom_point() + geom_smooth(method = "lm") + ggtitle("Yahoo Salary vs Performance")


undervalued_players <- nba_fantasy %>%
  filter(draft_undervalued == "Undervalued") %>%
  arrange(desc(draft_residuals))
head(undervalued_players)



ggplot(nba_fantasy, aes(x = draftsal, y = draftp)) +
  geom_point(aes(color = draft_undervalued)) +
  geom_smooth(method = "lm") +
  ggtitle("DraftKings Salary vs. Performance with Valuation Highlight")


# Extended model including potential bias factors
bias_model <- lm(draftp ~ draftsal + daysrest + venue, data = nba_fantasy)
summary(bias_model)

# Compare models
#anova(model_dk, bias_model)

# The Effect of days rest on player performance
ggplot(nba_fantasy, aes(x = as.factor(daysrest), y = draftsal)) +
  geom_boxplot() +
  ggtitle("Impact of Days Rest on Salary")

# The Effect of venue on salary
ggplot(nba_fantasy, aes(x = venue, y = draftsal)) +
  geom_boxplot() +
  ggtitle("Salary Variation by Venue")

view(nba_fantasy)


# Ensuring the data types are correct
nba_fantasy$daysrest <- as.numeric(as.character(nba_fantasy$daysrest))
nba_fantasy$venue <- as.factor(nba_fantasy$venue)

# Updating regression models with additional predictors
model_dk_extended <- lm(draftp ~ draftsal + daysrest + venue, data = nba_fantasy)
model_fd_extended <- lm(fanp ~ fansal + daysrest + venue, data = nba_fantasy)
model_yh_extended <- lm(yahp ~ yahsal + daysrest + venue, data = nba_fantasy)

# Summarize the extended models
summary(model_dk_extended)
summary(model_fd_extended)
summary(model_yh_extended)

# Filtering out any rows with NAs in the relevant columns
nba_fantasy_filtered <- nba_fantasy %>%
  filter(!is.na(draftsal) & !is.na(daysrest) & !is.na(venue) & 
           !is.na(fansal) & !is.na(yahsal))

# Refitting all models with this filtered dataset - cuz yk..
model_dk <- lm(draftp ~ draftsal, data = nba_fantasy_filtered)
model_fd <- lm(fanp ~ fansal, data = nba_fantasy_filtered)
model_yh <- lm(yahp ~ yahsal, data = nba_fantasy_filtered)

model_dk_extended <- lm(draftp ~ draftsal + daysrest + venue, data = nba_fantasy_filtered)
model_fd_extended <- lm(fanp ~ fansal + daysrest + venue, data = nba_fantasy_filtered)
model_yh_extended <- lm(yahp ~ yahsal + daysrest + venue, data = nba_fantasy_filtered)

# perform ANOVA
anova_dk <- anova(model_dk, model_dk_extended)
anova_fd <- anova(model_fd, model_fd_extended)
anova_yh <- anova(model_yh, model_yh_extended)

# ANOVA results
print(anova_dk)
print(anova_fd)
print(anova_yh)

# Example of investigating team influence on salary
team_effect_model <- lm(draftp ~ draftsal + OWN.TEAM, data = nba_fantasy_filtered)
summary(team_effect_model)

# Visualizing the effect of OWN.TEAM on DraftKings Salary
ggplot(nba_fantasy_filtered, aes(x = OWN.TEAM, y = draftsal)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Team Influence on DraftKings Salary")

# Updating regression models with additional predictors
model_dk_full <- lm(draftp ~ draftsal + daysrest + venue + starter + MINUTES + OPPONENT.TEAM, data = nba_fantasy_filtered)
model_fd_full <- lm(fanp ~ fansal + daysrest + venue + starter + MINUTES + OPPONENT.TEAM, data = nba_fantasy_filtered)
model_yh_full <- lm(yahp ~ yahsal + daysrest + venue + starter + MINUTES + OPPONENT.TEAM, data = nba_fantasy_filtered)

# Summarize the full models
summary(model_dk_full)
summary(model_fd_full)
summary(model_yh_full)

# Visualizing the impact of being a starter on DraftKings Salary
ggplot(nba_fantasy_filtered, aes(x = starter, y = draftsal, fill = starter)) +
  geom_boxplot() +
  ggtitle("Impact of Starting Status on DraftKings Salary")

nba_fantasy_filtered$starter <- as.factor(nba_fantasy_filtered$starter)
nba_fantasy_filtered$OPPONENT.TEAM <- as.factor(nba_fantasy_filtered$OPPONENT.TEAM)

# Visualizing the impact of minutes played on DraftKings Salary
ggplot(nba_fantasy_filtered, aes(x = MINUTES, y = draftsal)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  ggtitle("Impact of Minutes Played on DraftKings Salary")

# Visualizing the impact of opponent team on DraftKings Salary
ggplot(nba_fantasy_filtered, aes(x = OPPONENT.TEAM, y = draftsal, fill = OPPONENT.TEAM)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Impact of Opponent Team on DraftKings Salary")

# Regression Diagnostics
vif(model_dk_full)  # Check for multicollinearity

plot(model_dk_full, which = 1)  # Residuals vs Fitted
plot(model_dk_full, which = 2)  # Normal Q-Q

# Example of selecting undervalued players based on model residuals
nba_fantasy_filtered$residuals <- residuals(model_dk_full)
undervalued_players <- nba_fantasy_filtered[nba_fantasy_filtered$residuals > 0, ]
top_undervalued_players <- undervalued_players[order(undervalued_players$residuals, decreasing = TRUE), ]

# Print top undervalued players
head(top_undervalued_players)



