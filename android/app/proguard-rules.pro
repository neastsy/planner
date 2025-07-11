# Flutter's default rules.
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# flutter_local_notifications için önerilen kurallar
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver

# Hive için gerekli kurallar
-keep class * extends hive.TypeAdapter { *; }
-keep class * implements hive.HiveObject { *; }
-keep class * extends hive.HiveObject { *; }
-keepclassmembers class * extends hive.HiveObject {
    <fields>;
}