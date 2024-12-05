#' Get the Current Script Path
#'
#' A function to determine the path of the currently running script.
#' @return The normalized directory path of the script.
#' @export
getCurrentPath <- function() {
    cmdArgs <- commandArgs(trailingOnly = FALSE)
    if (length(grep("^-f$", cmdArgs)) > 0) { # R console option
        normalizePath(dirname(cmdArgs[grep("^-f", cmdArgs) + 1]))[1]
    } else if (length(grep("^--file=", cmdArgs)) > 0) { # Rscript/R console option
        scriptPath <- normalizePath(dirname(sub("^--file=", "", cmdArgs[grep("^--file=", cmdArgs)])))[1]
    } else if (Sys.getenv("RSTUDIO") == "1") { # RStudio
        dirname(rstudioapi::getSourceEditorContext()$path)
    } else if (is.null(attr(stub, "srcref")) == FALSE) { # 'source'd via R console
        dirname(normalizePath(attr(attr(stub, "srcref"), "srcfile")$filename))
    } else {
        stop("Cannot find file path")
    }
}
