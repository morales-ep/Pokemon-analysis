# ====== METADATA ======
# TITLE: Pokémon Linear Regression Project
# PURPOSE: Demonstrate base R proficiency by exploring your research questsion(s)
#          and familiarity with reproducible research practices (i.e., clean/process 
#          dataset, accessible github repository, comments for clarity, communication, etc.)

# # GITHUB REPOSITORY: https://github.com/morales-ep/Pokemon-analysis
# DATA FILE: 'data/raw_data/Pokemon.csv'

# AUTHOR: Earl Morales
# CONTACT: morales.el808@gmail.com

# DATE OF SCRIPT'S CREATION: 3/19/2022
# DATE LAST MODIFIED: 03/19/2022
# Current Date & Time:
Sys.time()

# SESSION INFORMATION:
xfun::session_info()



# ==== DATA PROCESSING ====

# ---- Note: R objects of the following named "x.y" are data sets

# Pull data from git repo and save to an R object
#'https://raw.githubusercontent.com/morales-ep/Pokemon-analysis/main/data/raw_data/Pokemon.csv'
#pokemon.raw <- read.csv(file = 'https://github.com/morales-ep/Pokemon-analysis/blob/main/data/raw_data/Pokemon.csv')
# ^ DO NOT RUN, WILL CAUSE RSTUDIO TO CRASH
#   ^^ DO NOT RUN UNTIL YOU SOLVED THIS ISSUE

# Check structure and summary of dataset
str(pokemon.raw)
summary(pokemon.raw)

# Check for NAs in the dataset
colSums(sapply(X = pokemon.raw, FUN = is.na))
unique(pokemon.raw$Type.2)


