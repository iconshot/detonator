import $, { Hook } from "untrue";

import { View, Text, Color, StyleSheet } from "detonator";

const buttonColor = new Color(Color.Hues.CERULEAN);

const styles = StyleSheet.create({
  container: {
    width: "100%",
    height: "100%",
    backgroundColor: "black",
    justifyContent: "center",
    alignItems: "center",
    gap: 30,
  },
  heading: { color: "white", fontSize: 30 },
  counter: { color: "white", fontSize: 24 },
  button: {
    borderRadius: 10,
    backgroundColor: buttonColor.hex(90),
    justifyContent: "center",
    alignItems: "center",
    paddingVertical: 15,
    paddingHorizontal: 25,
  },
  buttonText: { color: "white", fontSize: 18 },
});

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

  const onTap = Hook.useCallback(() => {
    const transition = animation.animate(1, 150);

    transition.on("end", () => {
      updateCounter(counter + 1).done(() => {
        animation.animate(0, 150);
      });
    });
  }, [counter]);

  return $(View, { style: styles.container }, [
    $(Text, { style: styles.heading }, "Hello, world."),
    $(Text, { ref: textRef, style: styles.counter }, counter),
    $(
      View,
      { style: styles.button, onTap },
      $(Text, { style: styles.buttonText }, "Tap")
    ),
  ]);
}

export default App;
