#Fill in csv template
library(readxl)
library(tidyverse)


#read in model output
rootdir_data= paste("C:/Users/",unlist(strsplit(getwd(),'/'))[3],"/Australian Institute of Marine Science/RRAP M&DS - 2_DataWorkflows/IPMF",sep="")
simulation_name = "Counterfactuals_Jan23" 
modelout = paste(rootdir_data, "model_runs", simulation_name, sep= "/")

scen_name<-paste(rootdir_data, "model_runs",simulation_name,"ScenarioID.xlsx", sep = "/")
Scenarios<-read_excel(scen_name, sheet="ScenarioID")



Template<-read.csv(paste(rootdir_data, "model_runs",simulation_name,"IS_ModelRunUpload.csv", sep = "/"))

Temporal<-unique(Scenarios$Disturbance_file)


for (i in 1:25){
  Template[i,]<-NA
  TemporalFile<-strsplit(Temporal[i],"_")
  ClimateScenario<-TemporalFile[[1]][2]
  ClimateModel<-strsplit(TemporalFile[[1]][3],".Rd")[[1]][1]

  Template$X_workflow.template.id.102.100.100.483907<-"102.100.100/483907"
  Template$description[i]<-paste("Counterfactual Jan2023",ClimateScenario,ClimateModel,sep=" ")
  Template$agent.id[i]<-"102.100.100/483690"
  Template$execution.start.time..YYYY.MM.DD.HH.MM.SS.HH.MM.<-Scenarios$date[Scenarios$Disturbance_file==Temporal[[1]]][1]
  Template$execution.end.time..YYYY.MM.DD.HH.MM.SS.HH.MM.<-Scenarios$date[Scenarios$Disturbance_file==Temporal[[1]]][1]

  Template$dataset.id.for.template.102.100.100.483904<-"102.100.100/483895"
  Geometry<-strsplit(Scenarios$Geometry_file[Scenarios$Disturbance_file==Temporal[[1]]][1],"/")
  Template$resource..Polygon<-Geometry[[1]][1]
  Template$resource..Point<-Geometry[[1]][2]
  
  Template$resource..Connectivity<-Scenarios$Connectivity_file[Scenarios$Disturbance_file==Temporal[[1]]][1]
  Template$resource..dataframe<-Scenarios$Spatial_file[Scenarios$Disturbance_file==Temporal[[1]]][1]
  Template$dataset.id.for.template.102.100.100.483905<-"102.100.100/483900"
  Template$resource..Temporal<-Scenarios$Disturbance_file[Scenarios$Disturbance_file==Temporal[[1]]][1]
  Template$dataset.id.for.template.102.100.100.483906<-"102.100.100/483643"
  Template$resource..CombinedRaw<-paste("Raw_results",ClimateScenario,ClimateModel,sep="/")
  Template$resource..CombinedReduced<-paste("Reduced_results",ClimateScenario,ClimateModel,sep="/")

}


write.csv(Template,paste(rootdir_data, "model_runs",simulation_name,"IS_ModelRunUpload2.csv", sep = "/"),na="")
