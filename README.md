# Pokemon Data Analysis
This repository contains files related to projects involving the [Pokémon with Stats](https://www.kaggle.com/abcsds/pokemon) dataset

![Image](https://images.nintendolife.com/12057e37053a0/pokemon-gotta-catch-em-all.large.jpg)


## About Pokémon (A brief summary)


### About the Dataset

This data set includes 721 Pokémon, including their number, name, first and second type, and basic stats: HP, Attack, Defense, Special Attack, Special Defense, and Speed.

These are the raw attributes that are used for calculating how much damage an attack will do in the games. This dataset is about the pokémon games (NOT pokémon cards or Pokemon Go).

The data as described by [Myles O'Neill](https://www.kaggle.com/mylesoneill) (with slight edits):

- **#**: ID for each pokemon
- **Name**: Name of each pokemon
- **Type 1**: The pokémon's first type; this determines weakness/resistance to attacks
- **Type 2**: The pokémon's second type (if applicable); some pokemon are dual type
- **Total**: sum of all numeric stats of a pokémon; serves as a general guide to how strong a pokemon is
- **HP**: "hit points", or health, defines how much damage a pokemon can withstand before fainting
- **Attack**: the base modifier for physical attacks (eg. Scratch, Bite)
- **Defense**: the base damage resistance against physical attacks
- **SP Atk**: special attack, the base modifier for special attacks (e.g. Fire blast, Bubble beam)
- **SP Def**: the base damage resistance against special attacks
- **Speed**: determines which pokemon attacks first each round

*Note:* Prior to Generation 4 attacks were not categorized as physical or special, though, the stats existed as separate categories


#### Data Sources
The data is originally sourced from several websites but can be obtained through *Kaggle* or *data.world*
- [Kaggle](https://www.kaggle.com/abcsds/pokemon)
- [data.world](https://data.world/data-society/pokemon-with-stats)

The dataset will also be provided on this Github repository [here](https://github.com/morales-ep/Pokemon-analysis/blob/73e83606f543f95ff3036819c3b49388145506a6/data/raw_data/Pokemon.csv)

### Directory Structure
- **data** contains files of the dataset(s) used for pokémon data analysis projects
  + *raw_data* contains the raw data downloaded directly from their source, e.g. Kaggle, before data wrangling and processing
  + *cleanPokemon.csv* is the dataset that was produced in the script file *pokemonCleaning.R*; the file is intended to facilitate analyses for future projects
   - This csv file has variables/columns with proper format (e.g., factor variables that were previously character variables), properly categorized legendary and mystical pokémon, and removes "mega" pokémon
  + *pokemonCleaning.R* contains the R script used to process and prepare a dataset based on the raw data in order to facilitate future work
