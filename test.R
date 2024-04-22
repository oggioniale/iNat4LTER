# import excel table ----
LTER_Italy_Sites_DEIMS_iNat <- readxl::read_excel("LTER_Italy_Sites_DEIMS_iNat.xlsx") |>
  dplyr::filter(
    !is.na(iNat_obs) & iNat_obs >= 100
  )

# download observations from all LTER-Italy iNat projects ----
iNatObsLTERSite <- lapply(1:nrow(LTER_Italy_Sites_DEIMS_iNat), function(i){
  proj_alias <- stringr::str_replace(
    LTER_Italy_Sites_DEIMS_iNat$iNaturalist_link[i],
    'https://www.inaturalist.org/projects/(.*?)',
    '\\1'
  )
  iNat_project_info <- rinat::get_inat_obs_project(
    proj_alias,
    type = "info",
    raw = TRUE
  )
  obs_iNat_project <- rinat::get_inat_obs_project(
    proj_alias,
    type = "observations",
    raw = TRUE
  ) |>
    dplyr::mutate(
      info_title_proj = iNat_project_info$title,
      info_slug_proj = iNat_project_info$slug,
      info_taxa_num_proj = iNat_project_info$taxa_count,
      info_place_uuid_proj = iNat_project_info$raw$rule_place$uuid,
      LTER_site_type = LTER_Italy_Sites_DEIMS_iNat$Category[i]
    )
}) |> dplyr::bind_rows()
