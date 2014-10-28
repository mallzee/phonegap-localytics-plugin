//
//  LocalyticsPlugin.m
//
//  Copyright 2014 Localytics. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalyticsPlugin.h"
#import "LocalyticsAmpSession.h"

@implementation LocalyticsPlugin

+ (void)load
{
    NSString *appId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LocalyticsAppID"];

    if (appId) {
        [[LocalyticsAmpSession sharedLocalyticsSession] LocalyticsSession:appId];
    } else {
        NSLog(@"Localtyics warning: APP ID Missing. Must have 'LocalyticsAppID' key in your info.plist");
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRegisterForRemoteNotificationsWithDeviceTokenObserver:)name:CDVRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLaunchingWithOptionsObserver:)name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURLObserver:)name:CDVPluginHandleOpenURLNotification object:nil];
}

+ (void)didFinishLaunchingWithOptionsObserver:(NSNotification *)notification
{
    NSDictionary *launchOptions = [notification userInfo];
    if ([[launchOptions allKeys]
         containsObject:UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        [[LocalyticsAmpSession shared] resume];
        [[LocalyticsAmpSession shared] handleRemoteNotification:[launchOptions
                                                                     objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
}

+ (void)didRegisterForRemoteNotificationsWithDeviceTokenObserver:(NSNotification *)notification
{
    [[LocalyticsAmpSession shared] setPushToken:notification.object];
}

+ (void)openURLObserver:(NSNotification *)notification
{
    // If the URL is handled by Localytics, we will return yes.
    [[LocalyticsAmpSession shared] handleURL:notification.object];
}

- (void)init:(CDVInvokedUrlCommand *)command
{
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
        [[LocalyticsAmpSession sharedLocalyticsSession] LocalyticsSession:[command.arguments objectAtIndex:0]];
	}
}

- (void)didRecieveRemoteNotificationObserver:(NSNotification *)notification
{
    [[LocalyticsAmpSession shared] handleRemoteNotification:notification.object];
}

- (void)resume:(CDVInvokedUrlCommand *)command
{
    [[LocalyticsAmpSession sharedLocalyticsSession] resume];
}

- (void)close:(CDVInvokedUrlCommand *)command
{
    [[LocalyticsAmpSession sharedLocalyticsSession] close];
}

- (void)upload:(CDVInvokedUrlCommand *)command
{
    [[LocalyticsAmpSession sharedLocalyticsSession] upload];
}

- (void)tagEvent:(CDVInvokedUrlCommand *)command
{
	if (command.arguments.count == 3)
	{
		NSString *eventName = [command.arguments objectAtIndex:0];
		NSDictionary *attributes = nil;
		if (![[command.arguments objectAtIndex:1] isKindOfClass:[NSNull class]])
		{
			attributes = [command.arguments objectAtIndex:1];
		}
		NSNumber *customerValueIncrease = [command.arguments objectAtIndex:2];

		if (eventName && [eventName isKindOfClass:[NSString class]] && eventName.length > 0 &&
			customerValueIncrease && [customerValueIncrease isKindOfClass:[NSNumber class]])
		{
			[[LocalyticsAmpSession sharedLocalyticsSession] tagEvent:eventName attributes:attributes customerValueIncrease:customerValueIncrease];
		}
	}
}

- (void)tagScreen:(CDVInvokedUrlCommand *)command
{
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		[[LocalyticsAmpSession sharedLocalyticsSession] tagScreen:[command.arguments objectAtIndex:0]];
	}
}

- (void)setCustomDimension:(CDVInvokedUrlCommand *)command;
{
	NSNumber *dimensionNumber = [command.arguments objectAtIndex:0];
	NSString *dimensionValue = nil;
	if (![[command.arguments objectAtIndex:1] isKindOfClass:[NSNull class]])
	{
		dimensionValue = [command.arguments objectAtIndex:1];
	}

	if ([dimensionValue isKindOfClass:[NSNull class]]) { dimensionValue = nil; };

	if (dimensionNumber && [dimensionNumber isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsAmpSession sharedLocalyticsSession] setCustomDimension:[dimensionNumber intValue] value:dimensionValue];
	}
}

- (void)setCustomIdentifier:(CDVInvokedUrlCommand *)command
{
	NSString *name = [command.arguments objectAtIndex:0];
	NSString *value = nil;
	if (![[command.arguments objectAtIndex:1] isKindOfClass:[NSNull class]])
	{
		value = [command.arguments objectAtIndex:1];
	}

	if (name && [name isKindOfClass:[NSString class]] && name.length > 0)
	{
		[[LocalyticsAmpSession sharedLocalyticsSession] setValueForIdentifier:name value:value];
	}
}

- (void)setCustomerId:(CDVInvokedUrlCommand *)command
{
	NSString *cid = nil;
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		cid = [command.arguments objectAtIndex:0];
	}

	[[LocalyticsAmpSession sharedLocalyticsSession] setCustomerId:cid];
}

- (void)setCustomerName:(CDVInvokedUrlCommand *)command
{
	NSString *name = nil;
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		name = [command.arguments objectAtIndex:0];
	}

	[[LocalyticsAmpSession sharedLocalyticsSession] setCustomerName:name];
}

- (void)setCustomerEmail:(CDVInvokedUrlCommand *)command
{
	NSString *email = nil;
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		email = [command.arguments objectAtIndex:0];
	}

	[[LocalyticsAmpSession sharedLocalyticsSession] setCustomerEmail:email];
}

- (void)setLoggingEnabled:(CDVInvokedUrlCommand *)command
{
	NSNumber *enabled = [command.arguments objectAtIndex:0];

	if (enabled && [enabled isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsAmpSession sharedLocalyticsSession] setLoggingEnabled:[enabled boolValue]];
	}
}

- (void)setHttpsEnabled:(CDVInvokedUrlCommand *)command
{
	NSNumber *enabled = [command.arguments objectAtIndex:0];

	if (enabled && [enabled isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsAmpSession sharedLocalyticsSession] setEnableHTTPS:[enabled boolValue]];
	}
}

- (void)setAdvertisingIdentifierEnabled:(CDVInvokedUrlCommand *)command
{
	NSNumber *enabled = [command.arguments objectAtIndex:0];

	if (enabled && [enabled isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsAmpSession sharedLocalyticsSession] setAdvertisingIdentifierEnabled:[enabled boolValue]];
	}
}

- (void)setSessionTimeout:(CDVInvokedUrlCommand *)command
{
	NSNumber *timeout = [command.arguments objectAtIndex:0];

	if (timeout && [timeout isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsAmpSession sharedLocalyticsSession] setSessionTimeoutInterval:[timeout floatValue]];
	}
}

- (void)setProfileValue:(CDVInvokedUrlCommand *)command
{
    if (command.arguments.count == 2) {
        @try {

            return [[LocalyticsAmpSession sharedLocalyticsSession]
                    setProfileValue:[command.arguments objectAtIndex:1]
                    forAttribute:[command.arguments objectAtIndex:0]];

        } @catch (NSException *error) {
            NSLog(@"Localytics profile error %@", error);
        }
    }
}

- (void)setPushToken:(CDVInvokedUrlCommand *)command
{
    [[LocalyticsAmpSession shared] setPushToken:[command.arguments objectAtIndex:0]];
}

@end