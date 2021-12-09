# ====== METADATA ======

# TITLE: Pokémon Exploratory Data Analysis
# GOAL: Use base R and/or other packages, i.e. ggplot2 and lattice, 
#       to wrangle/clean pokémon dataset, describe the data, 
#       and identify interesting patterns and trends

# GITHUB REPOSITORY: https://github.com/morales-ep/Pokemon-analysis
# DATA FILE: 'data/raw_data/Pokemon.csv'

# AUTHOR: Earl Morales
# CONTACT: morales.el808@gmail.com

# DATE OF SCRIPT'S CREATION: 12/9/2021
# DATE LAST MODIFIED: ts

# R SESSION INFORMATION:
xfun::session_info()



# ==== Data Processing and Wrangling ====

# Pull dataset from git repo and save to an R object
pokemon <- read.csv(file = 'https://raw.githubusercontent.com/morales-ep/Pokemon-analysis/main/data/raw_data/Pokemon.csv')

# Check structure and summary of dataset
str(pokemon)
summary(pokemon)

# Check for NAs in the dataset
colSums(sapply(X = pokemon, FUN = is.na))
unique(pokemon$Type.2)
# Not all pokemon have a 2nd type, hence missing values coded as ""

# Recode missing data (coded as empty character "") to NA
pokemon[pokemon == ""] <- NA
colSums(sapply(X = pokemon, FUN = is.na))
# There are 386 missing values in the entired dataset; only 'Type.2' variable has missing data

# Recode variables to appropriate data type; Rename variables if necessary
colnames(pokemon)[1] <- "ID"
pokemon$ID <- as.character(pokemon$ID)

pokemon[, c("Type.1", "Type.2", "Generation", "Legendary")] <- lapply(X = pokemon[, c("Type.1", "Type.2", "Generation", "Legendary")],
                                                                      FUN = as.factor)
# Keep 'Legendary' variable as a factor instead of a logical/boolean for now...

# Check dataset's structure after processing
str(pokemon)



# ==== Exploratory Data Analysis ====

# Create tables and or data frames of descriptive stats; generate questions to guide your analysis
# ---- ^ CONTINUE HERE ^ ----



# ===== Citation ====
citation()
