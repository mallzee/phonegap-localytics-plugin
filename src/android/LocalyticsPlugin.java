//
//  LocalyticsPlugin.java
//
//  Copyright 2014 Localytics. All rights reserved.
//

package com.localytics.phonegap;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;

import com.localytics.android.LocalyticsAmpSession;

/**
 * This class echoes a string called from JavaScript.
 */
public class LocalyticsPlugin extends CordovaPlugin {

    private LocalyticsAmpSession localyticsSession;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        try {
            this.localyticsSession = new LocalyticsAmpSession(cordova.getActivity().getApplicationContext());
        }
        catch (final Exception e) {}
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("init")) {
            String key = args.getString(0);
            if (key != null && key.length() > 0) {
                this.localyticsSession = new LocalyticsAmpSession(cordova.getActivity().getApplicationContext(), key);
                callbackContext.success();
            } else {
                callbackContext.error("Expected non-empty key argument.");
            }
            return true;
        }
        else if (action.equals("resume")) {
            this.localyticsSession.open();
            callbackContext.success();
            return true;
        }
        else if (action.equals("close")) {
            this.localyticsSession.close();
            callbackContext.success();
            return true;
        }
        else if (action.equals("upload")) {
            this.localyticsSession.upload();
            callbackContext.success();
            return true;
        }
        else if (action.equals("upload")) {
            this.localyticsSession.upload();
            callbackContext.success();
            return true;
        }
        else if (action.equals("tagEvent")) {
            if (args.length() == 3) {
                String name = args.getString(0);
                if (name != null && name.length() > 0) {
                    JSONObject attributes = null;
                    if (!args.isNull(1)) {
                        attributes = args.getJSONObject(1);
                    }
                    HashMap<String, String> a = null;
                    if (attributes != null && attributes.length() > 0) {
                        a = new HashMap<String, String>();                    
                        Iterator<?> keys = attributes.keys();
                        while (keys.hasNext()) {
                            String key = (String)keys.next();
                            String value = attributes.getString(key);
                            a.put(key, value);
                        }
                    }
                    int customerValueIncrease = args.getInt(2);
                    this.localyticsSession.tagEvent(name, a, null, customerValueIncrease);
                    callbackContext.success();
                } else {
                    callbackContext.error("Expected non-empty name argument.");
                }                            
            } else {
                callbackContext.error("Expected three arguments.");
            }
            return true;
        } else if (action.equals("tagScreen")) {
            String name = args.getString(0);
            if (name != null && name.length() > 0) {
                this.localyticsSession.tagScreen(name);
                callbackContext.success();
            } else {
                callbackContext.error("Expected non-empty name argument.");
            }
            return true;
        } else if (action.equals("setCustomDimension")) {
            if (args.length() == 2) {
                int index = args.getInt(0);
                String value = null;
                if (!args.isNull(1)) {
                    value = args.getString(1);   
                }
                this.localyticsSession.setCustomDimension(index, value);
                callbackContext.success();
            } else {
                callbackContext.error("Expected two arguments.");
            }
            return true;
        } else if (action.equals("setCustomIdentifier")) {
            if (args.length() == 2) {
                String name = args.getString(0);
                if (name != null && name.length() > 0) {
                    String value = null;
                    if (!args.isNull(1)) {
                        value = args.getString(1);   
                    }
                    this.localyticsSession.setCustomerData(name, value);
                    callbackContext.success();                
                } else {
                    callbackContext.error("Expected non-empty name argument.");
                }
            } else {
                callbackContext.error("Expected two arguments.");
            }
            return true;
        } else if (action.equals("setCustomerId")) {
            String id = null;
            if (!args.isNull(0)) {
                id = args.getString(0);   
            }
            this.localyticsSession.setCustomerId(id);
            callbackContext.success();
            return true;
        } else if (action.equals("setCustomerName")) {
            String name = null;
            if (!args.isNull(0)) {
                name = args.getString(0);   
            }
            this.localyticsSession.setCustomerName(name);
            callbackContext.success();
            return true;
        } else if (action.equals("setCustomerEmail")) {
            String email = null;
            if (!args.isNull(0)) {
                email = args.getString(0);   
            }
            this.localyticsSession.setCustomerEmail(email);
            callbackContext.success();
            return true;
        } else if (action.equals("setLoggingEnabled")) {
            boolean enabled = args.getBoolean(0);
            LocalyticsAmpSession.setLoggingEnabled(enabled);
            callbackContext.success();
            return true;
        } else if (action.equals("setHttpsEnabled")) {
            boolean enabled = args.getBoolean(0);
            LocalyticsAmpSession.setHttpsEnabled(enabled);
            callbackContext.success();
            return true;
        } else if (action.equals("setSessionTimeout")) {
            int timeout = args.getInt(0);
            LocalyticsAmpSession.setSessionExpiration(timeout);
            callbackContext.success();
            return true;
        }

        return false;
    }
}