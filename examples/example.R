library("tidyverse")
library("keggR")

# Load KEGG auxiliary data
loadKEGG("~/KEGG/")

# Read BLAST results
blast <- readBlast("examples/input_data.txt")
getBlastTable(blast)

# Assign KOs
KOtable <- blast %>%
  assignKEGG

# Run MinPath
KOtable <- KOtable %>%
  runMinpath

KOtable
getKOtable(KOtable)

# Summarise
summary <- KOtable %>%
  summariseKEGG

summary
getSummary(summary, "pathways", "level3")
getSummary(summary, "modules", "level4")

# Plot examples
getSummary(summary, "modules", "level4") %>%
  ggplot(aes(x = level4, y = count)) +
  geom_bar(stat="identity") +
  facet_grid("level2", scales = "free", space = "free") +
  theme(strip.text = element_blank()) +
  coord_flip()
