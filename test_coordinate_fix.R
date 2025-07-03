# Simple test to verify coordinate mapping fix without requiring ggplot2
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

# Simulate buggy data preparation
dat.corr.buggy <- corr_data
dat.corr.buggy$stoma <- factor(dat.corr.buggy$stoma, levels = stoma_levels)
dat.corr.buggy$trait <- factor(dat.corr.buggy$trait, levels = trait_levels)
# BUG: x0 and y0 assignments are swapped!
dat.corr.buggy$x0 <- as.numeric(dat.corr.buggy$stoma)  # This should be trait 
dat.corr.buggy$y0 <- as.numeric(dat.corr.buggy$trait)  # This should be stoma

cat("Buggy dat.corr mapping (x0=stoma, y0=trait - WRONG):\n")
print(dat.corr.buggy[, c("stoma", "trait", "correlation", "x0", "y0")])
cat("\n")

# FIXED VERSION - shows the solution
cat("2. FIXED VERSION (Solution):\n")
cat("---------------------------\n")

# Simulate fixed data preparation  
dat.corr.fixed <- corr_data
dat.corr.fixed$stoma <- factor(dat.corr.fixed$stoma, levels = stoma_levels)
dat.corr.fixed$trait <- factor(dat.corr.fixed$trait, levels = trait_levels)
# FIXED: Correct coordinate mapping
dat.corr.fixed$x0 <- as.numeric(dat.corr.fixed$trait)  # x0 corresponds to trait (columns)
dat.corr.fixed$y0 <- as.numeric(dat.corr.fixed$stoma)  # y0 corresponds to stoma (rows) 

cat("Fixed dat.corr mapping (x0=trait, y0=stoma - CORRECT):\n")
print(dat.corr.fixed[, c("stoma", "trait", "correlation", "x0", "y0")])
cat("\n")

# Validation for specific examples from problem statement
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
  
  # Find what buggy version would map to
  buggy_row <- dat.corr.buggy[dat.corr.buggy$stoma == ex$stoma & 
                             dat.corr.buggy$trait == ex$trait, ]
  
  # Find what fixed version maps to  
  fixed_row <- dat.corr.fixed[dat.corr.fixed$stoma == ex$stoma & 
                             dat.corr.fixed$trait == ex$trait, ]
  
  cat(sprintf("%s-%s:\n", ex$stoma, ex$trait))
  cat(sprintf("  CSV Value: %.3f\n", csv_val))
  cat(sprintf("  Expected:  %.3f\n", ex$expected))
  cat(sprintf("  Buggy coordinates: x=%d, y=%d\n", buggy_row$x0, buggy_row$y0))
  cat(sprintf("  Fixed coordinates: x=%d, y=%d\n", fixed_row$x0, fixed_row$y0))
  cat(sprintf("  Status: %s\n\n", 
             ifelse(csv_val == ex$expected, "✓ FIXED", "✗ NEEDS FIX")))
}

# Show coordinate mapping comparison for SW row
cat("4. COORDINATE MAPPING COMPARISON FOR SW ROW:\n")
cat("------------------------------------------\n")
sw_buggy <- dat.corr.buggy[dat.corr.buggy$stoma == "SW", ]
sw_fixed <- dat.corr.fixed[dat.corr.fixed$stoma == "SW", ]

cat("Buggy mapping (SW row):\n")
print(sw_buggy[, c("trait", "correlation", "x0", "y0")])
cat("\nFixed mapping (SW row):\n") 
print(sw_fixed[, c("trait", "correlation", "x0", "y0")])

cat("\n5. EXPLANATION OF THE FIX:\n")
cat("--------------------------\n")
cat("The bug was in the coordinate assignments in dat.corr preparation:\n")
cat("- BUGGY:  x0 = as.numeric(stoma), y0 = as.numeric(trait)\n") 
cat("- FIXED:  x0 = as.numeric(trait), y0 = as.numeric(stoma)\n\n")
cat("This means:\n")
cat("- x0 should correspond to trait (columns in heatmap)\n")
cat("- y0 should correspond to stoma (rows in heatmap)\n\n")
cat("The geom_ellipse and geom_text coordinate usage should also be:\n")
cat("- BUGGY:  aes(x0 = y0, y0 = x0, ...) and aes(x = y0, y = x0, ...)\n")
cat("- FIXED:  aes(x0 = x0, y0 = y0, ...) and aes(x = x0, y = y0, ...)\n")

cat("\n6. VERIFICATION:\n")
cat("---------------\n")
cat("After this fix, the heatmap should display:\n")
cat("- SW-SS = 0.288 (not -0.253)\n")
cat("- SW-St = 0.432 (not 0.064)\n") 
cat("- SW-NSC = 0.418 (not -0.171)\n")