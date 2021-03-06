#' Site Data Import from Water Quality Portal
#'
#' Returns a list of sites from the Water Quality Portal web service. This function gets the data from: \url{http://www.waterqualitydata.us}.
#' Arguments to the function should be based on \url{www.waterqualitydata.us/webservices_documentation.jsp}
#'
#' @param \dots see \url{www.waterqualitydata.us/webservices_documentation.jsp} for a complete list of options
#' @keywords data import WQP web service
#' @return A data frame with at least the following columns:
#' \tabular{lll}{ 
#' Name \tab Type \tab Description \cr
#' OrganizationIdentifier \tab character \tab  A designator used to uniquely identify a unique business establishment within a context. \cr
#' OrganizationFormalName \tab character \tab	The legal designator (i.e. formal name) of an organization. \cr
#' MonitoringLocationIdentifier \tab character \tab	A designator used to describe the unique name, number, or code assigned to identify the monitoring location. \cr
#' MonitoringLocationName \tab character \tab	The designator specified by the sampling organization for the site at which sampling or other activities are conducted. \cr
#' MonitoringLocationTypeName \tab character \tab	The descriptive name for a type of monitoring location. \cr
#' MonitoringLocationDescriptionText \tab character \tab 	Text description of the monitoring location. \cr
#' HUCEightDigitCode \tab character \tab	The 8 digit federal code used to identify the hydrologic unit of the monitoring location to the cataloging unit level of precision. \cr
#' DrainageAreaMeasure/MeasureValue * \tab character \tab	The drainage basin of a lake, stream, wetland, or estuary site. Measure value is given in the units stored in DrainageAreaMeasure/MeasureUnitCode. \cr
#' DrainageAreaMeasure/MeasureUnitCode * \tab character \tab	The code that represents the unit for measuring the item. \cr
#' ContributingDrainageAreaMeasure/MeasureValue * \tab character \tab	The contributing drainage area of a lake, stream, wetland, or estuary site. Measure value is given in the units stored in ContributingDrainageAreaMeasure/MeasureUnitCode. \cr
#' ContributingDrainageAreaMeasure/MeasureUnitCode * \tab character \tab	The code that represents the unit for measuring the item. \cr
#' LatitudeMeasure \tab numeric \tab	The measure of the angular distance on a meridian north or south of the equator. \cr
#' LongitudeMeasure \tab numeric \tab	The measure of the angular distance on a meridian east or west of the prime meridian. \cr
#' SourceMapScaleNumeric \tab character \tab	The number that represents the proportional distance on the ground for one unit of measure on the map or photo. \cr
#' HorizontalAccuracyMeasure/MeasureValue * \tab character \tab	The horizontal measure of the relative accuracy of the latitude and longitude coordinates." Measure value is given in the units stored in HorizontalAccuracyMeasure/MeasureUnitCode. \cr
#' HorizontalAccuracyMeasure/MeasureUnitCode * \tab character \tab	The code that represents the unit for measuring the item. \cr
#' HorizontalCollectionMethodName \tab character \tab	The name that identifies the method used to determine the latitude and longitude coordinates for a point on the earth. \cr
#' HorizontalCoordinateReferenceSystemDatumName \tab character \tab	The name that describes the reference datum used in determining latitude and longitude coordinates. \cr
#' VerticalMeasure/MeasureValue \tab character \tab	The measure of elevation (i.e., the altitude), above or below a reference datum. Measure value is given in the units stored in VerticalMeasure/MeasureUnitCode. \cr
#' VerticalMeasure/MeasureUnitCode \tab character \tab	The code that represents the unit for measuring the item. \cr
#' VerticalAccuracyMeasure/MeasureValue * \tab character \tab	The vertical measure of the relative accuracy of the latitude and longitude coordinates. Measure value is given in the units stored in VerticalAccuracyMeasure/MeasureUnitCode. \cr
#' VerticalAccuracyMeasure/MeasureUnitCode * \tab character \tab	The code that represents the unit for measuring the item. \cr
#' VerticalCollectionMethodName \tab character \tab	The name that identifies the method used to collect the vertical measure (i.e. the altitude) of a reference point. \cr
#' VerticalCoordinateReferenceSystemDatumName \tab character \tab	The name of the reference datum used to determine the vertical measure (i.e., the altitude). \cr
#' CountryCode \tab character \tab	A code designator used to identify a primary geopolitical unit of the world. \cr
#' StateCode \tab character \tab	A code designator used to identify a principal administrative subdivision of the United States, Canada, or Mexico. \cr
#' CountyCode \tab character \tab	A code designator used to identify a U.S. county or county equivalent. \cr
#' AquiferName * \tab character \tab 	Name of the aquifer in which the well is completed. \cr
#' FormationTypeText * \tab character \tab	Name of the primary formation or soils unit, in which the well is completed. \cr
#' AquiferTypeName * \tab character \tab	The type of aquifer, such as confined or unconfined. \cr
#' ConstructionDateText * \tab character \tab	Date of construction when well was completed. May be year only. \cr
#' WellDepthMeasure/MeasureValue * \tab character \tab	Depth below land surface datum (LSD) to the bottom of the hole on completion of drilling. Measure value is given in the units stored in WellDepthMeasure/MeasureUnitCode. \cr
#' WellDepthMeasure/MeasureUnitCode * \tab character \tab	The code that represents the unit for measuring the item. \cr
#' WellHoleDepthMeasure/MeasureValue * \tab character \tab	Depth below land surface datum (LSD) to the bottom of the hole on completion of drilling. Measure value is given in the units stored in WellHoleDepthMeasure/MeasureUnitCode. \cr
#' WellHoleDepthMeasure/MeasureUnitCode * \tab character \tab	The code that represents the unit for measuring the item. \cr
#' queryTime \tab POSIXct \tab Query time \cr
#' }
#' * element is only in NWIS
#' 
#' @export
#' @examples
#' \dontrun{
#' site1 <- whatWQPsites(siteid="USGS-01594440")
#' 
#' type <- "Stream"
#' sites <- whatWQPsites(countycode="US:55:025",siteType=type)
#' }
whatWQPsites <- function(...){

  matchReturn <- list(...)
  
  values <- sapply(matchReturn, function(x) URLencode(as.character(paste(eval(x),collapse=";",sep=""))))
  
  if("tz" %in% names(values)){
    values <- values[!(names(values) %in% "tz")]
  }
  
  if("statecode" %in% names(values)){
    stCd <- values["statecode"]
    if(!grepl("US:",stCd)){
      values["statecode"] <- paste0("US:",stateCdLookup(stCd, "id"))
    }
  }
  
  if("stateCd" %in% names(values)){
    stCd <- values["stateCd"]
    if(!grepl("US:",stCd)){
      values["stateCd"] <- paste0("US:",stateCdLookup(stCd, "id"))
    }
    names(values)[names(values) == "stateCd"] <- "statecode"
  }
  
  values <- gsub(",","%2C",values)
  values <- gsub(";","%3B",values)
  values <- gsub("%20","+",values)
  values <- gsub(":","%3A",values)
  
  if("bBox" %in% names(values)){
    values['bBox'] <- gsub(pattern = ";", replacement = ",", x = values['bBox'])
  }
  
  values <- checkWQPdates(values)
    
  urlCall <- paste(paste(names(values),values,sep="="),collapse="&")
  
  
  baseURL <- "http://www.waterqualitydata.us/Station/search?"
  urlCall <- paste(baseURL,
               urlCall,
               "&mimeType=tsv",sep = "")
  
  doc <- getWebServiceData(urlCall)
  headerInfo <- attr(doc, "headerInfo")
    
  numToBeReturned <- as.numeric(headerInfo["Total-Site-Count"])
  
  if (!is.na(numToBeReturned) & numToBeReturned != 0){
 
    retval <- read.delim(textConnection(doc), header = TRUE, quote="\"", 
                         dec=".", sep='\t', 
                         colClasses=c('character'), 
                         fill = TRUE)    
    actualNumReturned <- nrow(retval)
    
    if(actualNumReturned != numToBeReturned) warning(numToBeReturned, " sites were expected, ", actualNumReturned, " were returned")
    
    if("LatitudeMeasure" %in% names(retval)){
      retval$LatitudeMeasure <- as.numeric(retval$LatitudeMeasure)
    }
    
    if("LongitudeMeasure" %in% names(retval)){
      retval$LongitudeMeasure <- as.numeric(retval$LongitudeMeasure)
    }
    
    retval$queryTime <- Sys.time()
    
    return(retval)
    
  } else {
    if(headerInfo['Total-Site-Count'] == "0"){
      warning("No data returned")
    }
    
    for(i in grep("Warning",names(headerInfo))){
      warning(headerInfo[i])
    }
  }

}
