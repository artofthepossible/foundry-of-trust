# Testcontainers Integration Demo

## Quick Start

Run the complete demo:
```bash
./demos/03-testcontainers.sh
```

## Manual Commands

```bash
# 1. Compile first to make sure everything is working
mvn compile test-compile

# 2. Run just the integration test
mvn test -Dtest=ApplicationIntegrationTest

# 3. Run all tests
mvn test
```

## What Gets Tested

✅ **Application Launch Validation** - Spring Boot app starts successfully  
✅ **GitHub Link Verification** - "Get it on GitHub" link is present  
✅ **Testcontainers Integration** - Redis container demonstrates functionality

## Files Created

- **Script**: `demos/03-testcontainers.sh` - Automated demo with colored output
- **Test**: `src/test/java/com/example/whale_of_a_time/ApplicationIntegrationTest.java` - Integration test
- **Documentation**: `docs/TESTCONTAINERS_README.md` - Complete technical documentation

## Expected Results

```
Tests run: 4, Failures: 0, Errors: 0, Skipped: 0

✅ applicationStartsSuccessfully() - App launches correctly
✅ githubLinkIsPresent() - "Get it on GitHub" link found  
✅ testcontainerIsWorking() - Testcontainers Redis container operational
✅ contextLoads() - Original Spring Boot test still works
```

## Benefits

- **Fast**: Tests complete in ~2-7 seconds total
- **Reliable**: Uses Testcontainers for consistent testing environment  
- **Simple**: Clean, focused test code that's easy to maintain
- **CI/CD Ready**: Works anywhere Docker is available

For detailed technical information, see `docs/TESTCONTAINERS_README.md`.