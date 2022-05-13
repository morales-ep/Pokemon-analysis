# ====== METADATA ======
# TITLE: Pokémon Data Cleaning
# PURPOSE: Demonstrate base R proficiency and familiarity with reproducible research practices 
#          (i.e., clean/process dataset, accessible github repository, comments for clarity, 
#          communication, etc.) by preparing the Pokémon dataset for analysis and storing in Git repo

# GITHUB REPOSITORY: https://github.com/morales-ep/Pokemon-analysis
# SOURCE DATA FILE: 'data/raw_data/Pokemon.csv'
# RESULT DATA FILE: 'data/cleanPokemon.csv'

# AUTHOR: Earl Morales
# CONTACT: morales.el808@gmail.com

# CREATED: 3/19/2022
# MOST RECENT REVIEW: 05/03/2022
# Current Date & Time:
Sys.time()

# SESSION INFORMATION:
xfun::session_info()



# ==== DATA PROCESSING ====

# ---- Note: R objects of the following named "x.y" are data sets

# Pull data from git repo and save to an R object
pokemon.raw <- read.csv(file = 'https://raw.githubusercontent.com/morales-ep/Pokemon-analysis/main/data/raw_data/Pokemon.csv')
# 'pokemon.raw' will be the raw, unedited/unaltered dataset for all ensuing pokemon-related projects

# Check structure and summary of dataset
str(pokemon.raw)
summary(pokemon.raw)
# Will need to convert some variables/columns to appropriate data type

# Make assign raw data to new R object to create a clean, unsubsetted dataset
pokemon <- pokemon.raw
# 'pokemon' will be the cleaned dataset by which all subsetted data will based upon



# ==== DATA CLEANING ====

# Check for NAs in the dataset
colSums(sapply(X = pokemon, FUN = is.na))
unique(pokemon$Type.2)
# Not all pokémon have a 2nd type, hence missing values coded as  ""

# Check the number of records/pokémon with missing 2nd type (i.e., single-type pokémon)
nrow(is.na(pokemon[pokemon$Type.2 == "",]))
# There are 386 single-typed pokemon missing values in the entire dataset

# Recode missing data (coded as empty character "") to NA
pokemon[pokemon == ""] <- NA
colSums(sapply(X = pokemon, FUN = is.na))
# Confirmation: 386 missing values in the entire dataset; only 'Type.2' variable has missing data


# Recode variables to appropriate data type; Rename variables if necessary
colnames(pokemon)[1] <- "ID"
pokemon$ID <- as.character(pokemon$ID)

# Convert columns to factor type
pokemon[, c("Type.1", "Type.2", "Generation", "Legendary")] <- lapply(X = pokemon[, c("Type.1", "Type.2", "Generation", "Legendary")], FUN = as.factor)
# Keep 'Legendary' variable as a factor instead of a logical/boolean for now...



# ==== Legendary Pokémon ====

# ---- NOTE ----
# Some pokémon that were originally legendary (e.g. Mew, Celebi, Manaphy) 
# are not categorized as 'legendary' in this dataset
# They are a subgroup of legendaries called "mythical pokémon" bc not available in-game
# Use links for reference: https://www.serebii.net/pokemon/legendary.shtml#mythical
#  https://bulbapedia.bulbagarden.net/wiki/Mythical_Pokémon#List_of_Mythical_Pok.C3.A9mon

# Will need to recode factor level for "mythical legendaries" in 'pokemon' and subsequent datasets
# Start with the original 'pokemon' dataset
# There are also Legendary Pokemon not listed as "Legendary" (e.g. Cresselia)

# Add "Mythical" factor level to 'Legendary' variable/column
pokemon$Legendary <- factor(x = pokemon$Legendary, levels = c("True", "False", "Mythical"))

# Pull Mythicals w/ one form and just the 13th ('Legendary') column
# Categorize these pokemon as "Mythical"
pokemon[pokemon$Name %in% c("Mew", "Celebi", "Jirachi", "Manaphy", 
                            "Phione", "Darkrai","Arceus", "Victini", 
                            "Genesect", "Volcanion"), 13] <- factor("Mythical")

# Pull 'Legendary' column of Mythicals that have multiple forms and assign "Mythical" factor level 
# grep() returns row index
pokemon[c(grep(pattern = "Deoxys", x = pokemon$Name), 
          grep(pattern = "Shaymin", x = pokemon$Name), 
          grep(pattern = "Keldeo", x = pokemon$Name), 
          grep(pattern = "Meloetta", x = pokemon$Name), 
          grep(pattern = "Diancie", x = pokemon$Name), 
          grep(pattern = "Hoopa", x = pokemon$Name)), 13] <- factor("Mythical")

# Recategorize "Cresselia" as a Legendary pokémon
pokemon[pokemon$Name == "Cresselia", 13] <- factor("True")

# Check dataset's structure and summary after processing
str(pokemon)
summary(pokemon)



# ==== MISCELANEOUS SUBSETS ===

# ---- Note: May not need this section since subsetting can be its own procedure
#            for a specific analysis in another script

# Subets of single-type and double-type pokemon respectfully in entire dataset
# pokemon_single <- subset(x = pokemon, subset = is.na(Type.2))
# pokemon_double <- subset(x = pokemon, subset = !is.na(Type.2)) 
# 
# # Ratio of double-type pokemon to single-type and vice versa
# nrow(pokemon_double) / nrow(pokemon_single)
# nrow(pokemon_single) / nrow(pokemon_double)
# # More double-type than single-types
# 
# # Subset of 'Mega' pokemon in dataset
# # '..' specifies characters preceding string 'Mega' thus removing'Meganium' string matching
# pokemon_mega <- pokemon[grep(pattern = "..Mega", x = pokemon$Name),]
# 
# # Create subset of "pokemon" excluding Mega pokemon; Resulting dataset should contain 752 rows
# pokemon_noMega <- pokemon[!(pokemon$Name %in% pokemon_mega$Name),]
# # Pull pokémon from "pokemon" dataset that are NOT in "pokemon_mega" dataset
# 
# #pokemon_mega[pokemon_mega$Name %in% pokemon$Name,] # Pulls mega pokémon in the "pokemon" dataset
# 
# # Check structure of "pokemon_noMega" and summarize dataframe
# str(pokemon_noMega)
# summary(pokemon_noMega)


# ==== DATA STORAGE ====

# Export raw pokémon dataset as csv file
write.csv(x = pokemon, file = "cleanPokemon.csv", row.names = FALSE)
# file manually moved into 'data' subfolder

# Edit pokémon git repo after completing data storage tasks;
# Solve issue with Git push using SSH Keys
# ---- ^ CONTINUE HERE ^ ----


# ==== R Citation ====
citation()

# remove all objects from environment
rm(list = ls())
