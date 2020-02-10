package com.ghost.thermoai;

import io.flutter.app.FlutterApplication;

public class MyApp extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        PushServiceFactory.init(this);
    }
}
