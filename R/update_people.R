## Dependencies are defined in the renv.lock file
library(dplyr)
library(stringi)
library(airtabler)
library(yaml)
library(janitor)
library(purrr)

#' Import member data
#'
#' This function imports data on members of RECON from the AirTable Database
#' It returns a `tibble`. Note AIRTABLE_API_KEY must be set in the environment.
import_memberships <- function(base = "app8BI6aTKIuB9U9y") {
  members <- airtabler::fetch_all(base, "People", view = "Members" )
  statuses <- airtabler::fetch_all(base, "Statuses")
  names(members) <- janitor::make_clean_names(stringi::stri_trans_tolower(names(members)))
  names(statuses) <- janitor::make_clean_names(stringi::stri_trans_tolower(names(statuses)))
  members <- members |>
    mutate(membership_status = unlist(membership_status)) |>
    left_join(select(statuses, status_id = id, status_name), by = c("membership_status"="status_id")) |>
    mutate(photo_url = purrr::map_chr(photo, ~.$url[1] %||% NA_character_), photo_filename = purrr::map_chr(photo, ~.$filename[1]  %||% NA_character_)) |>
    select(id, first_name, last_name, status = status_name, position_and_expertise_short, institution, country, website, twitter, github, photo_url, photo_filename) |>
    as_tibble() |>
    mutate_if(is.character, stri_trim_both)
  members
}

# #' Fetch the profile pics of all members (not needed, as we link directly to
# #' the AirTable Source)
# download_profile_images <- function(members, fdir = "img/people") {
#   if (!dir.exists(fdir)) dir.create(fdir)
#   m2 <- members |>
#     filter(!is.na(photo_url), !is.na(photo_filename))
#   walk2(m2$photo_url, m2$photo_filename, function(furl, fname) {
#     download.file(furl, file.path(fdir, fname))
#   })
# }

#' Convert members data to YAML that will be used in
#' Removes nonallowed URLs rather than fixing, assuming fixes upstream
make_members_data <- function(members) {

  members <- members |>
    mutate(status = if_else(status %in% c("Regular member", "Contributing member"), "members", status))

  members_data <- members |>
    arrange(last_name) |>
    group_split(status) |>
    map(function(group) {
      group |>
        mutate(name = paste(first_name, last_name),
               desc = paste(position_and_expertise_short, institution, country, sep  = ", "),
               img = photo_url
        ) |>
        select(name, desc, img, website, twitter, github) |>
        mutate(across(c(website,twitter,github),
                      ~if_else(stri_detect_regex(., "^https?://"), ., NA_character_ ))) |>
        as.list() |>
        transpose() |>
        map(~discard(., is.na))
    })
  names(members_data) <- members |>
    group_by(status) |>
    group_keys() |>
    pull(status) |>
    janitor::make_clean_names()

  members_data
}

members <- import_memberships()
write_yaml(make_members_data(members), "_data/people.yaml")

