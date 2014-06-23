//
//  LocalyticsPlugin.m
//
//  Copyright 2014 Localytics. All rights reserved.
//

#import "LocalyticsPlugin.h"
#import "LocalyticsSession.h"

@implementation LocalyticsPlugin

- (void)init:(CDVInvokedUrlCommand *)command
{
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		[[LocalyticsSession sharedLocalyticsSession] localyticsSession:[command.arguments objectAtIndex:0]];
	}
}

- (void)resume:(CDVInvokedUrlCommand *)command
{
    [[LocalyticsSession sharedLocalyticsSession] resume];
}

- (void)close:(CDVInvokedUrlCommand *)command
{
    [[LocalyticsSession sharedLocalyticsSession] close];
}

- (void)upload:(CDVInvokedUrlCommand *)command
{
    [[LocalyticsSession sharedLocalyticsSession] upload];
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
			[[LocalyticsSession sharedLocalyticsSession] tagEvent:eventName attributes:attributes customerValueIncrease:customerValueIncrease];
		}
	}
}

- (void)tagScreen:(CDVInvokedUrlCommand *)command
{
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		[[LocalyticsSession sharedLocalyticsSession] tagScreen:[command.arguments objectAtIndex:0]];
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
		[[LocalyticsSession sharedLocalyticsSession] setCustomDimension:[dimensionNumber intValue] value:dimensionValue];
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
		[[LocalyticsSession sharedLocalyticsSession] setValueForIdentifier:name value:value];
	}
}

- (void)setCustomerId:(CDVInvokedUrlCommand *)command
{
	NSString *cid = nil;
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		cid = [command.arguments objectAtIndex:0];
	}
	
	[[LocalyticsSession sharedLocalyticsSession] setCustomerId:cid];
}

- (void)setCustomerName:(CDVInvokedUrlCommand *)command
{
	NSString *name = nil;
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		name = [command.arguments objectAtIndex:0];
	}
	
	[[LocalyticsSession sharedLocalyticsSession] setCustomerName:name];
}

- (void)setCustomerEmail:(CDVInvokedUrlCommand *)command
{
	NSString *email = nil;
	if (![[command.arguments objectAtIndex:0] isKindOfClass:[NSNull class]])
	{
		email = [command.arguments objectAtIndex:0];
	}
	
	[[LocalyticsSession sharedLocalyticsSession] setCustomerEmail:email];
}

- (void)setLoggingEnabled:(CDVInvokedUrlCommand *)command
{
	NSNumber *enabled = [command.arguments objectAtIndex:0];
	
	if (enabled && [enabled isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsSession sharedLocalyticsSession] setLoggingEnabled:[enabled boolValue]];
	}
}

- (void)setHttpsEnabled:(CDVInvokedUrlCommand *)command
{
	NSNumber *enabled = [command.arguments objectAtIndex:0];
	
	if (enabled && [enabled isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsSession sharedLocalyticsSession] setEnableHTTPS:[enabled boolValue]];
	}
}

- (void)setAdvertisingIdentifierEnabled:(CDVInvokedUrlCommand *)command
{
	NSNumber *enabled = [command.arguments objectAtIndex:0];
	
	if (enabled && [enabled isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsSession sharedLocalyticsSession] setAdvertisingIdentifierEnabled:[enabled boolValue]];
	}
}

- (void)setSessionTimeout:(CDVInvokedUrlCommand *)command
{
	NSNumber *timeout = [command.arguments objectAtIndex:0];
	
	if (timeout && [timeout isKindOfClass:[NSNumber class]])
	{
		[[LocalyticsSession sharedLocalyticsSession] setSessionTimeoutInterval:[timeout floatValue]];
	}
}

@end