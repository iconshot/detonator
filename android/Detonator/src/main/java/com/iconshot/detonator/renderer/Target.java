package com.iconshot.detonator.renderer;

import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;

import com.iconshot.detonator.module.FullScreenModule;

public class Target {
    public final ViewGroup view;
    public int index;

    public Target(ViewGroup view, int index) {
        this.view = view;
        this.index = index;
    }

    public void insert(View child) {
        ViewParent parent = child.getParent();

        if (child == FullScreenModule.view) {
            return;
        }

        View currentChild = view.getChildAt(index);

        if (currentChild != null) {
            if (child != currentChild) {
                if (parent != null) {
                    remove(child);
                }

                view.addView(child, index);
            }
        } else {
            if (parent != null) {
                remove(child);
            }

            view.addView(child);
        }

        index++;
    }

    public void remove(View child) {
        view.removeView(child);
    }
}
