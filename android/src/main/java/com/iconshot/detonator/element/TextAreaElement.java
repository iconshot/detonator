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
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    protected EditText createView() {
        EditText view = new EditText(ContextHelper.context);

        defaultColor = view.getCurrentTextColor();

        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                OnChangeData data = new OnChangeData();

                data.value = s.toString();

                detonator.emitHandler("onChange", edge.id, data);
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

        String autoCapitalize = attributes.autoCapitalize;

        String currentAutoCapitalize = currentAttributes != null ? currentAttributes.autoCapitalize : null;

        boolean patchAutoCapitalize = forcePatch || !CompareHelper.compareObjects(autoCapitalize, currentAutoCapitalize);

        if (patchAutoCapitalize) {
            patchInputType(autoCapitalize);
        }
    }

    private void patchInputType( String autoCapitalize) {
        int value = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE;

        String tmpAutoCapitalize = autoCapitalize != null ? autoCapitalize : "sentences";

        switch (tmpAutoCapitalize) {
            case "characters": {
                value |= InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;

                break;
            }

            case "words": {
                value |= InputType.TYPE_TEXT_FLAG_CAP_WORDS;

                break;
            }

            case "sentences": {
                value |= InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;

                break;
            }

            case "none": {
                value |= InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS;

                break;
            }
        }

        view.setInputType(value);
    }

    protected void patchFontSize(Float fontSize) {
        float value = ((Integer) PixelHelper.dpToPx(fontSize != null ? fontSize : 16)).floatValue();

        view.setTextSize(TypedValue.COMPLEX_UNIT_PX, value);
    }

    protected void patchColor(Object color) {
        Integer tmpColor = ColorHelper.parseColor(color);

        view.setTextColor(tmpColor != null ? tmpColor : defaultColor);
    }

    private static class OnChangeData {
        String value;
    }

    protected static class Attributes extends Element.Attributes {
        String placeholder;
        Object placeholderColor;
        String value;
        String autoCapitalize;
        Boolean onChange;
    }
}
