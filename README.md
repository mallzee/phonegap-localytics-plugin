Localytics for PhoneGap/Cordova 3.x
========

## Installation

	cordova plugin add https://github.com/localytics/phonegap.git

## Integration

Analytics only integration (Option 1) can be done cross platform in your web app. Analytics + marketing (Option 2) requires platform specific native integration.

### Option 1: Cross platform (analytics only)

In your index.html, modify your \<body\> tag:

	<body onload="onLoad()">

Also in your index.html, add the following \<script\> block:

*Note*: replace \<YOUR_APP_KEY\> with your Localytics app key

	<script type="text/javascript">
        function onLoad() {
            document.addEventListener("deviceready", onDeviceReady, false);
            document.addEventListener("resume", onResume, false);
            document.addEventListener("pause", onPause, false);
        }
        function onDeviceReady() {
            Localytics.init("<YOUR_APP_KEY>");
            Localytics.resume();                
            Localytics.upload();
        }
        function onResume() {
            Localytics.resume();
            Localytics.upload();
        }
        function onPause() {
            Localytics.close();
            Localytics.upload();
        }
    </script>
    
### Option 2: Platform specific (analytics + marketing)

#### iOS

At the top of your app delegate, add the following import: 

	import "LocalyticsAmpSession.h"

In your app delegate's implementation, add the following code:

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		// ... existing code ...
	
		[[LocalyticsAmpSession shared] LocalyticsSession:@"<YOUR_APP_KEY>"];
	    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];	   
		[LocalyticsAmpSession shared] handleRemoteNotification:launchOptions]];
	   
	    return YES;
	}

	- (void)applicationDidBecomeActive:(UIApplication *)application
	{
		[[LocalyticsAmpSession shared] resume];
		[[LocalyticsAmpSession shared] upload];
	}
	
	- (void)applicationDidEnterBackground:(UIApplication *)application 
	{
		[[LocalyticsAmpSession shared] close];
		[[LocalyticsAmpSession shared] upload];
	}
	
	- (void)applicationWillEnterForeground:(UIApplication *)application 
	{
		[[LocalyticsAmpSession shared] resume];
		[[LocalyticsAmpSession shared] upload];
	}

	- (void)applicationWillTerminate:(UIApplication *)application 
	{
		[[LocalyticsAmpSession shared] close];
		[[LocalyticsAmpSession shared] upload];
	}
	
	- (void)applicationWillResignActive:(UIApplication *)application
	{
		[[LocalyticsAmpSession shared] close];
		[[LocalyticsAmpSession shared] upload];
	}
	
	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
	{
		[[LocalyticsAmpSession shared] setPushToken:deviceToken];
	}
	 
	- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
	{
		NSLog(@"Failed to register for remote notifications: %@", [error description]);
	}
	 
	- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
	{
		[[LocalyticsAmpSession shared] handleRemoteNotification:userInfo];
	}
	
#### Android

In your AndroidManifest.xml, add the following before your \<application\> tag:

*Note*: replace YOUR.PACKAGE.NAME with your package name, ie, com.yourcompany.yourapp
	
	<uses-permission android:name="android.permission.INTERNET" />
	<uses-permission android:name="android.permission.GET_ACCOUNTS" />
	<uses-permission android:name="android.permission.WAKE_LOCK" />   
	<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
	  
	<permission android:name="YOUR.PACKAGE.NAME.permission.C2D_MESSAGE"
	    android:protectionLevel="signature" />
	<uses-permission android:name="YOUR.PACKAGE.NAME.permission.C2D_MESSAGE" />
	
Inside your \<application\> tag, add: 

*Note*: replace \<YOUR_APP_KEY\> with your Localytics app key and YOUR.PACKAGE.NAME with your package name

	<receiver
	    android:name="com.localytics.android.PushReceiver"
	    android:permission="com.google.android.c2dm.permission.SEND" >
	    <intent-filter>
	        <action android:name="com.google.android.c2dm.intent.REGISTRATION" />
	        <action android:name="com.google.android.c2dm.intent.RECEIVE" />               
	        <category android:name="YOUR.PACKAGE.NAME" />
	    </intent-filter>
	</receiver>
	
	<meta-data android:name="LOCALYTICS_APP_KEY" android:value="<YOUR_APP_KEY>" />
	
At the top of your main activity, add the following import: 

	import com.localytics.android.*;
	
Add the session object as a private member variable inside your activity class:

	private LocalyticsAmpSession localyticsSession;
	
Inside your activity class, add or modify the following methods:

*Note*: replace \<YOUR_PROJECT_NUMBER\> with your GCM project number

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		// ... existing code ...
	 
		this.localyticsSession = new LocalyticsSession(this.getApplicationContext());
		this.localyticsSession.registerPush("<YOUR_PROJECT_NUMBER>");       
		this.localyticsSession.open();
		this.localyticsSession.handlePushReceived(getIntent());
		this.localyticsSession.upload();
	}
	
	@Override
	public void onResume()
	{
	    super.onResume();
	    this.localyticsSession.open();
	    this.localyticsSession.handlePushReceived(getIntent());
	    this.localyticsSession.upload();
	}	
	
	@Override
	public void onPause()
	{
	    this.localyticsSession.close();
	    this.localyticsSession.upload();
	    super.onPause();
	}
	
	@Override
	protected void onNewIntent(Intent intent)
	{
	    super.onNewIntent(intent);
	    setIntent(intent);
	} 	

## Instrumentation

Regardless of the integration option you chose, all instrumentation should be done inside the web app. 

### Event tagging

Anywhere in your application where an interesting event occurs you may tag it by adding the following line of code where “Options Saved” is a string describing the event:

	Localytics.tagEvent("Options Saved", null,  0);

For some events, it may be interesting to collect additional data about the event. Such as how many lives the player has, or what the last action the user took was before clicking on an advertisement. This is accomplished with the second parameter of tagEvent, which takes a hash of attributes and values:

	Localytics.tagEvent("Options Saved", { "Display Units" : "MPH", "Age Range" : "18-25" },  0);

The third parameter of tagEvent is used to increase customer lifetime value. If the user makes a purchase, you might specify the price of the purchase in cents: 

	Localytics.tagEvent("Purchase Completed", { "Item Name" : "Power Up" }, 499);
