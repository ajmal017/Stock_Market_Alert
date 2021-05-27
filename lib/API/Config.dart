class Config {
  static final String API_KEY = "Tpk_ed17789aa23448839382da6aa7e173b9";
  static final String prefix_url = "https://sandbox.iexapis.com/stable/";

  static final basic_symbol_data = "ref-data/symbols?token=" + API_KEY;
  static final news_data =
      'time-series/news?range=1m&limit=30&token=' + API_KEY;
  static final analytics =
      "batch?types=quote,chart&range=1y&chartCloseOnly=true&token=" + API_KEY;
}
