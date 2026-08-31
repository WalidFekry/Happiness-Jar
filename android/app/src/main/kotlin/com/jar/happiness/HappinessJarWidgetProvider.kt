package com.jar.happiness

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class HappinessJarWidgetProvider : HomeWidgetProvider() {

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

        // 2. Logic to pick next message from the cached list
        val messageListJson = widgetData.getString("message_list", null)
        var messageIndex = widgetData.getInt("message_index", 0)
        
        var currentMessage = widgetData.getString("message_text", "برطمان السعادة يتمنى لك يوماً سعيداً")

        if (messageListJson != null) {
            try {
                val jsonArray = JSONArray(messageListJson)
                if (jsonArray.length() > 0) {
                    // Ensure index is within bounds
                    if (messageIndex < 0 || messageIndex >= jsonArray.length()) {
                        messageIndex = 0
                    }
                    
                    currentMessage = jsonArray.getString(messageIndex)
                    
                    // Increment and save for next time
                    val nextIndex = (messageIndex + 1) % jsonArray.length()
                    widgetData.edit().putInt("message_index", nextIndex).apply()
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
    }
}
