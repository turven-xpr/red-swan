import 'package:drift/drift.dart';

import '../local/app_database.dart';

/// A2 deck — 84 flashcards across 6 themes.  Mirrors the
/// rows of `RESEARCH_A2_B1.md`.
class A2Deck {
  /// Returns the deck wrapped in [FlashcardsCompanion.insert] for
  /// Drift hydration.  Cards appear in the A2 SRS bucket on
  /// first launch.
  static List<FlashcardsCompanion> entries({
    required DateTime now,
  }) {
    return _wrap([
      FlashEntry("aufstehen", "to get up", "se lever", "يَستيقِظ", "verb", "Ich stehe jeden Morgen um sieben auf.", "I get up every morning at seven.", "Alltag"),
      FlashEntry("aufwachen", "to wake up", "se réveiller", "يَصحو", "verb", "Wann wachst du normalerweise auf?", "When do you usually wake up?", "Alltag"),
      FlashEntry("sich anziehen", "to get dressed", "s'habiller", "يَرتَدي مَلابسَه", "phrase", "Zieh dich warm an, es ist kalt draußen.", "Dress warmly, it's cold outside.", "Alltag"),
      FlashEntry("sich waschen", "to wash oneself", "se laver", "يَغتَسِل", "phrase", "Ich wasche mich jeden Morgen.", "I wash myself every morning.", "Alltag"),
      FlashEntry("die Zähne putzen", "to brush one's teeth", "se brosser les dents", "يَفرِش أسنانَه", "noun", "Vergiss nicht, die Zähne zu putzen.", "Don't forget to brush your teeth.", "Alltag"),
      FlashEntry("das Frühstück", "breakfast", "le petit-déjeuner", "الفُطور", "noun", "Das Frühstück ist um acht Uhr.", "Breakfast is at eight.", "Alltag"),
      FlashEntry("das Mittagessen", "lunch", "le déjeuner", "الغَداء", "noun", "Wir essen Mittagessen in der Kantine.", "We eat lunch in the cafeteria.", "Alltag"),
      FlashEntry("das Abendessen", "dinner", "le dîner", "العَشاء", "noun", "Was gibt es heute zum Abendessen?", "What's for dinner today?", "Alltag"),
      FlashEntry("einkaufen", "to shop (groceries)", "faire les courses", "يَتَسوَّق", "verb", "Ich gehe nach der Arbeit einkaufen.", "I go grocery shopping after work.", "Alltag"),
      FlashEntry("kochen", "to cook", "cuisiner", "يَطهِي", "verb", "Kannst du gut kochen?", "Can you cook well?", "Alltag"),
      FlashEntry("abwaschen", "to wash the dishes", "faire la vaisselle", "يَغسِل الصِّحون", "verb", "Wer macht heute ab?", "Who's doing the dishes today?", "Alltag"),
      FlashEntry("aufräumen", "to tidy up", "ranger", "يُرَتِّب", "verb", "Räum bitte dein Zimmer auf.", "Please tidy up your room.", "Alltag"),
      FlashEntry("die Hausarbeit", "housework", "le ménage", "أَعمال المَنزِل", "noun", "Die Hausarbeit ist fair aufgeteilt.", "Housework is fairly divided.", "Alltag"),
      FlashEntry("der Wecker", "the alarm clock", "le réveil", "السَّاعَة المُنبِّهَة", "noun", "Stell bitte den Wecker auf sieben.", "Please set the alarm to seven.", "Alltag"),
      FlashEntry("die Reise", "the journey/trip", "le voyage", "الرِّحلة", "noun", "Unsere Reise war fantastisch.", "Our trip was fantastic.", "Reisen"),
      FlashEntry("die Fahrkarte", "the ticket", "le billet", "تَذكرة", "noun", "Ich brauche eine Fahrkarte nach Berlin.", "I need a ticket to Berlin.", "Reisen"),
      FlashEntry("der Fahrplan", "the timetable", "l'horaire", "جَدول", "noun", "Schauen wir den Fahrplan an.", "Let's look at the timetable.", "Reisen"),
      FlashEntry("der Bahnhof", "the train station", "la gare", "مَحطَّة القِطار", "noun", "Der Bahnhof ist sehr weit.", "The train station is very far.", "Reisen"),
      FlashEntry("der Flughafen", "the airport", "l'aéroport", "المَطار", "noun", "Wir müssen vor dem Flughafen sein.", "We need to be at the airport by then.", "Reisen"),
      FlashEntry("das Flugzeug", "the airplane", "l'avion", "الطَّائِرَة", "noun", "Das Flugzeug landet um fünf.", "The plane lands at five.", "Reisen"),
      FlashEntry("der Zug", "the train", "le train", "القِطار", "noun", "Der Zug nach Hamburg fährt in zehn Minuten.", "The train to Hamburg leaves in ten minutes.", "Reisen"),
      FlashEntry("das Gepäck", "the luggage", "les bagages", "الحَقائب", "noun", "Mein Gepäck ist verloren gegangen.", "My luggage has been lost.", "Reisen"),
      FlashEntry("umsteigen", "to change (trains)", "changer", "يُحوِّل", "verb", "Wir müssen in Köln umsteigen.", "We have to change trains in Cologne.", "Reisen"),
      FlashEntry("ankommen", "to arrive", "arriver", "يَصِل", "verb", "Wann kommen wir an?", "When do we arrive?", "Reisen"),
      FlashEntry("die Unterkunft", "the accommodation", "le logement", "السَّكَن", "noun", "Die Unterkunft war sehr sauber.", "The accommodation was very clean.", "Reisen"),
      FlashEntry("das Hostel", "the hostel", "l'auberge", "الفُندُق الشَّبابيّ", "noun", "Das Hostel hat eine gute Lage.", "The hostel has a good location.", "Reisen"),
      FlashEntry("buchen", "to book (a trip)", "réserver", "يَحجِز", "verb", "Wir müssen den Flug online buchen.", "We need to book the flight online.", "Reisen"),
      FlashEntry("der Koffer", "the suitcase", "la valise", "الحَقِيبَة", "noun", "Pack den Koffer bitte heute Abend.", "Please pack the suitcase tonight.", "Reisen"),
      FlashEntry("die Erkältung", "the cold (illness)", "le rhume", "الرُّشاحَة", "noun", "Ich habe eine schlimme Erkältung.", "I have a bad cold.", "Gesundheit"),
      FlashEntry("das Fieber", "the fever", "la fièvre", "الحُمَّى", "noun", "Sie hat hohes Fieber.", "She has a high fever.", "Gesundheit"),
      FlashEntry("der Husten", "the cough", "la toux", "السُّعال", "noun", "Husten ist ein Symptom.", "Coughing is a symptom.", "Gesundheit"),
      FlashEntry("der Kopfschmerz", "the headache", "le mal de tête", "صُداع", "noun", "Ich habe Kopfschmerzen.", "I have a headache.", "Gesundheit"),
      FlashEntry("der Bauchschmerz", "the stomach ache", "le mal de ventre", "أَلَم في البَطن", "noun", "Er klagt über Bauchschmerzen.", "He's complaining of a stomach ache.", "Gesundheit"),
      FlashEntry("die Apotheke", "the pharmacy", "la pharmacie", "الصَّيدلِيَّة", "noun", "Die Apotheke ist bis zwanzig Uhr geöffnet.", "The pharmacy is open until eight p.m.", "Gesundheit"),
      FlashEntry("der Arzt", "the doctor", "le médecin", "الطَّبيب", "noun", "Ich muss zum Arzt gehen.", "I need to go to the doctor.", "Gesundheit"),
      FlashEntry("die Tablette", "the tablet", "le comprimé", "حُبوب", "noun", "Nimm dreimal täglich eine Tablette.", "Take one tablet three times a day.", "Gesundheit"),
      FlashEntry("genesen", "to recover (from illness)", "guérir", "يَشفى", "verb", "Sie ist schnell genesen.", "She recovered quickly.", "Gesundheit"),
      FlashEntry("sich erholen", "to recover", "se reposer", "يَسترِيح", "phrase", "Er muss sich erholen.", "He has to recover.", "Gesundheit"),
      FlashEntry("die Übung", "the exercise", "l'exercice", "التَّمارين", "noun", "Tägliche Übung hält gesund.", "Daily exercise keeps you healthy.", "Gesundheit"),
      FlashEntry("der Stress", "the stress", "le stress", "الإجهاد", "noun", "Weniger Stress ist wichtig.", "Lower stress is important.", "Gesundheit"),
      FlashEntry("die Allergie", "the allergy", "l'allergie", "الحَسَّاسِيَّة", "noun", "Ich habe eine Pollenallergie.", "I have a pollen allergy.", "Gesundheit"),
      FlashEntry("der Verband", "the bandage", "le bandage", "الضِّمادَة", "noun", "Brauchst du einen Verband?", "Do you need a bandage?", "Gesundheit"),
      FlashEntry("der Beruf", "the profession", "la profession", "المِهنة", "noun", "Was ist dein Beruf?", "What's your profession?", "Arbeit & Beruf"),
      FlashEntry("die Stelle", "the job/position", "le poste", "الوَظِفَة", "noun", "Er hat eine neue Stelle bekommen.", "He got a new position.", "Arbeit & Beruf"),
      FlashEntry("die Bewerbung", "the application", "la candidature", "الطَّلَب", "noun", "Schickst du die Bewerbung heute ab?", "Are you sending the application today?", "Arbeit & Beruf"),
      FlashEntry("der Lebenslauf", "the CV", "le CV", "السِّيرَة الذَّاتِيَّة", "noun", "Mein Lebenslauf ist auf dem neuesten Stand.", "My CV is up to date.", "Arbeit & Beruf"),
      FlashEntry("die Erfahrung", "the experience", "l'expérience", "التَّجرِبَة", "noun", "Bewerber brauchen mehr Erfahrung.", "Applicants need more experience.", "Arbeit & Beruf"),
      FlashEntry("der Kollege", "the colleague", "le collègue", "الزَّميل", "noun", "Meine Kollegen sind sehr nett.", "My colleagues are very nice.", "Arbeit & Beruf"),
      FlashEntry("die Chefin", "the (female) boss", "la chef(fe)", "المُديرة", "noun", "Die Chefin ist heute nicht da.", "The boss isn't in today.", "Arbeit & Beruf"),
      FlashEntry("die Überstunden", "overtime", "les heures sup", "السَّاعات الإضافِيَّة", "noun", "Ich mache diese Woche Überstunden.", "I'm working overtime this week.", "Arbeit & Beruf"),
      FlashEntry("verdienen", "to earn", "gagner", "يَكسِب", "verb", "Was verdienst du in deinem Job?", "What do you earn in your job?", "Arbeit & Beruf"),
      FlashEntry("kündigen", "to quit (a job)", "démissionner", "يَستقيل", "verb", "Er hat gestern gekündigt.", "He quit yesterday.", "Arbeit & Beruf"),
      FlashEntry("einstellen", "to hire", "embaucher", "يُوَظِّف", "verb", "Die Firma stellt neue Leute ein.", "The firm is hiring new people.", "Arbeit & Beruf"),
      FlashEntry("der Termin", "the appointment", "le rendez-vous", "المَوعد", "noun", "Wir haben einen Termin um drei.", "We have an appointment at three.", "Arbeit & Beruf"),
      FlashEntry("der Kunde", "the customer", "le client", "العَميل", "noun", "Der Kunde zahlt sofort.", "The customer pays immediately.", "Arbeit & Beruf"),
      FlashEntry("die Gehaltserhöhung", "the salary raise", "l'augmentation", "زيادَة الرَّاتب", "noun", "Ich hoffe auf eine Gehaltserhöhung.", "I hope for a salary raise.", "Arbeit & Beruf"),
      FlashEntry("die Anmeldung", "the registration", "l'inscription", "التَّسجيل", "noun", "Die Anmeldung dauert eine Stunde.", "The registration takes an hour.", "Behörden & Dokumente"),
      FlashEntry("der Personalausweis", "the ID card", "la carte d'identité", "بِطاقَة الهُوِيَّة", "noun", "Zeigen Sie bitte Ihren Personalausweis.", "Please show your ID card.", "Behörden & Dokumente"),
      FlashEntry("der Reisepass", "the passport", "le passeport", "جَواز السَّفر", "noun", "Mein Reisepass ist abgelaufen.", "My passport has expired.", "Behörden & Dokumente"),
      FlashEntry("die Versicherung", "the insurance", "l'assurance", "التَّأمين", "noun", "Ich brauche eine private Versicherung.", "I need private insurance.", "Behörden & Dokumente"),
      FlashEntry("die Steuererklärung", "the tax return", "la déclaration d'impôts", "إقرار الضَّريبَة", "noun", "Hilf mir bitte bei der Steuererklärung.", "Please help me with my tax return.", "Behörden & Dokumente"),
      FlashEntry("der Mietvertrag", "the rental contract", "le bail", "عَقد الإيجار", "noun", "Wir haben den Mietvertrag unterschrieben.", "We signed the rental contract.", "Behörden & Dokumente"),
      FlashEntry("die Kaution", "the deposit", "la caution", "العَربون", "noun", "Die Kaution wird am Ende zurückgezahlt.", "The deposit is refunded at the end.", "Behörden & Dokumente"),
      FlashEntry("die Rechnung", "the bill/invoice", "la facture", "الفاتورَة", "noun", "Die Rechnung kommt per E-Mail.", "The bill comes by email.", "Behörden & Dokumente"),
      FlashEntry("die Quittung", "the receipt", "le reçu", "الإيصال", "noun", "Hast du die Quittung bekommen?", "Did you get the receipt?", "Behörden & Dokumente"),
      FlashEntry("ausfüllen", "to fill in", "remplir", "يَملَأ", "verb", "Bitte das Formular ausfüllen.", "Please fill in the form.", "Behörden & Dokumente"),
      FlashEntry("unterschreiben", "to sign", "signer", "يُوَقِّع", "verb", "Du musst hier unterschreiben.", "You have to sign here.", "Behörden & Dokumente"),
      FlashEntry("die Genehmigung", "the approval", "l'autorisation", "الإذن", "noun", "Wir warten auf die Genehmigung vom Rathaus.", "We wait for approval from city hall.", "Behörden & Dokumente"),
      FlashEntry("die Behörde", "the authority", "l'administration", "الجِهاز الحُكوميّ", "noun", "Das Rathaus ist die wichtigste Behörde.", "City hall is the main public authority.", "Behörden & Dokumente"),
      FlashEntry("der Termin (Behörde)", "admin appointment", "le rdv admin", "مَوعد رَسمِيّ", "noun", "Vergiss den Termin im Bürgeramt nicht.", "Don't forget the office appointment.", "Behörden & Dokumente"),
      FlashEntry("die Freizeit", "free time", "le temps libre", "وَقت الفَراغ", "noun", "Lesen ist meine liebste Freizeitbeschäftigung.", "Reading is my favourite leisure activity.", "Freizeit & Hobbys"),
      FlashEntry("das Hobby", "the hobby", "le hobby", "الهِوايَة", "noun", "Welche Hobbys hast du?", "What hobbies do you have?", "Freizeit & Hobbys"),
      FlashEntry("die Musik", "the music", "la musique", "المُوسِيقى", "noun", "Ich höre gern klassische Musik.", "I like listening to classical music.", "Freizeit & Hobbys"),
      FlashEntry("der Film", "the film/movie", "le film", "الفِلم", "noun", "Dieser Film ist wirklich spannend.", "This film is really exciting.", "Freizeit & Hobbys"),
      FlashEntry("das Konzert", "the concert", "le concert", "الحَفلَة", "noun", "Wir gehen morgen zum Konzert.", "We're going to the concert tomorrow.", "Freizeit & Hobbys"),
      FlashEntry("die Sportart", "the sport", "le sport", "الرِّياضَة", "noun", "Meine Lieblingssportart ist Fußball.", "My favourite sport is football.", "Freizeit & Hobbys"),
      FlashEntry("der Verein", "the club", "le club", "النَّادي", "noun", "Ich bin im Sportverein.", "I'm in the sports club.", "Freizeit & Hobbys"),
      FlashEntry("die Party", "the party", "la fête", "الحَفلَة", "noun", "Morgen steigt eine große Party.", "Tomorrow there is a big party.", "Freizeit & Hobbys"),
      FlashEntry("wandern", "to hike", "faire de la rando", "يَتَسَلَّق", "phrase", "Wir gehen gerne in den Alpen wandern.", "We like hiking in the Alps.", "Freizeit & Hobbys"),
      FlashEntry("spielen", "to play (game)", "jouer", "يَلعَب", "verb", "Spielst du gern Schach?", "Do you like playing chess?", "Freizeit & Hobbys"),
      FlashEntry("Fahrrad fahren", "to cycle", "faire du vélo", "يَركَب الدَّرَّاجَة", "phrase", "Ich fahre jeden Tag Fahrrad.", "I cycle every day.", "Freizeit & Hobbys"),
      FlashEntry("das Treffen", "the meeting", "la rencontre", "اللِّقاء", "noun", "Das Treffen ist bei mir zu Hause.", "The meeting is at my house.", "Freizeit & Hobbys"),
      FlashEntry("die Sendung", "the show/episode", "l'émission", "البَرنامَج", "noun", "Die neue Sendung kommt heute Abend.", "The new show airs tonight.", "Freizeit & Hobbys"),
      FlashEntry("die Verabredung", "the appointment/date", "le rdv", "مَوعد", "noun", "Wir haben eine Verabredung um acht.", "We have a date at eight.", "Freizeit & Hobbys"),
    ], 'A2', now);
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
