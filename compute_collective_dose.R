# This function computes the collective whole body and extremity doses by work group.
# 
# First, you need to load the data from a spreadsheet with `dose_assess_import`.


df[, c(1:5, 9, 11:12)]

df %>% group_by(Work_Group_ID) %>% summarize(collective_wb = sum(wb_dose))

df %>% group_by(Work_Group_ID) %>% summarize(collective_Ext = sum(ext_dose))
