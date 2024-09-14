package com.iconshot.detonator.element;

import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.TypedValue;
import android.widget.EditText;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ColorHelper;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.PixelHelper;

public class InputElement extends Element<EditText, InputElement.Attributes> {
    private int defaultColor;

    public InputElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    protected EditText createView() {
        EditText view = new EditText(ContextHelper.context);

        view.setMaxLines(1);
        view.setInputType(InputType.TYPE_CLASS_TEXT);

        defaultColor = view.getCurrentTextColor();

        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                OnChangeData data = new OnChangeData();

                data.value = s.toString();

                detonator.handlerEmitter.emit("onChange", edge.id, data);
            }

            @Override
            public void afterTextChanged(Editable s) {}
        };

        view.addTextChangedListener(textWatcher);

        return view;
    }

    @Override
    protected void patchView() {
        String placeholder = attributes.placeholder;

        String currentPlaceholder = currentAttributes != null ? currentAttributes.placeholder : null;

        boolean patchPlaceholder = forcePatch || !CompareHelper.compareObjects(placeholder, currentPlaceholder);

        if (patchPlaceholder) {
            view.setHint(placeholder != null ? placeholder : "");
        }

        String value = attributes.value;

        boolean patchValue = forcePatch;

        if (patchValue) {
            view.setText(value != null ? value : "");
        }
    }

    protected void patchFontSize(Float fontSize) {
        float value = ((Integer) PixelHelper.dpToPx(fontSize != null ? fontSize : 16)).floatValue();

        view.setTextSize(TypedValue.COMPLEX_UNIT_PX, value);
    }

    protected void patchColor(Object color) {
        Integer tmpColor = color != null ? ColorHelper.parseColor(color) : null;

        view.setTextColor(tmpColor != null ? tmpColor : defaultColor);
    }

    protected static class Attributes extends Element.Attributes {
        String placeholder;
        String value;
        Boolean onChange;
    }

    private static class OnChangeData {
        String value;
    }
}
