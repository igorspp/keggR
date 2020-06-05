library("tidyverse")
library("keggR")

# Load KEGG auxiliary data
loadKEGG("~/KEGG/")

# Read BLAST results
blast <- readBlast("examples/input_data.txt")

blast

# Assign KOs
KOtable <- blast %>%
  assignKEGG

KOtable

# Summarise pathways and modules
summary <- KOtable %>%
  summariseKEGG("~/bin/MinPath")

# Get summaries
summary$pathways$level3
summary$modules$level4

# Plot examples
summary$modules$level4 %>%
  ggplot(aes(x = level4, y = count)) +
  geom_bar(stat="identity") +
  facet_grid("level2", scales = "free", space = "free") +
  theme(strip.text = element_blank()) +
  coord_flip()
