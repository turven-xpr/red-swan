import 'package:drift/drift.dart';

import '../local/app_database.dart';

/// B1 deck — 82 flashcards across 6 themes.  Mirrors the
/// rows of `RESEARCH_A2_B1.md`.
class B1Deck {
  /// Returns the deck wrapped in [FlashcardsCompanion.insert] for
  /// Drift hydration.  Cards appear in the B1 SRS bucket on
  /// first launch.
  static List<FlashcardsCompanion> entries({
    required DateTime now,
  }) {
    return _wrap([
      FlashEntry("die Gesellschaft", "society", "la société", "المُجتَمَع", "noun", "Unsere Gesellschaft verändert sich schnell.", "Our society is changing quickly.", "Gesellschaft & Politik"),
      FlashEntry("die Politik", "politics", "la politique", "السِّياسَة", "noun", "Politik interessiert mich sehr.", "I'm very interested in politics.", "Gesellschaft & Politik"),
      FlashEntry("die Regierung", "the government", "le gouvernement", "الحُكومَة", "noun", "Die Regierung diskutiert neue Gesetze.", "The government is discussing new laws.", "Gesellschaft & Politik"),
      FlashEntry("das Gesetz", "the law", "la loi", "القَانُون", "noun", "Das neue Gesetz gilt ab Juli.", "The new law applies from July.", "Gesellschaft & Politik"),
      FlashEntry("das Recht", "the (legal) right", "le droit", "الحَقّ", "noun", "Du hast das Recht zu schweigen.", "You have the right to remain silent.", "Gesellschaft & Politik"),
      FlashEntry("die Demokratie", "democracy", "la démocratie", "الدِّيمُقرَاطِيَّة", "noun", "Die Demokratie lebt vom Mitmachen.", "Democracy thrives on participation.", "Gesellschaft & Politik"),
      FlashEntry("die Wahl", "the election/choice", "l'élection", "الانتخاب", "noun", "Wann ist die nächste Wahl?", "When is the next election?", "Gesellschaft & Politik"),
      FlashEntry("wählen", "to vote / to choose", "voter", "يُنتَخِب / يَختار", "verb", "Wir wählen alle vier Jahre.", "We vote every four years.", "Gesellschaft & Politik"),
      FlashEntry("die Partei", "the party", "le parti", "الحِزب", "noun", "Sie ist Mitglied der Regierungspartei.", "She's a member of the governing party.", "Gesellschaft & Politik"),
      FlashEntry("der Bürger", "the citizen", "le citoyen", "المُواطِن", "noun", "Bürger haben viele Rechte.", "Citizens have many rights.", "Gesellschaft & Politik"),
      FlashEntry("die Meinungsfreiheit", "freedom of speech", "la liberté d'expression", "حُرِّيَّة الرَّأي", "noun", "Meinungsfreiheit ist ein Grundrecht.", "Freedom of speech is a basic right.", "Gesellschaft & Politik"),
      FlashEntry("die Gleichberechtigung", "equal rights", "l'égalité", "المُسَاوَاة", "noun", "Gleichberechtigung ist uns wichtig.", "Equal rights are important to us.", "Gesellschaft & Politik"),
      FlashEntry("die Politikverdrossenheit", "political disenchantment", "la désillusion", "الإحباط السِّياسيّ", "noun", "Viele sprechen heute von Politikverdrossenheit.", "Many talk today about political disenchantment.", "Gesellschaft & Politik"),
      FlashEntry("die Wirtschaft", "the economy", "l'économie", "الاقتصاد", "noun", "Die Wirtschaft wächst wieder.", "The economy is growing again.", "Wirtschaft & Arbeit"),
      FlashEntry("das Unternehmen", "the company", "l'entreprise", "الشَّرِكَة", "noun", "Das Unternehmen hat fünfzig Mitarbeiter.", "The company has fifty employees.", "Wirtschaft & Arbeit"),
      FlashEntry("der Gewinn", "the profit", "le bénéfice", "الرِّبح", "noun", "Der Gewinn ist dieses Jahr gestiegen.", "Profit has risen this year.", "Wirtschaft & Arbeit"),
      FlashEntry("der Verlust", "the loss", "la perte", "الخَسارَة", "noun", "Wir mussten einen Verlust hinnehmen.", "We had to absorb a loss.", "Wirtschaft & Arbeit"),
      FlashEntry("der Umsatz", "the turnover", "le chiffre d'affaires", "حَجم البِياعَات", "noun", "Der Umsatz steigt stetig.", "Turnover is steadily rising.", "Wirtschaft & Arbeit"),
      FlashEntry("die Investition", "the investment", "l'investissement", "الاسِتثمار", "noun", "Investitionen in Bildung sind wichtig.", "Investments in education are important.", "Wirtschaft & Arbeit"),
      FlashEntry("die Inflation", "inflation", "l'inflation", "التَّضخُّم", "noun", "Die Inflation bleibt hoch.", "Inflation remains high.", "Wirtschaft & Arbeit"),
      FlashEntry("die Arbeitslosigkeit", "unemployment", "le chômage", "البِطالَة", "noun", "Arbeitslosigkeit ist ein großes Problem.", "Unemployment is a major problem.", "Wirtschaft & Arbeit"),
      FlashEntry("der Kunde", "the customer", "le client", "العَميل", "noun", "Der Kunde ist König.", "The customer is king.", "Wirtschaft & Arbeit"),
      FlashEntry("der Mitarbeiter", "the employee", "l'employé", "المُوَظَّف", "noun", "Wir suchen einen neuen Mitarbeiter.", "We're hiring a new employee.", "Wirtschaft & Arbeit"),
      FlashEntry("der Vertrag", "the contract", "le contrat", "العَقد", "noun", "Bitte unterschreiben Sie den Vertrag.", "Please sign the contract.", "Wirtschaft & Arbeit"),
      FlashEntry("das Gehalt", "the salary", "le salaire", "الرَّاتب", "noun", "Mein Gehalt ist fair.", "My salary is fair.", "Wirtschaft & Arbeit"),
      FlashEntry("der Kündigungsschutz", "protection against dismissal", "la protection", "حِمايَّة من الفَصل", "noun", "In Deutschland gibt es starken Kündigungsschutz.", "Germany has strong dismissal protection.", "Wirtschaft & Arbeit"),
      FlashEntry("die Technologie", "technology", "la technologie", "التِّكنولوجيا", "noun", "Neue Technologie verändert unser Leben.", "New technology changes our life.", "Technik & Medien"),
      FlashEntry("das Internet", "the internet", "l'internet", "الإنترنت", "noun", "Das Internet ist heute fast überall verfügbar.", "The internet is available almost everywhere today.", "Technik & Medien"),
      FlashEntry("die Software", "the software", "le logiciel", "البَرنامَج", "noun", "Diese Software ist kostenlos.", "This software is free.", "Technik & Medien"),
      FlashEntry("die Hardware", "the hardware", "le matériel", "الأَجهِزَة", "noun", "Die Hardware ist veraltet.", "The hardware is outdated.", "Technik & Medien"),
      FlashEntry("das Smartphone", "the smartphone", "le smartphone", "الهَاتِف الذَّكيّ", "noun", "Mein Smartphone ist gestern kaputtgegangen.", "My smartphone broke yesterday.", "Technik & Medien"),
      FlashEntry("die App", "the app", "l'appli", "التَّطبِيق", "noun", "Diese App ist sehr nützlich.", "This app is very useful.", "Technik & Medien"),
      FlashEntry("die Website", "the website", "le site web", "مَوقِع الرَّبط", "noun", "Die Website ist gut gestaltet.", "The website is well designed.", "Technik & Medien"),
      FlashEntry("das Passwort", "the password", "le mot de passe", "كَلِمَة السِّرّ", "noun", "Vergiss dein Passwort nicht.", "Don't forget your password.", "Technik & Medien"),
      FlashEntry("die Daten (pl)", "the data", "les données", "البَيانَات", "noun", "Daten sind das neue Gold.", "Data is the new gold.", "Technik & Medien"),
      FlashEntry("die Datenschutz", "data protection", "la protection des données", "حِمايَة البَيانَات", "noun", "Datenschutz ist uns wichtig.", "Data protection is important to us.", "Technik & Medien"),
      FlashEntry("sich informieren", "to inform oneself", "s'informer", "يَستعِلم", "phrase", "Ich informiere mich täglich.", "I inform myself daily.", "Technik & Medien"),
      FlashEntry("die Nachricht (im Funk)", "the message/news", "le message", "رِسالَة / خَبَر", "noun", "Schick mir bitte eine Nachricht.", "Please send me a message.", "Technik & Medien"),
      FlashEntry("soziale Netzwerke", "social networks", "les réseaux sociaux", "الشَّبَكات الاجتماعيَّة", "phrase", "Soziale Netzwerke verändern die Kommunikation.", "Social networks change communication.", "Technik & Medien"),
      FlashEntry("die Umwelt", "the environment", "l'environnement", "البِيئَة", "noun", "Die Umwelt braucht unsere Hilfe.", "The environment needs our help.", "Umwelt & Natur"),
      FlashEntry("die Natur", "nature", "la nature", "الطَّبيعَة", "noun", "Die Natur ist sehr vielfältig.", "Nature is very diverse.", "Umwelt & Natur"),
      FlashEntry("der Klimawandel", "climate change", "le changement climatique", "تَغَيُّر المَناخ", "noun", "Der Klimawandel ist eine globale Bedrohung.", "Climate change is a global threat.", "Umwelt & Natur"),
      FlashEntry("der Wald", "the forest", "la forêt", "الغَابَة", "noun", "Wälder sind wichtig für das Klima.", "Forests are important for the climate.", "Umwelt & Natur"),
      FlashEntry("das Meer", "the sea", "la mer", "البَحر", "noun", "Das Meer bedeckt 70 Prozent der Erde.", "The sea covers 70 percent of the Earth.", "Umwelt & Natur"),
      FlashEntry("der Fluss", "the river", "la rivière", "النَّهر", "noun", "Der Rhein ist ein wichtiger Fluss.", "The Rhine is an important river.", "Umwelt & Natur"),
      FlashEntry("der Berg", "the mountain", "la montagne", "الجَبَل", "noun", "Die Alpen sind hohe Berge.", "The Alps are high mountains.", "Umwelt & Natur"),
      FlashEntry("die Luft", "the air", "l'air", "الهَواء", "noun", "Die Luft ist heute sauber.", "The air is clean today.", "Umwelt & Natur"),
      FlashEntry("die Luftverschmutzung", "air pollution", "la pollution de l'air", "تَلَوُّث الهَواء", "noun", "Luftverschmutzung ist in Großstädten schlimm.", "Air pollution is bad in big cities.", "Umwelt & Natur"),
      FlashEntry("der Müll", "the trash", "les déchets", "القِمامَة", "noun", "Wir müssen den Müll trennen.", "We have to separate the trash.", "Umwelt & Natur"),
      FlashEntry("das Recycling", "the recycling", "le recyclage", "إعَادَة التَّدوير", "noun", "Recycling hilft der Umwelt.", "Recycling helps the environment.", "Umwelt & Natur"),
      FlashEntry("die Tierart", "the animal species", "l'espèce", "النَّوع الحَيَوانيّ", "noun", "Viele Tierarten sind vom Aussterben bedroht.", "Many animal species are endangered.", "Umwelt & Natur"),
      FlashEntry("der Klimaschutz", "climate protection", "la protection du climat", "حِمايَة المَناخ", "noun", "Klimaschutz ist eine globale Aufgabe.", "Climate protection is a global task.", "Umwelt & Natur"),
      FlashEntry("die Erde", "the Earth", "la Terre", "الأَرض", "noun", "Die Erde dreht sich um die Sonne.", "The Earth rotates around the Sun.", "Umwelt & Natur"),
      FlashEntry("die Bildung", "education", "l'éducation", "التَّعليم", "noun", "Bildung ist der Schlüssel zur Zukunft.", "Education is the key to the future.", "Bildung & Kultur"),
      FlashEntry("die Schule", "the school", "l'école", "المَدرَسَة", "noun", "Ich gehe morgens zur Schule.", "I go to school in the morning.", "Bildung & Kultur"),
      FlashEntry("die Universität", "the university", "l'université", "الجَامِعَة", "noun", "Sie studiert an der Universität München.", "She studies at Munich university.", "Bildung & Kultur"),
      FlashEntry("der Studiengang", "the degree programme", "le cursus", "البَرنامَج الدِّراسيّ", "noun", "Welcher Studiengang passt zu dir?", "Which degree programme suits you?", "Bildung & Kultur"),
      FlashEntry("der Abschluss", "the graduation", "le diplôme", "التَّخرُّج", "noun", "Sie hat ihren Abschluss mit Auszeichnung gemacht.", "She graduated with distinction.", "Bildung & Kultur"),
      FlashEntry("das Wissen", "the knowledge", "le savoir", "المَعرِفَة", "noun", "Wissen ist Macht.", "Knowledge is power.", "Bildung & Kultur"),
      FlashEntry("die Ausbildung", "the training/apprenticeship", "la formation", "التَّدرِيب", "noun", "Er macht eine Ausbildung zum Handwerker.", "He's doing an apprenticeship as a craftsman.", "Bildung & Kultur"),
      FlashEntry("die Kultur", "culture", "la culture", "الثَّقافَة", "noun", "Die deutsche Kultur ist vielfältig.", "German culture is varied.", "Bildung & Kultur"),
      FlashEntry("die Literatur", "literature", "la littérature", "الأَدَب", "noun", "Deutsche Literatur ist stark.", "German literature is strong.", "Bildung & Kultur"),
      FlashEntry("die Kunst", "art", "l'art", "الفَنّ", "noun", "Kunst spiegelt die Gesellschaft.", "Art mirrors society.", "Bildung & Kultur"),
      FlashEntry("die Tradition", "tradition", "la tradition", "التَّقْليد", "noun", "Familientraditionen sind uns wichtig.", "Family traditions are important to us.", "Bildung & Kultur"),
      FlashEntry("die Sprache", "the language", "la langue", "اللُّغَة", "noun", "Sprache ist das Tor zur Welt.", "Language is the gateway to the world.", "Bildung & Kultur"),
      FlashEntry("das Museum", "the museum", "le musée", "المَتْحَف", "noun", "Wir gehen am Wochenende ins Museum.", "We go to the museum on the weekend.", "Bildung & Kultur"),
      FlashEntry("die Weltoffenheit", "open-mindedness", "l'ouverture d'esprit", "انفِتاح العَقل", "noun", "Weltoffenheit ist ein deutscher Wert.", "Open-mindedness is a German value.", "Bildung & Kultur"),
      FlashEntry("die Beziehung", "the relationship", "la relation", "العَلاقَة", "noun", "Unsere Beziehung ist stabil.", "Our relationship is stable.", "Beziehungen & Emotionen"),
      FlashEntry("die Freundschaft", "the friendship", "l'amitié", "الصَّداقَة", "noun", "Freundschaft ist unbezahlbar.", "Friendship is priceless.", "Beziehungen & Emotionen"),
      FlashEntry("die Liebe", "the love", "l'amour", "الحُبّ", "noun", "Liebe kennt keine Grenzen.", "Love knows no boundary.", "Beziehungen & Emotionen"),
      FlashEntry("die Familie", "the family", "la famille", "العَائِلَة", "noun", "Familie ist wichtig.", "Family is important.", "Beziehungen & Emotionen"),
      FlashEntry("die Ehe", "the marriage", "le mariage", "الزَّواج", "noun", "Die Ehe wird gefeiert.", "The marriage is being celebrated.", "Beziehungen & Emotionen"),
      FlashEntry("die Scheidung", "the divorce", "le divorce", "الطَّلاق", "noun", "Scheidung tut weh.", "Divorce hurts.", "Beziehungen & Emotionen"),
      FlashEntry("die Nachbarschaft", "the neighbourhood", "le voisinage", "الجِيران", "noun", "Eine gute Nachbarschaft hilft allen.", "A good neighbourhood helps everyone.", "Beziehungen & Emotionen"),
      FlashEntry("das Glück", "the happiness", "le bonheur", "السَّعَادَة", "noun", "Glück lässt sich nicht kaufen.", "Happiness can't be bought.", "Beziehungen & Emotionen"),
      FlashEntry("die Trauer", "the grief", "le deuil", "الحُزن", "noun", "Trauer braucht Zeit.", "Grief needs time.", "Beziehungen & Emotionen"),
      FlashEntry("die Angst", "the fear", "la peur", "الخَوْف", "noun", "Angst vor Veränderung ist normal.", "Fear of change is normal.", "Beziehungen & Emotionen"),
      FlashEntry("die Wut", "the rage", "la colère", "الغَضَب", "noun", "Wut ist eine starke Emotion.", "Rage is a strong emotion.", "Beziehungen & Emotionen"),
      FlashEntry("die Freude", "the joy", "la joie", "الفَرح", "noun", "Diese Nachricht bereitet uns Freude.", "This news brings us joy.", "Beziehungen & Emotionen"),
      FlashEntry("die Einsamkeit", "the loneliness", "la solitude", "الوَحْدَة", "noun", "Einsamkeit ist ein ernstes Thema.", "Loneliness is a serious issue.", "Beziehungen & Emotionen"),
      FlashEntry("vertrauen", "to trust", "faire confiance", "يَثِق", "verb", "Wir vertrauen unserem Team.", "We trust our team.", "Beziehungen & Emotionen"),
      FlashEntry("sich verlieben", "to fall in love", "tomber amoureux", "يُعجَب", "phrase", "Ich habe mich verliebt.", "I fell in love.", "Beziehungen & Emotionen"),
    ], 'B1', now);
  }
}

class FlashEntry {
  const FlashEntry(this.de, this.en, this.fr, this.ar, this.kind,
      this.exampleDe, this.exampleEn, this.theme);
  final String de;
  final String en;
  final String fr;
  final String ar;
  final String kind;
  final String exampleDe;
  final String exampleEn;
  final String theme;
}

List<FlashcardsCompanion> _wrap(
    List<FlashEntry> entries, String level, DateTime now) {
  return entries
      .map((e) => FlashcardsCompanion.insert(
            german: e.de,
            english: e.en,
            french: Value(e.fr),
            arabic: Value(e.ar),
            partOfSpeech: e.kind,
            exampleGerman: Value(e.exampleDe),
            exampleEnglish: Value(e.exampleEn),
            theme: Value(e.theme),
            level: Value(level),
            nextReviewDate: now,
          ))
      .toList(growable: false);
}
