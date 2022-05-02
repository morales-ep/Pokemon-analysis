# ====== METADATA ======
# TITLE: Pokémon Exploratory Data Analysis
# GOAL: Demonstrate base R proficiency and reproducible research
#       practices by wrangling/cleaning pokémon dataset, 
#       describing the data with descriptive statistics, 
#       and identify interesting patterns and trends.

# Findings from this EDA project may be used for other projects
# that utilize this pokémon dataset.

# GITHUB REPOSITORY: https://github.com/morales-ep/Pokemon-analysis
# DATA FILE: 'data/raw_data/Pokemon.csv'

# AUTHOR: Earl Morales
# CONTACT: morales.el808@gmail.com

# DATE OF SCRIPT'S CREATION: 12/9/2021
# DATE LAST MODIFIED: 02/01/2022
Sys.time()

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

# Convert columns to factor type
pokemon[, c("Type.1", "Type.2", "Generation", "Legendary")] <- lapply(X = pokemon[, c("Type.1", "Type.2", "Generation", "Legendary")],
                                                                      FUN = as.factor)
# Keep 'Legendary' variable as a factor instead of a logical/boolean for now...

# ---- NOTE ----
# Some pokémon that were traditionally legendary (e.g. Mew, Celebi, Manaphy) 
# are not categorized as 'legendary' in this dataset
# They are a subgroup of legendaries called "mythical pokémon" bc not available in-game
# Use link as a reference: https://www.serebii.net/pokemon/legendary.shtml#mythical
#                          https://bulbapedia.bulbagarden.net/wiki/Mythical_Pokémon#List_of_Mythical_Pok.C3.A9mon

# Will need to recode factor level for "mythical legendaries" in 'pokemon' dataset and subsequent datasets
# Start at 'pokemon' original dataset, then update pokemon_noMega
# There are also Legendary Pokemon not listed as Legendary (e.g. Cresselia)

# Add "Mythical" factor level to 'Legendary' variable/column
pokemon$Legendary <- factor(x = pokemon$Legendary, levels = c("True", "False", "Mythical"))

# Pull Mythicals w/ one form and just the 13th ('Legendary') column
# Categorize these pokemon as "Mythical"
pokemon[pokemon$Name %in% c("Mew", "Celebi", "Jirachi", "Manaphy", 
                            "Phione", "Darkrai","Arceus", "Victini", 
                            "Genesect", "Volcanion"), 13] <- factor("Mythical")

# Pull 'Legendary' column of Mythcial w/ multiple forms; grep returns row index
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

# Subets of single-type and double-type pokemon respectfully in entire dataset
pokemon_single <- subset(x = pokemon, subset = is.na(Type.2))
pokemon_double <- subset(x = pokemon, subset = !is.na(Type.2)) 

# Ratio of double-type pokemon to single-type and vice versa
nrow(pokemon_double) / nrow(pokemon_single)
nrow(pokemon_single) / nrow(pokemon_double)
# More double-type than single-types

# Subset of 'Mega' pokemon in dataset
# '..' specifies characters preceding string 'Mega' thus removing'Meganium' string matching
pokemon_mega <- pokemon[grep(pattern = "..Mega", x = pokemon$Name),]

# Create subset of "pokemon" excluding Mega pokemon; Resulting dataset should contain 752 rows
pokemon_noMega <- pokemon[!(pokemon$Name %in% pokemon_mega$Name),]
# Pull pokémon from "pokemon" dataset that are NOT in "pokemon_mega" dataset

#pokemon_mega[pokemon_mega$Name %in% pokemon$Name,] # Pulls mega pokémon in the "pokemon" dataset

# Check structure of "pokemon_noMega" and summarize dataframe
str(pokemon_noMega)
summary(pokemon_noMega)

# ---- NOTE ---- 
# I recommend uploading cleaned dataset(s) to Git repo in addition to raw dataset



# ==== Exploratory Data Analysis ====

# ---- Research Questions ----
# 1. What trends exist among the "stat" variables (e.g., Attack, Sp..Atk, etc.)
#    and what correlations exist?
# 2. What do the distributions in the "stat" variables look like by Type?, Legendary Status, Generation?
#    NOTE: Type maybe difficult because the abundance of double-type pokémon

# **** IGNORE ****
# 3. What is the "best" starter, legendary, and/or legendary form based on stats and typing?
#    NOTE: Possibly stratify by Generation for more detailed analysis?
#     ^ May need to change or eliminate this RQ bc it's too broad; can serve as its own project
# **** IGNORE ****

# *MAKE SURE TO PUSH YOUR WORK TO POKEMON GIT REPO; Your breanch is ahead of 'origin/main' by 1 commit*



# ---- RQ 1. ----

# *FUNCTIONS BELOW ARE FROM 'introR.Rmd' Chapter 4 Question 12*
# Define a function to produce histograms along specified panels in pairs plots
panel.hist <- function(x, ...)
{
  usr <- par("usr")
  on.exit(par(usr))
  
  par(usr = c(usr[1:2], 0, 1.5))
  
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks
  nB <- length(breaks)
  
  y <- h$counts; y <- y/max(y)
  
  rect(breaks[-nB], 0, breaks[-1], y, col = "orange")
}

# Define function to display correlation coefficients within specified panels of pairs plot
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor)
{
  usr <- par("usr")
  on.exit(par(usr))
  
  par(usr = c(0, 1, 0, 1))
  r <- cor(x, y)
  
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  
  text(0.5, 0.5, txt, cex = cex.cor * r)
}

# Scatterplot Matrices w/ Pearson's Correlation in upper panel and Historgrams along diagonal
# Limit pairs plot to non-Legendary pokémon excluding Mythicals
pairs(formula = ~ Total + HP + Attack + Defense + Sp..Atk + Sp..Def + Speed,
      data = pokemon_noMega[pokemon_noMega$Legendary == "False",],
      panel = panel.smooth,
      diag.panel = panel.hist,
      upper.panel = panel.cor)
# ^ Should supplement pairs plot with correlation matrix

# Correlation matrix (Pearson's Correlation) of Poké stat variables among non-Legendaries
round(cor(pokemon_noMega[pokemon_noMega$Legendary == "False", 5:11], method = "pearson"), 2)

# RESULT(S):
# It appears that for non-Legendary Pokémon the strongest correlations among the stat variables
# occur between the 'Total' variable and the other stat variables, with 'Speed' having the lowest
# correlation with Total. In addition, the stat variables have positive, moderate correlations with
# 'Total', meaning that Total rises with every unit increase in each stat variable. This finding is 
# logical since the Total variable is the sum of all of a pokémon's stats.

# With exception to 'Total' and 'Attack', though to a lesser extent, the stat variables seem to be
# distributed with a left skew depicted by histograms along the diagonal panels suggesting that most 
# pokémon tend to have stats that fall below the mean and/or median. This is unsurprising since pokémon 
# with relatively high stats are often late-stage evolutions or Legendaries with the latter excluded 
# from this analysis. An interesting finding is that there is a negative, albeit weak, correlation
# between 'Defense' and 'Speed'. This finding makes sense logically since a pokémon with large physical
# defense stat tend to be bulkier and thus slower; further research is needed to verify this hypothesis



# ---- RQ 2. ----

# Means and Medians of 'Total' variable for each Pokémon Generation
round(tapply(X = pokemon_noMega$Total, INDEX = pokemon_noMega$Generation, FUN = mean), 2)
tapply(X = pokemon_noMega$Total, INDEX = pokemon_noMega$Generation, FUN = median)
# ^ Median may be more appropriate bc of outliers including Legendaries

# Median and Mean values of 'Total' by Legendary Status
tapply(X = pokemon_noMega$Total, INDEX = pokemon_noMega$Legendary, FUN = median)
round(tapply(X = pokemon_noMega$Total, INDEX = pokemon_noMega$Legendary, FUN = mean), 2)

# tapply(X = pokemon_noMega$Total, INDEX = list(pokemon_noMega$Legendary, pokemon_noMega$Generation), 
#        FUN = median, na.rm = TRUE)


# Average values of Poké-stats variables by 'Generation' using aggregate()
aggregate(formula = cbind(Total, HP, Attack, Defense, Sp..Atk, Sp..Def, Speed) ~ Generation,
          data = pokemon_noMega, FUN = mean, na.rm = TRUE)

# Median values of Poké-stats variables by 'Generation' using aggregate()
aggregate(formula = cbind(Total, HP, Attack, Defense, Sp..Atk, Sp..Def, Speed) ~ Generation,
          data = pokemon_noMega, FUN = median, na.rm = TRUE)

# Average values of Poké-stats variables by 'Legendary' using aggregate()
aggregate(formula = cbind(Total, HP, Attack, Defense, Sp..Atk, Sp..Def, Speed) ~ Legendary,
          data = pokemon_noMega, FUN = mean, na.rm = TRUE)

# Median values of Poké-stats variables by 'Legendary' using aggregate()
aggregate(formula = cbind(Total, HP, Attack, Defense, Sp..Atk, Sp..Def, Speed) ~ Legendary,
          data = pokemon_noMega, FUN = median, na.rm = TRUE)

# Median values of Poké-stats variables by 'Generation' and 'Legendary' categories using aggregate()
aggregate(formula = cbind(Total, HP, Attack, Defense, Sp..Atk, Sp..Def, Speed) ~ Generation + Legendary,
          data = pokemon_noMega, FUN = median, na.rm = TRUE)

# Average values of Poké-stats variables by 'Generation' and 'Legendary' categories using aggregate()
aggregate(formula = cbind(Total, HP, Attack, Defense, Sp..Atk, Sp..Def, Speed) ~ Generation + Legendary,
          data = pokemon_noMega, FUN = mean, na.rm = TRUE)

# ^ Decide which table(s) you will keep then summarize findings from all "items" (graphs, tables, etc.)
# ---- ^ CONTINUE HERE ^ ----


# Set graphing parameters for boxplot and violin plot; 1 row, 2 columns single page
# Keep either boxplot OR violin plot
#par(mfrow = c(3, 1))

# Boxplots of 'Total' variable by 'Generation'
boxplot(formula = Total ~ Generation, data = pokemon_noMega[pokemon_noMega$Legendary == "False",], 
        ylab = "Stat Total", col = "Yellow", 
        main = "Boxplot of Total Pokémon Stats by Generation")

# Violin Plot of 'Total' variable by 'Generation'
vioplot::vioplot(formula = Total ~ Generation, data = pokemon_noMega[pokemon_noMega$Legendary == "False",], 
                 ylab = "Stat Total", col = "Yellow", 
                 main = "Violin Plot of Total Pokémon Stats by Generation")

# Cleveland Dot Chart of Stat Total by Generation; might be useful supplement to box-vio plots
with(data = pokemon_noMega[pokemon_noMega$Legendary == "False",], 
     expr = dotchart(x = Total, groups = Generation, 
                     gcolor = colorspace::rainbow_hcl(3)[c(Generation)],
                     ylab = "Pokémon Generation", xlab = "Stat Total",
                     main = "Cleveland Dot Plot of Pokémon Stat Totals by Generation"))
# ^ Group labels print but are cut out of frame; Gen 1-6 ascending order (top-down)



# Graphs of 'Total' by 'Generation' among Legendaries (including Mythical pokémon)
# Set graphing parameters
par(mfrow = c(1, 3))

# Boxplots of 'Total' variable by 'Generation'
boxplot(formula = Total ~ Generation, 
        data = pokemon_noMega[pokemon_noMega$Legendary != "False",], 
        ylab = "Stat Total", col = "azure", 
        main = "Boxplot of Total Pokémon Stats by Generation")

# Violin Plot of 'Total' variable by 'Generation'
vioplot::vioplot(formula = Total ~ Generation, data = pokemon_noMega[pokemon_noMega$Legendary != "False",], 
                 ylab = "Stat Total", col = "azure2", 
                 main = "Violin Plot of Total Pokémon Stats by Generation")

# Cleveland dot chart of 'Total' for Legendaries (including Mythical pokémon)
with(data = pokemon_noMega[pokemon_noMega$Legendary != "False",], 
     expr = dotchart(x = Total, groups = Generation, 
                     labels = pokemon_noMega[pokemon_noMega$Legendary != "False", 2], 
                     gcolor = colorspace::rainbow_hcl(3)[c(Generation)],
                     ylab = "Pokémon Generation", xlab = "Stat Total",
                     main = "Cleveland Dot Plot of Pokémon Stat Totals by Generation"))
# ^ Will print labels (names of Legendaries) for each point; may not display using par()



# Lattice histograms of 'Total' by Legendary status; 1 column, 3 rows
lattice::histogram(x = ~ Total | Legendary, type = "count", 
                   data = pokemon_noMega, layout = c(1, 3))

# Lattice kernal density plots of 'Total' by Legendary status; 1 column, 3 rows
lattice::densityplot(x = ~ Total | Legendary, type = "count", 
                     data = pokemon_noMega, layout = c(1, 3))

# Place lattice 2 graphs side-by-side on a single page using grid.arrange
# Lattice often ignores par()
gridExtra::grid.arrange(lattice::histogram(x = ~ Total | Legendary, type = "count", 
                                data = pokemon_noMega, layout = c(1, 3)),
             lattice::densityplot(x = ~ Total | Legendary, type = "count", 
                                  data = pokemon_noMega, layout = c(1, 3)), 
             ncol = 2)

# RESULT(S):




# ---- RQ 3. ----

# Contingency table(s) of Legendaries and non-Legendaries by Generation
ftable(xtabs(formula = ~ Generation + Legendary, data = pokemon_noMega))
ftable(with(pokemon_noMega, expr = table(Generation, Legendary)))
# Same tables, different syntax; 1st is more efficient bc running 2 functions only instead of 3



# ==== Graphs ====

# Scatterplots of poké-stat variables
with(data = pokemon_noMega, expr = plot(x = Attack, y = Sp..Atk))
with(data = pokemon_noMega, expr = plot(x = Defense, y = Sp..Def))

# Cleveland Dot Plot
dotchart(x = pokemon_noMega$Total, xlab = "Total of Pokémon Stats")

# Histogram(s)
hist(x = pokemon_noMega$Total)


# ===== Citation ====
citation()

# Remove all R objects from Global Environment
rm(list = ls())