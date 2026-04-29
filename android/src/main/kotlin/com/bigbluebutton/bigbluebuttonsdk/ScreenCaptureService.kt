package com.bigbluebutton.bigbluebuttonsdk

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.IBinder

import android.util.Log

class ScreenCaptureService : Service() {

    override fun onCreate() {
        super.onCreate()
        Log.d("ScreenCaptureService", "onCreate called")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("ScreenCaptureService", "onStartCommand called")
        val resultCode = intent?.getIntExtra("resultCode", 0) ?: 0
        val data = intent?.getParcelableExtra<Intent>("data")

        Log.d("ScreenCaptureService", "resultCode: $resultCode, data: $data")

        if (resultCode != android.app.Activity.RESULT_OK || data == null) {
            Log.e("ScreenCaptureService", "Invalid result code or data, stopping service")
            stopSelf()
            return START_NOT_STICKY
        }

        Log.d("ScreenCaptureService", "Starting foreground service with type MEDIA_PROJECTION")
        createNotification()
        return START_STICKY
    }

    private fun createNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "screen_capture_channel"
            val channelName = "Screen Capture"
            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW)
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)

            val notification: Notification = Notification.Builder(this, channelId)
                .setContentTitle("Screen Sharing")
                .setContentText("Your screen is being shared")
                .setSmallIcon(android.R.drawable.ic_media_play)
                .build()

            if (Build.VERSION.SDK_INT >= 29) {
                startForeground(1, notification, android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION)
            } else {
                startForeground(1, notification)
            }
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
