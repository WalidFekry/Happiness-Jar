package com.jar.happiness

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HappinessJarWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        
        // This Intent will trigger the Flutter background callback
        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("happinessjar://update_message")
        )

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.jar_widget_layout)
            
            val messageText = widgetData.getString("message_text", "رسالتك اليوم من البرطمان..")
            views.setTextViewText(R.id.widget_message, messageText)
            
            // Trigger background update when clicking (as a bonus)
            views.setOnClickPendingIntent(R.id.widget_message, backgroundIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
