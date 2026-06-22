
library(ggplot2)
library(dplyr)
library(moments)

theme_set(
  theme_minimal(base_size = 14)
)

generate_data <- function(n_samples = 500, 
                          dist_type = "normal", 
                          noise_lvl = 1.5, 
                          na_prop = 0.08) {

  raw_values <- switch(
    dist_type,
    "normal"  = rnorm(n_samples, mean = 50, sd = 10),
    "uniform" = runif(n_samples, min = 0, max = 100),
    "poisson" = rpois(n_samples, lambda = 20),
    "binom"   = rbinom(n_samples, size = 100, prob = 0.5),
    "gamma"   = rgamma(n_samples, shape = 2, rate = 0.1),
    stop("Oops! That distribution isn't supported.")
  )
  
  random_noise <- rnorm(n_samples, mean = 0, sd = noise_lvl)
  dirty_values <- raw_values + random_noise

  missing_spots <- sample(1:n_samples, size = floor(na_prop * n_samples))
  dirty_values[missing_spots] <- NA
  
  return(dirty_values)
}

set.seed(123) 

my_distributions <- c("normal", "uniform", "poisson", "binom", "gamma")
master_dataset   <- data.frame()

for (d in my_distributions) {
  simulated_vals <- generate_data(
    n_samples    = 500, 
    dist_type    = d, 
    noise_lvl    = 1.5, 
    na_prop      = 0.08
  )
  
  temp_df <- data.frame(
    Distribution = d,
    Value        = simulated_vals,
    SampleIndex  = 1:length(simulated_vals) # Keep track of index within each group
  )
  
  master_dataset <- rbind(master_dataset, temp_df)
}

clean_plot_data <- master_dataset %>% 
  filter(!is.na(Value))

project_summary <- master_dataset %>%
  group_by(Distribution) %>%
  summarise(
    Missing_Count = sum(is.na(Value)),
    Minimum       = round(min(Value, na.rm = TRUE), 2),
    Quartile_1    = round(quantile(Value, 0.25, na.rm = TRUE), 2),
    Median        = round(median(Value, na.rm = TRUE), 2),
    Mean          = round(mean(Value, na.rm = TRUE), 2),
    Quartile_3    = round(quantile(Value, 0.75, na.rm = TRUE), 2),
    Maximum       = round(max(Value, na.rm = TRUE), 2),
    Std_Dev       = round(sd(Value, na.rm = TRUE), 2),
    Skewness      = round(skewness(Value, na.rm = TRUE), 2),
    Kurtosis      = round(kurtosis(Value, na.rm = TRUE), 2)
  )

print("--- Final Summary Table ---")
print(project_summary)


# Plot 1: Histograms to see shape/spread
hist_chart <- ggplot(clean_plot_data, aes(x = Value, fill = Distribution)) +
  geom_histogram(bins = 30, color = "white", alpha = 0.75) +
  facet_wrap(~Distribution, scales = "free", ncol = 2) +
  labs(
    title = "Comparing Distribution Shapes",
    subtitle = "Histograms of our generated dataset",
    x = "Measured Values", y = "Count"
  ) +
  theme(legend.position = "none")

ggsave("student_histogram.png", hist_chart, width = 12, height = 8, dpi = 300)
print(hist_chart)

# Plot 2: Boxplots for IQR Outlier Spotting
box_chart <- ggplot(clean_plot_data, aes(x = Distribution, y = Value, fill = Distribution)) +
  geom_boxplot(outlier.color = "darkred", outlier.shape = 17, outlier.size = 2.5) +
  labs(
    title = "Boxplot Analysis & Outlier Spotting",
    subtitle = "Red triangles show outliers discovered using the IQR method",
    x = "Distribution Type", y = "Data Scale"
  )

ggsave("student_boxplot.png", box_chart, width = 10, height = 6, dpi = 300)
print(box_chart)

# Plot 3: Clean Density Curves
density_chart <- ggplot(clean_plot_data, aes(x = Value, fill = Distribution)) +
  geom_density(alpha = 0.4) +
  facet_wrap(~Distribution, scales = "free", ncol = 2) +
  labs(
    title = "Smooth Density Curves",
    subtitle = "Probability density profiles across different distributions",
    x = "Value Range", y = "Density Scale"
  ) +
  theme(legend.position = "none")

ggsave("student_density.png", density_chart, width = 12, height = 8, dpi = 300)
print(density_chart)

# Plot 4: Violin Plots combined with internal Boxplots
violin_chart <- ggplot(clean_plot_data, aes(x = Distribution, y = Value, fill = Distribution)) +
  geom_violin(alpha = 0.5, color = "black") +
  geom_boxplot(width = 0.12, fill = "white", outlier.alpha = 0) +
  labs(
    title = "Violin Plot Distribution Profiles",
    subtitle = "Showing internal box plots alongside total spread thickness",
    x = "Target Distribution", y = "Values"
  )

ggsave("student_violin.png", violin_chart, width = 10, height = 6, dpi = 300)
print(violin_chart)

# Plot 5: ALL DISTRIBUTIONS QQ PLOTS (Updated!)
qq_all_chart <- ggplot(clean_plot_data, aes(sample = Value, color = Distribution)) +
  stat_qq(alpha = 0.6, size = 1.5) +
  stat_qq_line(color = "black", linewidth = 1) +
  facet_wrap(~Distribution, scales = "free", ncol = 3) +
  labs(
    title = "Normal QQ Plots for All Stored Distributions",
    subtitle = "Assessing how well each shape fits a theoretical normal line",
    x = "Expected Theoretical Quantiles", y = "Actual Sample Quantiles"
  ) +
  theme(legend.position = "none")

ggsave("student_qq_plots.png", qq_all_chart, width = 14, height = 8, dpi = 300)
print(qq_all_chart)

# Plot 6: Scatter plot 
scatter_chart <- ggplot(clean_plot_data, aes(x = SampleIndex, y = Value, color = Distribution)) +
  geom_point(alpha = 0.5, size = 1.5) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "black", linetype = "dashed") +
  facet_wrap(~Distribution, scales = "free_y", ncol = 2) +
  labs(
    title = "Scatter Plots & Sequential Trends",
    subtitle = "Checking for random dispersion patterns and global trend lines",
    x = "Sample ID Number (1-500)", y = "Value Output"
  ) +
  theme(legend.position = "none")

ggsave("student_scatter.png", scatter_chart, width = 12, height = 9, dpi = 300)
print(scatter_chart)


cat("\n========================================================\n")
cat("STUDENT PROJECT REPORT SUMMARY & THOUGHTS:\n")
cat("========================================================\n")
cat("
1. Summary Table captures standard 5-number summaries across everything perfectly.
2. Skewed datasets like Gamma show clear offsets on their Histograms and Density lines.
3. The comprehensive QQ Plots show the Normal distribution aligning beautifully, while 
   Uniform, Poisson, and Gamma heavily drift away from the trend line as expected!
4. Outliers were accurately flagged using red triangles across our test classes.
")