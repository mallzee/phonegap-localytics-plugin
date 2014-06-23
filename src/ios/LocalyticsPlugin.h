//
//  LocalyticsPlugin.h
//
//  Copyright 2014 Localytics. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface LocalyticsPlugin : CDVPlugin

- (void)init:(CDVInvokedUrlCommand *)command;
- (void)resume:(CDVInvokedUrlCommand *)command;
- (void)close:(CDVInvokedUrlCommand *)command;
- (void)upload:(CDVInvokedUrlCommand *)command;
- (void)tagEvent:(CDVInvokedUrlCommand *)command;
- (void)tagScreen:(CDVInvokedUrlCommand *)command;
- (void)setCustomDimension:(CDVInvokedUrlCommand *)command;
- (void)setCustomIdentifier:(CDVInvokedUrlCommand *)command;
- (void)setCustomerId:(CDVInvokedUrlCommand *)command;
- (void)setCustomerName:(CDVInvokedUrlCommand *)command;
- (void)setCustomerEmail:(CDVInvokedUrlCommand *)command;
- (void)setLoggingEnabled:(CDVInvokedUrlCommand *)command;
- (void)setHttpsEnabled:(CDVInvokedUrlCommand *)command;
- (void)setAdvertisingIdentifierEnabled:(CDVInvokedUrlCommand *)command;
- (void)setSessionTimeout:(CDVInvokedUrlCommand *)command;

@end