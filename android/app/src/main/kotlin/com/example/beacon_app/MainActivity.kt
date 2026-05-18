package com.example.beacon_app

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val googleMapsChannel = "beacon/google_maps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            googleMapsChannel
        ).setMethodCallHandler { call, result ->
            if (call.method != "open") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val latitude = call.argument<Double>("latitude")
            val longitude = call.argument<Double>("longitude")
            if (latitude == null || longitude == null) {
                result.error("INVALID_COORDINATE", "Missing map coordinate.", null)
                return@setMethodCallHandler
            }

            result.success(openGoogleMaps(latitude, longitude))
        }
    }

    private fun openGoogleMaps(latitude: Double, longitude: Double): Boolean {
        val coordinate = "$latitude,$longitude"
        val geoUri = Uri.parse("geo:0,0?q=$coordinate")
        val mapsIntent = Intent(Intent.ACTION_VIEW, geoUri).apply {
            setPackage("com.google.android.apps.maps")
        }

        return try {
            if (mapsIntent.resolveActivity(packageManager) != null) {
                startActivity(mapsIntent)
            } else {
                val webUri =
                    Uri.parse("https://www.google.com/maps/search/?api=1&query=$coordinate")
                startActivity(Intent(Intent.ACTION_VIEW, webUri))
            }
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }
}
