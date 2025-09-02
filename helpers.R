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

# Function to write a line break 
docu.linebr <- function(){
  if(!exists("docu.path")) stop('No path assigned. Please assign first using assign.docu.path')
  txt.from.file <- readLines(docu.path)
  write.me <- c(txt.from.file, '')
  writeLines(write.me, docu.path)
}

# Function to write to an assigned path
docu.write <- function(write){
  if(!exists("docu.path")) stop('No path assigned. Please assign first using assign.docu.path')
  txt.from.file <- readLines(docu.path)
  newline <- paste(get.time(), ':', write)
  write.me <- c(txt.from.file, newline)
  writeLines(write.me, docu.path)
}

# Better version of docu start and end
docu.func <- function(func, ...){
  func.name <- as.character(substitute(func))
  docu.linebr()
  docu.write(paste("Running", func.name))
  func(...)
  docu.write(paste("Finished", func.name))
}

query.continue <- function(...){
  cat(...)
  answer = readline()
  continue <- answer %in% c("Yes", "yes", "y")
  if(!continue) stop("User did not affirm. Code Terminated")
}