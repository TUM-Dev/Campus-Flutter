package de.tum.`in`.tumcampus.widgets.calendar

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import de.tum.`in`.tumcampus.R
import java.util.Locale
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

class CalendarWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

private fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Instantiate the RemoteViews object for the app widget layout.
    val remoteViews = RemoteViews(context.packageName, R.layout.calendar_widget)

    // Set formatted date in the header
    val localDate = DateTime.now().toLocalDate()
    val date = DateTimeFormat.longDate().print(localDate)
    remoteViews.setTextViewText(R.id.timetable_widget_date, date)

    // Set weekday in the header
    val weekday = localDate.dayOfWeek().getAsText(Locale.getDefault())
    remoteViews.setTextViewText(R.id.timetable_widget_weekday, weekday)

    /*
    // Set up the configuration activity listeners
    val configIntent = Intent(context, TimetableWidgetConfigureActivity::class.java)
    configIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
    val pendingConfigIntent = PendingIntent.getActivity(
        context, appWidgetId, configIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
    remoteViews.setOnClickPendingIntent(R.id.timetable_widget_setting, pendingConfigIntent)

    // Set up the calendar activity listeners
    val calendarIntent = Intent(context, CalendarActivity::class.java)
    val pendingCalendarIntent = PendingIntent.getActivity(
        context, appWidgetId, calendarIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
    remoteViews.setOnClickPendingIntent(R.id.timetable_widget_header, pendingCalendarIntent)

    // Set up the calendar intent used when the user taps an event
    val eventIntent = Intent(context, CalendarActivity::class.java)
    eventIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
    val eventPendingIntent = PendingIntent.getActivity(
        context, appWidgetId, eventIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
    remoteViews.setPendingIntentTemplate(R.id.timetable_widget_listview, eventPendingIntent)
    */

    // Set up the intent that starts the TimetableWidgetService, which will
    // provide the departure times for this station
    val intent = Intent(context, CalendarWidgetService::class.java)
    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
    intent.data = Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME))
    remoteViews.setRemoteAdapter(R.id.timetable_widget_listview, intent)

    // The empty view is displayed when the collection has no items.
    // It should be in the same layout used to instantiate the RemoteViews
    // object above.
    remoteViews.setEmptyView(R.id.timetable_widget_listview, R.id.empty_list_item)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.timetable_widget_listview)
}
