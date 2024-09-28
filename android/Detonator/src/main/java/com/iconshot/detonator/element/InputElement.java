package com.iconshot.detonator.element;

import android.content.Context;
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

                detonator.handlerEmitter.emit("onChange", edge.id, data);
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

                    detonator.handlerEmitter.emit("onDone", edge.id);
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

        String value = attributes.value;

        boolean patchValue = forcePatch;

        if (patchValue) {
            view.setText(value != null ? value : "");
        }

        String inputType = attributes.inputType;

        String currentInputType = currentAttributes != null ? currentAttributes.inputType : null;

        boolean patchInputType = forcePatch || !CompareHelper.compareObjects(inputType, currentInputType);

        if (patchInputType) {
            String tmpInputType = inputType != null ? inputType : "text";

            switch (tmpInputType) {
                case "text": {
                    view.setInputType(InputType.TYPE_CLASS_TEXT);

                    break;
                }

                case "password": {
                    view.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);

                    break;
                }

                case "email": {
                    view.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);

                    break;
                }
            }
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
        String inputType;
        Boolean onChange;
        Boolean onDone;
    }

    private static class OnChangeData {
        String value;
    }
}
