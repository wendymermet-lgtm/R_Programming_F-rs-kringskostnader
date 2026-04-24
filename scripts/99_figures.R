library(ggplot2)

### --- dataanalys ---

# plot för att se spridningen av försäkringskostnader per antal kunder

p_charges_distribution <- ggplot(df_insurance, aes(x = charges)) +
  geom_histogram(bins = 30, fill = "lightblue", color = "white") +
  labs(title = "Distribution of Insurance Charges",
       x = "Charges", y = "Amount of customers") +
  theme_minimal()

p_charges_distribution

ggsave("report/images/charges_distribution.png", p_charges_distribution, width = 8, height = 5)

# plot för att se kostnader per plan-typ

p_plan_type_view <-  ggplot(df_insurance, aes(x = plan_type, y = charges, fill = plan_type)) +
  geom_boxplot() +
  scale_fill_manual(values = c("pink", "lightblue","lightyellow"))

p_plan_type_view


ggsave("report/images/charges_per_plan_type.png", p_plan_type_view, width = 8, height = 5)

# plot över de 10 viktigaste drivarna

p_top_10_drivers <- ggplot(top_drivers, aes(x = reorder(variable, correlation), y = correlation, fill = correlation > 0)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = c("TRUE" = "lightblue", "FALSE" = "pink"), guide = "none") +
  labs(
    title = "Top 10 Drivers of Insurance Charges",
    x = "Variable",
    y = "Correlation"
  ) +
  
  theme_minimal()

p_top_10_drivers

ggsave("report/images/top_10_drivers.png", p_top_10_drivers, width = 8, height = 5)


# -- jämförelse av regressionsanalys (plot) --

# databehandling för plot

train_plot <- bind_rows(lm_cv, rf_cv) %>%
  filter(.metric %in% c("rmse", "rsq")) %>%
  select(model, .metric, mean) %>%
  mutate(set = "Train") %>%
  rename(value = mean)


test_plot <- bind_rows(lm_test, rf_test) %>%
  filter(.metric %in% c("rmse", "rsq")) %>%
  select(model, .metric, .estimate) %>%
  mutate(set = "Test") %>%
  rename(value = .estimate)

plot_data <- bind_rows(train_plot, test_plot)

# dashboard med tränings- och testresultat för modellerna

p_model_results_summary <- ggplot(plot_data, aes(x = model, y = value, fill = set)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.6) +
  facet_wrap(~ .metric, scales = "free_y") +
  scale_fill_manual(values = c("Train" = "pink", "Test" = "lightblue")) +
  labs(
    title = "Model Performance: Train vs Test",
    x = "Model",
    y = "Score",
    fill = "Data split"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

p_model_results_summary


ggsave("report/images/model_results_summary.png", p_model_results_summary, width = 8, height = 5)

# plot för att se residualfördelning för båda modellerna


p_rf_residual <- ggplot(rf_pred, aes(x = charges, y = .pred)) +
  geom_point(aes(color = abs_residual), alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  scale_color_gradient(low = "#A6D8F0", high = "#F4A6C8") + 
  labs(
    title = "Actual vs Predicted Charges (Random Forest)",
    x = "Actual charges",
    y = "Predicted charges",
    color = "Abs error"
  ) +
  theme_minimal()

p_rf_residual

ggsave("report/images/random_forest_residual_plot.png", p_rf_residual, width = 8, height = 5)


p_lm_residual <- ggplot(lm_pred, aes(x = charges, y = .pred)) +
  geom_point(aes(color = abs_residual), alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  scale_color_gradient(low = "#A6D8F0", high = "#F4A6C8") + 
  labs(
    title = "Actual vs Predicted Charges (Linear Regression)",
    x = "Actual charges",
    y = "Predicted charges",
    color = "Abs error"
  ) +
  theme_minimal()

p_lm_residual

ggsave("report/images/linear_regression_residual_plot.png", p_lm_residual, width = 8, height = 5)
