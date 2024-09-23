import $, { Animation, Hook } from "untrue";

import { View, Text, Color } from "detonator";

const buttonColor = new Color(Color.Hues.CERULEAN);

function App() {
  const [counter, updateCounter] = Hook.useState(0);

  const textRef = Hook.useRef<Text>();

  const animation = Hook.useMemo(() => new Animation(0));

  Hook.useAnimation(animation, () => {
    const text = textRef.current!;

    text.style({
      opacity: animation.interpolate([0, 1], [1, 0]),
      top: animation.interpolate([0, 1], [0, 50]),
    });
  });

  const onTap = () => {
    const transition = animation.animate(1, 150);

    transition.on("end", () => {
      updateCounter(counter + 1).done(() => {
        animation.animate(0, 150);
      });
    });
  };

  return $(
    View,
    {
      style: {
        width: "100%",
        height: "100%",
        justifyContent: "center",
        alignItems: "center",
      },
    },
    [
      $(Text, { style: { fontSize: 30, marginBottom: 30 } }, "Hello, world."),
      $(
        Text,
        { ref: textRef, style: { fontSize: 24, marginBottom: 30 } },
        counter
      ),
      $(
        View,
        {
          style: {
            borderRadius: 10,
            backgroundColor: buttonColor.hex(90),
            justifyContent: "center",
            alignItems: "center",
            paddingVertical: 15,
            paddingHorizontal: 25,
          },
          onTap,
        },
        $(Text, { style: { color: "white", fontSize: 18 } }, "Tap")
      ),
    ]
  );
}

export default App;
