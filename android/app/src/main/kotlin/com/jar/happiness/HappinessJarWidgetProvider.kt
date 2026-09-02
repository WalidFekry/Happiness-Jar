package com.jar.happiness

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import androidx.work.*
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import java.util.concurrent.TimeUnit

class HappinessJarWidgetProvider : HomeWidgetProvider() {

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        scheduleWidgetUpdate(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        WorkManager.getInstance(context).cancelUniqueWork("happiness_jar_widget_update")
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        
        // 1. Prepare App Launch Intent
        val openAppIntent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_MAIN
            addCategory(Intent.CATEGORY_LAUNCHER)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        
        val openAppPendingIntent = PendingIntent.getActivity(
            context,
            0,
            openAppIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // 2. Logic to pick CURRENT message from the cached list
        val messageListJson = widgetData.getString("message_list", null)
        val messageIndex = widgetData.getInt("message_index", 0)
        
        var currentMessage = widgetData.getString("message_text", "برطمان السعادة يتمنى لك يوماً سعيداً")

        if (messageListJson != null) {
            try {
                val jsonArray = JSONArray(messageListJson)
                if (jsonArray.length() > 0) {
                    // Use modulo in case index went out of bounds
                    val safeIndex = if (messageIndex < 0 || messageIndex >= jsonArray.length()) 0 else messageIndex
                    currentMessage = jsonArray.getString(safeIndex)
                }
            } catch (e: Exception) {
                // Keep default or current message if parsing fails
            }
        }

        // 3. Update all widgets
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.jar_widget_layout)
            
            views.setTextViewText(R.id.widget_message, currentMessage)
            views.setOnClickPendingIntent(R.id.widget_root, openAppPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        
        // Ensure WorkManager is scheduled whenever we update
        scheduleWidgetUpdate(context)
    }

    private fun scheduleWidgetUpdate(context: Context) {
        val workRequest =
            PeriodicWorkRequestBuilder<HappinessJarWidgetWorker>(
                15,
                TimeUnit.MINUTES
            ).build()
        
        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            "happiness_jar_widget_update",
            ExistingPeriodicWorkPolicy.KEEP,
            workRequest
        )
    }
}
