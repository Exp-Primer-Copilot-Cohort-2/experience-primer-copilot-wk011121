# Test Script: Demonstrating Original Problems vs Corrected Solutions
# ==================================================================

cat("=== STOMATAL ANALYSIS PROBLEM DEMONSTRATION ===\n\n")

# Setup test data
set.seed(123)
matrix.var <- matrix(runif(80), nrow = 5, ncol = 16)
actual_vars <- c("SL", "SD", "SPI", "gmax", "LMA")
rownames(matrix.var) <- actual_vars

cat("Test data setup:\n")
cat("- Matrix dimensions:", dim(matrix.var), "\n")
cat("- Actual row names:", rownames(matrix.var), "\n\n")

# ==================================================================
# DEMONSTRATE THE ORIGINAL PROBLEMS
# ==================================================================

cat("=== ORIGINAL PROBLEMATIC APPROACH ===\n")

# Problem 1: Using non-existent variable names
cat("\n1. Testing access to non-existent variables 'SW' and 'SS':\n")

# This would cause an error in the original code:
problematic_vars <- c("SW", "SS")
cat("Attempting to access variables:", paste(problematic_vars, collapse = ", "), "\n")

# Check if these variables exist
missing_vars <- problematic_vars[!problematic_vars %in% rownames(matrix.var)]
if(length(missing_vars) > 0) {
  cat("✗ ERROR: Variables not found:", paste(missing_vars, collapse = ", "), "\n")
  cat("  This would cause: 'subscript out of bounds' error\n")
} else {
  cat("✓ Variables found\n")
}

# Problem 2: Mismatch between extracted rows and defined variables
cat("\n2. Testing matrix dimension mismatch:\n")
old_level_stoma <- c("SL", "SD", "SPI", "gmax")  # Missing LMA
cat("Old level.stoma definition:", paste(old_level_stoma, collapse = ", "), "\n")
cat("Number of variables defined:", length(old_level_stoma), "\n")
cat("Matrix rows available:", nrow(matrix.var), "\n")

if(length(old_level_stoma) != nrow(matrix.var)) {
  cat("✗ ERROR: Mismatch between defined variables (", length(old_level_stoma), 
      ") and matrix rows (", nrow(matrix.var), ")\n")
  cat("  This would cause indexing problems\n")
} else {
  cat("✓ Dimensions match\n")
}

# ==================================================================
# DEMONSTRATE THE CORRECTED APPROACH
# ==================================================================

cat("\n=== CORRECTED APPROACH ===\n")

# Solution 1: Use actual variable names
cat("\n1. Using actual existing variables:\n")
corrected_vars <- actual_vars
cat("Corrected variables:", paste(corrected_vars, collapse = ", "), "\n")

# Validate variables exist
missing_vars <- corrected_vars[!corrected_vars %in% rownames(matrix.var)]
if(length(missing_vars) > 0) {
  cat("✗ ERROR: Variables not found:", paste(missing_vars, collapse = ", "), "\n")
} else {
  cat("✓ All variables found in matrix\n")
  
  # Safe extraction
  extracted_data <- matrix.var[corrected_vars, ]
  cat("✓ Successfully extracted data for", nrow(extracted_data), "variables\n")
}

# Solution 2: Proper dimension alignment
cat("\n2. Corrected dimension handling:\n")
corrected_level_stoma <- c("SL", "SD", "SPI", "gmax", "LMA")  # All 5 variables
cat("Corrected level.stoma:", paste(corrected_level_stoma, collapse = ", "), "\n")
cat("Number of variables defined:", length(corrected_level_stoma), "\n")
cat("Matrix rows available:", nrow(matrix.var), "\n")

if(length(corrected_level_stoma) == nrow(matrix.var)) {
  cat("✓ Perfect dimension match\n")
  cat("✓ Can safely extract all", length(corrected_level_stoma), "variables\n")
} else {
  cat("✗ Still have dimension mismatch\n")
}

# ==================================================================
# VALIDATION FUNCTION DEMONSTRATION
# ==================================================================

cat("\n=== VALIDATION FUNCTION DEMONSTRATION ===\n")

#' Enhanced validation function
validate_stomatal_variables <- function(matrix_data, variable_names) {
  cat("\nValidating variables:", paste(variable_names, collapse = ", "), "\n")
  
  # Check if matrix exists
  if(is.null(matrix_data) || !is.matrix(matrix_data)) {
    cat("✗ Invalid matrix data\n")
    return(FALSE)
  }
  
  # Check dimensions
  if(nrow(matrix_data) != length(variable_names)) {
    cat("✗ Dimension mismatch: matrix has", nrow(matrix_data), 
        "rows but", length(variable_names), "variables specified\n")
    return(FALSE)
  }
  
  # Check variable existence
  missing <- variable_names[!variable_names %in% rownames(matrix_data)]
  if(length(missing) > 0) {
    cat("✗ Missing variables:", paste(missing, collapse = ", "), "\n")
    return(FALSE)
  }
  
  # Check data quality
  if(any(is.na(matrix_data))) {
    cat("⚠ Warning: Matrix contains NA values\n")
  }
  
  cat("✓ All validations passed\n")
  return(TRUE)
}

# Test validation with problematic variables
cat("\nTesting with problematic variables:")
validate_stomatal_variables(matrix.var, c("SW", "SS"))

# Test validation with corrected variables  
cat("\nTesting with corrected variables:")
result <- validate_stomatal_variables(matrix.var, corrected_level_stoma)

if(result) {
  cat("\n✓ Ready for analysis with corrected variables\n")
  
  # Demonstrate successful analysis
  analysis_data <- matrix.var[corrected_level_stoma, ]
  variable_means <- apply(analysis_data, 1, mean)
  
  cat("\nExample analysis results:\n")
  for(var in names(variable_means)) {
    cat(sprintf("  %s: mean = %.3f\n", var, variable_means[var]))
  }
}

# ==================================================================
# SUMMARY
# ==================================================================

cat("\n=== SUMMARY OF FIXES ===\n")
cat("✓ Problem 1 FIXED: Replaced 'SW', 'SS' with actual variables 'SL', 'SD', 'SPI', 'gmax', 'LMA'\n")
cat("✓ Problem 2 FIXED: Updated level.stoma to include all 5 variables\n")
cat("✓ Problem 3 FIXED: Added comprehensive validation functions\n")
cat("✓ Problem 4 FIXED: Enhanced error handling and debugging\n")
cat("✓ Problem 5 FIXED: Ensured matrix dimensions match variable count\n")

cat("\n=== TEST COMPLETED ===\n")