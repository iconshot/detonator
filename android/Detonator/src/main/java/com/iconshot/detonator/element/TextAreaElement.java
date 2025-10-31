package com.iconshot.detonator.element;

import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ColorHelper;
import com.iconshot.detonator.helpers.CompareHelper;

public class TextAreaElement extends Element<EditText, TextAreaElement.Attributes> {
    private int defaultColor;
    private final int defaultPlaceholderColor = Color.parseColor("#BFFFFFFF");

    public TextAreaElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    protected EditText createView() {
        EditText view = new EditText(detonator.context);

        view.setGravity(Gravity.TOP);

        defaultColor = view.getCurrentTextColor();

        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                OnChangeData data = new OnChangeData();

                data.value = s.toString();

                sendHandler("onChange", data);
            }

            @Override
            public void afterTextChanged(Editable s) {}
        };

        view.addTextChangedListener(textWatcher);

        setRequestListener("com.iconshot.detonator.ui.textarea::focus", (promise, value) -> {
            view.requestFocus();

            int position = view.getText().length();

            view.setSelection(position);

            view.post(() -> {
                InputMethodManager imm = (InputMethodManager) detonator.context.getSystemService(Context.INPUT_METHOD_SERVICE);

                imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT);

                promise.resolve();
            });
        });

        setRequestListener("com.iconshot.detonator.ui.textarea::blur", (promise, value) -> {
            view.clearFocus();

            view.post(() -> {
                InputMethodManager imm = (InputMethodManager) detonator.context.getSystemService(Context.INPUT_METHOD_SERVICE);

                imm.hideSoftInputFromWindow(view.getWindowToken(), 0);

                promise.resolve();
            });
        });

        setRequestListener("com.iconshot.detonator.ui.textarea::setValue", (promise, value) -> {
            view.setText(value);

            promise.resolve();
        });

        return view;
    }

    @Override
    protected void patchView() {
        String placeholder = attributes.placeholder;

        String prevPlaceholder = prevAttributes != null ? prevAttributes.placeholder : null;

        boolean patchPlaceholder = forcePatch || !CompareHelper.compareObjects(placeholder, prevPlaceholder);

        if (patchPlaceholder) {
            view.setHint(placeholder != null ? placeholder : "");
        }

        Object placeholderColor = attributes.placeholderColor;

        Object prevPlaceholderColor = prevAttributes != null ? prevAttributes.placeholderColor : null;

        boolean patchPlaceholderColor = forcePatch || !CompareHelper.compareColors(placeholderColor, prevPlaceholderColor);

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

        String prevAutoCapitalize = prevAttributes != null ? prevAttributes.autoCapitalize : null;

        boolean patchAutoCapitalize = forcePatch || !CompareHelper.compareObjects(autoCapitalize, prevAutoCapitalize);

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
        float value = ((Integer) dpToPx(fontSize != null ? fontSize : 16)).floatValue();

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
