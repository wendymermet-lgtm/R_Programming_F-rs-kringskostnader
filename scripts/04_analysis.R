library(dplyr)
library(fastDummies)


df_insurance %>% 
  summarise(
    average_charges = mean(charges),
    median_charges = median(charges),
    min_charges = min(charges),
    max_charges = max(charges)
  )

# vi kan se att de flesta kostnader är under 10k och att vi har en tydlig outlier på 32,6k.
# om vi tar bort outliern ser vi en normalfördelning med en högerskev svans i försäkringskostnaderna bland kunderna

plan_type_summary <- df_insurance %>% 
                      group_by(plan_type) %>% 
                      summarise(
                        average_charges = mean(charges),
                        median_charges = median(charges),
                        min_charges = min(charges),
                        max_charges = max(charges),
                        total_customers = n(),
                        proportion_smokers = sum(smoker == "yes", na.rm = TRUE) / n()
                      )

plan_type_summary

# vi observerar flest outliers i standardplanen. Kunder med premiumplaner har högre kostnader.

# vi kan se att för de numeriska variablerna leder en ökning i ålder och tidigare olyckor till högre genomsnittliga kostnader.
# de andra kategorierna visar inte lika tydliga samband var för sig.
# dessutom ser vi vissa kostnadstoppar vid mycket högt BMI, men detta i sig förklarar inte ökningen i genomsnittliga kostnader.
# mer sannolikt leder detta till lägre träningsnivå, vilket har en tydligare påverkan på kostnaderna.
# från de kategoriska variablerna ser vi en tydlig påverkan på kostnader för rökare, kunder med kroniska sjukdomar samt olika träningsnivåer.

# feature engineering

# lägger till åldersgrupper för att undersöka om ålder spelar en roll för kostnaderna
# kombinerar tidigare skadeanmälningar och tidigare olyckor till en variabel där tidigare olyckor ges högre vikt,
# eftersom dessa har större påverkan på kostnaderna

df_insurance <- df_insurance %>%
  mutate(
    age_group = cut(age, breaks = c(0, 30, 50, 100),
                    labels = c("young", "middle", "old")),
    prior_risk_score = (1 * prior_claims) + (2 * prior_accidents)  # prior accidents lead to more charges, hence making it wheigt more into the risk score
  )

# kontroll av de 10 viktigaste faktorerna som leder till högre försäkringskostnader

df_drivers <- df_insurance %>%
  select(-customer_id,
         -prior_claims, -prior_accidents, -age, -bmi)
df_drivers

df_dummies <- df_drivers %>%
  fastDummies::dummy_cols(
    remove_selected_columns = TRUE
  )

df_dummies

cor_vec <- cor(df_dummies, use = "complete.obs")[, "charges"]

cor_df <- data.frame(
  variable = names(cor_vec),
  correlation = cor_vec
) %>%
  filter(variable != "charges")
cor_df

top_drivers <- cor_df %>%
  mutate(abs_corr = abs(correlation)) %>%
  arrange(desc(abs_corr)) %>%
  slice(1:10)


cor_df

top_drivers

# huvuddrivarna i detta dataset för försäkringskostnader är:
# - smoker
# -  chronic condition
# - prior risk score
# - exercise level
# - age
