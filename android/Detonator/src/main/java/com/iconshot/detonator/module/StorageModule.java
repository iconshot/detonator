package com.iconshot.detonator.module;

import android.content.Context;
import android.content.SharedPreferences;

import com.iconshot.detonator.Detonator;

public class StorageModule extends Module {
    public StorageModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setRequestListener("com.iconshot.detonator.storage::getItem", (promise, value, edge) -> {
            GetItemData data = detonator.decode(value, GetItemData.class);

            SharedPreferences sharedPreferences = getSharedPreferences(data.name);

            String itemValue = sharedPreferences.getString(data.key, null);

            promise.resolve(itemValue != null ? "&" + itemValue : ":n");
        });

        detonator.setRequestListener("com.iconshot.detonator.storage::setItem", (promise, value, edge) -> {
            SetItemData data = detonator.decode(value, SetItemData.class);

            SharedPreferences sharedPreferences = getSharedPreferences(data.name);

            SharedPreferences.Editor editor = sharedPreferences.edit();

            editor.putString(data.key, data.value);

            editor.apply();

            promise.resolve();
        });
    }

    private SharedPreferences getSharedPreferences(String name) {
        return detonator.context.getSharedPreferences(name, Context.MODE_PRIVATE);
    }

    private static class GetItemData {
        String name;
        String key;
    }

    private static class SetItemData {
        String name;
        String key;
        String value;
    }
}
