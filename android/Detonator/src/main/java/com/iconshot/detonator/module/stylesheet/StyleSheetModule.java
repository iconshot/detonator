package com.iconshot.detonator.module.stylesheet;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.module.Module;
import com.iconshot.detonator.renderer.Edge;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StyleSheetModule extends Module {
    public StyleSheetModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void register() {
        detonator.setMessageListener("com.iconshot.detonator.stylesheet::create", value -> {
            IdStyleEntry[] idStyleEntries = detonator.decode(value, IdStyleEntry[].class);

            for (IdStyleEntry idStyleEntry : idStyleEntries) {
                styleEntries.put(idStyleEntry.id, idStyleEntry.styleEntry);
            }
        });

        detonator.setMessageListener("com.iconshot.detonator.stylesheet::applyStyle", value -> {
            ElementStyleEntry[] elementStyleEntries = detonator.decode(value, ElementStyleEntry[].class);

            for (ElementStyleEntry elementStyleEntry : elementStyleEntries) {
                Edge edge = detonator.getEdge(elementStyleEntry.elementId);

                edge.element.applyStyle(elementStyleEntry.styleEntries);
            }

            detonator.performLayout();
        });

        detonator.setMessageListener("com.iconshot.detonator.stylesheet::removeStyle", value -> {
            ElementRemoveStyleEntry[] elementRemoveStyleEntries = detonator.decode(value, ElementRemoveStyleEntry[].class);

            for (ElementRemoveStyleEntry elementRemoveStyleEntry : elementRemoveStyleEntries) {
                Edge edge = detonator.getEdge(elementRemoveStyleEntry.elementId);

                edge.element.removeStyle(elementRemoveStyleEntry.toRemoveKeys);
            }

            detonator.performLayout();
        });
    }

    public static Map<Integer, StyleEntry> styleEntries = new HashMap<>();

    class IdStyleEntry {
        int id;
        StyleEntry styleEntry;
    }

    class ElementStyleEntry {
        int elementId;
        StyleEntry[] styleEntries;
    }

    class ElementRemoveStyleEntry {
        int elementId;
        List<String>[] toRemoveKeys;
    }
}
