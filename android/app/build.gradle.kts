import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Apply Google Services plugin so the Firebase initializer sees
    // android/app/google-services.json (Android OAuth client ids, etc.).
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keyPropsFile = rootProject.file("key.properties")
if (keyPropsFile.exists()) {
    FileInputStream(keyPropsFile).use { keystoreProperties.load(it) }
}

val hasReleaseKeystore = keystoreProperties.containsKey("storeFile") &&
    !keystoreProperties.getProperty("storeFile").isNullOrBlank()

android {
    namespace = "com.deutschy.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // The unique identifier for Deutschy on the Play Store.
        applicationId = "com.deutschy.app"
        // Firebase Auth requires minSdk 21+.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                val sf = keystoreProperties.getProperty("storeFile")
                storeFile = if (sf != null) file(sf) else null
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Real release signing when key.properties is present, else
            // fall back to the debug keystore so local `flutter build`
            // still produces an installable APK.
            if (hasReleaseKeystore) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false   // disabled for v1 to keep ProGuard rules minimal
            isShrinkResources = false
        }
        debug {
            // KEEP `applicationId` identical to release so the same
            // Firebase `google-services.json` `package_name` matches.
            // If you want a separate dev-installable build, copy
            // google-services.json with the `.debug` package name
            // *added* before enabling the suffix.
            versionNameSuffix = "-debug"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
