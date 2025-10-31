require "./app"

ATH.configure({
  framework: {
    cors: {
      enabled:  true,
      defaults: {
        allow_origin: ["*"],
      },
    },
  },
})

ATH.run
