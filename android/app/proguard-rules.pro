-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Hive için gerekli kurallar
-keep class * extends hive.TypeAdapter { *; }
-keep class * implements hive.HiveObject { *; }
-keep class * extends hive.HiveObject { *; }
-keepclassmembers class * extends hive.HiveObject {
    <fields>;
}