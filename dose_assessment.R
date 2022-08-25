library(readxl)
library(dplyr)

my_dir <- "C:/R_files/dose_assessment_package_dev/"
my_spreadsheet <- "my_dose_assessment.xlsx"

# Overall production
prod_tbl <- read_xlsx(paste0(my_dir, my_spreadsheet),
                      col_types = c("text", "text", "numeric"),
                      sheet = "Production")

# work breakdown by task
task_tbl <- read_xlsx(paste0(my_dir, my_spreadsheet),
                      col_types = c("text", "text", "text", "numeric", "numeric"),
                      sheet = "Task")

# tasks assigned to work groups and worker types
WG_tbl <- read_xlsx(paste0(my_dir, my_spreadsheet),
                      col_types = c("text", "text"),
                      sheet = "WG")

# Dose Rates
DR_tbl <- read_xlsx(paste0(my_dir, my_spreadsheet),
                    col_types = c("text", "numeric", "numeric"),
                    sheet = "Dose_rates")


# workers by skill level (needed only for detailed assessment with 
# uncertainties in task time by skill level)
worker_tbl <- read_xlsx(paste0(my_dir, my_spreadsheet),
                      col_types = c("text", "numeric"),
                      sheet = "Workers")

df <- full_join(prod_tbl, task_tbl, by = "Task_ID") %>% 
  full_join(., WG_tbl, by = "Work_Group_ID") %>% 
  full_join(., DR_tbl, by = "Loc_ID")

df <- df %>% mutate(wb_dose = WB_dr_mrem_h * WG_task_min / 60 * times_per_y) %>% 
  mutate(ext_dose = Ext_dr_mrem_h * Ext_task_min / 60 * times_per_y +
           WB_dr_mrem_h * (WG_task_min - Ext_task_min) / 60 * times_per_y)

df[, c(1:5, 9, 11:12)]

df %>% group_by(Work_Group_ID) %>% summarize(collective_wb = sum(wb_dose))

df %>% group_by(Work_Group_ID) %>% summarize(collective_Ext = sum(ext_dose))
