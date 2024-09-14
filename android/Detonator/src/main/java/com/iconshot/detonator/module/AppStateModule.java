package com.iconshot.detonator.module;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ContextHelper;

public class AppStateModule extends Module {
    protected boolean foreground = false;

    public AppStateModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void register() {
        Context context = ContextHelper.context;

        Application application = (Application) context.getApplicationContext();

        application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityResumed(Activity activity) {
                if (foreground) {
                    return;
                }

                foreground = true;

                emit();
            }

            @Override
            public void onActivityPaused(Activity activity) {
                foreground = false;

                emit();
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

    private void emit() {
        String currentState = foreground ? "foreground": "background";

        detonator.eventEmitter.emit("com.iconshot.detonator.appstate/state", currentState);
    }
}
