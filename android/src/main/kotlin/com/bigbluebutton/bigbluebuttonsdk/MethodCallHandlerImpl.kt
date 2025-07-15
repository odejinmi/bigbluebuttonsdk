package com.bigbluebutton.bigbluebuttonsdk

import android.Manifest
import android.app.Activity
import android.app.Activity.RESULT_OK
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioManager
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat.*
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat

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
    }

    private var channel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private var eventchannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null


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

            else -> result.notImplemented()
        }
    }

    /**
     * this is the call back that is invoked when the activity result returns a value after calling
     * startActivityForResult().
     * @param data is the intent that has the bundle where we can get our result
     * @param requestCode if it matches with our REQUEST_CODE it means the result is the one we
     * asked for.
     * @param resultCode, it is okay if it equals [RESULT_OK]
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == 100 && resultCode == Activity.RESULT_OK) {
            // Handle your specific activity result here
        }
        return true
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
            val allGranted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }


            return true
        }
        return false
    }
}