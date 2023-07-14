#* This is a playground for testing out new ideas and building new scripts and
#* functions before they are moved to the main project. I still use the BCI
#* data.

#% SETUP ---------------------------------------------------------------------#
#* Load packages
library(tidyverse)
library(vegan)
library(devtools)

#* Load data
data("BCI")

#* Set seed
set.seed(123)

#% ABUNDANCE ANALYSIS AND VISUALIZATION --------------------------------------#
#* Calculate abundance from BCI count data
spec_abund <- as.data.frame(colSums(BCI))
#* Rename column
names(abund) <- "species_abundance"

#* Plot number of species vs. abundance with simple theme
ggplot(abund, aes(x = species_abundunce)) +
  geom_histogram(binwidth = 25,
                 fill = "#6d6dfa",
                 color = "black") +
  labs(x = "Abundance", y = "Number of species") +
    theme_classic()

#* Plot number of species vs. abundance on log scale with simple theme
ggplot(abund, aes(x = species_abundunce)) +
  geom_histogram(binwidth = 0.25,
                 fill = "#6d6dfa",
                 color = "black") +
  labs(x = "Abundance", y = "Number of species") +
  scale_x_log10() +
    theme_classic()

#* Use bootstrapping to calculate 95% confidence intervals for the number
#* of species in each abundance class


#%----------------------------------------------------------------------------#
#% INDICES OF DIVERSITY SUMMARY ----------------------------------------------#
#* Calculate abundance per site from BCI count data
site_abund <- as.data.frame(rowSums(BCI))
names(abund) <- "site_abundunce"

#* Calculate species richness per site
site_rich <- as.data.frame(rowSums(BCI > 0))
names(site_rich) <- "site_richness"

#* Calculate Shannon diversity per site
p_i <- BCI / rowSums(BCI)
site_shan <- -rowSums(p_i * log(p_i), na.rm = TRUE)
site_shan <- data.frame(sites = names(site_shan),
                        sh = as.numeric(site_shan))

#* Calculate Simpson diversity per site
site_simp <- 1 - rowSums(p_i^2, na.rm = TRUE)
site_simp <- data.frame(sites = names(site_simp),
                         simp = as.numeric(site_simp))

#* Calculate Chao1 for each site
site_chao1 <- rowSums(BCI > 0) +
                  ((rowSums(BCI == 1) * (rowSums(BCI == 1) - 1)) /
                      (2 * (rowSums(BCI == 2) + 1)))
site_chao1 <- data.frame(sites = names(site_chao1),
                         chao1 = as.numeric(site_chao1))

#* Calculate difference between Chao1 and observed richness
site_chao_diff <- data.frame(sites = rownames(site_chao1),
                             site_chao1$chao1 - site_rich$site_richness)

#* Function wrapper
calculate_diversity_measures <- function(count_data) {
  # Calculate abundance per site
  site_abund <- as.data.frame(rowSums(count_data))
  site_abund <- data.frame(sites = rownames(site_abund), abundance = site_abund[,1])
  
  # Calculate species richness per site
  site_rich <- as.data.frame(rowSums(count_data > 0))
  site_rich <- data.frame(sites = rownames(site_rich), richness = site_rich[,1])

  # Calculate Shannon diversity per site
  p_i <- count_data / rowSums(count_data)
  site_shan <- -rowSums(p_i * log(p_i), na.rm = TRUE)
  site_shan <- data.frame(sites = rownames(count_data), shannon = as.numeric(site_shan))

  # Calculate Simpson diversity per site
  site_simp <- 1 - rowSums(p_i^2, na.rm = TRUE)
  site_simp <- data.frame(sites = rownames(count_data), simpson = as.numeric(site_simp))

  # Calculate Chao1 for each site
  site_chao1 <- rowSums(count_data > 0) +
    ((rowSums(count_data == 1) * (rowSums(count_data == 1) - 1)) /
       (2 * (rowSums(count_data == 2) + 1)))
  site_chao1 <- data.frame(sites = rownames(count_data), chao1 = as.numeric(site_chao1))

  # Calculate difference between Chao1 and observed richness
  site_chao_diff <- data.frame(sites = rownames(count_data),
                               chao_diff = site_chao1$chao1 - site_rich$richness)

  # Combine all data frames into a single data frame
  diversity_measures <- Reduce(function(x, y) merge(x, y, by = "sites", all = TRUE),
                               list(site_abund, site_rich, site_shan, site_simp, site_chao1, site_chao_diff))

  # Return the resulting data frame
  return(diversity_measures[order(diversity_measures$sites), ])
}


test <- calculate_diversity_measures(BCI)
