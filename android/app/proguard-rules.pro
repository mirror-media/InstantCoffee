# ----------------------------
# Flutter 基本保留
# ----------------------------
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# MethodChannel / BasicMessageChannel
-keep class io.flutter.plugin.common.** { *; }

# Kotlin metadata
-keep class kotlin.Metadata { *; }

# Annotation
-keepattributes *Annotation*

# 保留泛型 / 簽名 / 類別結構資訊
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# ----------------------------
# Crashlytics / stack trace
# ----------------------------
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# ----------------------------
# Google Play Billing
# ----------------------------
-keep class com.android.billingclient.** { *; }

# ----------------------------
# Google Mobile Ads
# ----------------------------
-keep class com.google.android.gms.ads.** { *; }

# ----------------------------
# WebView / JavaScript interface
# ----------------------------
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# ----------------------------
# Facebook Login
# ----------------------------
-keep class com.facebook.** { *; }

# ----------------------------
# Google Sign-In / Google Play services auth
# ----------------------------
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.api.** { *; }

# ----------------------------
# Firebase
# ----------------------------
-keep class com.google.firebase.** { *; }

# ----------------------------
# Comscore
# ----------------------------
-keep class com.comscore.** { *; }

# ----------------------------
# Flutter deferred components / Play Core
# ----------------------------
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager
-dontwarn com.google.android.play.core.tasks.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**