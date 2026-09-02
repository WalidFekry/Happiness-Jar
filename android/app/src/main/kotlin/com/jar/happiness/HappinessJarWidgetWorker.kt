package com.jar.happiness

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import org.json.JSONArray

class HappinessJarWidgetWorker(
    private val context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        // home_widget uses "HomeWidgetPreferences" for SharedPreferences
        val sharedPrefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        
        val messageListJson = sharedPrefs.getString("message_list", null)
        val messageIndex = sharedPrefs.getInt("message_index", 0)

        if (messageListJson != null) {
            try {
                val jsonArray = JSONArray(messageListJson)
                if (jsonArray.length() > 0) {
                    // Increment and save index for next time (modulo size)
                    val nextIndex = (messageIndex + 1) % jsonArray.length()
                    sharedPrefs.edit().putInt("message_index", nextIndex).apply()
                    
                    // Trigger Provider update to show the message at the NEW index
                    triggerProviderUpdate()
                }
            } catch (e: Exception) {
                return Result.failure()
            }
        }
        
        return Result.success()
    }

    private fun triggerProviderUpdate() {
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val componentName = ComponentName(context, HappinessJarWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
        
        if (appWidgetIds.isNotEmpty()) {
            val intent = Intent(context, HappinessJarWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
            }
            context.sendBroadcast(intent)
        }
    }
}
