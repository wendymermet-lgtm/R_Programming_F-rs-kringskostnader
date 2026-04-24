library(tidymodels)
library(recipes)
library(ranger)

# städning av datasetet: vi tar bort variablerna  sex, children, region, customer ID, plan type eftersom de inte visar någon tydlig påverkan på försäkringskostnaderna och vi vill hålla modellen enkel
# dessutom tar jag bort outliern för att inte komplicera analysen i onödan

#glimpse( df_insurance)

df_insurance %>%
  dplyr::arrange(desc(charges)) %>%
  dplyr::select(customer_id, charges) %>%
  head(10)

df_insurance_clean <- df_insurance %>%
  dplyr::filter(customer_id != "C100063")  


df_reg_analysis <- df_insurance_clean %>%
                  select(-customer_id,
                  -sex, -children, -region, -plan_type, -age, -prior_claims, -prior_accidents)

#glimpse(df_reg_analysis)

y <- df_reg_analysis$charges
X <- df_reg_analysis %>% select(-charges)

# train/test split:

set.seed(123)

split <- initial_split(df_reg_analysis, prop = 0.8, strata = charges)
train_data <- training(split)
test_data  <- testing(split)

# preprocessing One Hot encoder:

rec <- recipe(charges ~ ., data = train_data) %>%
  
  # one-hot encoding för alla kategoriska variabler
  step_dummy(all_nominal_predictors()) %>%
  
  # normalisera numeriska prediktorer
  step_normalize(all_numeric_predictors())

# 5 fold cross validation:

set.seed(123)

folds <- vfold_cv(train_data, v = 5, strata = charges)

# Model 1 - linear regression:

lm_model <- linear_reg() %>%
  set_engine("lm")

# Model 2 - Random Forest:

rf_model <- rand_forest(trees = 500) %>%
  set_engine("ranger") %>%
  set_mode("regression")

# Workflows:

lm_wf <- workflow() %>%
  add_recipe(rec) %>%
  add_model(lm_model)

rf_wf <- workflow() %>%
  add_recipe(rec) %>%
  add_model(rf_model)

# linear regression CV:


lm_res <- fit_resamples(
  lm_wf,
  resamples = folds,
  metrics = metric_set(rmse, rsq)
)


# Random Forest CV:

rf_res <- fit_resamples(
  rf_wf,
  resamples = folds,
  metrics = metric_set(rmse, rsq)
)

# jämförelse av modellprestanda:

collect_metrics(lm_res)
collect_metrics(rf_res)

lm_cv <- collect_metrics(lm_res) %>%
  mutate(model = "Linear Regression", 
         dataset = "CV (Train)")

rf_cv <- collect_metrics(rf_res) %>%
  mutate(model = "Random Forest",
         dataset = "CV (Train)")
rf_cv

train_summary <- bind_rows(lm_cv, rf_cv) %>%
  filter(.metric %in% c("rmse", "rsq")) %>%
  select(model, .metric, mean) %>%
  tidyr::pivot_wider(names_from = .metric, values_from = mean) %>%
  arrange(model)%>%
  knitr::kable(
    digits = 3,
    col.names = c("Model", "RMSE ↓ (better)", "R² ↑ (better)"),
    caption = "Model Performance (Train CV)"
  )

train_summary

# slutlig modellanpassning på träningsdata
final_lm <- fit(lm_wf, data = train_data)
final_rf <- fit(rf_wf, data = train_data)

# prediktioner på testdata
lm_pred <- predict(final_lm, test_data) %>%
  bind_cols(test_data)

rf_pred <- predict(final_rf, test_data) %>%
  bind_cols(test_data)

lm_test <- metrics(lm_pred, truth = charges, estimate = .pred) %>%
  mutate(model = "Linear Regression",
         dataset = "Test")

rf_test <- metrics(rf_pred, truth = charges, estimate = .pred) %>%
  mutate(model = "Random Forest",
         dataset = "Test")

test_summary <- bind_rows(lm_test, rf_test) %>%
  filter(.metric %in% c("rmse", "rsq")) %>%
  select(model, .metric, .estimate) %>%
  tidyr::pivot_wider(names_from = .metric, values_from = .estimate) %>%
  arrange(model) %>%
  knitr::kable(
    digits = 3,
    col.names = c("Model", "RMSE ↓ (better)", "R² ↑ (better)"),
    caption = "Model Performance (Test Set)"
  )


test_summary 

# Tolkning av modellprestanda:

# linjär regression presterar något bättre på träningsdata (lägre RMSE, högre R²),vilket tyder på en starkare anpassning till träningsdata. på testdata visar dock random forest något bättre resultat (lägre RMSE och högre R²), vilket tyder på bättre generalisering till nya data.
# Den lilla skillnaden mellan tränings- och testresultat för båda modellerna indikerar att det inte finns någon tydlig överanpassning, även om linjär regression verkar anpassa sig något mer till träningsdata.
# Övergripande presterar båda modellerna likvärdigt och förklarar cirka 70–73 % av variationen i kostnader, med random forest som har ett svagt övertag i prediktiv prestanda.


