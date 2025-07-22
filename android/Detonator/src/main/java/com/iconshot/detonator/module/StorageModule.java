package com.iconshot.detonator.module;

import android.content.Context;
import android.content.SharedPreferences;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.request.Request;

public class StorageModule extends Module {
    public StorageModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setRequestClass("com.iconshot.detonator.storage::getItem", StorageGetItemRequest.class);
        detonator.setRequestClass("com.iconshot.detonator.storage::setItem", StorageSetItemRequest.class);
    }

    private static SharedPreferences getSharedPreferences(Context context, String name) {
        return context.getSharedPreferences(name, Context.MODE_PRIVATE);
    }

    public static class StorageGetItemRequest extends Request<StorageGetItemRequest.Data> {
        public StorageGetItemRequest(Detonator detonator, IncomingRequest incomingRequest) {
            super(detonator, incomingRequest);
        }

        @Override
        public void run() {
            Data data = decodeData(Data.class);

            SharedPreferences sharedPreferences = StorageModule.getSharedPreferences(detonator.context, data.name);

            String value = sharedPreferences.getString(data.key, null);

            end(value);
        }

        public class Data {
            String name;
            String key;
        }
    }

    public static class StorageSetItemRequest extends Request<StorageSetItemRequest.Data> {
        public StorageSetItemRequest(Detonator detonator, IncomingRequest incomingRequest) {
            super(detonator, incomingRequest);
        }

        @Override
        public void run() {
            Data data = decodeData(Data.class);

            SharedPreferences sharedPreferences = StorageModule.getSharedPreferences(detonator.context, data.name);

            SharedPreferences.Editor editor = sharedPreferences.edit();

            editor.putString(data.key, data.value);

            editor.apply();

            end();
        }

        public class Data {
            String name;
            String key;
            String value;
        }
    }
}
