plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.timesmed_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.timesmed_project"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    lint {
        checkReleaseBuilds = false
    }

    flavorDimensions += "app"
    productFlavors {
        create("doctor") {
            dimension = "app"
            applicationId = "com.timesmed.timesmed_project.doctor"
            versionCode = flutter.versionCode
            versionName = flutter.versionName
        }

        create("patient") {
            dimension = "app"
            applicationId = "com.timesmed.timesmed_project.patient"
            versionCode = flutter.versionCode
            versionName = flutter.versionName
        }

        create("superApp") {
            dimension = "app"
            applicationId = "com.timesmed.timesmed_project"
            versionCode = flutter.versionCode
            versionName = flutter.versionName
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
