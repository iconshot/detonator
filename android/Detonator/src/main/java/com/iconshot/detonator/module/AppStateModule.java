package com.iconshot.detonator.module;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ContextHelper;

public class AppStateModule extends Module {
    private boolean foreground = false;

    public AppStateModule(Detonator detonator) {
        super(detonator);
    }

    private void setForeground(boolean foreground) {
        if (this.foreground == foreground) {
            return;
        }

        this.foreground = foreground;

        String currentState = foreground ? "active": "background";

        detonator.emit("com.iconshot.detonator.appstate.state", currentState);
    }

    @Override
    public void register() {
        Context context = ContextHelper.context;

        Application application = (Application) context.getApplicationContext();

        application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityResumed(Activity activity) {
                setForeground(true);
            }

            @Override
            public void onActivityPaused(Activity activity) {
                setForeground(false);
            }

            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {}
            @Override
            public void onActivityStarted(Activity activity) {}
            @Override
            public void onActivityStopped(Activity activity) {}
            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {}
            @Override
            public void onActivityDestroyed(Activity activity) {}
        });
    }
}
