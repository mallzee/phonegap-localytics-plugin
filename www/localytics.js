//
//  Localytics.js
//
//  Copyright 2014 Localytics. All rights reserved.
//

var Localytics = function () {
}

// Initializes Localytics without opening a session
// appKey = Localytics App ID as a string
Localytics.prototype.init = function (appKey) {
	cordova.exec(null, null, "LocalyticsPlugin", "init", [appKey]);
}

// Resumes a session
// This should typically be called on deviceready and resume events
Localytics.prototype.resume = function() {
	cordova.exec(null, null, "LocalyticsPlugin", "resume", []);
}

// Closes a session
// This should typically be called on pause events
Localytics.prototype.close = function() {
	cordova.exec(null, null, "LocalyticsPlugin", "close", []);
}

// Tags an event
// event = Name of the event
// attributes = a hash of key/value pairs containing the event attributes
// customerValueIncrease = customer value increase as an int
Localytics.prototype.tagEvent = function (event, attributes, customerValueIncrease) {
	cordova.exec(null, null, "LocalyticsPlugin", "tagEvent", [event, attributes, customerValueIncrease]);
}

// Tags a screen
// Call this when a screen is displayed
// screen = screen name as a string
Localytics.prototype.tagScreen = function (screen) {
	cordova.exec(null, null, "LocalyticsPlugin", "tagScreen", [screen]);
}

// Initiates an upload
// This should typically be called on deviceready, resume, and pause events
Localytics.prototype.upload = function() {
	cordova.exec(null, null, "LocalyticsPlugin", "upload", []);
}

// Sets a custom dimension
// index = dimension index as an int
// value = dimension value as a string
Localytics.prototype.setCustomDimension = function (index, value) {
	cordova.exec(null, null, "LocalyticsPlugin", "setCustomDimension", [index, value]);
}

// Sets a custom idenitifer
// name = identifier name as a string
// value = identifier value as a string
Localytics.prototype.setCustomIdentifier = function (name, value) {
	cordova.exec(null, null, "LocalyticsPlugin", "setCustomIdentifier", [name, value]);
}

// Set customer ID
// id = unique customer id as a string (ie, "12345")
Localytics.prototype.setCustomerId = function (id) {
	cordova.exec(null, null, "LocalyticsPlugin", "setCustomerId", [id]);
}

// Set customer name
// name = customer name as a string (ie, "John Doe")
Localytics.prototype.setCustomerName = function (name) {
	cordova.exec(null, null, "LocalyticsPlugin", "setCustomerName", [name]);
}

// Set customer email address
// email = customer email as a string (ie, "johndoe@company.com")
Localytics.prototype.setCustomerEmail = function (email) {
	cordova.exec(null, null, "LocalyticsPlugin", "setCustomerEmail", [email]);
}

// Enables or disables Localytics logging (disabled by default)
// enabled = boolean
Localytics.prototype.setLoggingEnabled = function (enabled) {
	cordova.exec(null, null, "LocalyticsPlugin", "setLoggingEnabled", [enabled]);
}

// Enables or disables HTTPS for uploads (disabled by default)
// enabled = boolean
Localytics.prototype.setHttpsEnabled = function (enabled) {
	cordova.exec(null, null, "LocalyticsPlugin", "setHttpsEnabled", [enabled]);
}

// Enables or disables IDFA (enabled by default, iOS only)
// enabled = boolean
Localytics.prototype.setAdvertisingIdentifierEnabled = function (enabled) {
	if (device.platform == "iOS") {
		cordova.exec(null, null, "LocalyticsPlugin", "setAdvertisingIdentifierEnabled", [enabled]);
	}
}

// Set session resume timeout (15 seconds by default)
// seconds = timeout in seconds as int
Localytics.prototype.setSessionTimeout = function (seconds) {
	cordova.exec(null, null, "LocalyticsPlugin", "setSessionTimeout", [seconds]);
}

module.exports = new Localytics();
