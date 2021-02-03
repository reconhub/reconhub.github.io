
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
#' @param x one line of membership tibble
#'
#' @param add_missing_pic a logical indicating if a default 'anonymous' pic
#'   should be created to replace missing photos

make_member_yaml <- function(x, add_missing_pic = TRUE) {

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
    if (add_missing_pic) {
      file.copy("../img/people/anonymous.jpg", path_to_pic)
    }
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
#'
#' @param add_missing_pic a logical indicating if a default 'anonymous' pic
#'   should be created to replace missing photos

generate_members_data <- function(add_missing_pic = TRUE) {
  ## Read data from google spreadsheet
  sheet <- import_memberships()

  ## Reorder data
  sheet <- dplyr::arrange(sheet, "Last name", "First name")

  ## Generate entries for all members
  list_entries <- lapply(seq_len(nrow(sheet)),
                         function(i)
                           make_member_yaml(sheet[i, ], add_missing_pic))
  all_entries <- unlist(list_entries)

  out <- c("people-list:", all_entries)
  out <- gsub("[.],", ",", out)
  out <- gsub(" NA,", "", out)
  out
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
