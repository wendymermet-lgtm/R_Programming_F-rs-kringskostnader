library(ggplot2)
library(dplyr)
library(patchwork)

# tillägg av residualer till prediktionerna
lm_pred <- lm_pred %>%
  mutate(
    residual     = charges - .pred,
    abs_residual = abs(residual)
  )

rf_pred <- rf_pred %>%
  mutate(
    residual     = charges - .pred,
    abs_residual = abs(residual)
  )

glimpse(rf_pred)
glimpse(lm_pred)

# -- Top 10 worst predictions (LM) --
top_10_error_lm <- lm_pred %>%
                  arrange(desc(abs_residual)) %>%
                  select(charges, .pred, residual, smoker, age_group, bmi, prior_risk_score, chronic_condition, exercise_level,annual_checkups) %>%
                  head(10)%>% 
                  knitr::kable(
                    digits = 3,
                    caption = "Top 10 worst predictions (Linear Regression)"
                  )

top_10_error_lm
write.csv(top_10_error_lm, "report/top_10_error_lm.csv", row.names = FALSE)

# -- Top 10 worst predictions (RF) --


top_10_error_rf <- rf_pred %>%
                    arrange(desc(abs_residual)) %>% 
                    select(charges, .pred, residual, smoker, age_group, bmi, prior_risk_score, chronic_condition, exercise_level,annual_checkups) %>%
                    head(10)%>% 
                    knitr::kable(
                      digits = 3,
                      caption = "Top 10 worst predictions (Random Forest)"
                    )
top_10_error_rf
write.csv(top_10_error_rf, "report/top_10_error_rf.csv", row.names = FALSE)


####
# tolkning av modellresultat (topp 10 prediktionsfel)

# båda modellerna har stora fel för ett fåtal observationer, främst där kostnaderna är höga,
# vilket visar att de underskattar extrema värden.

# särskilt gäller detta fall där individer har oväntat höga kostnader som inte förklaras av
# tillgängliga variabler, vilket tyder på saknade faktorer eller outliers i datan.

# rökning och BMI verkar ha en viktig men inte helt stabil effekt, troligen p.g.a.
# saknade interaktioner med andra variabler som riskpoäng.

# random forest presterar något bättre än linjär regression, men båda modellerna har
# svårt att fånga extremvärden.