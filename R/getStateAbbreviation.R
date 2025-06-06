#' @title Convert State Names to Abbreviations or Vice Versa
#'
#' @description
#' A utility function that converts between state names and their two-letter abbreviations.
#' This function is used internally by other SGP functions and is not exported.
#'
#' @param supplied.name A character string containing a state name or abbreviation
#' @param SGPfunction Optional character string specifying the calling SGP function for error messages
#' @param type Character string indicating the type of conversion: "ABBREVIATION" (default) or "FULL_NAME"
#'
#' @return
#' Returns a character string containing either:
#' - The two-letter state abbreviation when type="ABBREVIATION"
#' - The full state name when type="FULL_NAME"
#' 
#' @details
#' The function uses an internal lookup table that includes all 50 US states plus additional
#' special cases like Washington DC, Department of Defense, and various assessment programs.
#' The matching is case-insensitive and can handle partial matches.
#'
#' @note
#' This function is not exported and is intended for internal use within the SGP package.
#' If a state's metadata is not found, the function will provide guidance on how to add
#' the state's data to the SGPstateData object.
#'
#' @importFrom data.table fread
#'
#' @examples
#' \dontrun{
#' getStateAbbreviation("Colorado") # Returns "CO"
#' getStateAbbreviation("CO", type="FULL_NAME") # Returns "Colorado"
#' }
#' 
#' @rdname getStateAbbreviation
#' @keywords internal

getStateAbbreviation <-
	function(
		supplied.name,
		SGPfunction=NULL,
		type="ABBREVIATION"
	) {

	state.abbreviation.name.lookup <- fread(
"ABBREVIATION, FULL_NAME
AL, Alabama
AK, Alaska
AZ, Arizona
AR, Arkansas
CA, California
CO, Colorado
CT, Connecticut
DE, Delaware
FL, Florida
GA, Georgia
HI, Hawaii
ID, Idaho
IL, Illinois
IN, Indiana
IA, Iowa
KS, Kansas
KY, Kentucky
LA, Louisiana
ME, Maine
MD, Maryland
MI, Michigan
MN, Minnesota
MS, Mississippi
MO, Missouri
MT, Montana
NE, Nebraska
NV, Nevada
NH, New Hampshire
NJ, New Jersey
NM, New Mexico
NY, New York
NC, North Carolina
ND, North Dakota
OH, Ohio
OK, Oklahoma
OR, Oregon
PA, Pennsylvania
RI, Rhode Island
SC, South Carolina
SD, South Dakota
TN, Tennessee
TX, Texas
UT, Utah
VT, Vermont
VA, Virginia
WV, West Virginia
WI, Wisconsin
WY, Wyoming
ABQ, Albuquerque
AOB, AOB
ATI, ATI
CFU, CFU
BI, Bureau of Indian Education
CO_ORIGINAL, Colorado
DC, Washington DC
DD, Department of Defense
DEMO, Demonstration
DEMO, SGPDATA LONG
DEMO, SGPFLOWDATA LONG
DEMO_COVID, Demonstration COVID
DEMO_COVID, SGPDATA LONG COVID
DEMO_EOCT, Demonstration
ERB, ERB
GCPS, Gwinnett
GUA, Guatemala
MA_MCAS, Massachusetts MCAS
MA_PARCC, Massachusetts PARCC
MA, Massachusetts
MA_ORIGINAL, Massachusetts
NCSC_SD, NCSC SD
NJ_ORIGINAL, New Jersey
NM_MSR, New Mexico
PARCC, PARCC
RI_ORIGINAL, Rhode Island
RLI_UK, RLI UK
RLI, RLI
RLI, SGPTDATA LONG
SBAC, SBAC
VI, US Virgin Islands
WIDA_CO, WIDA CO
WIDA_DPS, WIDA DPS
WIDA_GA, WIDA GA
WIDA_HI, WIDA HI
WIDA_ID, WIDA ID
WIDA_IN, WIDA IN
WIDA_MA, WIDA MA
WIDA_MI, WIDA MI
WIDA_NH, WIDA NH
WIDA_NM, WIDA NM
WIDA_NV, WIDA NV
WIDA_RI, WIDA RI
WIDA_WA, WIDA WA
WIDA_WI, WIDA WI
WIDA, WIDA
WA, Washington")

	if (toupper(type)=="ABBREVIATION") {
		tmp.name.position <- sapply(toupper(state.abbreviation.name.lookup[["FULL_NAME"]]), function(x) regexpr(x, toupper(supplied.name)))
	} else {
		tmp.name.position <- sapply(lapply(toupper(state.abbreviation.name.lookup[["ABBREVIATION"]]), function(x) regexpr(x, toupper(supplied.name))), function(x) attributes(x)[['match.length']])
	}

	if (any(tmp.name.position!=-1)) {
		if (toupper(type)=="ABBREVIATION") {
			if (length(possible.name <- unique(names(sort(tmp.name.position[tmp.name.position!=-1])))) > 1) {
				possible.name <- possible.name[which.min(abs(sapply(lapply(possible.name, function(x) regexpr(x, toupper(supplied.name))), function(x) attributes(x)[['match.length']])-nchar(supplied.name)))]
			}
			state.abbreviation.name.lookup[["ABBREVIATION"]][which(possible.name==toupper(state.abbreviation.name.lookup[["FULL_NAME"]]))[1]]
		} else {
			state.abbreviation.name.lookup[["FULL_NAME"]][which(tmp.name.position==nchar(supplied.name))[1]]
		}
	} else {
		if (!is.null(SGPfunction)) {
			message(paste0("\tNOTE: Use of the higher level '", SGPfunction, "' function requires extensive metadata embedded in the 'SGPstateData' list object.\n\tEither supply the two letter state acronymn as an argument or name the object supplied as 'sgp_object' using the entire state name (e.g., 'Colorado_SGP').\n\tIf your state's meta-data is not a part of the package, please add your state's data to 'SGPstateData' by examining a state that is currently embedded in https://github.com/CenterForAssessment/SGPstateData/blob/master/SGPstateData.R.\n\tPlease contact the package administrator with further questions."))
		} else {
			message(paste0("\tNOTE: Either supply a state/organization acronymn as an argument or name the object supplied as 'sgp_object' using the entire state name (e.g., 'Colorado_SGP').\n\tIf your state's meta-data is not a part of the package, please add your state's data to 'SGPstateData' by examining state that is currently embedded in https://github.com/CenterForAssessment/SGPstateData/blob/master/SGPstateData.R.\n\tPlease contact the package administrator with further questions."))
		}
	}
} ### END getStateAbbreviation
