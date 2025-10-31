package com.iconshot.detonator.module;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.layout.ViewLayout;
import com.iconshot.detonator.renderer.Edge;

public class FullScreenModule extends Module {
    public static ViewGroup parent = null;
    public static ViewLayout view = null;
    public static Integer index = null;
    public static ViewLayout.LayoutParams layoutParams = null;
    public static ViewLayout fullScreenView = null;

    public FullScreenModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setRequestListener("com.iconshot.detonator.fullscreen::open", (promise, value, edge) -> {
            ViewLayout view = (ViewLayout) edge.children.get(0).element.view;

            ViewLayout.LayoutParams layoutParams = (ViewLayout.LayoutParams) view.getLayoutParams();

            ViewGroup parent = (ViewGroup) view.getParent();

            Activity activity = (Activity) detonator.context;

            Window window = activity.getWindow();

            ViewGroup decorView = (ViewGroup) window.getDecorView();

            int index = parent.indexOfChild(view);

            ViewLayout fullScreenView = new ViewLayout(view.getContext());

            ViewGroup.LayoutParams fullScreenViewLayoutParams = new ViewGroup.LayoutParams(
                    ViewLayout.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT
            );

            fullScreenView.setLayoutParams(fullScreenViewLayoutParams);

            ViewLayout.LayoutParams tmpLayoutParams = new ViewLayout.LayoutParams(
                    ViewLayout.LayoutParams.WRAP_CONTENT,
                    ViewLayout.LayoutParams.WRAP_CONTENT
            );

            tmpLayoutParams.position = layoutParams.position;
            tmpLayoutParams.display = layoutParams.display;
            tmpLayoutParams.width = layoutParams.width;
            tmpLayoutParams.widthPercent = layoutParams.widthPercent;
            tmpLayoutParams.maxWidth = layoutParams.maxWidth;
            tmpLayoutParams.maxWidthPercent = layoutParams.maxWidthPercent;
            tmpLayoutParams.minWidth = layoutParams.minWidth;
            tmpLayoutParams.minWidthPercent = layoutParams.minWidthPercent;
            tmpLayoutParams.height = layoutParams.height;
            tmpLayoutParams.heightPercent = layoutParams.heightPercent;
            tmpLayoutParams.maxHeight = layoutParams.maxHeight;
            tmpLayoutParams.maxHeightPercent = layoutParams.maxHeightPercent;
            tmpLayoutParams.minHeight = layoutParams.minHeight;
            tmpLayoutParams.minHeightPercent = layoutParams.minHeightPercent;
            tmpLayoutParams.flex = layoutParams.flex;
            tmpLayoutParams.alignSelf = layoutParams.alignSelf;
            tmpLayoutParams.aspectRatio = layoutParams.aspectRatio;
            tmpLayoutParams.positionTop = layoutParams.positionTop;
            tmpLayoutParams.positionTopPercent = layoutParams.positionTopPercent;
            tmpLayoutParams.positionLeft = layoutParams.positionLeft;
            tmpLayoutParams.positionLeftPercent = layoutParams.positionLeftPercent;
            tmpLayoutParams.positionBottom = layoutParams.positionBottom;
            tmpLayoutParams.positionBottomPercent = layoutParams.positionBottomPercent;
            tmpLayoutParams.positionRight = layoutParams.positionRight;
            tmpLayoutParams.positionRightPercent = layoutParams.positionRightPercent;
            tmpLayoutParams.topMargin = layoutParams.topMargin;
            tmpLayoutParams.leftMargin = layoutParams.leftMargin;
            tmpLayoutParams.bottomMargin = layoutParams.bottomMargin;
            tmpLayoutParams.rightMargin = layoutParams.rightMargin;

            layoutParams.position = ViewLayout.LayoutParams.POSITION_RELATIVE;
            layoutParams.display = ViewLayout.LayoutParams.DISPLAY_FLEX;
            layoutParams.width = ViewLayout.LayoutParams.WRAP_CONTENT;
            layoutParams.widthPercent = 1.0f;
            layoutParams.maxWidth = null;
            layoutParams.maxWidthPercent = null;
            layoutParams.minWidth = null;
            layoutParams.minWidthPercent = null;
            layoutParams.height = ViewLayout.LayoutParams.WRAP_CONTENT;
            layoutParams.heightPercent = 1.0f;
            layoutParams.maxHeight = null;
            layoutParams.maxHeightPercent = null;
            layoutParams.minHeight = null;
            layoutParams.minHeightPercent = null;
            layoutParams.flex = null;
            layoutParams.alignSelf = null;
            layoutParams.aspectRatio = null;
            layoutParams.positionTop = null;
            layoutParams.positionTopPercent = null;
            layoutParams.positionLeft = null;
            layoutParams.positionLeftPercent = null;
            layoutParams.positionBottom = null;
            layoutParams.positionBottomPercent = null;
            layoutParams.positionRight = null;
            layoutParams.positionRightPercent = null;
            layoutParams.topMargin = 0;
            layoutParams.leftMargin = 0;
            layoutParams.bottomMargin = 0;
            layoutParams.rightMargin = 0;

            FullScreenModule.parent = parent;
            FullScreenModule.view = view;
            FullScreenModule.index = index;
            FullScreenModule.layoutParams = tmpLayoutParams;
            FullScreenModule.fullScreenView = fullScreenView;

            parent.removeView(view);

            fullScreenView.addView(view);

            decorView.addView(fullScreenView);

            decorView.setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_FULLSCREEN |
                            View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
                            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
            );

            activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);

            detonator.performLayout();

            promise.resolve();
        });

        detonator.setRequestListener("com.iconshot.detonator.fullscreen::close", (promise, value, edge) -> {
            View view = FullScreenModule.view;

            ViewLayout.LayoutParams layoutParams = (ViewLayout.LayoutParams) view.getLayoutParams();
            ViewLayout.LayoutParams tmpLayoutParams = FullScreenModule.layoutParams;

            Activity activity = (Activity) detonator.context;

            Window window = activity.getWindow();

            ViewGroup decorView = (ViewGroup) window.getDecorView();

            layoutParams.position = tmpLayoutParams.position;
            layoutParams.display = tmpLayoutParams.display;
            layoutParams.width = tmpLayoutParams.width;
            layoutParams.widthPercent = tmpLayoutParams.widthPercent;
            layoutParams.maxWidth = tmpLayoutParams.maxWidth;
            layoutParams.maxWidthPercent = tmpLayoutParams.maxWidthPercent;
            layoutParams.minWidth = tmpLayoutParams.minWidth;
            layoutParams.minWidthPercent = tmpLayoutParams.minWidthPercent;
            layoutParams.height = tmpLayoutParams.height;
            layoutParams.heightPercent = tmpLayoutParams.heightPercent;
            layoutParams.maxHeight = tmpLayoutParams.maxHeight;
            layoutParams.maxHeightPercent = tmpLayoutParams.maxHeightPercent;
            layoutParams.minHeight = tmpLayoutParams.minHeight;
            layoutParams.minHeightPercent = tmpLayoutParams.minHeightPercent;
            layoutParams.flex = tmpLayoutParams.flex;
            layoutParams.alignSelf = tmpLayoutParams.alignSelf;
            layoutParams.aspectRatio = tmpLayoutParams.aspectRatio;
            layoutParams.positionTop = tmpLayoutParams.positionTop;
            layoutParams.positionTopPercent = tmpLayoutParams.positionTopPercent;
            layoutParams.positionLeft = tmpLayoutParams.positionLeft;
            layoutParams.positionLeftPercent = tmpLayoutParams.positionLeftPercent;
            layoutParams.positionBottom = tmpLayoutParams.positionBottom;
            layoutParams.positionBottomPercent = tmpLayoutParams.positionBottomPercent;
            layoutParams.positionRight = tmpLayoutParams.positionRight;
            layoutParams.positionRightPercent = tmpLayoutParams.positionRightPercent;
            layoutParams.topMargin = tmpLayoutParams.topMargin;
            layoutParams.leftMargin = tmpLayoutParams.leftMargin;
            layoutParams.bottomMargin = tmpLayoutParams.bottomMargin;
            layoutParams.rightMargin = tmpLayoutParams.rightMargin;

            FullScreenModule.fullScreenView.removeView(view);

            FullScreenModule.parent.addView(view, FullScreenModule.index);

            decorView.removeView(FullScreenModule.fullScreenView);

            decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
            activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);

            FullScreenModule.parent = null;
            FullScreenModule.view = null;
            FullScreenModule.index = null;
            FullScreenModule.layoutParams = null;
            FullScreenModule.fullScreenView = null;

            detonator.performLayout();

            promise.resolve();
        });
    }
}
