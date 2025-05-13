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
        detonator.addMessageHandler("com.iconshot.detonator.stylesheet/create", dataString -> {
            IdStyleEntry[] idStyleEntries = detonator.decode(dataString, IdStyleEntry[].class);

            for (IdStyleEntry idStyleEntry : idStyleEntries) {
                styleEntries.put(idStyleEntry.id, idStyleEntry.styleEntry);
            }
        });

        detonator.addMessageHandler("com.iconshot.detonator.stylesheet/applyStyle", dataString -> {
            ElementStyleEntry[] elementStyleEntries = detonator.decode(dataString, ElementStyleEntry[].class);

            for (ElementStyleEntry elementStyleEntry : elementStyleEntries) {
                Edge edge = detonator.getEdge(elementStyleEntry.elementId);

                edge.element.applyStyle(elementStyleEntry.styleEntries);
            }

            detonator.performLayout();
        });

        detonator.addMessageHandler("com.iconshot.detonator.stylesheet/removeStyle", dataString -> {
            ElementRemoveStyleEntry[] elementRemoveStyleEntries = detonator.decode(dataString, ElementRemoveStyleEntry[].class);

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
