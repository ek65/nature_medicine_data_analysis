################################################################################
# This script generates the plot in Figure 3 of the paper comparing Basic (Wilson) vs GLMM estimates and
# saves it as PNG.
#
# Prerequisites (once per machine):
#   install.packages(c("binom", "lme4", "readr", "dplyr", "ggplot2", "scales"))
###############################################################################
suppressPackageStartupMessages({
  library(binom)    # Wilson CIs
  library(lme4)     # glmer()
  library(readr)    # read_csv()
  library(dplyr)
  library(ggplot2)
  library(scales)
})

## ── 1. Load your data ───────────────────────────────────────────────────────
df <- read_csv("study_data_summary.csv", show_col_types = FALSE)

## ── 2. Convenience function for Wilson estimate & CI ────────────────────────
wilson_ci <- function(k, n) {
  ci <- binom.confint(k, n, methods = "wilson")[, c("lower", "upper")]
  data.frame(est = k / n, lo95 = ci$lower, hi95 = ci$upper)
}

## ── 3. Basic (Wilson) estimates ─────────────────────────────────────────────
acc_basic  <- wilson_ci(sum(df$correct), nrow(df))
sens_basic <- wilson_ci(sum(df$correct & df$truth == 1),
                        sum(df$truth == 1))
spec_basic <- wilson_ci(sum(df$correct & df$truth == 0),
                        sum(df$truth == 0))

basic_tbl <- bind_rows(
  mutate(acc_basic,  Metric = "Accuracy"),
  mutate(sens_basic, Metric = "Sensitivity"),
  mutate(spec_basic, Metric = "Specificity")
) %>% mutate(Method = "Wilson")

## ── 4. GLMM helper ──────────────────────────────────────────────────────────
glmm_ci <- function(data_subset) {
  fit <- glmer(correct ~ 1 + (1 | exerciseID/therapistID/instruction_step),
               data = data_subset, family = binomial, nAGQ = 0)
  beta0 <- fixef(fit)[1]
  se    <- sqrt(vcov(fit)[1, 1])
  est   <- plogis(beta0)
  ci    <- plogis(beta0 + c(-1, 1) * qnorm(0.975) * se)
  data.frame(est = est, lo95 = ci[1], hi95 = ci[2])
}

## ── 5. GLMM estimates ───────────────────────────────────────────────────────
acc_glmm  <- glmm_ci(df)
sens_glmm <- glmm_ci(df %>% filter(truth == 1))
spec_glmm <- glmm_ci(df %>% filter(truth == 0))

glmm_tbl <- bind_rows(
  mutate(acc_glmm,  Metric = "Accuracy"),
  mutate(sens_glmm, Metric = "Sensitivity"),
  mutate(spec_glmm, Metric = "Specificity")
) %>% mutate(Method = "GLMM")

## ── 6. Combine for plotting ────────────────────────────────────────────────
plot_df <- bind_rows(basic_tbl, glmm_tbl) %>%
  mutate(Metric = factor(Metric, levels = c("Accuracy","Sensitivity","Specificity")),
         Method = factor(Method, levels = c("Wilson","GLMM")))

## ── 7. Forest plot ──────────────────────────────────────────────────────────
p <- ggplot(plot_df,
            aes(x = est, y = Metric,
                colour = Method, shape = Method)) +
  geom_point(position = position_dodge(width = 0.5), size = 3) +
  geom_errorbarh(aes(xmin = lo95, xmax = hi95),
                 position = position_dodge(width = 0.5), height = 0.2) +
  scale_x_continuous(limits = c(0.70, 1.00),
                     labels = percent_format(accuracy = 1)) +
  scale_y_discrete(limits = c("Specificity", "Sensitivity", "Accuracy")) +
  labs(x = "Estimate (95% CI)",
       y = NULL,
       title = "     Evaluation of Intervention Software Monitoring Performance") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom",
        plot.title = element_text(size = 12))

print(p)  # show in RStudio or X11/aqua device

## ── 8. Save to disk ─────────────────────────────────────────────────────────
ggsave("monitoring_analysis.png", p, width = 6, height = 4, dpi = 300)

message("Plot saved as monitoring_analysis.png")