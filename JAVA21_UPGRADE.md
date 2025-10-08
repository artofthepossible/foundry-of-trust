# Java 21 Upgrade Guide

## 🎯 Current Status
- **Before**: Java 17 (Maven configuration) + Java 21 (Docker images) - **MISMATCH**
- **After**: Java 21 (Maven configuration) + Java 21 (Docker images) - **ALIGNED** ✅

## 🚀 Update Mechanisms Applied

### 1. **Maven Configuration Updates**
- ✅ Updated `<java.version>` from 17 to 21
- ✅ Added explicit compiler source/target/release properties
- ✅ Enhanced Maven compiler plugin configuration
- ✅ Added Surefire plugin for Java 21 testing

### 2. **Docker Configuration** (Already Correct)
- ✅ Using `dhi-temurin:21-jdk-alpine3.21-dev` for build stage
- ✅ Using `dhi-temurin:21_whale` for runtime stage

## 🔧 Validation Steps

### Local Testing
```bash
# 1. Verify Maven uses Java 21
./mvnw --version

# 2. Clean and rebuild
./mvnw clean compile

# 3. Run tests
./mvnw test

# 4. Package application
./mvnw package

# 5. Build Docker image
docker build -t foundry-test:java21 .

# 6. Run container and check Java version
docker run --rm foundry-test:java21 java -version
```

### CI/CD Integration
```bash
# Use the existing GitHub Action workflow - it will automatically use Java 21
git add .
git commit -m "upgrade: Update to Java 21"
git push origin main
```

## 🎉 Java 21 Features You Can Now Use

### **1. Pattern Matching (Preview in 21)**
```java
// Before (Java 17)
if (obj instanceof String) {
    String s = (String) obj;
    return s.length();
}

// After (Java 21)
if (obj instanceof String s) {
    return s.length();
}
```

### **2. Virtual Threads (Preview in 21)**
```java
// Spring Boot configuration for virtual threads
@Bean
public TomcatProtocolHandlerCustomizer<?> protocolHandlerVirtualThreadExecutorCustomizer() {
    return protocolHandler -> {
        protocolHandler.setExecutor(Executors.newVirtualThreadPerTaskExecutor());
    };
}
```

### **3. Record Patterns (Preview in 21)**
```java
public record Point(int x, int y) {}

// Pattern matching with records
public String describePoint(Object obj) {
    return switch (obj) {
        case Point(var x, var y) -> "Point at (%d, %d)".formatted(x, y);
        default -> "Not a point";
    };
}
```

### **4. String Templates (Preview in 21)**
```java
// Enhanced string formatting
String name = "World";
String message = STR."Hello, \{name}!";
```

## ⚠️ Important Notes

### **Preview Features**
- Some Java 21 features are preview features
- Added `--enable-preview` flag in Maven configuration (optional)
- Remove preview flags for production if not using preview features

### **Spring Boot Compatibility**
- ✅ Spring Boot 3.2.10 fully supports Java 21
- ✅ All your dependencies are compatible with Java 21

### **Performance Benefits**
- **ZGC Improvements**: Better garbage collection
- **Virtual Threads**: Improved concurrency for web applications
- **Performance Enhancements**: General JVM optimizations

## 🔄 Rollback Plan

If issues arise, you can quickly rollback:

```xml
<!-- In pom.xml, change back to: -->
<java.version>17</java.version>
<maven.compiler.source>17</maven.compiler.source>
<maven.compiler.target>17</maven.compiler.target>
<maven.compiler.release>17</maven.compiler.release>
```

## 🧪 Testing Checklist

- [ ] Application builds successfully
- [ ] All tests pass
- [ ] Docker image builds without errors
- [ ] Application starts correctly in container
- [ ] Health check endpoints respond
- [ ] VEX document embedding still works
- [ ] SBOM generation includes Java 21 components
- [ ] GitHub Actions workflow completes successfully

## 📊 Verification Commands

```bash
# Check Java version in built application
./mvnw spring-boot:run &
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/info

# Check Docker container Java version
docker run --rm demonstrationorg/foundry-of-trust:latest java -version

# Verify SBOM includes Java 21
docker scout sbom demonstrationorg/foundry-of-trust:latest | grep -i "java\|jdk\|jre"
```

## 🎯 Next Steps

1. **Test the build**: Run `./mvnw clean package` to verify compilation
2. **Update documentation**: Update README files to reflect Java 21 usage
3. **Consider Java 21 features**: Evaluate which new features benefit your application
4. **Monitor performance**: Compare application performance metrics
5. **Update VEX documents**: Consider if Java 21 affects any CVE statements