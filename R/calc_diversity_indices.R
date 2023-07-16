#' Calculate biodiversity summary indices from count data
#'
#' @param data A data frame of count data,
#'              with sites as rows and species as columns.
#'
#' @return A data frame with sites as rows and diversity indices as columns.
#'          The columns are: abundance,
#'                           species richness,
#'                           Shannon diveristy index,
#'                           Simpson diversity index,
#'                           Chao1,
#'                           Difference between Choa1 and species richness.
#' @export
#'
#' @examples
#' ind <- calc_diversity_indices(BCI)
calc_diversity_indices <- function(data) {
    #* Calculate abundance per site
    abund <- as.data.frame(rowSums(data))
    abund <- data.frame(sites = rownames(abund),
                        abundance = abund[, 1])

    #* Calculate species richness per site
    richness <- as.data.frame(rowSums(data > 0))
    richness <- data.frame(sites = rownames(richness),
                           richness = richness[, 1])

    #* Calculate Shannon diversity per site
    p_i <- data / rowSums(data)
    sh <- -rowSums(p_i * log(p_i), na.rm = TRUE)
    sh <- data.frame(sites = rownames(data),
                     shannon = as.numeric(sh))

    #* Calculate Simpson diversity per site
    simp <- 1 - rowSums(p_i ^ 2, na.rm = TRUE)
    simp <- data.frame(sites = rownames(data),
                       simpson = as.numeric(simp))

    #* Calculate Chao1 for each site
    chao1 <- rowSums(data > 0) +
        ((rowSums(data == 1) * (rowSums(data == 1) - 1)) /
        (2 * (rowSums(data == 2) + 1)))
    chao1 <- data.frame(sites = rownames(data), 
                        chao1 = as.numeric(chao1))

    #* Calculate difference between Chao1 and observed richness
    chao_diff <- data.frame(sites = rownames(data),
                            chao_diff = chao1$chao1 - richness$richness)

    #* Combine all data frames into a single data frame
    div_indices <- Reduce(function(x, y) merge(x, y, by = "sites", all = TRUE),
                          list(abund, richness, sh, simp, chao1, chao_diff))

    #* Return the resulting data frame
    return(div_indices)
}
