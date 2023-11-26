package backend;

//link: https://github.com/Tw1ddle/samcodes-notifications
#if android
import extension.notifications.Notifications;

class NotificationsExtend{

// Android uses the importance of a notification to determine how much the notification should interrupt the user (visually and audibly). The higher the importance of a notification, the more interruptive the notification will be.
// Mirrors NotificationImportance constants from Android 8.0 (API level 26)

/*
@:enum abstract NotificationImportance(Int)
{
	var NONE = 0;
	var MIN = 1;
	var LOW = 2;
	var DEFAULT = 3;
	var HIGH = 4;
	var MAX = 5;
}
*/


	// Note, keeping these methods separate since even the common parameters here serve pretty different purposes
	// It would be better to wrap these methods if you use them a lot, as they might change in the future
	// See the demo project here for usage examples: https://github.com/Tw1ddle/samcodes-notifications-demo
	
	/**
	   Schedules a local notification on Android
	   @param	slot The slot index of the notification (you should define a set of values for these using an enum abstract)
	   @param	triggerAfterSecs The number of seconds until the notification will be presented
	   @param	titleText The title text shown in the notification
	   @param	subtitleText The subtitle text shown in the notification
	   @param	messageBodyText The body/message text shown in the notification
	   @param	tickerText The ticker/status bar text shown in the notification (likely to be what's read by accessibility services too)
	   @param	incrementBadgeCount Whether to increment the application badge count when the notification is triggered
	   @param	isOngoing Whether the notification is the "ongoing" (persistent) notification type
	   @param	smallIconName The name of the small icon resource to show with the notification, will use generic icon if empty or null
	   @param	largeIconName The name of the large icon resource to show with the notification, will use application or generic icon if empty or null
	   @param	channelId Identifier for the channel that the notification will be assigned to. Starting in Android 8.0, notifications must be assigned a channel or they do not appear.
	   @param	channelName The display name of the channel that the notification will be assigned to.
	   @param	channelDescription The descriptive text for the channel that the notification will be assigned to.
	   @param	importance The importance of the notification. The higher the importance, the more interruptive the notification will be. Note this can only be set once per channel (i.e. the first time it's set, it sticks).
	**/
	public static function scheduleLocalNotification(slot:Int, triggerAfterSecs:Float, titleText:String, subtitleText:String, messageBodyText:String, tickerText:String, incrementBadgeCount:Bool, isOngoing:Bool, smallIconName:String, largeIconName:String, channelId:String, channelName:String, channelDescription:String, channelImportance:Int):Void {
		Notifications.scheduleLocalNotification(slot, triggerAfterSecs, titleText, subtitleText, messageBodyText, tickerText, incrementBadgeCount, isOngoing, smallIconName, largeIconName, channelId, channelName, channelDescription, channelImportance);
	}
	
	public static function cancelLocalNotification(slot:Int):Void {
		Notifications.cancelLocalNotification(slot);
	}
	
	public static function cancelLocalNotifications():Void {
		Notifications.cancelLocalNotification();
	}
	
	public static function getApplicationIconBadgeNumber():Int {
		Notifications.getApplicationIconBadgeNumber();
	}
	
	public static function setApplicationIconBadgeNumber(number:Int):Bool {
		Notifications.setApplicationIconBadgeNumber(number);
	}
}
#end