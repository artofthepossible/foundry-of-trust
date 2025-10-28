#!/bin/bash

# fix-app - Script to fix application-layer vulnerability dependencies
# This script updates Maven dependencies to address security vulnerabilities

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script information
SCRIPT_NAME="fix-app"
VERSION="1.0.0"

# Vulnerability fixes to apply
LOGBACK_PROPERTY="logback.version"
LOGBACK_NEW_VERSION="1.5.19"

SPRING_PROPERTY="spring-framework.version"
SPRING_NEW_VERSION="6.2.11"

# Function to print colored output
print_status() {
    local level="$1"
    local message="$2"
    case "$level" in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
    esac
}

# Function to show usage
show_usage() {
    cat << EOF
$SCRIPT_NAME v$VERSION - Fix application-layer Maven dependency vulnerabilities

USAGE:
    $SCRIPT_NAME [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -d, --dry-run       Show what would be changed without making changes
    -v, --verbose       Enable verbose output
    -b, --backup        Create backup of pom.xml before changes
    --no-compile        Skip Maven compilation after applying fixes

FIXES APPLIED:
    • ch.qos.logback/logback-core: 1.5.13 → 1.5.19
    • org.springframework/spring-core: 6.2.10 → 6.2.11

EXAMPLES:
    $SCRIPT_NAME                    # Apply fixes and compile project
    $SCRIPT_NAME --dry-run          # Show what would be changed
    $SCRIPT_NAME --backup           # Create backup before applying fixes
    $SCRIPT_NAME --no-compile       # Skip compilation after applying fixes

EOF
}

# Function to check if pom.xml exists
check_pom_exists() {
    if [[ ! -f "pom.xml" ]]; then
        print_status "ERROR" "pom.xml not found in current directory"
        print_status "INFO" "Please run this script from the project root directory"
        exit 1
    fi
}

# Function to create backup
create_backup() {
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="pom.xml.backup.$timestamp"
    
    cp pom.xml "$backup_file"
    print_status "SUCCESS" "Backup created: $backup_file"
}

# Function to check current versions
check_current_versions() {
    print_status "INFO" "Checking current dependency versions..."
    
    # Check logback version
    local logback_current
    logback_current=$(grep -o "<$LOGBACK_PROPERTY>[^<]*</$LOGBACK_PROPERTY>" pom.xml | sed "s/<$LOGBACK_PROPERTY>\(.*\)<\/$LOGBACK_PROPERTY>/\1/" || echo "NOT_FOUND")
    
    if [[ "$logback_current" != "NOT_FOUND" ]]; then
        print_status "INFO" "Current $LOGBACK_PROPERTY: $logback_current"
    else
        print_status "WARNING" "Property $LOGBACK_PROPERTY not found in pom.xml"
    fi
    
    # Check Spring Framework version
    local spring_current
    spring_current=$(grep -o "<$SPRING_PROPERTY>[^<]*</$SPRING_PROPERTY>" pom.xml | sed "s/<$SPRING_PROPERTY>\(.*\)<\/$SPRING_PROPERTY>/\1/" || echo "NOT_FOUND")
    
    if [[ "$spring_current" != "NOT_FOUND" ]]; then
        print_status "INFO" "Current $SPRING_PROPERTY: $spring_current"
    else
        print_status "WARNING" "Property $SPRING_PROPERTY not found in pom.xml"
    fi
}

# Function to apply fixes
apply_fixes() {
    local dry_run="$1"
    local changes_made=0
    
    print_status "INFO" "Applying vulnerability fixes..."
    
    # Fix logback version
    local logback_current
    logback_current=$(grep -o "<$LOGBACK_PROPERTY>[^<]*</$LOGBACK_PROPERTY>" pom.xml | sed "s/<$LOGBACK_PROPERTY>\(.*\)<\/$LOGBACK_PROPERTY>/\1/" || echo "NOT_FOUND")
    
    if [[ "$logback_current" == "NOT_FOUND" ]]; then
        print_status "WARNING" "Property $LOGBACK_PROPERTY not found in pom.xml - skipping"
    elif [[ "$logback_current" == "$LOGBACK_NEW_VERSION" ]]; then
        print_status "INFO" "$LOGBACK_PROPERTY is already at version $LOGBACK_NEW_VERSION"
    else
        if [[ "$dry_run" == "true" ]]; then
            print_status "INFO" "[DRY RUN] Would update $LOGBACK_PROPERTY: $logback_current → $LOGBACK_NEW_VERSION"
        else
            if sed -i.tmp "s|<$LOGBACK_PROPERTY>$logback_current</$LOGBACK_PROPERTY>|<$LOGBACK_PROPERTY>$LOGBACK_NEW_VERSION</$LOGBACK_PROPERTY>|g" pom.xml; then
                rm -f pom.xml.tmp
                print_status "SUCCESS" "Updated $LOGBACK_PROPERTY: $logback_current → $LOGBACK_NEW_VERSION"
                ((changes_made++))
            else
                print_status "ERROR" "Failed to update $LOGBACK_PROPERTY"
                rm -f pom.xml.tmp
                exit 1
            fi
        fi
    fi
    
    # Fix Spring Framework version
    local spring_current
    spring_current=$(grep -o "<$SPRING_PROPERTY>[^<]*</$SPRING_PROPERTY>" pom.xml | sed "s/<$SPRING_PROPERTY>\(.*\)<\/$SPRING_PROPERTY>/\1/" || echo "NOT_FOUND")
    
    if [[ "$spring_current" == "NOT_FOUND" ]]; then
        print_status "WARNING" "Property $SPRING_PROPERTY not found in pom.xml - skipping"
    elif [[ "$spring_current" == "$SPRING_NEW_VERSION" ]]; then
        print_status "INFO" "$SPRING_PROPERTY is already at version $SPRING_NEW_VERSION"
    else
        if [[ "$dry_run" == "true" ]]; then
            print_status "INFO" "[DRY RUN] Would update $SPRING_PROPERTY: $spring_current → $SPRING_NEW_VERSION"
        else
            if sed -i.tmp "s|<$SPRING_PROPERTY>$spring_current</$SPRING_PROPERTY>|<$SPRING_PROPERTY>$SPRING_NEW_VERSION</$SPRING_PROPERTY>|g" pom.xml; then
                rm -f pom.xml.tmp
                print_status "SUCCESS" "Updated $SPRING_PROPERTY: $spring_current → $SPRING_NEW_VERSION"
                ((changes_made++))
            else
                print_status "ERROR" "Failed to update $SPRING_PROPERTY"
                rm -f pom.xml.tmp
                exit 1
            fi
        fi
    fi
    
    if [[ "$dry_run" == "false" && $changes_made -gt 0 ]]; then
        print_status "SUCCESS" "Applied $changes_made vulnerability fixes to pom.xml"
        print_status "INFO" "You should now run: mvn clean compile"
        print_status "INFO" "Or rebuild your Docker image to apply the fixes"
    elif [[ "$dry_run" == "false" && $changes_made -eq 0 ]]; then
        print_status "INFO" "No changes needed - all dependencies are up to date"
    fi
}

# Function to validate the updated pom.xml
validate_pom() {
    if command -v mvn >/dev/null 2>&1; then
        print_status "INFO" "Validating pom.xml syntax..."
        if mvn validate -q; then
            print_status "SUCCESS" "pom.xml validation passed"
        else
            print_status "ERROR" "pom.xml validation failed"
            return 1
        fi
    else
        print_status "WARNING" "Maven not found - skipping pom.xml validation"
    fi
}

# Function to compile the project
compile_project() {
    if command -v mvn >/dev/null 2>&1; then
        print_status "INFO" "Compiling project with updated dependencies..."
        if mvn clean compile -q; then
            print_status "SUCCESS" "Project compiled successfully with updated dependencies"
        else
            print_status "ERROR" "Project compilation failed with updated dependencies"
            print_status "INFO" "You may need to resolve compatibility issues manually"
            return 1
        fi
    else
        print_status "WARNING" "Maven not found - skipping project compilation"
        print_status "INFO" "Please run 'mvn clean compile' manually to verify the fixes"
    fi
}

# Main function
main() {
    local dry_run="false"
    local verbose="false"
    local create_backup_flag="false"
    local compile_flag="true"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -d|--dry-run)
                dry_run="true"
                shift
                ;;
            -v|--verbose)
                verbose="true"
                shift
                ;;
            -b|--backup)
                create_backup_flag="true"
                shift
                ;;
            --no-compile)
                compile_flag="false"
                shift
                ;;
            *)
                print_status "ERROR" "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Enable verbose output if requested
    if [[ "$verbose" == "true" ]]; then
        set -x
    fi
    
    print_status "INFO" "Starting $SCRIPT_NAME v$VERSION"
    
    # Check prerequisites
    check_pom_exists
    
    # Show current versions
    check_current_versions
    
    # Create backup if requested
    if [[ "$create_backup_flag" == "true" && "$dry_run" == "false" ]]; then
        create_backup
    fi
    
    # Apply fixes
    apply_fixes "$dry_run"
    
    # Validate if not dry run
    if [[ "$dry_run" == "false" ]]; then
        validate_pom
        
        # Compile project if not skipped
        if [[ "$compile_flag" == "true" ]]; then
            compile_project
        else
            print_status "INFO" "Compilation skipped (--no-compile flag used)"
        fi
    fi
    
    print_status "SUCCESS" "$SCRIPT_NAME completed successfully"
}

# Run main function with all arguments
main "$@"