import $, { Hook } from "untrue";

import { View, Text, Color } from "detonator";

const buttonColor = new Color(Color.Hues.CERULEAN);

function App() {
  const [counter, updateCounter] = Hook.useState(0);

  const textRef = Hook.useRef<Text>();

  const animation = Hook.useAnimation(0);

  animation.use(() => {
    const text = textRef.value!;

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
        backgroundColor: "black",
        justifyContent: "center",
        alignItems: "center",
        gap: 30,
      },
    },
    [
      $(Text, { style: { color: "white", fontSize: 30 } }, "Hello, world."),
      $(
        Text,
        {
          ref: textRef,
          style: { color: "white", fontSize: 24 },
        },
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
