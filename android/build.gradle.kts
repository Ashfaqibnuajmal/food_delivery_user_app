// -------------------------------
// Root-level build.gradle.kts
// (android/build.gradle.kts)
// -------------------------------

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Google Services classpath (needed for KTS builds)
        classpath("com.google.gms:google-services:4.4.4")
        classpath("com.android.tools.build:gradle:8.6.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")

    }
}

plugins {
    // Firebase Google Services plugin (KTS requires version)
    id("com.google.gms.google-services") version "4.4.4" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
