package com.iconshot.detonator.module;

import com.iconshot.detonator.Detonator;

public abstract class Module {
    protected Detonator detonator;

    public Module(Detonator detonator) {
        this.detonator = detonator;
    }

    public abstract void setUp();
}
