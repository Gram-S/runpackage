# This is a skeleton script for running the R package PTMsToPathways. Please run this file using Rscript in the terminal 

# The data folder requires:
      #* ptmtable.rda
      #* [add more]

# The sources folder is optional, but having it will allow you to view the source code of the functions and how much time they take rather then their subfuctions, so it's highly recommended

# The log folder (formatted mm-dd-yyyy at [time]) will have: 
      #* Env_Image.rda | A snapshot of the global enviroment at the time this script ends which includes every object created in the functions
      #* Pr_Output.txt | The "natural" output of every print statement in the functions. (This will NOT include things output with "message" function)
      #* Progress.txt | A file that updates in real time as the code progresses. The last line is what the script is currently doing. Please check this to check the progress
      #* profile      | An output if the html widget is disabled
      #* profile.html | The output of the R profiler for all operations done. Please view this

# For organizational purposes, some commonly used functions are in the helpers file
try({sink()}) # If code exits with error this can mess up the console
if(tail(strsplit(getwd(), split="/")[[1]], n=1) != "runpackage") stop(paste("Your current directory is ", getwd(), "Please set your working directory to 'runpackage' (the folder this script was ran in)")) # Error catch
message('Sourcing helper and body...')
source("helpers.R")
source('body.R')

# Error catch for dependencies so that the code does not stop after 5 days because a package wasn't loaded
message('Checking and librarying dependencies...')
dependencies <-  c("profvis", "igraph", "plyr", "purrr", "Rtsne", "vegan", "dplyr", "utils", "BiocManager", "STRINGdb", "RCy3")
required.dependencies <- setdiff(dependencies, rownames(installed.packages()))
if(length(required.dependencies) >= 1) stop(cat("The following packages have not been found: ", required.dependencies, "Note: STRINGdb and RCy3 must be installed with BiocManager.")) 
lapply(dependencies, library, character.only=TRUE)

# Source every function in the PTMsToPathways package
message('Attempting to clone package...')
system(" 
       Rscript -e 'options(keep.source=TRUE)' 
       rm -rf PTMsToPathways
       git clone https://github.com/UM-Applied-Algorithms-Lab/PTMsToPathways
       ")
cat('Sourcing file functions...', '\n', '  Unsourced files: ', '\n')
for(x in list.files('PTMsToPathways/R', full.name=TRUE)) tryCatch({source(x)}, error=function(y){cat('   ', '-', x, 'not sourcable', '\n')}) # This should be a sapply function but apply is being mean to me today :(
#query.continue('\n You can continue without sourcing these files, but the profiler will not be able to analyze the source code of those files. Continue? (yes/no)')

# Create a logs folder and populate
logs.directory <- paste("log", get.time())
message(paste('Initilizing log directory:', logs.directory))
if(dir.exists(logs.directory)) stop(paste(logs.directory, 'already exists! Please wait a few seconds and retry this script.'))
dir.create(logs.directory)
setwd(logs.directory)
progress.file <- file.create("Progress.txt")
assign.docu.path("Progress.txt")
sink(file="Pr_Output.txt")
# Objects.rda & profile.html must be created at the end of file




# Running the profiler over the code in the body file
message('Started running package!')
cat("Started running package at ", get.time(), "\n") # For sink
docu.write(paste("Started running package!", "\n", "\n"))
try({myprofile <- profvis({runme()}, prof_output = "profile")}) #TOTAL TIME -> 
docu.write(paste("Finished running package!"))



# Save Global Enviroment to a file
save.image(file="Env_Image.rda")
try({htmlwidgets::saveWidget(myprofile, logs.directory, "profile.html")}) # Doesn't work if running script from terminal

# Cleanup
setwd('..')
sink() # DO NOT FORGET
cat("Log file:" , logs.directory, '\n')
