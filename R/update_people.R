
## We handle dependencies here (there's most likely better ways to do this but
## whatever)

if (!require(googlesheets4)) {
  install.packages("googlesheets4")
}

if (!require(dplyr)) {
  install.packages("dplyr")
}





#' Import member data from registration spreadsheet
#'
#' This function imports data on members of RECON from the google
#' spreadsheet. It returns a `tibble`, keeping only non-rejected members.

import_memberships <- function() {
  url <- "https://docs.google.com/spreadsheets/d/16sEx6mPoFpmL53j2DXP1SXyzztaYdGlVh29VYS6ahRU/edit#gid=983075176"
  out <- googlesheets4::read_sheet(url)
  accepted <- c("regular member", "contributing member")
  dplyr::filter(out, `Board decision` %in% accepted)
}





#' Generate yaml entries for one member
#'
#' This function will generate a yaml entry compatible with the people.md file
#' for a single member. Its argument is a single-row tibble matching the
#' structure of the output of `import_memberships`. The output is a character
#' vector which can be fed to `cat()` when creating the new `people.md` file.
#'

make_member_yaml <- function(x) {

  # Some columns are renamed for convenience
  x <- dplyr::rename(x,
                     position = "Position and expertise (short)",
                     twitter = "Twitter account (full address)",
                     github = "Github account (full address)",
                     website = "Website")

  
  # Output is built incrementally
  ## name
  out <- paste("  - name:", x["First name"], x["Last name"], sep = " ")

  ## image
  img_txt <- tolower(paste0("    img: /img/people/",
                            gsub(" ", "-", x["First name"]),
                            "-",
                            gsub(" ", "-",  x["Last name"]),
                            ".jpg"))
  img_txt <- gsub("&ouml;", "o", img_txt)

  out <- c(out, img_txt)

  ## if image does not exist, copy the anonymous pic by default
  path_to_pic <- sub("^[ ]*img: ", "", img_txt)

  ## handle non ascii characters like ö
  path_to_pic <- gsub("&ouml;", "o", path_to_pic)

  if (!file.exists(path_to_pic)) {
    warning("Picture file ", path_to_pic, " is missing")
  }

  ## description
  x["position"] <- sub("[.]+$", ".", paste(x["position"], ".", collapse = "", sep = ""))
  x["position"] <- gsub(":", ",", x["position"])
  x["Institution"] <- gsub(":", ",", x["Institution"])
  x["Country"] <- gsub(":", ",", x["Country"])
  out <- c(out, paste(
                    paste0("    desc: ",
                           x["position"]), " ",
                    x["Institution"], ", ",
                    x["Country"], ".",
                    collapse = "", sep = ""))
  out[3] <- gsub("[ ]+,", ",", out[3])

  ## website
  if (!is.na(x["website"])) {
    out <- c(out, paste0("    website: ", x["website"]))
    out <- c(out, paste0("    url: ", x["website"]))
  }

  ## github
  if (!is.na(x["github"])) {
    out <- c(out, paste0("    github: ", x["github"]))
    if (is.na(x$website)) {
      out <- c(out, paste0("    url: ", x["github"]))
    }
  }

  ## twitter
  if (!is.na(x["twitter"])) {
    out <- c(out, paste0("    twitter: ", x["twitter"]))
    if (is.na(x["website"]) && is.na(x["github"])) {
      out <- c(out, paste0("    url: ", x["twitter"]))
    }
  }

  return(out)
}





#' Generate yaml info for all members
#'
#' This function will read membership data and generate entries for every
#' members in a format compatible with the header of `people.md`.The output is a
#' character vector which can be fed to `cat()` when creating the new
#' `people.md` file.

generate_members_data <- function() {
  ## Read data from google spreadsheet
  sheet <- import_memberships()

  ## Reorder data
  sheet <- dplyr::arrange(sheet, "Last name", "First name")

  ## Generate entries for all members
  list_entries <- lapply(seq_len(nrow(sheet)), function(i) make_member_yaml(sheet[i, ]))
  all_entries <- unlist(list_entries)

  out <- c("people-list:", all_entries)
  out <- gsub("[.],", ",", out)
  out <- gsub(" NA,", "", out)
  out
}





read.registrations <- function(title = "Registrations", quiet=FALSE){
  if (!require("googlesheets")) {
    install.packages("googlesheets")
    if (!require("googlesheets")) {
      stop("googlesheets is not present and cannot be installed")
    }
  }

  tib <- gs_read(gs_title(title))
  tib <- as.data.frame(tib)

  ## Processing of the tibble: we need to ensure lower case for the column
  ## names, and to sort

  ## the entries as follows:
  ## 1st: Jombart
  ## rest: alphabetically after the last name

  names(tib) <- tolower(names(tib))
  lastnames <- tolower(tib[, 3])
  firstnames <- tolower(tib[, 2])
  fullnames <- paste(lastnames, firstnames, sep = "_")
  tj <- "jombart_thibaut"
  rownames(tib) <- fullnames

  id.tj <- grep(tj, fullnames)
  if (length(id.tj > 0)) {
    order <- c(tj, sort(setdiff(fullnames, tj)))
  } else {
    order <- order(fullnames)
  }

  tib <- tib[order, ]

  ## The output will be the 'people-list:' item from the header of the .md
  ## file. We make a character vector, each item being a separate line in the
  ## output. The function 'read.one' will read one record and shape it into
  ## the relevant characters.

  out <- "people-list:"

  read.one <- function(x){

    ## name
    out <- paste("  - name:", x[2], x[3], sep=" ")

    ## image
    img.txt <- tolower(paste0("    img: /img/people/",
                              gsub(" ", "-", x[2]),
                              "-",
                              gsub(" ", "-",  x[3]),
                              ".jpg"))
    img.txt <- gsub("&ouml;", "o", img.txt)

    out <- c(out, img.txt)

    ## if image does not exist, copy the anonymous pic by default
    path_to_pic <- tolower(paste0("../img/people/",
                                  gsub(" ", "-", x[2]), "-",
                                  gsub(" ", "-",  x[3]),
                                  ".jpg"))

    ## handle non ascii characters like ö
    path_to_pic <- gsub("&ouml;", "o", path_to_pic)

    if (!file.exists(path_to_pic)) {
      message("file ", path_to_pic, " does not exist - using default picture")
      file.copy("../img/people/anonymous.jpg", path_to_pic)
    }

    ## description
    x[6] <- sub("[.]+$", ".", paste(x[6], ".", collapse="", sep=""))
    x[6] <- gsub(":", ",", x[6])
    x[7] <- gsub(":", ",", x[7])
    x[8] <- gsub(":", ",", x[8])
    out <- c(out, paste(
      paste0("    desc: ", x[6]), " ", x[7], ", ", x[8], ".", collapse = "", sep = ""))

    ## website
    if (!is.na(x$website)) {
      out <- c(out, paste0("    website: ", x$website))
      out <- c(out, paste0("    url: ", x$website))
    }

    ## github
    if (!is.na(x$github)) {
      out <- c(out, paste0("    github: ", x$github))
      if (is.na(x$website)) {
        out <- c(out, paste0("    url: ", x$github))
      }
    }

    ## twitter
    if (!is.na(x$twitter)) {
      out <- c(out, paste0("    twitter: ", x$twitter))
      if (is.na(x$website) && is.na(x$github)) {
        out <- c(out, paste0("    url: ", x$twitter))
      }
    }

    return(out)
  }

  ## generate output - one item per row
  out <- c(out, unlist(lapply(seq_len(nrow(tib)), function(i) read.one(tib[i, ]))))
  out <- gsub("[.],", ",", out)
  out <- gsub(" NA,", "", out)

  if (!quiet) {
    cat("\n\n\n *** Copy-paste the following into people.md's header ***\n",
        out, "\n\n", sep="\n")
  }
  return(invisible(out))

}





## This function generates a new, updated people.md
update.people <- function(file = "../people.md", input = file, ...) {
  current <- suppressWarnings(readLines(input))
  head.stop <- grep("people-list", current)[1] - 1
  tail.start <- tail(grep("---", current), 1)
  replacement <- read.registrations(...)

  out <- c(current[1:head.stop],
           replacement,
           current[tail.start:length(current)]
           )

  cat("\n\n *** Create a new file:", file, "***\n")
  cat(out, file = file, sep = "\n")
  return(invisible(out))
}
