import daisyui from "daisyui";

export default {
  content: ["./src/**/*.{vue,js,ts}"],
  plugins: [
    daisyui, // added Daisy UI TailwindCSS plugin
  ],
  theme: {
    extend: {},
  },
  daisyui: {
    theme: ["forest", "lemonade", "valentine"],
  },
};
