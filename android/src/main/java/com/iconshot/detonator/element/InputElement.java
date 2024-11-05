package com.iconshot.detonator.element;

import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.TypedValue;
import android.view.KeyEvent;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ColorHelper;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.PixelHelper;

public class InputElement extends Element<EditText, InputElement.Attributes> {
    private int defaultColor;
    private final int defaultPlaceholderColor = Color.parseColor("#BFFFFFFF");

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

        view.setOnKeyListener((v, keyCode, event) -> {
            if (keyCode == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_UP) {
                view.clearFocus();

                view.post(() -> {
                    InputMethodManager imm = (InputMethodManager) ContextHelper.context.getSystemService(Context.INPUT_METHOD_SERVICE);

                    imm.hideSoftInputFromWindow(view.getWindowToken(), 0);

                    detonator.emitHandler("onDone", edge.id);
                });

                return true;
            }

            return false;
        });

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

        String inputType = attributes.inputType;

        String currentInputType = currentAttributes != null ? currentAttributes.inputType : null;

        boolean patchInputType = forcePatch || !CompareHelper.compareObjects(inputType, currentInputType);

        String autoCapitalize = attributes.autoCapitalize;

        String currentAutoCapitalize = currentAttributes != null ? currentAttributes.autoCapitalize : null;

        boolean patchAutoCapitalize = forcePatch || !CompareHelper.compareObjects(autoCapitalize, currentAutoCapitalize);

        if (patchInputType || patchAutoCapitalize) {
            patchInputType(inputType, autoCapitalize);
        }
    }

    private void patchInputType(String inputType, String autoCapitalize) {
        int value = InputType.TYPE_CLASS_TEXT;

        String tmpInputType = inputType != null ? inputType : "text";

        String tmpAutoCapitalize = autoCapitalize != null ? autoCapitalize : "sentences";

        switch (tmpInputType) {
            case "password": {
                value |= InputType.TYPE_TEXT_VARIATION_PASSWORD;

                break;
            }

            case "email": {
                value |= InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS;

                break;
            }
        }

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
        String inputType;
        String autoCapitalize;
        Boolean onChange;
        Boolean onDone;
    }
}
