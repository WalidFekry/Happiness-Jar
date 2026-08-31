package com.jar.happiness

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HappinessJarWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        
        // Intent for background refresh (happens every hour or when triggered)
        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("happinessjar://update_message")
        )

        // Intent to open the main app
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

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.jar_widget_layout)
            
            val messageText = widgetData.getString("message_text", "رسالتك اليوم من البرطمان..")
            views.setTextViewText(R.id.widget_message, messageText)
            
            // Clicking the whole widget opens the app
            views.setOnClickPendingIntent(R.id.widget_root, openAppPendingIntent)
            
            // Also trigger a background update in parallel if desired, 
            // but standard behavior is opening the app.
            // If you want BOTH, you'd need a more complex setup. 
            // Usually, opening the app is what users expect.

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
