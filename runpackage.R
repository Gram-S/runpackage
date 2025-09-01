# This is a skeleton script for running the R package PTMsToPathways. Please run this file using Rscript in the terminal 

# The data folder requires:
      #* ptmtable.rda
      #* [add more]

# The log folder (formatted mm-dd-yyyy at [time]) will have: 
      #* Env_Image.rda | A snapshot of the global enviroment at the time this script ends which includes every object created in the functions
      #* Pr_Output.txt | The "natural" output of every print statement in the functions. (This will NOT include things output with "message" function)
      #* Progress.txt | A file that updates in real time as the code progresses. The last line is what the script is currently doing. Please check this to check the progress
      #* PTMsTP_Profile | The output of the R profiler for all operations done. Can be viewed with the command: [profvis::profvis(prof_input = "logs/PTMsTP_profile")]


# For organizational purposes, some commonly used functions are in the helpers file
source("helpers.R")

# Error catch for dependencies so that the code does not stop after 5 days because a package wasn't loaded
dependencies <-  c("PTMsToPathways", "igraph", "plyr", "purrr", "Rtsne", "vegan", "dplyr", "utils", "BiocManager", "STRINGdb", "RCy3")
required.dependencies <- setdiff(dependencies, rownames(installed.packages()))
if(length(required.dependencies) >= 1) stop(cat("The following packages have not been found: ", required.dependencies, "Note: STRINGdb and RCy3 must be installed with BiocManager.")) 
lapply(dependencies, library, character.only=TRUE)

# Create a logs folder and get ready populate
logs.directory <- paste("log", get.time())
if(!dir.exists(logs.directory)) dir.create(logs.directory)
path <- path.to.new.file(logs.directory, "Progress.txt")
progress.file <- file.create(path) # File will ONLY be written after code is complete
sink(file=path.to.new.file(logs.directory, "Pr_Output.txt"))
# Objects.rda & PTMsTP_Profile must be created at the end of file

# Initilize Databases
ptmtable.name <- load("data/ptmtable.rda", verbose=TRUE)
# ptmtable <- get(ptmtable.name) #This is how you get a varible regardless of name
#bioplanet.name <- load("TO DO", verbose=TRUE)





# Running the profiler over the code
profvis::profvis({
  {
    docu.start(path, "MakeClusterList")
    MakeClusterList(get(ptmtable.name))
    docu.end(path, "MakeClusterList")
  }
}, prof_output = path.to.new.file(logs.directory, "PTMsTP_profile"))










# Save Global Enviroment to a file
save.image(file=path.to.new.file(logs.directory, "Env_Image.rda"))

# Cleanup
sink() # DO NOT FORGET
rm("docu.start", "docu.end", "get.time", "path.to.new.file")