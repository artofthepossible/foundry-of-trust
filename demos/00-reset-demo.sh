#!/bin/bash

# Demo Script: Reset POM to Original State (Demonstrate Vulnerability Introduction)
# Purpose: Reset pom.xml to its original state to show the vulnerability management process
# This demonstrates the "before" state with known CVEs that need to be addressed

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Demo configuration
DEMO_NAME="Reset Demo - Restore Original POM (with CVEs)"
ORIGINAL_POM="demos/pom-original.xml"
CURRENT_POM="pom.xml"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}${DEMO_NAME}${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if we're in the right directory
if [[ ! -f "pom.xml" ]]; then
    echo -e "${RED}❌ Error: pom.xml not found. Please run from project root.${NC}"
    exit 1
fi

if [[ ! -f "${ORIGINAL_POM}" ]]; then
    echo -e "${RED}❌ Error: Original POM backup not found at ${ORIGINAL_POM}${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Demo Overview:${NC}"
echo "This script resets the pom.xml to its original state (before security fixes)"
echo "to demonstrate the vulnerability management process from the beginning."
echo ""
echo -e "${RED}⚠️  WARNING: This will introduce known CVEs for demonstration purposes!${NC}"
echo ""

# Show current dependency status
echo -e "${BLUE}🔍 Current Security Status (FIXED):${NC}"
echo "Checking current dependency versions..."

# Check current versions
if mvn dependency:list 2>/dev/null | grep -E "(tomcat-embed-core|logback-classic)" | head -2; then
    echo ""
else
    echo "Unable to check current dependencies"
fi

echo ""
read -p "Continue with reset? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Demo cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}🔄 Resetting pom.xml to original state...${NC}"

# Backup current (fixed) pom.xml
echo "Creating backup of current (fixed) pom.xml..."
cp "${CURRENT_POM}" "demos/pom-fixed-backup.xml"
echo -e "${GREEN}✅ Current POM backed up to demos/pom-fixed-backup.xml${NC}"

# Replace with original POM
echo "Restoring original pom.xml (with vulnerabilities)..."
cp "${ORIGINAL_POM}" "${CURRENT_POM}"
echo -e "${GREEN}✅ POM reset to original state${NC}"

echo ""
echo -e "${BLUE}🧪 Testing reset state...${NC}"

# Clean and compile to ensure it works
echo "Cleaning and compiling with original dependencies..."
if mvn clean compile -q; then
    echo -e "${GREEN}✅ Compilation successful${NC}"
else
    echo -e "${RED}❌ Compilation failed${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}🔍 New Vulnerability Status (RESET):${NC}"
echo "Checking dependency versions after reset..."

# Check versions after reset
if mvn dependency:list 2>/dev/null | grep -E "(tomcat-embed-core|logback-classic)" | head -2; then
    echo ""
else
    echo "Dependencies will use Spring Boot parent versions (with known CVEs)"
fi

echo ""
echo -e "${RED}⚠️  VULNERABILITY STATUS AFTER RESET:${NC}"
echo "• org.apache.tomcat.embed:tomcat-embed-core: Using Spring Boot default (~10.1.44)"
echo "• ch.qos.logback:logback-classic: Using Spring Boot default (~1.5.19)" 
echo "• org.springframework:spring-*: Using Spring Boot default (~6.2.11)"
echo ""
echo -e "${YELLOW}📝 Next Steps for Demo:${NC}"
echo "1. Run vulnerability scanning tools to detect CVEs"
echo "2. Run '../scripts/fix-app.sh' to apply security fixes"
echo "3. Use 'mvn versions:display-dependency-updates' to check for updates"
echo "4. Compare before/after security posture"
echo ""

# Option to run basic vulnerability check
echo -e "${BLUE}🔍 Optional: Run quick vulnerability check?${NC}"
read -p "Check for available dependency updates? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Checking for dependency updates...${NC}"
    mvn versions:display-dependency-updates -Dincludes="org.apache.tomcat.embed:tomcat-embed-core,ch.qos.logback:logback-classic,org.springframework:spring-core" 2>/dev/null | grep -E "(tomcat-embed-core|logback-classic|spring-core)" || echo "Run full update check with: mvn versions:display-dependency-updates"
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}✅ Reset Demo Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}📊 Demo Results:${NC}"
echo "• POM reset to original state with known vulnerabilities"
echo "• Current POM backed up to demos/pom-fixed-backup.xml"
echo "• Project ready for vulnerability demonstration workflow"
echo ""
echo -e "${BLUE}🚀 Ready for Next Demo Steps:${NC}"
echo "• Run vulnerability scanning"
echo "• Apply security fixes with fix-app script"  
echo "• Compare security posture before/after"
echo ""
echo -e "${RED}⚠️  Remember: This is for demonstration only!${NC}"
echo -e "${RED}   Restore security fixes before production use.${NC}"
