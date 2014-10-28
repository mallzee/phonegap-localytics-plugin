Localytics for PhoneGap/Cordova 3.x
========

## Installation

	cordova plugin add https://github.com/mallzee/phonegap-localytics-plugin.git --variable APP_ID=[APP ID]

## Integration (iOS Only)

The plugin now fully integrates without the need to modify your AppDelegate.m file. The following JavaScript code is bare minimum to get running. This will integrate the analytics and marketing segments of the SDK.

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

### Customer Details

You can track basic information about your customers. This is useful when you want to export data via the API and for use with the new Profiles section. [Click here for more info](http://support.localytics.com/IOS#User_ID_and_Email_Tracking)

    Localytics.setCustomerId(id);
    Localytics.setCustomerName(name);
    Localytics.setCustomerEmail(email);

### Custom Dimensions

You can set a global custom dimension on all of your localytics events. This is useful to track a global property across the full app. [Click here for more info](http://support.localytics.com/IOS#Custom_Dimensions)

    Localytics.setCustomDimension(dimension, value);

### Profile Attributes

Localytics now supports profiles. You can start to tag attributes about your customers based on their customer id. See here for more information about profiles. [Localytics Profiles](http://support.localytics.com/IOS#Profile_Attributes)

    Localytics.setProfileValue(attribute, value);

### Push Token

Localytics requires the devices push token to enable the push marketing campaigns. With the default integration it forces the user to answer the question of if they want Push Notifications enabled for the app in question. Sometimes, this is not the correct place to ask. This allows you to set the push token on you're own schedule. A good time to ask is after an action that you could update the user on so they understand the value of the notifications from your app.

    Localytics.setPushToken(token);


