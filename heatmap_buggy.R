# Heatmap visualization with coordinate mapping bug
library(ggplot2)
library(dplyr)

# Read correlation data
corr_data <- read.csv("correlation_data.csv")

# Create the stoma and trait variables as factors
stoma_levels <- c("SW", "SL", "SA", "SD")  
trait_levels <- c("SS", "St", "NSC")

# Prepare data for heatmap - THIS HAS THE BUG
dat.corr <- corr_data %>%
  mutate(
    stoma = factor(stoma, levels = stoma_levels),
    trait = factor(trait, levels = trait_levels),
    # BUG: x0 and y0 assignments are swapped!
    x0 = as.numeric(stoma),  # This should be trait 
    y0 = as.numeric(trait)   # This should be stoma
  )

# Create the heatmap with ellipses and text
p <- ggplot(dat.corr) +
  # BUG: coordinate mappings are incorrect in geom_ellipse
  geom_ellipse(aes(x0 = y0, y0 = x0, a = abs(correlation), 
                   b = abs(correlation) * 0.8, 
                   angle = 0, fill = correlation), 
               alpha = 0.7) +
  # BUG: coordinate mappings are incorrect in geom_text  
  geom_text(aes(x = y0, y = x0, label = round(correlation, 3)), 
            size = 3, color = "black") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, name = "Correlation") +
  scale_x_continuous(breaks = 1:length(trait_levels), 
                     labels = trait_levels, name = "Trait") +
  scale_y_continuous(breaks = 1:length(stoma_levels), 
                     labels = stoma_levels, name = "Stoma") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Correlation Heatmap (Buggy Version)")

# Print the plot
print(p)

# Save the plot
ggsave("heatmap_buggy.png", plot = p, width = 8, height = 6, dpi = 300)

# Print correlation data for verification
print("Correlation data from CSV:")
print(corr_data)

# Print processed data for debugging
print("Processed dat.corr data (shows the bug):")
print(dat.corr)