# This is a skeleton script for running the R package PTMsToPathways. Please run this file using Rscript in the terminal 

# The data folder requires:
      #* ptmtable.rda
      #* [add more]

# The sources folder is optional, but having it will allow you to view the source code of the functions and how much time they take rather then their subfuctions, so it's highly recommended

# The log folder (formatted mm-dd-yyyy at [time]) will have: 
      #* Env_Image.rda | A snapshot of the global enviroment at the time this script ends which includes every object created in the functions
      #* Pr_Output.txt | The "natural" output of every print statement in the functions. (This will NOT include things output with "message" function)
      #* Progress.txt | A file that updates in real time as the code progresses. The last line is what the script is currently doing. Please check this to check the progress
      #* profile.html | The output of the R profiler for all operations done. Please view this

# For organizational purposes, some commonly used functions are in the helpers file
source("helpers.R")
source('body.R')

# Error catch for dependencies so that the code does not stop after 5 days because a package wasn't loaded
dependencies <-  c("PTMsToPathways", "profvis", "igraph", "plyr", "purrr", "Rtsne", "vegan", "dplyr", "utils", "BiocManager", "STRINGdb", "RCy3")
required.dependencies <- setdiff(dependencies, rownames(installed.packages()))
if(length(required.dependencies) >= 1) stop(cat("The following packages have not been found: ", required.dependencies, "Note: STRINGdb and RCy3 must be installed with BiocManager.")) 
lapply(dependencies, library, character.only=TRUE)

# Source every function in the PTMsToPathways package
if(tail(strsplit(getwd(), split="/")[[1]], n=1) != "runpackage") stop(paste("Your current directory is ", getwd(), "Please set your working directory to 'runpackage' (the folder this script was ran in)"))
system(" 
       Rscript -e 'options(keep.source=TRUE)' 
       rm -rf PTMsToPathways
       git clone https://github.com/UM-Applied-Algorithms-Lab/PTMsToPathways
       ")
tryCatch({sapply(list.files('PTMsToPathways/R', full.names = TRUE), source)}, error=function(){query.continue("R directory NOT found in ", getwd(), "You can continue without this, but you will not be able to see the source code in the flame graph section of profvis. This is not recommended, continue anyways?")})

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

databases <- list(get(ptmtable.name)) #db stands for databases, requires: TO DO


# Running the profiler over the code
myprofile <- profvis({runme(databases)})




# Save Global Enviroment to a file
save.image(file=path.to.new.file(logs.directory, "Env_Image.rda"))
htmlwidgets::saveWidget(myprofile, path.to.new.file(logs.directory, "profile.html"))

# Cleanup
sink() # DO NOT FORGET
cat("Log file:" , logs.directory)
