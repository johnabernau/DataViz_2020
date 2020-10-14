# Tue Oct 13 16:27:38 2020 ------------------------------
# Data Visualization in R
# SOC500 Workshop
# John A. Bernau
# Data wrangling with the tidyverse
# -------------------------------------------------------

# setup
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")
require(dplyr)
require(tidyr)
require(ggplot2)

# alternatively...
install.packages("tidyverse")
require(tidyverse)

# built-in datasets in dplyr
starwars
storms

# various ways to examine data
head(starwars, n = 10) # first N rows
names(starwars) # variable names
count(storms, status) # tabulate data
count(storms, year)
count(storms, year, status)

# the pipe operator "%>%" takes the output of a command and inserts it as first argument of next command
# these two lines are equivalent:
sample_n(storms, size = 20)
storms %>% sample_n(size = 20)


# -------------------- TEN ESSENTIAL DATA WRANGLING VERBS ---------------------
# save data in local environment
starwars <- starwars

# 1. select() to keep or remove variables
starwars %>% select(name, gender, homeworld, species)
starwars %>% select(-films, -vehicles, -starships)
starwars %>% select(name, species, gender, everything())

# 2. rename() to rename variables
starwars %>% rename(planet = homeworld)
starwars %>% rename(yob = birth_year)

# NOTE: these changes are being printed but not saved unless the output is stored as a new object
starwars_cleaned <- starwars %>% 
  select(name, gender, birth_year, homeworld, species) %>% 
  rename(planet = homeworld, yob = birth_year)

# 3. arrange() to sort data
starwars %>% arrange(mass)
starwars %>% arrange(desc(mass))

# 4. filter() to filter data
starwars %>% filter(mass < 100)
starwars %>% filter(hair_color == "blond")
starwars %>% filter(startsWith(name, "B"))
starwars %>% filter(gender == "male", startsWith(name, "B"), height < 190)

# 5. mutate() to create new variables
starwars %>% mutate(mass2 = mass^2)
starwars %>% mutate(mass_per_cm = mass / height)
starwars %>% mutate(species = toupper(species))

# 6. factor() to manually set levels and labels of a factor
# NOTE: there is also a tidyverse package to work with factors called "forcats"
class(starwars$gender)

starwars %>% count(gender) %>%  ggplot(aes(gender, n)) + geom_bar(stat = "identity")

starwars$gender <- factor(starwars$gender, levels = c("male", "female", "hermaphrodite", "none", "NA"))

starwars$gender <- factor(starwars$gender, levels = c("male", "female", "hermaphrodite", "none", "NA"), 
                          labels = c("M", "F", "H", "none", "NA"))

# 7. summarize() to create new variables and summarize data
starwars %>% summarize(avg_mass = mean(mass))
starwars %>% filter(!is.na(mass)) %>% summarize(avg_mass = mean(mass))
mean(starwars$mass, na.rm = TRUE) # easier for non-grouped data

# 8. group_by() to group by varaibles
starwars %>% group_by(homeworld) %>% summarize(avg_mass = mean(mass))
starwars %>% filter(!is.na(mass)) %>% group_by(homeworld) %>% summarize(avg_mass = mean(mass))

# 9. gather() to collapse columns into rows
swg <- starwars %>% 
  select(name, mass, hair_color, gender, homeworld, species) %>% 
  gather(key = "var", value = "value", gender:species) %>% 
  arrange(name)

# 10. spread() to convert rows into columns
swg %>% spread(key = var, value = value)

# NOTE: gather() and spread() have been replaced by the "pivot" functions
vignette("pivot")