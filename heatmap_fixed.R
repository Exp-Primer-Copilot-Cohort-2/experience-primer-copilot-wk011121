# Heatmap visualization with coordinate mapping fix
library(ggplot2)
library(dplyr)

# Read correlation data
corr_data <- read.csv("correlation_data.csv")

# Create the stoma and trait variables as factors
stoma_levels <- c("SW", "SL", "SA", "SD")  
trait_levels <- c("SS", "St", "NSC")

# Prepare data for heatmap - FIXED VERSION
dat.corr <- corr_data %>%
  mutate(
    stoma = factor(stoma, levels = stoma_levels),
    trait = factor(trait, levels = trait_levels),
    # FIXED: Correct coordinate mapping
    x0 = as.numeric(trait),  # x0 corresponds to trait (columns)
    y0 = as.numeric(stoma)   # y0 corresponds to stoma (rows) 
  )

# Create the heatmap with ellipses and text
p <- ggplot(dat.corr) +
  # FIXED: Correct coordinate mappings in geom_ellipse
  geom_ellipse(aes(x0 = x0, y0 = y0, a = abs(correlation), 
                   b = abs(correlation) * 0.8, 
                   angle = 0, fill = correlation), 
               alpha = 0.7) +
  # FIXED: Correct coordinate mappings in geom_text  
  geom_text(aes(x = x0, y = y0, label = round(correlation, 3)), 
            size = 3, color = "black") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, name = "Correlation") +
  scale_x_continuous(breaks = 1:length(trait_levels), 
                     labels = trait_levels, name = "Trait") +
  scale_y_continuous(breaks = 1:length(stoma_levels), 
                     labels = stoma_levels, name = "Stoma") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Correlation Heatmap (Fixed Version)")

# Print the plot
print(p)

# Save the plot
ggsave("heatmap_fixed.png", plot = p, width = 8, height = 6, dpi = 300)

# Validation: Check that heatmap values match CSV data
print("Validation - Correlation data from CSV:")
print(corr_data)

print("Validation - Processed dat.corr data (fixed):")
print(dat.corr)

# Specific validation for SW row as mentioned in problem statement
sw_data <- dat.corr[dat.corr$stoma == "SW", ]
print("SW row data (should show SS=0.288, St=0.432, NSC=0.418):")
print(sw_data[, c("trait", "correlation")])

# Additional validation function
validate_heatmap_data <- function(corr_data, dat_corr) {
  cat("Validation Results:\n")
  cat("==================\n")
  
  for(i in 1:nrow(corr_data)) {
    csv_row <- corr_data[i, ]
    processed_row <- dat_corr[dat_corr$stoma == csv_row$stoma & 
                              dat_corr$trait == csv_row$trait, ]
    
    if(nrow(processed_row) == 1) {
      if(csv_row$correlation == processed_row$correlation) {
        cat(sprintf("✓ %s-%s: CSV=%.3f, Heatmap=%.3f (MATCH)\n", 
                   csv_row$stoma, csv_row$trait, 
                   csv_row$correlation, processed_row$correlation))
      } else {
        cat(sprintf("✗ %s-%s: CSV=%.3f, Heatmap=%.3f (MISMATCH)\n", 
                   csv_row$stoma, csv_row$trait, 
                   csv_row$correlation, processed_row$correlation))
      }
    } else {
      cat(sprintf("✗ %s-%s: Not found in processed data\n", 
                 csv_row$stoma, csv_row$trait))
    }
  }
}

# Run validation
validate_heatmap_data(corr_data, dat.corr)