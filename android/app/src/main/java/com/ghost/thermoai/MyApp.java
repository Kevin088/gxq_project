package com.ghost.thermoai;

import android.util.Log;

import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.jarvanmo.rammus.RammusPushIntentService;

import io.flutter.app.FlutterApplication;

public class MyApp extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        PushServiceFactory.init(this);

        CloudPushService pushService = PushServiceFactory.getCloudPushService();
        pushService.register(this, new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                Log.e("ssss",s);
            }

            @Override
            public void onFailed(String s, String s1) {
                Log.e("ssss",s+s1);
            }
        });
        //一定要添加这一句代码
        pushService.setPushIntentService(RammusPushIntentService.class);

    }
}
