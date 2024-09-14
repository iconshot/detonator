package com.iconshot.detonator.tree;

import android.view.View;
import android.view.ViewParent;

import com.iconshot.detonator.layout.ViewLayout;

public class Target {
    private final ViewLayout view;
    private int index;

    public Target(ViewLayout view, int index) {
        this.view = view;
        this.index = index;
    }

    public void insert(View child) {
        ViewParent parent = child.getParent();

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
