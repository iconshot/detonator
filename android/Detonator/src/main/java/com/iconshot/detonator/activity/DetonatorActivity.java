package com.iconshot.detonator.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.layout.ViewLayout;

public class DetonatorActivity extends AppCompatActivity {
    private Detonator detonator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ViewLayout rootView = new ViewLayout(this);

        setContentView(rootView);

        detonator = new Detonator(rootView, "dist/index.js");
    }
}
