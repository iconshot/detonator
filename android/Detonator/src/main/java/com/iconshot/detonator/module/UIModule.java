package com.iconshot.detonator.module;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.ActivityIndicatorElement;
import com.iconshot.detonator.element.AudioElement;
import com.iconshot.detonator.element.IconElement;
import com.iconshot.detonator.element.InputElement;
import com.iconshot.detonator.element.SafeAreaViewElement;
import com.iconshot.detonator.element.TextAreaElement;
import com.iconshot.detonator.element.TextElement;
import com.iconshot.detonator.element.horizontalscrollviewelement.HorizontalScrollViewElement;
import com.iconshot.detonator.element.imageelement.ImageElement;
import com.iconshot.detonator.element.verticalscrollviewelement.VerticalScrollViewElement;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.element.viewelement.ViewElement;

public class UIModule extends Module {
    public UIModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setElementClass("com.iconshot.detonator.ui.view", ViewElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.text", TextElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.input", InputElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.textarea", TextAreaElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.image", ImageElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.video", VideoElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.audio", AudioElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.verticalscrollview", VerticalScrollViewElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.horizontalscrollview", HorizontalScrollViewElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.safeareaview", SafeAreaViewElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.icon", IconElement.class);
        detonator.setElementClass("com.iconshot.detonator.ui.activityindicator", ActivityIndicatorElement.class);
    }
}
