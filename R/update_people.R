
## We handle dependencies here (there's most likely better ways to do this but
## whatever)

if (!require(googlesheets4)) {
  install.packages("googlesheets4")
}

if (!require(dplyr)) {
  install.packages("dplyr")
}

if (!require(stringi)) {
  install.packages("stringi")
}


## Some functions for capitalization of names
### Atomic version
simple_cap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1, 1)), tolower(substring(s, 2)),
        sep = "", collapse = " ")
}

### vectorised version
capitalize <- function(x) unname(vapply(x, simple_cap, character(1)))

## Function to enforce ascii characters
enforce_ascii <- function(x) {
  x <- as.character(x)
  transformation  <- "Any-Latin; Latin-ASCII"
  stringi::stri_trans_general(x, id = transformation)
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

make_member_yaml <- function(x, add_missing_pic = FALSE) {

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
  out <- c(out, img_txt)

  ## if image does not exist, copy the anonymous pic by default
  path_to_pic <- sub("^[ ]*img: ", "", img_txt)
  path_to_pic <- paste0("..", path_to_pic)

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
  description <- paste0("    desc: ", x["position"])

  if (!is.na(x["Institution"])) {
    institution <- paste0(" ", x["Institution"], collapse = "")
  } else {
    institution <- ""
  }

  if (!is.na(x["Country"])) {
    country <- paste0(" ", x["Country"], ".", collapse = "")
  } else {
    country <- "."
  }
  description <- paste0(description, institution, country, collapse = "")
  out <- c(out, description)
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
  twit <- x["twitter"]
  if (!is.na(twit)) {
    twit <- gsub("https://twitter.com/", "", twit, fixed = TRUE)
    twit <- gsub("http://twitter.com/", "", twit, fixed = TRUE)
    twit <- gsub("twitter.com/", "", twit, fixed = TRUE)
    twit <- gsub("@", "", twit, fixed = TRUE)
    twit <- paste0("https://twitter.com/", twit)
    out <- c(out, paste0("    twitter: ", twit))
    if (is.na(x["website"]) && is.na(x["github"])) {
      out <- c(out, paste0("    url: ", twit))
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

generate_members_data <- function(add_missing_pic = FALSE) {
  ## Read data from google spreadsheet
  sheet <- import_memberships()

  ## Reorder data
  sheet <- dplyr::arrange(sheet, "Last name", "First name")

  ## Make sure capitalization is consistent across entries
  sheet <- dplyr::mutate(sheet,
                         "First name" = enforce_ascii(`First name`),
                         "First name" = capitalize(`First name`),
                         "Last name" = enforce_ascii(`Last name`),
                         "Last name" = capitalize(`Last name`))
                    
  ## handle duplicates; only the most recent one is kept
  sheet <- dplyr::mutate(sheet, name = paste(`First name`, `Last name`, sep = "_"))
  sheet <- dplyr::arrange(sheet, desc(Timestamp))
  sheet <- dplyr::filter(sheet, !duplicated(name))

  ## Ensure alphabetic order
  sheet <- dplyr::arrange(sheet, `Last name`, `First name`)
  
  ## Generate entries for all members
  list_entries <- lapply(seq_len(nrow(sheet)),
                         function(i)
                           make_member_yaml(sheet[i, ], add_missing_pic))
  all_entries <- unlist(list_entries)

  out <- c("members:", all_entries)
  out <- gsub("\\.\\.+", "\\.", out)
  out <- gsub("[.],", ",", out)
  out <- gsub(" NA,", "", out)
  out
}






#' This function generates a new, updated people.md
#'
#' The function will read the current people.md file, import membership data,
#' generate entries for all members in the registration spreadsheet, and insert
#' these new data in the 'people-list' section in a new, updated people.md
#' file. Note that if unsure, you can specify an alternative output file, so
#' that you can compare the old and new version to make sure nothing got
#' lost. In particular, make sure all members are recorded in the registration
#' spreadsheet, as only these will be present in the updated version. The
#' following additional changes are also made when processing entries of the
#' registration form: i) capitalisation of names is enforced (upper casde for
#' first letter, lower case for others) ii) names are converted to ASCII
#' characters (including for the path to photo files) iii) optionally, generic
#' 'anonymous' photos are placed in the right folder if the photo file is
#' missing (see argument `add_missing_pic`).
#'
#' @param in_file the file to be used as input, defaults to `people.md`
#'
#' @param out_file the file to be used as output, defaults to the same as
#'   `in_file` in which case the input file will be replaced by the new version.
#'
#' @param add_missing_pic a logical indicating if a default 'anonymous' pic
#'   should be created to replace missing photos
#'
#' @author Thibaut Jombart

update_people_file <- function(in_file = "../people.md",
                               out_file = in_file,
                               add_missing_pic = FALSE) {

  current_content <- suppressWarnings(readLines(in_file))
  head_stop <- grep("^members:", current_content)[1] - 1
  tail_start <- tail(grep("---", current_content), 1)
  members_entries <- generate_members_data(add_missing_pic)

  out <- c(
    current_content[1:head_stop],
    members_entries,
    current_content[tail_start:length(current_content)]
  )

  cat("\n\n *** Create updated file:", out_file, "***\n")
  cat(out, file = out_file, sep = "\n")
  return(invisible(out))
}
