# Various functions for organizing runpackage.R

# Time
get.time <- function(){
  return(format(Sys.time(), "%b-%d-%Y at %X"))
}

# Append
path.to.new.file <- function(directory, filename){
  return(paste(directory, "/", filename, sep=""))
}


# Assign path
assign.docu.path <- function(path){
  assign("docu.path", path, envir = .GlobalEnv)
}

# Function to write to an assigned path
docu.write <- function(write){
  if(!exists("docu.path")) stop('No path assigned. Please assign first using assign.docu.path')
  txt.from.file <- readLines(docu.path)
  newline <- paste("\n", write)
  write.me <- c(txt.from.file, newline)
  writeLines(write.me, docu.path)
}

# Function to get the name of another function
f.name <- function(func){
  return(as.character(substitute(func)))
}

# Better version of docu start and end
docu.func <- function(func, ...){
  func.name <- f.name(func)
  docu.write(docu.path, paste("\n", get.time(), "Running", func.name))
  func(...)
  docu.write(docu.path, paste(get.time(), "Finished", func.name))
}

query.continue <- function(...){
  cat(...)
  answer = readline()
  continue <- answer %in% c("Yes", "yes", "y")
  if(!continue) stop("User did not affirm. Code Terminated")
}