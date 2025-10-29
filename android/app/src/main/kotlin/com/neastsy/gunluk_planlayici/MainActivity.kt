package com.neastsy.gunluk_planlayici

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // "Uçtan uca" (edge-to-edge) ekran modunu etkinleştir.
        // Bu, sistem çubuklarının (status bar, navigation bar) arkasına çizim yapmamızı sağlar.
        // Bu, super.onCreate'den ÖNCE çağrılmalıdır.
        WindowCompat.setDecorFitsSystemWindows(window, false)

        super.onCreate(savedInstanceState)
    }
}