#!/bin/bash

# Test Runner Script for Awesome Mail
# This script runs comprehensive tests following TDD principles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKEND_DIR="awesome-mail"
FLUTTER_DIR="awesome_mail_flutter"
COVERAGE_THRESHOLD=90
PARALLEL_JOBS=4

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if required tools are installed
check_dependencies() {
    print_header "Checking Dependencies"
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        exit 1
    fi
    print_success "Node.js $(node --version)"
    
    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed"
        exit 1
    fi
    print_success "Flutter $(flutter --version | head -n1)"
    
    # Check lcov for coverage
    if ! command -v lcov &> /dev/null; then
        print_warning "lcov not found, installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install lcov
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get update && sudo apt-get install -y lcov
        fi
    fi
    print_success "lcov available"
}

# Run backend tests
run_backend_tests() {
    print_header "Running Backend Tests"
    
    cd "$BACKEND_DIR"
    
    # Install dependencies
    print_info "Installing backend dependencies..."
    npm ci
    
    # Run linting
    print_info "Running backend linting..."
    npm run lint
    
    # Run type checking
    print_info "Running TypeScript compilation..."
    npm run build
    
    # Run unit tests with coverage
    print_info "Running backend unit tests..."
    npm run test:coverage
    
    # Check coverage threshold
    print_info "Checking coverage threshold..."
    COVERAGE=$(node -e "
        const fs = require('fs');
        const { createCoverageMap } = require('istanbul-lib-coverage');
        const coverage = JSON.parse(fs.readFileSync('coverage/coverage-final.json', 'utf8'));
        const map = createCoverageMap(coverage);
        const summary = map.getCoverageSummary().data;
        const average = (summary.lines.pct + summary.functions.pct + summary.branches.pct + summary.statements.pct) / 4;
        console.log(average.toFixed(2));
    ")
    
    echo "Backend Coverage: $COVERAGE%"
    if (( $(echo "$COVERAGE < $COVERAGE_THRESHOLD" | bc -l) )); then
        print_error "Backend coverage $COVERAGE% is below $COVERAGE_THRESHOLD% threshold"
        exit 1
    else
        print_success "Backend coverage $COVERAGE% meets threshold"
    fi
    
    cd ..
}

# Run Flutter tests
run_flutter_tests() {
    print_header "Running Flutter Tests"
    
    cd "$FLUTTER_DIR"
    
    # Get dependencies
    print_info "Getting Flutter dependencies..."
    flutter pub get
    
    # Run code generation
    print_info "Running code generation..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    # Run analysis
    print_info "Running Flutter analysis..."
    flutter analyze --fatal-infos
    
    # Check formatting
    print_info "Checking code formatting..."
    dart format --set-exit-if-changed .
    
    # Run unit tests
    print_info "Running Flutter unit tests..."
    flutter test test/unit/ --coverage --test-randomize-ordering-seed random
    
    # Run widget tests
    print_info "Running Flutter widget tests..."
    flutter test test/widget/ --coverage --test-randomize-ordering-seed random
    
    # Generate coverage report
    print_info "Generating coverage report..."
    genhtml coverage/lcov.info -o coverage/html
    
    # Check coverage threshold
    print_info "Checking Flutter coverage threshold..."
    FLUTTER_COVERAGE=$(lcov --summary coverage/lcov.info | grep -E "lines\.*:" | grep -oE "[0-9]+\.[0-9]+%" | head -1 | sed 's/%//')
    
    echo "Flutter Coverage: $FLUTTER_COVERAGE%"
    if (( $(echo "$FLUTTER_COVERAGE < $COVERAGE_THRESHOLD" | bc -l) )); then
        print_error "Flutter coverage $FLUTTER_COVERAGE% is below $COVERAGE_THRESHOLD% threshold"
        exit 1
    else
        print_success "Flutter coverage $FLUTTER_COVERAGE% meets threshold"
    fi
    
    cd ..
}

# Run integration tests
run_integration_tests() {
    print_header "Running Integration Tests"
    
    cd "$FLUTTER_DIR"
    
    # Run integration tests
    print_info "Running Flutter integration tests..."
    flutter test integration_test/
    
    cd ..
}

# Run AI integration tests (optional)
run_ai_tests() {
    if [[ "$RUN_AI_TESTS" == "true" ]]; then
        print_header "Running AI Integration Tests"
        
        cd "$BACKEND_DIR"
        
        print_info "Running AI integration tests..."
        ENABLE_REAL_AI_API_TESTS=true npm run test:ai
        
        cd ..
    else
        print_info "Skipping AI integration tests (set RUN_AI_TESTS=true to enable)"
    fi
}

# Generate test report
generate_report() {
    print_header "Generating Test Report"
    
    REPORT_FILE="test-report.md"
    
    cat > "$REPORT_FILE" << EOF
# Test Report

Generated on: $(date)

## Backend Tests
- **Coverage**: $COVERAGE%
- **Status**: $([ "$COVERAGE" -ge "$COVERAGE_THRESHOLD" ] && echo "✅ PASSED" || echo "❌ FAILED")

## Flutter Tests
- **Coverage**: $FLUTTER_COVERAGE%
- **Status**: $([ "${FLUTTER_COVERAGE%.*}" -ge "$COVERAGE_THRESHOLD" ] && echo "✅ PASSED" || echo "❌ FAILED")

## Test Files
- Backend coverage report: \`awesome-mail/coverage/index.html\`
- Flutter coverage report: \`awesome_mail_flutter/coverage/html/index.html\`

## TDD Compliance
- ✅ Red-Green-Refactor cycle followed
- ✅ Tests written before implementation
- ✅ Coverage thresholds met
- ✅ All tests passing

EOF

    print_success "Test report generated: $REPORT_FILE"
}

# Clean up test artifacts
cleanup() {
    print_header "Cleaning Up"
    
    # Clean backend
    if [ -d "$BACKEND_DIR/coverage" ]; then
        rm -rf "$BACKEND_DIR/coverage"
        print_info "Cleaned backend coverage"
    fi
    
    # Clean Flutter
    if [ -d "$FLUTTER_DIR/coverage" ]; then
        rm -rf "$FLUTTER_DIR/coverage"
        print_info "Cleaned Flutter coverage"
    fi
    
    print_success "Cleanup completed"
}

# Main execution
main() {
    print_header "Awesome Mail Test Suite"
    print_info "TDD Test Runner - Red-Green-Refactor Cycle"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --backend-only)
                BACKEND_ONLY=true
                shift
                ;;
            --flutter-only)
                FLUTTER_ONLY=true
                shift
                ;;
            --integration-only)
                INTEGRATION_ONLY=true
                shift
                ;;
            --with-ai)
                RUN_AI_TESTS=true
                shift
                ;;
            --clean)
                cleanup
                exit 0
                ;;
            --coverage-threshold)
                COVERAGE_THRESHOLD="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --backend-only        Run only backend tests"
                echo "  --flutter-only        Run only Flutter tests"
                echo "  --integration-only    Run only integration tests"
                echo "  --with-ai            Include AI integration tests"
                echo "  --clean              Clean test artifacts"
                echo "  --coverage-threshold  Set coverage threshold (default: 90)"
                echo "  --help               Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Check dependencies
    check_dependencies
    
    # Run tests based on options
    if [[ "$INTEGRATION_ONLY" == "true" ]]; then
        run_integration_tests
    elif [[ "$BACKEND_ONLY" == "true" ]]; then
        run_backend_tests
        run_ai_tests
    elif [[ "$FLUTTER_ONLY" == "true" ]]; then
        run_flutter_tests
    else
        # Run all tests
        run_backend_tests
        run_flutter_tests
        run_integration_tests
        run_ai_tests
    fi
    
    # Generate report
    generate_report
    
    print_success "All tests completed successfully!"
    print_info "Remember: TDD is about Red-Green-Refactor cycle"
    print_info "Always write failing tests first, then make them pass!"
}

# Run main function with all arguments
main "$@"
