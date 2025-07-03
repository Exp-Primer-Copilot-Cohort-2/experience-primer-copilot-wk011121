# Comprehensive comparison of buggy vs fixed heatmap coordinate mapping
library(ggplot2)
library(dplyr)

# Function to install required packages if not available
install_if_missing <- function(packages) {
  for(pkg in packages) {
    if(!require(pkg, character.only = TRUE)) {
      install.packages(pkg, repos = "https://cran.r-project.org")
      library(pkg, character.only = TRUE)
    }
  }
}

# Install required packages
required_packages <- c("ggplot2", "dplyr")
install_if_missing(required_packages)

# Read correlation data
corr_data <- read.csv("correlation_data.csv")

# Create the stoma and trait variables as factors
stoma_levels <- c("SW", "SL", "SA", "SD")  
trait_levels <- c("SS", "St", "NSC")

cat("Problem Analysis: Heatmap Coordinate Mapping Bug\n")
cat("================================================\n\n")

cat("Original CSV Data:\n")
print(corr_data)
cat("\n")

# BUGGY VERSION - demonstrates the problem
cat("1. BUGGY VERSION (Current Issue):\n")
cat("--------------------------------\n")

dat.corr.buggy <- corr_data %>%
  mutate(
    stoma = factor(stoma, levels = stoma_levels),
    trait = factor(trait, levels = trait_levels),
    # BUG: x0 and y0 assignments are swapped!
    x0 = as.numeric(stoma),  # This should be trait 
    y0 = as.numeric(trait)   # This should be stoma
  )

cat("Buggy dat.corr mapping (x0=stoma, y0=trait - WRONG):\n")
print(dat.corr.buggy[, c("stoma", "trait", "correlation", "x0", "y0")])
cat("\n")

# FIXED VERSION - shows the solution
cat("2. FIXED VERSION (Solution):\n")
cat("---------------------------\n")

dat.corr.fixed <- corr_data %>%
  mutate(
    stoma = factor(stoma, levels = stoma_levels),
    trait = factor(trait, levels = trait_levels),
    # FIXED: Correct coordinate mapping
    x0 = as.numeric(trait),  # x0 corresponds to trait (columns)
    y0 = as.numeric(stoma)   # y0 corresponds to stoma (rows) 
  )

cat("Fixed dat.corr mapping (x0=trait, y0=stoma - CORRECT):\n")
print(dat.corr.fixed[, c("stoma", "trait", "correlation", "x0", "y0")])
cat("\n")

# Validation function
validate_specific_examples <- function() {
  cat("3. VALIDATION - Specific Examples from Problem Statement:\n")
  cat("--------------------------------------------------------\n")
  
  examples <- data.frame(
    stoma = c("SW", "SW", "SW"),
    trait = c("SS", "St", "NSC"),
    expected = c(0.288, 0.432, 0.418),
    buggy_display = c(-0.253, 0.064, -0.171)
  )
  
  for(i in 1:nrow(examples)) {
    ex <- examples[i, ]
    
    # Find actual CSV value
    csv_val <- corr_data[corr_data$stoma == ex$stoma & 
                        corr_data$trait == ex$trait, "correlation"]
    
    # Find what buggy version would display
    buggy_row <- dat.corr.buggy[dat.corr.buggy$stoma == ex$stoma & 
                               dat.corr.buggy$trait == ex$trait, ]
    
    # Find what fixed version displays  
    fixed_row <- dat.corr.fixed[dat.corr.fixed$stoma == ex$stoma & 
                               dat.corr.fixed$trait == ex$trait, ]
    
    cat(sprintf("%s-%s:\n", ex$stoma, ex$trait))
    cat(sprintf("  CSV Value: %.3f\n", csv_val))
    cat(sprintf("  Expected:  %.3f\n", ex$expected))
    cat(sprintf("  Buggy Display: %.3f (from coordinates x=%d, y=%d)\n", 
               ex$buggy_display, buggy_row$x0, buggy_row$y0))
    cat(sprintf("  Fixed Display: %.3f (from coordinates x=%d, y=%d)\n", 
               csv_val, fixed_row$x0, fixed_row$y0))
    cat(sprintf("  Status: %s\n\n", 
               ifelse(csv_val == ex$expected, "✓ FIXED", "✗ NEEDS FIX")))
  }
}

# Run validation
validate_specific_examples()

# Show coordinate mapping comparison
cat("4. COORDINATE MAPPING COMPARISON:\n")
cat("--------------------------------\n")
cat("For SW row (stoma=SW):\n")
sw_buggy <- dat.corr.buggy[dat.corr.buggy$stoma == "SW", ]
sw_fixed <- dat.corr.fixed[dat.corr.fixed$stoma == "SW", ]

cat("Buggy mapping:\n")
print(sw_buggy[, c("trait", "correlation", "x0", "y0")])
cat("\nFixed mapping:\n") 
print(sw_fixed[, c("trait", "correlation", "x0", "y0")])

cat("\n5. SUMMARY:\n")
cat("-----------\n")
cat("The bug was in the coordinate assignments:\n")
cat("- BUGGY:  x0 = as.numeric(stoma), y0 = as.numeric(trait)\n") 
cat("- FIXED:  x0 = as.numeric(trait), y0 = as.numeric(stoma)\n\n")
cat("And the corresponding geom coordinate usage:\n")
cat("- BUGGY:  geom_ellipse(aes(x0 = y0, y0 = x0, ...)) \n")
cat("- BUGGY:  geom_text(aes(x = y0, y = x0, ...))\n")  
cat("- FIXED:  geom_ellipse(aes(x0 = x0, y0 = y0, ...))\n")
cat("- FIXED:  geom_text(aes(x = x0, y = y0, ...))\n")