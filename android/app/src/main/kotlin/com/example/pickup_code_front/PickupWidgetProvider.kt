package com.example.pickup_code_front

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class PickupWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.pickup_widget)
            val pendingCount = widgetData.getInt("widget_pending_count", 0)
            views.setTextViewText(R.id.widget_count, "${pendingCount} 件待取")
            val listIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("pickup://list")
            )
            views.setOnClickPendingIntent(R.id.widget_container, listIntent)

            var visibleItems = 0
            for (index in 0..2) {
                val codeDisplay = widgetData.getString(codeDisplayKey(index), "") ?: ""
                val codeRaw = widgetData.getString(codeRawKey(index), "") ?: ""
                val station = widgetData.getString(stationKey(index), "") ?: ""
                val expire = widgetData.getString(expireKey(index), "") ?: ""
                val itemId = itemContainerId(index)
                val codeId = itemCodeId(index)
                val metaId = itemMetaId(index)

                if (codeDisplay.isBlank()) {
                    views.setViewVisibility(itemId, View.GONE)
                    continue
                }
                visibleItems += 1
                views.setViewVisibility(itemId, View.VISIBLE)
                views.setTextViewText(codeId, codeDisplay)
                val meta = buildMeta(station, expire)
                views.setTextViewText(metaId, meta)
                val intent = if (codeRaw.isBlank()) {
                    listIntent
                } else {
                    val encodedCode = Uri.encode(codeRaw)
                    HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("pickup://detail?code=$encodedCode")
                    )
                }
                views.setOnClickPendingIntent(itemId, intent)
            }

            if (visibleItems == 0) {
                views.setViewVisibility(R.id.widget_empty, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_empty, View.GONE)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun buildMeta(station: String, expire: String): String {
        val stationText = station.trim()
        val expireText = expire.trim()
        if (stationText.isNotEmpty() && expireText.isNotEmpty()) {
            return "$stationText · $expireText"
        }
        return stationText.ifEmpty { expireText }
    }

    private fun codeDisplayKey(index: Int): String {
        return "widget_item_${index}_code_display"
    }

    private fun codeRawKey(index: Int): String {
        return "widget_item_${index}_code_raw"
    }

    private fun stationKey(index: Int): String {
        return "widget_item_${index}_station"
    }

    private fun expireKey(index: Int): String {
        return "widget_item_${index}_expire"
    }

    private fun itemContainerId(index: Int): Int {
        return when (index) {
            0 -> R.id.widget_item_1
            1 -> R.id.widget_item_2
            else -> R.id.widget_item_3
        }
    }

    private fun itemCodeId(index: Int): Int {
        return when (index) {
            0 -> R.id.widget_item_1_code
            1 -> R.id.widget_item_2_code
            else -> R.id.widget_item_3_code
        }
    }

    private fun itemMetaId(index: Int): Int {
        return when (index) {
            0 -> R.id.widget_item_1_meta
            1 -> R.id.widget_item_2_meta
            else -> R.id.widget_item_3_meta
        }
    }
}
