#!/bin/bash

# Security validation script for K8s Platform Modules
# This script performs basic security checks on the Terraform modules

set -e

echo "🔍 Running Security Validation for K8s Platform Modules"
echo "======================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Function to print results
print_result() {
    local status=$1
    local message=$2
    case $status in
        "PASS")
            echo -e "${GREEN}✓ PASS${NC}: $message"
            ((PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}✗ FAIL${NC}: $message"
            ((FAILED++))
            ;;
        "WARN")
            echo -e "${YELLOW}⚠ WARN${NC}: $message"
            ((WARNINGS++))
            ;;
    esac
}

echo "1. Checking for hardcoded secrets..."
# Check for potential secrets in .tf files
if grep -r "secret.*=.*\"[A-Za-z0-9+/=]\{20,\}\"" --include="*.tf" . > /dev/null 2>&1; then
    print_result "FAIL" "Potential hardcoded secrets found in Terraform files"
    echo "   Run: grep -r \"secret.*=.*\\\"[A-Za-z0-9+/=]\\{20,\\}\\\"\" --include=\"*.tf\" . for details"
else
    print_result "PASS" "No obvious hardcoded secrets detected"
fi

echo
echo "2. Checking for wildcard IAM permissions..."
# Check for overly permissive IAM policies
if grep -r "\".*:\*\"" --include="*.tf" . | grep -v "pricing:GetProducts\|ce:GetCostAndUsage" > /dev/null 2>&1; then
    print_result "WARN" "Wildcard IAM permissions detected - review for least privilege"
    echo "   Consider restricting permissions to specific resources"
else
    print_result "PASS" "No wildcard IAM permissions found"
fi

echo
echo "3. Checking for missing security contexts..."
MODULES_WITH_HELM=$(find . -name "templates" -type d | wc -l)
MODULES_WITH_SECURITY=$(grep -r "securityContext\|runAsNonRoot" --include="*.yaml" . | wc -l)

if [ "$MODULES_WITH_SECURITY" -lt "$MODULES_WITH_HELM" ]; then
    print_result "WARN" "Some Helm templates may be missing security contexts"
    echo "   Found $MODULES_WITH_SECURITY security contexts for $MODULES_WITH_HELM modules with templates"
else
    print_result "PASS" "Security contexts appear to be properly configured"
fi

echo
echo "4. Checking for network policies..."
if find . -name "*network-policy*" -type f | grep -q .; then
    print_result "PASS" "Network policy templates found"
else
    print_result "WARN" "No network policy templates found - consider adding for defense in depth"
fi

echo
echo "5. Checking for encryption configurations..."
ENCRYPTION_CONFIGS=$(grep -r "encryption\|encrypted" --include="*.tf" . | wc -l)
if [ "$ENCRYPTION_CONFIGS" -gt 0 ]; then
    print_result "PASS" "Encryption configurations found ($ENCRYPTION_CONFIGS instances)"
else
    print_result "FAIL" "No encryption configurations found - data should be encrypted at rest"
fi

echo
echo "6. Checking for Terraform format..."
if terraform fmt -check -recursive . > /dev/null 2>&1; then
    print_result "PASS" "All Terraform files are properly formatted"
else
    print_result "FAIL" "Terraform files need formatting - run 'terraform fmt -recursive .'"
fi

echo
echo "7. Checking for resource tags..."
MODULES_COUNT=$(find . -name "main.tf" | wc -l)
MODULES_WITH_TAGS=$(grep -l "tags.*=" $(find . -name "*.tf") | wc -l)

if [ "$MODULES_WITH_TAGS" -ge "$((MODULES_COUNT / 2))" ]; then
    print_result "PASS" "Good tagging coverage found ($MODULES_WITH_TAGS/$MODULES_COUNT modules)"
else
    print_result "WARN" "Consider adding consistent resource tagging across all modules"
fi

echo
echo "8. Checking for version constraints..."
MODULES_WITH_VERSIONS=$(find . -name "versions.tf" | wc -l)
ALL_MODULES=$(find . -type d -name "k8s-platform-*" | wc -l)

if [ "$MODULES_WITH_VERSIONS" -eq "$ALL_MODULES" ]; then
    print_result "PASS" "All modules have version constraints ($MODULES_WITH_VERSIONS/$ALL_MODULES)"
else
    print_result "FAIL" "Missing version constraints in some modules ($MODULES_WITH_VERSIONS/$ALL_MODULES)"
fi

echo
echo "9. Checking for backup configurations..."
BACKUP_CONFIGS=$(grep -r "backup\|retention\|snapshot" --include="*.tf" . | wc -l)
if [ "$BACKUP_CONFIGS" -gt 0 ]; then
    print_result "PASS" "Backup/retention configurations found ($BACKUP_CONFIGS instances)"
else
    print_result "WARN" "Consider adding backup and retention policies for critical data"
fi

echo
echo "10. Checking for monitoring configurations..."
MONITORING_CONFIGS=$(grep -r "prometheus\|grafana\|metrics" --include="*.tf" --include="*.yaml" . | wc -l)
if [ "$MONITORING_CONFIGS" -gt 5 ]; then
    print_result "PASS" "Monitoring configurations found ($MONITORING_CONFIGS instances)"
else
    print_result "WARN" "Consider adding more comprehensive monitoring configurations"
fi

echo
echo "======================================================="
echo "🔍 Security Validation Summary:"
echo -e "${GREEN}✓ Passed: $PASSED${NC}"
echo -e "${YELLOW}⚠ Warnings: $WARNINGS${NC}"
echo -e "${RED}✗ Failed: $FAILED${NC}"

if [ "$FAILED" -eq 0 ]; then
    echo -e "\n${GREEN}🛡️ Overall security posture: GOOD${NC}"
    echo "Address any warnings to further improve security."
    exit 0
else
    echo -e "\n${RED}🚨 Overall security posture: NEEDS ATTENTION${NC}"
    echo "Please address the failed checks before deploying to production."
    exit 1
fi