buildscript {
    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2") // ✅ Correct way
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: Customize build directory location
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
