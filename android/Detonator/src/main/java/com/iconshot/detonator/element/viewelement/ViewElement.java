package com.iconshot.detonator.element.viewelement;

import com.iconshot.detonator.Detonator;

public class ViewElement extends BaseViewElement<BaseViewElement.Attributes> {
    public ViewElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    protected Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }
}
