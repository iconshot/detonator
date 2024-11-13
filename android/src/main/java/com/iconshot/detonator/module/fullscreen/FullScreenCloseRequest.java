package com.iconshot.detonator.module.fullscreen;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.layout.ViewLayout;
import com.iconshot.detonator.request.Request;
import com.iconshot.detonator.tree.Edge;
import com.iconshot.detonator.tree.Target;

public class FullScreenCloseRequest extends Request {
    public FullScreenCloseRequest(Detonator detonator, Request.IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    @Override
    public void run() {
        View view = FullScreenModule.view;

        ViewLayout.LayoutParams layoutParams = (ViewLayout.LayoutParams) view.getLayoutParams();
        ViewLayout.LayoutParams tmpLayoutParams = FullScreenModule.layoutParams;

        Activity activity = (Activity) ContextHelper.context;

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

        end();
    }
}
