runme <- function(){
  
  # Assign the databases
  ptmtable.name <- load("../PTMsToPathways/data/ptmtable.rda")
  #ptmtable.name <- load("../PTMsToPathways/data/ex_full_ptm_table.rda")
  ptmtable <- get(ptmtable.name)
  #bioplanet.name <- load("data/bioplanet.csv", verbose=TRUE)
  #bioplanet <- get(bioplanet.name)
  
  
  # Run the functions
  MCN.input <- docu.func(MakeClusterList, ptmtable)
  
  docu.func(MakeCorrelationNetwork, MCN.input[[2]], MCN.input[[3]])
  #docu.func(GetSTRINGdb, gene.cccn)
  
  
}