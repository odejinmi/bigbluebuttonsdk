package com.bigbluebutton.bigbluebuttonsdk

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioManager
import android.media.projection.MediaProjectionManager
import android.os.Build
import androidx.core.content.ContextCompat.*

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


const val ERROR_CODE_PAYMENT_INITIALIZATION = "INIT_PAYMENT_ERROR"

class MethodCallHandlerImpl(
    messenger: BinaryMessenger?,
    private val binding: ActivityPluginBinding
) :
    MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener,
    PluginRegistry.RequestPermissionsResultListener, EventChannel.StreamHandler {

    companion object {
        private const val TAG = "MainActivity"
        private const val REQUEST_PERMISSIONS = 10
        private val REQUEST_MEDIA_PROJECTION = 1001
    }

    private var channel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private var eventchannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var pendingResult: MethodChannel.Result? = null


    init {

        channel = MethodChannel(messenger!!, "bigbluebuttonsdk")
        channel?.setMethodCallHandler(this)

        eventchannel = EventChannel(messenger, "bigbluebuttonsdkevent")
        eventchannel?.setStreamHandler(this)

        binding.addActivityResultListener(this)
        binding.addRequestPermissionsResultListener(this)

    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        this.result = result

        val audioManager = binding.activity.getSystemService(Context.AUDIO_SERVICE) as AudioManager

        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            "earpiece" -> {
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                audioManager.isSpeakerphoneOn = false
                result.success(null)
            }

            "speaker" -> {
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                audioManager.isSpeakerphoneOn = true
                result.success(null)
            }

            "bluetooth" -> {
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                audioManager.startBluetoothSco()
                audioManager.isBluetoothScoOn = true
                result.success(null)
            }

            "headset" -> {
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                audioManager.isSpeakerphoneOn = false
                result.success(null)
            }
            "stopForegroundService" -> {
                val stopIntent = Intent(binding.activity, ScreenCaptureService::class.java)
                binding.activity.stopService(stopIntent)
                result.success("Service stopped")
            }
            "startForegroundService" -> {
                if (binding.activity == null) {
                    result.error("NO_ACTIVITY", "Activity is null", null)
                    return
                }
                val projectionManager =
                    binding.activity.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
                val captureIntent = projectionManager.createScreenCaptureIntent()
                pendingResult = result
                binding.activity.startActivityForResult(captureIntent, REQUEST_MEDIA_PROJECTION)
//
//                val serviceIntent = Intent(binding.activity, ScreenCaptureService::class.java).apply {
//                    putExtra("resultCode", REQUEST_MEDIA_PROJECTION)
//                    putExtra("data", captureIntent)
//                }
//
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                    binding.activity.startForegroundService(serviceIntent)
//                } else {
//                    binding.activity.startService(serviceIntent)
//                }
//                result.success(pendingResult)

            }

            else -> result.notImplemented()
        }
    }


    /**
     * dispose the channel when this handler detaches from the activity
     */
    fun dispose() {
        channel?.setMethodCallHandler(null)
        channel = null
        eventchannel?.setStreamHandler(null)
        eventchannel = null
        binding.removeActivityResultListener(this)
        binding.removeRequestPermissionsResultListener(this)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == REQUEST_PERMISSIONS) {

            return true
        }
        return false
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_MEDIA_PROJECTION) {
            if (resultCode == RESULT_OK && data != null) {
                val serviceIntent = Intent(binding.activity, ScreenCaptureService::class.java).apply {
                    putExtra("resultCode", resultCode)
                    putExtra("data", data)
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    binding.activity.startForegroundService(serviceIntent)
                } else {
                    binding.activity.startService(serviceIntent)
                }

                pendingResult?.success("Permission granted and service started")
                pendingResult = null
            } else {
                pendingResult?.error("PERMISSION_DENIED", "User denied screen capture", null)
                pendingResult = null
            }
            return true
        }
        return false
    }
}