# konvertering av kategoriska variabler till faktorer och standardisering av text inom kategorier

# Ändra datatyp från dbl -> int för:
# - children 
# - prior_accidents
# - prior_claims
# - annual_checkups

df_insurance <- insurance_raw %>% 
  mutate(
    region = str_trim(region),
    region = str_to_lower(region),
    region = as.factor(region),
    sex = str_trim(sex),
    sex = str_to_lower(sex),
    sex = as.factor(sex),
    exercise_level = str_trim(exercise_level),
    exercise_level = str_to_lower(exercise_level),
    exercise_level = as.factor(exercise_level),
    smoker = str_trim(smoker),
    smoker = str_to_lower(smoker),
    smoker = as.factor(smoker),
    chronic_condition = str_trim(chronic_condition),
    chronic_condition = str_to_lower(chronic_condition),
    chronic_condition = as.factor(chronic_condition),
    plan_type = str_trim(plan_type),
    plan_type = str_to_lower(plan_type),
    plan_type = as.factor(plan_type),
    children = as.integer(children),
    prior_accidents = as.integer(prior_accidents),
    prior_claims = as.integer(prior_claims),
    annual_checkups = as.integer(annual_checkups)
  )


df_insurance %>% 
  count(region)
df_insurance %>% 
  count(sex)
df_insurance %>% 
  count(exercise_level)
df_insurance %>% 
  count(smoker)
df_insurance %>% 
  count(chronic_condition)
df_insurance %>% 
  count(plan_type)

# botr tagning av kunder med saknade värden:
## saknade data:
# - 28 bmi
# - 22 Exercise_level
# - 20 annual_checkups

df_insurance <- df_insurance %>%
  drop_na(bmi, exercise_level, annual_checkups)

glimpse(df_insurance)

# nya df_insurance-datasetet innehåller 13 variabler för 1 031 kunder

write.csv(df_insurance, "report/df_insurance.csv", row.names = FALSE)






