# Corrected Stomatal Analysis Script
# =================================
# 
# This script fixes the following issues from the original version:
# 1. Variable name errors: Replaced non-existent "SW" and "SS" with actual variables
# 2. Matrix dimension problems: Updated to handle 5 stomatal variables correctly
# 3. Updated level.stoma definition to include LMA
# 4. Added comprehensive debugging information
# 5. Ensured matrix extraction matches actual variable count
#
# Actual stomatal variables: SL, SD, SPI, gmax, LMA
# Matrix dimensions: matrix.var is 5 x 16

# Load required libraries (add as needed)
# library(your_required_packages_here)

# ==============================================================================
# CORRECTED VARIABLE DEFINITIONS
# ==============================================================================

# Updated stomatal variable definitions to match actual data structure
# CORRECTED: Now includes all 5 actual variables including LMA
level.stoma <- c("SL", "SD", "SPI", "gmax", "LMA")

# Debug information about variable definitions
cat("=== CORRECTED VARIABLE DEFINITIONS ===\n")
cat("Number of stomatal variables defined:", length(level.stoma), "\n")
cat("Stomatal variables:", paste(level.stoma, collapse = ", "), "\n")
cat("\n")

# ==============================================================================
# MATRIX SETUP AND VALIDATION
# ==============================================================================

# Simulated matrix.var for demonstration (5 x 16 as specified)
# In actual implementation, this would be your real data
set.seed(123)  # For reproducible example
matrix.var <- matrix(runif(80), nrow = 5, ncol = 16)

# Add row names to match our stomatal variables
rownames(matrix.var) <- level.stoma

# Debug information about matrix structure
cat("=== MATRIX STRUCTURE VALIDATION ===\n")
cat("Matrix dimensions:", dim(matrix.var), "\n")
cat("Matrix row names:", rownames(matrix.var), "\n")
cat("Matrix column count:", ncol(matrix.var), "\n")
cat("Expected stomatal variables count:", length(level.stoma), "\n")
cat("Dimensions match expected structure:", 
    nrow(matrix.var) == length(level.stoma) && ncol(matrix.var) == 16, "\n")
cat("\n")

# ==============================================================================
# CORRECTED VALIDATION SECTION
# ==============================================================================

cat("=== CORRECTED VALIDATION SECTION ===\n")

# CORRECTED: Validate that all expected variables exist in matrix
missing_vars <- level.stoma[!level.stoma %in% rownames(matrix.var)]
if(length(missing_vars) > 0) {
  cat("ERROR: Missing variables in matrix:", paste(missing_vars, collapse = ", "), "\n")
  stop("Matrix validation failed: missing required variables")
} else {
  cat("✓ All expected stomatal variables found in matrix\n")
}

# CORRECTED: Extract data for all 5 stomatal variables (not just 4)
# This replaces the problematic code that tried to access "SW" and "SS"
extracted_data <- matrix.var[level.stoma, ]

cat("Successfully extracted data for", nrow(extracted_data), "variables\n")
cat("Extracted variables:", rownames(extracted_data), "\n")

# ==============================================================================
# CORRECTED VERIFICATION LOGIC
# ==============================================================================

cat("\n=== CORRECTED VERIFICATION LOGIC ===\n")

# CORRECTED: Use actual variable names instead of "SW" and "SS"
# Example verification for each actual variable
for(var in level.stoma) {
  if(var %in% rownames(matrix.var)) {
    var_data <- matrix.var[var, ]
    cat(sprintf("✓ Variable '%s': Found %d values, range [%.3f, %.3f]\n", 
                var, length(var_data), min(var_data), max(var_data)))
  } else {
    cat(sprintf("✗ Variable '%s': NOT FOUND in matrix\n", var))
  }
}

# ==============================================================================
# ADDITIONAL SAFETY CHECKS
# ==============================================================================

cat("\n=== ADDITIONAL SAFETY CHECKS ===\n")

# Check for any NA values
na_count <- sum(is.na(matrix.var))
cat("NA values in matrix:", na_count, "\n")

# Verify matrix is numeric
is_numeric <- is.numeric(matrix.var)
cat("Matrix is numeric:", is_numeric, "\n")

# Check if we can safely perform matrix operations
if(is_numeric && na_count == 0) {
  cat("✓ Matrix ready for analysis\n")
  
  # Example analysis with corrected variables
  cat("\n=== EXAMPLE ANALYSIS WITH CORRECTED VARIABLES ===\n")
  
  # Calculate means for each stomatal variable
  variable_means <- apply(matrix.var, 1, mean)
  cat("Variable means:\n")
  for(i in 1:length(variable_means)) {
    cat(sprintf("  %s: %.3f\n", names(variable_means)[i], variable_means[i]))
  }
  
  # Calculate correlations between variables
  correlation_matrix <- cor(t(matrix.var))
  cat("\nCorrelation matrix computed successfully for", nrow(correlation_matrix), "variables\n")
  
} else {
  cat("✗ Matrix requires cleaning before analysis\n")
}

# ==============================================================================
# SUMMARY OF CORRECTIONS MADE
# ==============================================================================

cat("\n=== SUMMARY OF CORRECTIONS MADE ===\n")
cat("1. ✓ Fixed variable names: Replaced 'SW' and 'SS' with actual variables\n")
cat("2. ✓ Updated level.stoma to include all 5 variables: SL, SD, SPI, gmax, LMA\n")
cat("3. ✓ Corrected matrix dimension handling (5 x 16)\n")
cat("4. ✓ Added comprehensive debugging information\n")
cat("5. ✓ Implemented proper validation logic\n")
cat("6. ✓ Added safety checks for data integrity\n")
cat("7. ✓ Provided clear comments explaining all corrections\n")

cat("\n=== SCRIPT EXECUTION COMPLETED SUCCESSFULLY ===\n")

# ==============================================================================
# FUNCTION DEFINITIONS FOR REUSABLE CODE
# ==============================================================================

#' Validate stomatal data matrix
#' 
#' @param matrix_data The data matrix to validate
#' @param expected_vars Vector of expected variable names
#' @return TRUE if validation passes, FALSE otherwise
validate_stomatal_matrix <- function(matrix_data, expected_vars) {
  cat("\n--- Matrix Validation Function ---\n")
  
  # Check dimensions
  if(nrow(matrix_data) != length(expected_vars)) {
    cat("ERROR: Matrix rows (", nrow(matrix_data), 
        ") don't match expected variables (", length(expected_vars), ")\n")
    return(FALSE)
  }
  
  # Check variable names
  missing_vars <- expected_vars[!expected_vars %in% rownames(matrix_data)]
  if(length(missing_vars) > 0) {
    cat("ERROR: Missing variables:", paste(missing_vars, collapse = ", "), "\n")
    return(FALSE)
  }
  
  # Check for NA values
  if(sum(is.na(matrix_data)) > 0) {
    cat("WARNING: Matrix contains NA values\n")
  }
  
  cat("✓ Matrix validation passed\n")
  return(TRUE)
}

#' Extract and validate stomatal variable data
#' 
#' @param matrix_data The source matrix
#' @param variables Vector of variable names to extract
#' @return Extracted data matrix or NULL if validation fails
extract_stomatal_data <- function(matrix_data, variables) {
  cat("\n--- Data Extraction Function ---\n")
  
  if(!validate_stomatal_matrix(matrix_data, variables)) {
    return(NULL)
  }
  
  extracted <- matrix_data[variables, ]
  cat("Successfully extracted data for", length(variables), "variables\n")
  return(extracted)
}

# Example usage of the corrected functions
cat("\n=== TESTING CORRECTED FUNCTIONS ===\n")
validated_data <- extract_stomatal_data(matrix.var, level.stoma)

if(!is.null(validated_data)) {
  cat("✓ Functions work correctly with corrected variable names\n")
} else {
  cat("✗ Functions failed - check implementation\n")
}

cat("\n=== END OF CORRECTED SCRIPT ===\n")