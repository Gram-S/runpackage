# Various functions for organizing runpackage.R

# Time
get.time <- function(){
  return(format(Sys.time(), "%b-%d-%Y at %X"))
}

# Append
path.to.new.file <- function(directory, filename){
  return(paste(directory, "/", filename, sep=""))
}

# Run immediately before you start a function, these functions allow for live time updates
docu.start <- function(path.to.file, func.name){
  txt.from.file <- readLines(path.to.file)
  newline <- paste("\n", get.time(), "Running", func.name)
  write.me <- c(txt.from.file, newline) # Add the new line to the text
  writeLines(write.me, path.to.file)
}

# Run immediately after a function stops
docu.end <- function(path.to.file, func.name){
  txt.from.file <- readLines(path.to.file)
  newline <- paste(get.time(), "Finished", func.name)
  write.me <- c(txt.from.file, newline) # Add the new line to the text
  writeLines(write.me, path.to.file)
}

query.continue <- function(...){
  cat(...)
  answer = readline()
  continue <- answer %in% c("Yes", "yes", "y")
  if(!continue) stop("User did not affirm. Code Terminated")
}