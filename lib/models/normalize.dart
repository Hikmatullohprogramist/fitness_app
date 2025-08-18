// API dagi mashqlar uchun kengaytirilgan MET mapping
final Map<String, double> metKeywords = {
  // Asosiy
  "aerobika": 6.8,
  "jismoniy tarbiya": 2.5,
  "oyoq": 4.0,
  "tez yurish": 3.8,
  "yugurish": 7.0,
  "sakrash": 11.0,
  "yurish": 2.8,
  "planka": 3.3,
  "qo‘l": 3.5,
  "butun tana": 6.0,
  "yoga": 2.5,
  "kardio": 8.0,
  "intensiv": 9.0,
  "cho‘zilish": 2.3,
  "bel": 4.5,
  "qorin": 3.8,

  // Siz tashagan loglardan (extra keywords)
  "stul": 2.5, // stulda bajariladigan mashqlar (otirish, bukish) – past yuklama
  "tors": 3.8, // gavda burish/egilish – o‘rtacha yuklama
  "depsinish": 4.0, // oyoq depsinish mashqlari
  "balandlik": 5.0, // step-up (balandlikka chiqish)
  "o‘tirish": 4.0, // squat va variantlari
  "qadam": 3.8, // qadam tashlash, yugurish tempida mashqlar
  "aylanma": 4.0, // oyoq/gavda aylanma mashqlar
  "sakrab o‘tirish": 6.0, // plyometric squat
  "o‘rdak yurishi": 4.5, // duck walk
  "yugurayotgandek": 6.5, // high knees va shunga o‘xshash
  "rezina": 5.5, // rezina lenta bilan mashqlar – qo‘shimcha yuklama
  "gantel": 6.0, // gantel bilan mashqlar
  "og‘irlik": 6.5, // og‘ir nimcha va sh.k.
  "qirolicha": 4.2, // curtsey squat
  "aylanib sakrash": 7.0, // jump + spin
};

String normalize(String text) {
  return text.toLowerCase().trim();
}

double getMetValue(String name, String? description) {
  final String text = normalize("$name ${description ?? ''}");

  for (final keyword in metKeywords.keys) {
    if (text.contains(keyword)) {
      return metKeywords[keyword]!;
    }
  }

  return 3.0; // default qiymat
}
