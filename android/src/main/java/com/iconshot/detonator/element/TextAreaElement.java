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

public class TextAreaElement extends Element<EditText, TextAreaElement.Attributes> {
    private int defaultColor;
    private int defaultPlaceholderColor;

    public TextAreaElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<TextAreaElement.Attributes> getAttributesClass() {
        return TextAreaElement.Attributes.class;
    }

    @Override
    protected EditText createView() {
        EditText view = new EditText(ContextHelper.context);

        view.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE);

        defaultColor = view.getCurrentTextColor();

        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                TextAreaElement.OnChangeData data = new TextAreaElement.OnChangeData();

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

        Object placeholderColor = attributes.placeholderColor;

        Object currentPlaceholderColor = currentAttributes != null ? currentAttributes.placeholderColor : null;

        boolean patchPlaceholderColor = forcePatch || !CompareHelper.compareColors(placeholderColor, currentPlaceholderColor);

        if (patchPlaceholderColor) {
            Integer tmpColor = ColorHelper.parseColor(placeholderColor);

            view.setHintTextColor(tmpColor != null ? tmpColor : defaultPlaceholderColor);
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
        Integer tmpColor = ColorHelper.parseColor(color);

        view.setTextColor(tmpColor != null ? tmpColor : defaultColor);
    }

    protected static class Attributes extends Element.Attributes {
        String placeholder;
        Object placeholderColor;
        String value;
        Boolean onChange;
    }

    private static class OnChangeData {
        String value;
    }
}
