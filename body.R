runme <- function(){
  
  # Assign the databases
  ptmtable.name <- load("data/ptmtable.rda", verbose=TRUE)
  ptmtable <- get(ptmtable.name)
  #bioplanet.name <- load("data/bioplanet.csv", verbose=TRUE)
  #bioplanet <- get(bioplanet.name)
  
  
  # Run the functions
  docu.func(MakeClusterList, ptmtable)
  docu.func(MakeCorrelationNetwork, common.clusters, ptm.correlation.matrix)
  
  #GetSTRINGdb(gene.cccn)
  
  
}