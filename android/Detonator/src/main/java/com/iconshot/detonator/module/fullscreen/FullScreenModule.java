package com.iconshot.detonator.module.fullscreen;

import android.view.ViewGroup;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.layout.ViewLayout;
import com.iconshot.detonator.module.Module;

public class FullScreenModule extends Module {
    public FullScreenModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setRequestClass("com.iconshot.detonator.fullscreen::open", FullScreenOpenRequest.class);
        detonator.setRequestClass("com.iconshot.detonator.fullscreen::close", FullScreenCloseRequest.class);
    }

    public static ViewGroup parent = null;
    public static ViewLayout view = null;
    public static Integer index = null;
    public static ViewLayout.LayoutParams layoutParams = null;
    public static ViewLayout fullScreenView = null;
}
