glimpse(insurance_raw)

# # Datasetet innehåller 13 variabler för 1 100 kunder

# kategoriska variabler =
# - "sex", 
# - "region", 
# - "exercise_level", 
# - "smoker", 
# - "chronic_condition", 
# - "plan_type"

# omvandla kategoriska variabler till faktorer

# Ändra datatyp från dbl -> int för:
# - children 
# - prior_accidents
# - prior_claims
# - annual_checkups

summary(insurance_raw)

colSums(is.na(insurance_raw))

# saknade data:
# - 28 bmi
# - 22 Exercise_level
# - 20 annual_checkups


insurance_raw %>% 
  count(sex)

insurance_raw %>% 
  count(region)
insurance_raw %>% 
  count(exercise_level)
insurance_raw %>% 
  count(smoker)
insurance_raw %>% 
  count(chronic_condition)
insurance_raw %>% 
  count(plan_type) 

# Chronic_condition och sex kategorierna ser bra ut, men alla andra kategorier har inkonsekvenser och behöver rensas samt standardiseras till gemener (små bokstäver)

# vi gör samma sak för chronic_condition och sex för att täcka eventuella inkonsekvenser i framtida dataset