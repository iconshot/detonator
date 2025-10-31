package com.iconshot.detonator.module.stylesheet;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.module.Module;
import com.iconshot.detonator.renderer.Edge;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StyleSheetModule extends Module {
    public static Map<Integer, StyleEntry> styleEntries = new HashMap<>();

    public StyleSheetModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setEventListener("com.iconshot.detonator.stylesheet::create", value -> {
            IdStyleEntry[] idStyleEntries = detonator.decode(value, IdStyleEntry[].class);

            for (IdStyleEntry idStyleEntry : idStyleEntries) {
                styleEntries.put(idStyleEntry.id, idStyleEntry.styleEntry);
            }
        });

        detonator.setEventListener("com.iconshot.detonator.stylesheet::applyStyle", value -> {
            ElementStyleEntry[] elementStyleEntries = detonator.decode(value, ElementStyleEntry[].class);

            for (ElementStyleEntry elementStyleEntry : elementStyleEntries) {
                Edge edge = detonator.getEdge(elementStyleEntry.elementId);

                edge.element.applyStyle(elementStyleEntry.styleEntries);
            }

            detonator.performLayout();
        });

        detonator.setEventListener("com.iconshot.detonator.stylesheet::removeStyle", value -> {
            ElementRemoveStyleEntry[] elementRemoveStyleEntries = detonator.decode(value, ElementRemoveStyleEntry[].class);

            for (ElementRemoveStyleEntry elementRemoveStyleEntry : elementRemoveStyleEntries) {
                Edge edge = detonator.getEdge(elementRemoveStyleEntry.elementId);

                edge.element.removeStyle(elementRemoveStyleEntry.toRemoveKeys);
            }

            detonator.performLayout();
        });
    }

    private static class IdStyleEntry {
        int id;
        StyleEntry styleEntry;
    }

    private static class ElementStyleEntry {
        int elementId;
        StyleEntry[] styleEntries;
    }

    private static class ElementRemoveStyleEntry {
        int elementId;
        List<String>[] toRemoveKeys;
    }
}
