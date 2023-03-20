
library(readxl)
library(tidyverse)



#read in model output
rootdir_data= paste("C:/Users/",unlist(strsplit(getwd(),'/'))[3],"/Australian Institute of Marine Science/RRAP M&DS - 2_DataWorkflows/IPMF",sep="")
simulation_name = "Counterfactuals_Jan23" 
modelout = paste(rootdir_data, "model_runs", simulation_name, sep= "/")

AWS_out<-"s3://rrap-prod-data-store/datasets/102-100-100-483643/"

scen_name<-paste(rootdir_data, "model_runs",simulation_name,"ScenarioID.xlsx", sep = "/")
Scenarios<-read_excel(scen_name, sheet="ScenarioID")

AWS_list_Reduced<-list()
AWS_list_Raw<-list()

for (i in 1:nrow(Scenarios)){
  TemporalFile<-strsplit(Scenarios$Disturbance_file[i],"_")
  ClimateScenario<-TemporalFile[[1]][2]
  ClimateModel<-strsplit(TemporalFile[[1]][3],".Rd")[[1]][1]
  
  File_Path_Reduced<-paste("/export/project/IPMF/model_runs/",simulation_name,"/model_combined/ReducedData/CombinedReduced_scenario",Scenarios$ID[i],".RData", sep="")
  File_Path_Raw<-paste("/export/project/IPMF/model_runs/",simulation_name,"/model_combined/RawData/CombinedRaw_scenario",Scenarios$ID[i],".RData", sep="")
  
  AWS_Command_Reduced<-paste("aws s3 cp ",File_Path_Reduced," ",AWS_out,"Reduced_results/",ClimateScenario,"/",ClimateModel,"/","CombinedReduced_scenario",Scenarios$ID[i],".RData",sep="")
  AWS_Command_Raw<-paste("aws s3 cp ",File_Path_Raw," ",AWS_out,"Raw_results/",ClimateScenario,"/",ClimateModel,"/","CombinedRaw_scenario",Scenarios$ID[i],".RData",sep="")
  
  AWS_list_Reduced[[i]]<-AWS_Command_Reduced
  AWS_list_Raw[[i]]<-AWS_Command_Raw
}
AWS_Vec_Reduced<-unlist(AWS_list_Reduced)
AWS_Vec_Raw<-unlist(AWS_list_Raw)

con <- file("aws_export.sh", open = "w")
writeLines(AWS_Vec_Reduced, con)
writeLines(AWS_Vec_Raw, con)
close(con)



