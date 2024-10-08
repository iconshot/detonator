package com.iconshot.detonator.element;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.viewelement.BaseViewElement;

public class SafeAreaViewElement extends BaseViewElement<SafeAreaViewElement.Attributes> {
    public SafeAreaViewElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    protected Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    public static class Attributes extends BaseViewElement.Attributes {
        String[] edges;
    }
}
