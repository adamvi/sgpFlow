% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createMatrices.R
\name{createMatrices}
\alias{createMatrices}
\title{Create SGP Coefficient Matrices}
\usage{
createMatrices(
  data_for_matrices,
  state = NULL,
  matrix.sgp.config,
  super_cohort.sgp.config,
  super_cohort_base_years,
  parallel.config,
  matrix_types = c("single-cohort", "super-cohort")
)
}
\arguments{
\item{data_for_matrices}{Either a `data.table` or an object of class `SGP` containing the necessary data for matrix construction. If the input is an `SGP` object, the `Data` slot will be used.}

\item{state}{A character string indicating the state for which matrices are being generated. If not provided (default) the function will attempt to determine the state from the name of the supplied `data_for_matrices`.}

\item{matrix.sgp.config}{A configuration list specifying the SGP baseline setup for generating coefficient matrices.}

\item{super_cohort.sgp.config}{A configuration list used specifically for creating super-cohort datasets. Required if `matrix_types` includes `"super-cohort"`.}

\item{super_cohort_base_years}{A character vector specifying the base years for the super-cohort analysis. If not provided, the function will use all years in the data.}

\item{parallel.config}{A configuration list for specifying parallel processing options.}

\item{matrix_types}{A character vector specifying the types of matrices to generate. Options are `"single-cohort"` and `"super-cohort"`. Default: `c("single-cohort", "super-cohort")`.}
}
\value{
A list of SGP coefficient matrices, with separate entries for each matrix type specified in `matrix_types`.
}
\description{
Generates single-cohort and super-cohort Student Growth Percentile (SGP) coefficient matrices using the provided data and configuration settings.

This function processes input data to create coefficient matrices that are essential for baseline SGP calculations. It supports both single-cohort and super-cohort analyses, based on the specified matrix types.
}
\details{
This function processes input data to generate SGP coefficient matrices for both single-cohort and super-cohort analyses. The workflow includes:
- Preparing data for SGP calculations using \code{\link[SGP]{prepareSGP}}.
- Constructing super-cohort datasets using \code{\link[SGP]{createSuperCohortData}} (if applicable).
- Generating SGP baseline matrices using \code{\link[SGP]{baselineSGP}} with the provided configuration settings.

The resulting matrices can be used for subsequent baseline SGP analyses or stored for further use.
}
\examples{
\dontrun{
if(interactive()){
  DEMO_sgpFlow_Matrices <- createMatrices(
     data_for_matrices = SGPdata::sgpData_LONG,
     state = "DEMO",
     matrix.sgp.config = DEMO_Matrix.config,
     super_cohort.sgp.config = DEMO_Super_Cohort.config,
     parallel.config=list(BACKEND = "PARALLEL", WORKERS=list(TAUS=num_cores)),
     matrix_types=c("single-cohort", "super-cohort")
  )
  save(DEMO_sgpFlow_Matrices, file="Data/DEMO_sgpFlow_Matrices.rda", compress="xz")
}
}
}
\seealso{
\code{\link[SGP]{createSuperCohortData}}, \code{\link[SGP]{prepareSGP}}, \code{\link[SGP]{baselineSGP}}
}
