plugins {
    application
}

repositories {
    mavenCentral()
    // Custom GitLab repository for 'FDO Manager SDK' dependency
    maven {
        url = uri("https://gitlab.indiscale.com/api/v4/projects/229/packages/maven")
    }
    // Handle.net repository for the 'handle' dependency in 'FDO Manager SDK' dependency
    maven {
        url = uri("https://handle.net/maven/")
    }
}

dependencies {
    implementation(libs.guava)
    implementation(libs.fdo.manager.sdk)
    implementation(libs.dotenv)
    implementation(libs.jakarta.json)
    implementation(libs.jackson.databind)
    implementation(libs.jackson.datatype.jdk8)
    testImplementation(libs.junit.jupiter.api)
    testImplementation(libs.junit.jupiter.engine)
    testImplementation(libs.mockito.core)
    testImplementation(libs.mockito.junit.jupiter)
    testRuntimeOnly(libs.junit.platform.launcher)
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

application {
    mainClass.set("fdoassetfetcher.Main")
}

tasks.test {
    useJUnitPlatform()
}