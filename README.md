# keggR

A tool to parse the results of BLAST/DIAMOND similarity searches made against the KEGG GENES prokaryotes database.  
Distributed under the terms of the GNU AGPL v3 <<https://www.gnu.org/licenses/agpl.html>>.

Version: 0.9.1  
Author: Igor S. Pessi  
E-mail: igor.pessi@gmail.com

## Installing

    library("devtools")
    install_github("igorspp/keggR")

## Usage example

### Load required packages

    library("tidyverse")
    library("keggR")

### Format the KEGG auxiliary data

The first step is to run *formatKEGG()* to format the KEGG auxiliary files.  
**[COMING UP, NOT YET IMPLEMENTED]**.

### Load KEGG auxiliary data

Then we load the formatted auxiliary files.  
For this, you need to run *loadKEGG()* giving the path to where the formatted files are located:

    loadKEGG("~/KEGG")

    ## Reading PROKARYOTES.DAT
    ## Reading KO00000
    ## Reading KO00001
    ## Reading KO00002

### Read BLAST results

The primary input for keggR is a BLAST/DIAMOND output table in the tabular format (outfmt 6).  
The BLAST table can be filtered based on an evalue threshold by passing the EVALUE argument (default EVALUE = 0, i.e. no filtering is done).  

    blast <- readBlast("examples/input_data.txt")

    blast

    ## # A tibble: 1,000 x 3
    ##    sequence target             evalue
    ##    <chr>    <chr>              <chr>  
    ##  1 read_1   gsu:GSU2105        1.7e-13
    ##  2 read_2   pla:Plav_0247      5.1e-18
    ##  3 read_5   mbry:B1812_20795   2.4e-15
    ##  4 read_6   aey:CDG81_18260    1.2e-11
    ##  5 read_7   amv:ACMV_04450     8.4e-21
    ##  6 read_11  pcu:pc0030         1.6e-19
    ##  7 read_14  slp:Slip_0435      1.2e-11
    ##  8 read_16  pht:BLM14_09585    5.3e-28
    ##  9 read_17  bic:LMTR13_36750   8.1e-24
    ## 10 read_18  vgo:GJW-30_1_03888 2.1e-11
    ## # … with 990 more rows

### Assign KOs

Now we use *assignKEGG()* to assign KO identifiers and gene names to the sequences.

    KOtable <- blast %>%
      assignKEGG

    KOtable

    ## # A tibble: 559 x 4
    ##    sequence  evalue  KO     gene                                                                             
    ##    <chr>     <chr>   <chr>  <chr>                                                                            
    ##  1 read_1    1.7e-13 K01338 lon; ATP-dependent Lon protease                                                  
    ##  2 read_561  6.6e-18 K01338 lon; ATP-dependent Lon protease                                                  
    ##  3 read_2    5.1e-18 K13894 yejB; microcin C transport system permease protein                               
    ##  4 read_11   1.6e-19 K04077 groEL, HSPD1; chaperonin GroEL                                                   
    ##  5 read_222  6e-11   K04077 groEL, HSPD1; chaperonin GroEL                                                   
    ##  6 read_14   1.2e-11 K06442 tlyA; 23S rRNA (cytidine1920-2'-O)/16S rRNA (cytidine1409-2'-O)-methyltransferase
    ##  7 read_16   5.3e-28 K03046 rpoC; DNA-directed RNA polymerase subunit beta'                                  
    ##  8 read_651  2.6e-14 K03046 rpoC; DNA-directed RNA polymerase subunit beta'                                  
    ##  9 read_1562 4.4e-22 K03046 rpoC; DNA-directed RNA polymerase subunit beta'                                  
    ## 10 read_1602 5.3e-15 K03046 rpoC; DNA-directed RNA polymerase subunit beta'                                  
    ## # … with 549 more rows

### Summarise pathways and modules

And now we can summarise the pathways and modules found with *summariseKEGG*.
Here, if a sequence has more than one hit, the one with the lowest evalue will be used.
It is a good idea to use MinPath (https://omics.informatics.indiana.edu/MinPath) to remove spurious pathways.  
For this you need to pass the directory where MinPath is installed.

    summary <- KOtable %>%
      summariseKEGG("~/bin/MinPath")

The output of *summariseKEGG* is a list.
To access the summaries, for example for pathways summarised at the level 3, we do:

    summary$pathways$level3

    ## # A tibble: 71 x 4
    ##    level1                               level2                           level3                                     count
    ##    <chr>                                <chr>                            <chr>                                      <int>
    ##  1 Cellular Processes                   Cell growth and death            04112 Cell cycle - Caulobacter                 9
    ##  2 Cellular Processes                   Cellular community - prokaryotes 02024 Quorum sensing                          27
    ##  3 Cellular Processes                   Cellular community - prokaryotes 02026 Biofilm formation - Escherichia coli     3
    ##  4 Cellular Processes                   Cellular community - prokaryotes 05111 Biofilm formation - Vibrio cholerae      5
    ##  5 Cellular Processes                   Transport and catabolism         04146 Peroxisome                               7
    ##  6 Environmental Information Processing Membrane transport               02010 ABC transporters                        23
    ##  7 Environmental Information Processing Membrane transport               02060 Phosphotransferase system (PTS)          2
    ##  8 Environmental Information Processing Membrane transport               03070 Bacterial secretion system               4
    ##  9 Environmental Information Processing Signal transduction              02020 Two-component system                    24
    ## 10 Genetic Information Processing       Folding, sorting and degradation 03018 RNA degradation                          9
    ## # … with 61 more rows

Or for modules summarised at the level 4:

    summary$modules$level4

    ## # A tibble: 102 x 5
    ##    level1         level2                               level3                          level4                                                                     count
    ##    <chr>          <chr>                                <chr>                           <chr>                                                                      <int>
    ##  1 Functional set Environmental information processing Drug efflux transporter/pump    M00646 Multidrug resistance, efflux pump AcrAD-TolC                            2
    ##  2 Functional set Environmental information processing Drug efflux transporter/pump    M00648 Multidrug resistance, efflux pump MdtABC                                1
    ##  3 Functional set Environmental information processing Drug efflux transporter/pump    M00701 Multidrug resistance, efflux pump EmrAB                                 2
    ##  4 Functional set Environmental information processing Drug resistance                 M00628 beta-Lactam resistance, AmpC system                                     1
    ##  5 Functional set Environmental information processing Drug resistance                 M00742 Aminoglycoside resistance, protease FtsH                                3
    ##  6 Functional set Environmental information processing Two-component regulatory system M00452 CusS-CusR (copper tolerance) two-component regulatory system            1
    ##  7 Functional set Environmental information processing Two-component regulatory system M00454 KdpD-KdpE (potassium transport) two-component regulatory system         1
    ##  8 Functional set Environmental information processing Two-component regulatory system M00506 CheA-CheYBV (chemotaxis) two-component regulatory system                1
    ##  9 Functional set Environmental information processing Two-component regulatory system M00512 CckA-CtrA/CpdR (cell cycle control) two-component regulatory system     2
    ## 10 Functional set Metabolism                           Aminoacyl tRNA                  M00359 Aminoacyl-tRNA biosynthesis, eukaryotes                                16
    ## # … with 92 more rows

### Plot examples

    summary$modules$level4 %>%
      ggplot(aes(x = level4, y = count)) +
      geom_bar(stat="identity") +
      facet_grid("level2", scales = "free", space = "free") +
      theme(strip.text = element_blank()) +
      coord_flip()

![](examples/Rplot.png)
