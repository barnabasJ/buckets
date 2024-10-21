defmodule BucketsWeb.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["en", "de"],
    providers: [Cldr.Number, Cldr.DateTime, Cldr.Calendar, Cldr.Unit],
    gettext: MyApp.Gettext,
    data_dir: "./priv/cldr",
    otp_app: :buckets,
    precompile_number_formats: ["¤¤#,##0.##"],
    precompile_transliterations: [{:latn, :arab}, {:thai, :latn}]
end
