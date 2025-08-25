import 'package:flutter/material.dart';

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nazariy ma\'lumot'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildTheorySection(
            context,
            'Mashqlar nazariyasi',
            [
              _buildTheoryTile(
                context,
                'Professiogramma',
                'Kasb uchun zarur bo\'lgan bilim, malaka va kompetensiyalar',
                Icons.work,
                _getProfessiogrammaContent(),
              ),
              _buildTheoryTile(
                context,
                'Aerobika mashqlari',
                'Musiqa ostida bajariladigan koordinatsiya mashqlari',
                Icons.music_note,
                _getAerobikaContent(),
              ),
              _buildTheoryTile(
                context,
                'Yuqori intensivlikdagi mashqlar (YIM)',
                'Qisqa muddatli interval mashqlar',
                Icons.flash_on,
                _getYIMContent(),
              ),
              _buildTheoryTile(
                context,
                'Kardio mashqlar',
                'Yurak-qon tomir tizimini mustahkamlash',
                Icons.favorite,
                _getKardioContent(),
              ),
              _buildTheoryTile(
                context,
                'Yoga mashqlari',
                'Tiklovchi va chiniqtiruvchi mashg\'ulotlar',
                Icons.self_improvement,
                _getYogaContent(),
              ),
            ],
          ),
          _buildTheorySection(
            context,
            'Jismoniy tarbiya daqiqalari',
            [
              _buildTheoryTile(
                context,
                'Jismoniy tarbiya daqiqalari',
                '5-10 daqiqalik qisqa mashqlar majmuasi',
                Icons.timer,
                _getPhysicalMinutesContent(),
              ),
            ],
          ),
          _buildTheorySection(
            context,
            'Mushak guruhlari bo\'yicha mashqlar',
            [
              _buildTheoryTile(
                context,
                'Qo\'l va yelka muskullari',
                'Kuch, chidamlilik va mushak massasini oshirish',
                Icons.fitness_center,
                _getArmShoulderContent(),
              ),
              _buildTheoryTile(
                context,
                'Qorin muskullari',
                'Qorin pressini mustahkamlash va posturani yaxshilash',
                Icons.accessibility,
                _getAbsContent(),
              ),
              _buildTheoryTile(
                context,
                'Oyoq muskullari',
                'Kuch, chidamlilik va muvozanatni oshirish',
                Icons.directions_walk,
                _getLegContent(),
              ),
              _buildTheoryTile(
                context,
                'Bel va orqa muskullari',
                'Umurtqa pog\'onasini qo\'llab-quvvatlash',
                Icons.accessibility_new,
                _getBackContent(),
              ),
            ],
          ),
          _buildTheorySection(
            context,
            'Maxsus mashqlar',
            [
              _buildTheoryTile(
                context,
                'Cho\'zilish mashqlari',
                'Mushaklarning elastikligini oshirish',
                Icons.sports_gymnastics,
                _getStretchingContent(),
              ),
              _buildTheoryTile(
                context,
                'Butun tana mashqlari',
                'Barcha mushak guruhlarini qamrab oluvchi mashqlar',
                Icons.sports,
                _getFullBodyContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTheorySection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTheoryTile(BuildContext context, String title, String subtitle,
      IconData icon, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TheoryDetailScreen(
                title: title,
                content: content,
                icon: icon,
              ),
            ),
          );
        },
      ),
    );
  }

  String _getProfessiogrammaContent() {
    return '''Professiogramma (kasbiy tavsifnoma) - bu kasb uchun ilmiy asoslangan norma va talablar to'plami bo'lib, u kasbga, professional faoliyat turiga hamda mutaxassisning shaxs sifatlariga qo'yilgan talablarni ifodalaydi.

🎯 Maqsadi:
• Pedagoglarning kasbiy rivojlanishi
• Tayyorgarlik darajasini belgilash
• Zarur bilim, malaka va kompetensiyalarni aniqlash
• Pedagogik jarayonning samaradorligini monitoring qilish

Bu - muayyan sohadagi mutaxassisning umumlashtirilgan etalon modelidir.''';
  }

  String _getAerobikaContent() {
    return '''Aerobika mashqlari musiqa ostida bajariladigan funksional rivojlantiruvchi mashg'ulotlardir.

✨ Asosiy xususiyatlari:
• Muvofiqlik (koordinatsiya) rivojlantiradi
• Harakat uyg'unligi va nafas olish tizimini yaxshilaydi
• Stressni kamaytiradi
• Jismoniy yuklamaning ko'tarinki ruhda o'tishini ta'minlaydi

🎵 Samarasi:
• Yog' almashinuvini faollashtiradi
• Tana vaznini me'yorlashtiradi
• O'rtacha intensivlikda uzoqroq davom etadi
• Sog'lomlashtiruvchi ta'sir ko'rsatadi''';
  }

  String _getYIMContent() {
    return '''Yuqori intensivlikdagi mashqlar (YIM) - yuqori tezlik va kuch talab qiladigan qisqa muddatli interval mashqlar.

⚡ Misol:
• 40 soniya yuqori sur'atda sakrash
• Burpi mashqlari
• 15-30 soniya dam olish
• Takrorlash (interval usuli)

🏃‍♂️ Samarasi:
• Qisqa vaqtda yurak urish tezligini oshiradi
• Moddalar almashinuvini faollashtiradi
• Maksimal zo'riqishga tayyorlaydi
• Favqulodda vaziyatlarda chaqqonlik beradi''';
  }

  String _getKardioContent() {
    return '''Kardio mashqlar yurak-qon tomir tizimini mustahkamlashga qaratilgan mashg'ulotlar.

🏃‍♀️ Turları:
• Yugurish
• Sakrash
• Tezkor yurish
• Umumiy chidamlilikni oshiruvchi boshqa mashqlar

❤️ Foydasi:
• Yurak faoliyatini yaxshilaydi
• Nafas olish tizimini mustahkamlaydi
• Uzoq davom etadigan faoliyatda charchoqni kechiktradi
• Ish qobiliyatini yuqori saqlaydi''';
  }

  String _getYogaContent() {
    return '''Yoga mashqlari tiklovchi va chiniqtiruvchi ta'sir ko'rsatadigan mashg'ulotlar majmuasi.

🧘‍♀️ Asanalarning foydasi:
• Mushaklarni cho'zish va bo'shashtirish
• Tananing moslashuvchanligini oshirish
• Nafas olishni boshqarish ko'nikmasi
• Diqqatni jamlash va ruhiy tetiklik

🌟 Ilmiy isbotlangan samarasi:
• Stress gormonlarini pasaytiradi
• Emotsional barqarorlikni ta'minlaydi
• Tiklanish bosqichi uchun ideal
• O'quv yuklama yuqori bo'lgan talabalar uchun foydali''';
  }

  String _getPhysicalMinutesContent() {
    return '''Jismoniy tarbiya daqiqalari - dars yoki ish jarayonida o'tkaziladigan qisqa muddatli jismoniy mashqlar majmuasi (5-10 daqiqa).

🎯 Asosiy vazifalar:
• Charchoqni kamaytirish
• Qon aylanishini yaxshilash
• Mushaklarni bo'shashtirish
• Qaddi-qomatni yaxshilash
• Kayfiyatni ko'tarish
• Ish qobiliyatini oshirish
• Salomatlikni mustahkamlash

💪 Mashqlar turlari:
• Bo'yin va yelka mashqlari (aylantirish, cho'zish)
• Qo'l va oyoq mashqlari (bukish, yozish, aylantirish)
• Gavdani egish va burish
• O'tirish va turish
• Sakrash va yugurish
• Nafas olish mashqlari
• Ko'z mashqlari

Bu mashqlarni darslarda, ish joylarida va hatto uy sharoitida ham bajarish mumkin.''';
  }

  String _getArmShoulderContent() {
    return '''Qo'l va yelka muskullari uchun mashqlar organizmga ko'plab foydali ta'sirlarni ko'rsatadi:

💪 Asosiy foydalar:
1. Kuch va chidamlilikni oshiradi
2. Mushak massasini oshiradi
3. Suyak zichligini yaxshilaydi
4. Bo'g'imlarning harakatchanligini oshiradi
5. Posturani yaxshilaydi

🏃‍♂️ Hayotdagi ahamiyati:
• Kundalik faoliyatni osonlashtiradi (kiyinish, ovqatlanish, uy ishlari)
• Sportdagi ko'rsatkichlarni yaxshilaydi
• Jarohatdan keyin tiklanishni tezlashtiradi
• Og'riqni kamaytiradi
• Psixologik ta'sir ko'rsatadi

⚠️ Eslatma:
Mashqlarni tanlashda jismoniy tayyorgarlik darajasi, maqsad va sog'liqni hisobga oling. To'g'ri texnikada bajarish va haddan tashqari yuklamadan saqlanish muhim.''';
  }

  String _getAbsContent() {
    return '''Qorin muskullari uchun mashqlarning asosiy vazifalari:

🔥 Asosiy foydalar:
1. Qorin pressini mustahkamlaydi
2. Orqa miyani (umurtqa pog'onasini) qo'llab-quvvatlaydi
3. Posturani (qomatni) yaxshilaydi
4. Ichki organlarning faoliyatini yaxshilaydi
5. Nafas olishni yaxshilaydi

💯 Qo'shimcha samaralar:
• Metabolizmni yaxshilaydi
• Sport ko'rsatkichlarini oshiradi
• Og'riqlarni kamaytiradi
• Estetik ko'rinishni yaxshilaydi
• Ich qotishining oldini oladi

🏋️‍♀️ Qorin muskullari:
• Qorinning to'g'ri, qiya va ko'ndalang muskullarini mustahkamlaydi
• Qorin bo'shlig'i a'zolarini qo'llab-quvvatlaydi
• Umurtqa pog'onasi uchun tabiiy korset vazifasini o'taydi''';
  }

  String _getLegContent() {
    return '''Oyoq muskullari uchun mashqlarning asosiy vazifalari:

🦵 Asosiy foydalar:
1. Kuch va chidamlilikni oshiradi
2. Mushak massasini oshiradi
3. Suyak zichligini oshiradi
4. Bo'g'imlarning harakatchanligini yaxshilaydi
5. Muvozanatni yaxshilaydi

🚶‍♂️ Kundalik hayotdagi ahamiyati:
• Yurish, yugurish, sakrashni osonlashtiradi
• Zinadan ko'tarilishni yengillashtiradi
• Yiqilish xavfini kamaytiradi
• Qon aylanishini yaxshilaydi
• Varikoz kengayishi xavfini kamaytiradi

🏃‍♀️ Sportdagi ahamiyati:
• Ko'plab sport turlarida zarur
• Metabolik salomatlikni yaxshilaydi
• Insulin sezuvchanligini oshiradi
• Qonda qand miqdorini nazorat qiladi

Oyoq muskullari tanadagi eng katta mushak guruhlaridan biri hisoblanadi.''';
  }

  String _getBackContent() {
    return '''Bel va orqa muskullari uchun mashqlarning asosiy vazifalari:

🏃‍♂️ Asosiy vazifalar:
1. Umurtqa pog'onasini qo'llab-quvvatlaydi
2. Posturani (qomatni) yaxshilaydi
3. Og'riqlarni kamaytiradi
4. Harakatlarni yaxshilaydi
5. Jarohatlanishning oldini oladi

💨 Qo'shimcha foydalar:
• Nafas olishni yaxshilaydi
• Ichki organlarning faoliyatini yaxshilaydi
• Metabolik salomatlikni yaxshilaydi
• Kundalik faoliyatni osonlashtiradi

⚡ Sportdagi ahamiyati:
Ko'plab sport turlarida (og'ir atletika, kurash, gimnastika, suzish, eshkak eshish) kuchli bel va orqa muskullari zarur.

⚠️ Muhim eslatma:
Umurtqa pog'onasi bilan bog'liq muammolar bo'lsa, mashqlarni bajarishdan oldin shifokor bilan maslahatlashish tavsiya etiladi.''';
  }

  String _getStretchingContent() {
    return '''Cho'zilish mashqlari (stretching) tanaga juda ko'p foyda keltiradigan muhim jismoniy mashq turidir.

🤸‍♀️ Asosiy foydalar:
1. Mushaklarning elastikligini oshiradi
2. Bo'g'imlarning harakatchanligini yaxshilaydi
3. Mushaklardagi zo'riqishni kamaytiradi
4. Qon aylanishini yaxshilaydi
5. Jarohatlanish xavfini kamaytiradi

✨ Qo'shimcha samaralar:
• Posturani yaxshilaydi
• Og'riqlarni kamaytiradi
• Sportdagi ko'rsatkichlarni yaxshilaydi
• Psixologik ta'sir ko'rsatadi
• Tiklanishni tezlashtiradi

📋 To'g'ri bajarish qoidalari:
• Har bir cho'zish 15-30 sekund davomida ushlab turilishi kerak
• Isinishdan keyin yoki jismoniy faoliyatdan so'ng bajarish tavsiya etiladi
• Haddan tashqari zo'riqishdan saqlanish muhim
• To'g'ri texnikaga rioya qilish zarur''';
  }

  String _getFullBodyContent() {
    return '''Butun tana muskullari uchun mashqlar - bir mashg'ulot davomida tananing barcha asosiy mushak guruhlarini qamrab oladigan mashqlar majmuasi.

🏋️‍♂️ Qamrab oladigan mushak guruhlari:
• Oyoqlar
• Orqa
• Ko'krak
• Qorin
• Yelka
• Qo'llar

💪 Asosiy vazifalar:
1. Mushak kuchini va massasini oshiradi
2. Metabolizmni tezlashtiradi
3. Yurak-qon tomir tizimini mustahkamlaydi
4. Gormonal muvozanatni yaxshilaydi
5. Funksional harakatlarni yaxshilaydi

🎯 Qo'shimcha foydalar:
• Jarohatlanish xavfini kamaytiradi
• Muvozanat va koordinatsiyani oshiradi
• Vaznni nazorat qilishga yordam beradi
• Kundalik hayotdagi harakatlarni yaxshilaydi
• Sport ko'rsatkichlarini oshiradi

Bu mashqlar turli xil yuklamalarni o'z ichiga oladi va barcha mushak guruhlarining bir vaqtda rivojlanishini ta'minlaydi.''';
  }
}

class TheoryDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const TheoryDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
