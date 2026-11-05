// Real lesson bodies drawn from `RESEARCH_A2_B1.md`.  Each entry contains
// the headline, a single-line subtitle, two or three paragraphs of body
// content, plus a worked example.  Snippets are concise so the rendering
// layer can amp with custom typography without hitting copy limits.
class GrammarLesson {
  const GrammarLesson({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.bodyParagraphs,
    required this.exampleDe,
    required this.exampleEn,
  });
  final String level; // 'A1' | 'A2' | 'B1'
  final String title;
  final String subtitle;
  final List<String> bodyParagraphs;
  final String exampleDe;
  final String exampleEn;
}

/// Bare-bones catalog — levels A1 → B1.
const List<GrammarLesson> kGrammarLessons = [
  GrammarLesson(
    level: 'A1',
    title: 'Articles: der / die / das',
    subtitle: 'Noun gender basics',
    bodyParagraphs: [
      'German nouns have a grammatical gender (masculine / feminine / neuter), shown by the article that comes before them.  There is no rule that works for every noun, but some patterns are reliable:',
      '1) **Masculine** — *der* — masculine persons (Mann, Vater), days of the week (Montag), the four seasons (Sommer), and many words that describe tools or machines (Computer, Mixer).',
      '2) **Feminine** — *die* — most words ending in `-e` (Tasche, Lampe), `-ung` (Zeitung), `-heit` (Freiheit), `-keit` (Sauberkeit), `-tion` (Nation / Lektion).',
      '3) **Neuter** — *das* — infinitives used as nouns (das Essen), most country names when they are not persons (das Frankreich, das Österreich), and small young creatures (das Baby).',
      'Tip:  learn the noun AND its article together.  Reading a noun without its article is a missed gender; that gender controls the case endings you will need later.',
    ],
    exampleDe: 'Der Tisch ist groß, die Lampe ist hell, und das Fenster ist offen.',
    exampleEn: 'The table is large, the lamp is bright, and the window is open.',
  ),
  GrammarLesson(
    level: 'A1',
    title: 'Verb conjugation (Präsens)',
    subtitle: 'ich / du / er / wir / ihr / sie',
    bodyParagraphs: [
      'Most German verbs follow a single pattern: drop the `-en` ending from the infinitive, then add an ending that depends on the subject.',
      'kommen  →  ich komm-e, du komm-st, er komm-t, wir komm-en, ihr komm-t, sie komm-en',
      'Watch the small but very common exceptions:  **sein** (ich bin, du bist, er ist, …), **haben** (ich habe, du hast, er hat, …), and the **modal verbs**, whose endings drop the personal forms entirely (kann, muss, will, soll, darf, mag).',
      'You will conjugate in almost every sentence, so commit the endings to muscle memory.  A short daily drill of 10 verbs in five forms will internalise the pattern within two weeks.',
    ],
    exampleDe: 'Ich komme aus Berlin.  Sie kommt aus München.  Wir kommen heute.',
    exampleEn: 'I come from Berlin.  She comes from Munich.  We are coming today.',
  ),
  GrammarLesson(
    level: 'A1',
    title: 'W-Fragen und Ja/Nein-Fragen',
    subtitle: 'Wortstellung',
    bodyParagraphs: [
      'German word order is **verb-second**: the conjugated verb must sit in the **second** position of every sentence.  Everything else is more flexible than in English.',
      'Statement (verb second):  **Ich** komme heute aus Berlin.',
      'Yes/No question (verb first):  Kommst du heute aus Berlin?',
      'W-Frage (verb second, W- word at the beginning):  Woher kommst du heute?',
      'The verb remains in slot 2 even when the subject slides to the end.',
    ],
    exampleDe: 'Wohnst du in Hamburg?  —  Ja, ich wohne in Hamburg.',
    exampleEn: 'Do you live in Hamburg?  —  Yes, I live in Hamburg.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Perfekt mit haben / sein',
    subtitle: 'Past-tense narration',
    bodyParagraphs: [
      'Used for past narration and for what has happened.  Form: auxiliary (haben OR sein) + Partizip II of the main verb, kept at the end of the clause.',
      'Choose **haben** for most verbs.  Use **sein** only for verbs of: motion with a clear destination (gehen, fahren, fliegen, kommen); state change (aufwachen, sterben, werden, bleiben); plus a small list (sein, passieren).',
      'Regular verbs build Partizip II with `ge-` + stem + `-t`.  Strong (irregular) verbs often change the stem vowel and end in `-en` (gelesen, gefahren, gesprochen, getrunken, getroffen).',
    ],
    exampleDe: 'Ich habe den Kaffee getrunken, dann bin ich spazieren gegangen.',
    exampleEn: 'I drank the coffee, then I went for a walk.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Präteritum der Modalverben',
    subtitle: 'Modal verbs in the past',
    bodyParagraphs: [
      'Used for past narration and formal writing. The main modal verbs are: konnte (could), musste (had to), wollte (wanted to), durfte (was allowed to), sollte (was supposed to).',
      'These drop their umlaut in the past tense and add regular past endings (-te, -test, -te, -ten, -tet, -ten).',
      'Usually combined with an infinitive at the end of the clause.',
    ],
    exampleDe: 'Ich musste gestern arbeiten und konnte nicht zum Deutschkurs kommen.',
    exampleEn: 'I had to work yesterday and could not come to the German class.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Präteritum von sein / haben',
    subtitle: 'Simple past of sein & haben',
    bodyParagraphs: [
      'Used as the baseline past tense for the auxiliary verbs sein (was) and haben (had). Often preferred over Perfekt for these two verbs in speaking.',
      'Conjugation: ich war / hatte, du warst / hattest, er war / hatte, wir waren / hatten, ihr wart / hattet, sie waren / hatten.',
      'Essential for storytelling and setting context: "Es war einmal..." (Once upon a time...).',
    ],
    exampleDe: 'Gestern hatte ich viel Stress und war sehr müde.',
    exampleEn: 'Yesterday I had a lot of stress and was very tired.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Nebensätze mit weil',
    subtitle: 'Subordinate clauses with weil',
    bodyParagraphs: [
      'Used to state the cause of an action. The connector *weil* (because) triggers the **verb-final** word order rule.',
      'The conjugated verb moves to the very end of the subordinate clause.',
      'If the subordinate clause starts the sentence, the main clause begins with the verb (verb-verb clash across the comma).',
    ],
    exampleDe: 'Ich lerne Deutsch, weil ich in Deutschland arbeiten möchte.',
    exampleEn: 'I am learning German because I want to work in Germany.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Nebensätze mit dass',
    subtitle: 'Complement clauses with dass',
    bodyParagraphs: [
      'Used for indirect statements, opinions, or feelings after verbs like sagen, glauben, finden, denken or adjectives like froh, wichtig.',
      'The connector *dass* (that) triggers the **verb-final** word order rule.',
    ],
    exampleDe: 'Ich glaube, dass Deutsch lernen viel Spaß macht.',
    exampleEn: 'I believe that learning German is a lot of fun.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Nebensätze mit wenn / als',
    subtitle: 'Condition vs single past event',
    bodyParagraphs: [
      'Use **wenn** for conditions in the present/future (if) and habitual events in the past (whenever).',
      'Use **als** strictly for a single, completed event in the past (when). Both trigger the **verb-final** rule.',
    ],
    exampleDe: 'Als ich ein Kind war, habe ich in Berlin gewohnt.',
    exampleEn: 'When I was a child, I lived in Berlin.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Nebensätze mit ob',
    subtitle: 'Indirect yes/no questions',
    bodyParagraphs: [
      'Used to report indirect yes/no questions (whether / if). The connector *ob* triggers the **verb-final** rule.',
      'Commonly introduced by phrases like "Ich weiß nicht,..." or "Können Sie mir sagen,...".',
    ],
    exampleDe: 'Ich weiß nicht, ob der Zug pünktlich ankommt.',
    exampleEn: 'Ich weiß nicht, ob der Zug pünktlich ankommt.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Reflexive Verben im Perfekt',
    subtitle: 'Reflexive verbs in the past',
    bodyParagraphs: [
      'Reflexive verbs use the auxiliary **haben** in the Perfekt tense, never *sein*, even if they involve movement.',
      'The reflexive pronoun (mich, dich, sich, uns, euch) stands directly after the auxiliary or the subject.',
    ],
    exampleDe: 'Ich habe mich heute Morgen schnell angezogen.',
    exampleEn: 'I got dressed quickly this morning.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Wechselpräpositionen',
    subtitle: 'Two-way prepositions',
    bodyParagraphs: [
      'Prepositions that take either Akkusativ or Dativ: in, an, auf, unter, über, vor, hinter, neben, zwischen.',
      'Use **Dativ** for stationary locations (Question: *Wo?* - Where?).',
      'Use **Akkusativ** for directional motion (Question: *Wohin?* - Where to?).',
    ],
    exampleDe: 'Ich lege das Buch auf den Tisch, nun liegt es auf dem Tisch.',
    exampleEn: 'I put the book on the table, now it lies on the table.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Komparativ + -er / -st',
    subtitle: 'Comparatives & superlatives',
    bodyParagraphs: [
      'Build comparisons by adding `-er` to the adjective. Superlatives use `am ...-sten` or the definite article + `-ste`.',
      'Monosyllabic adjectives often take an umlaut (alt → älter → am ältesten).',
      'Watch irregular forms: gut → besser → am besten; viel → mehr → am meisten.',
    ],
    exampleDe: 'Deutsch ist schwerer als Englisch, aber Finnisch ist am schwersten.',
    exampleEn: 'German is harder than English, but Finnish is the hardest.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Relativer Satz',
    subtitle: 'Relative clauses baseline',
    bodyParagraphs: [
      'Relative clauses describe nouns and are placed right after them, separated by a comma. They use relative pronouns (der, die, das) matching the gender of the noun.',
      'The verb moves to the end of the relative clause.',
    ],
    exampleDe: 'Das Auto, das dort steht, gehört meinem Kollegen.',
    exampleEn: 'The car that stands there belongs to my colleague.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Konjunktiv II (höflich)',
    subtitle: 'Polite requests',
    bodyParagraphs: [
      'Used to form polite questions and requests. Usually constructed using **würde + Infinitiv** or the subjunctive forms of modal/auxiliary verbs.',
      'Common polite forms: ich hätte gern (I would like to have), könnte (could), würde (would).',
    ],
    exampleDe: 'Ich hätte gern eine Fahrkarte nach Berlin, bitte.',
    exampleEn: 'I would like to have a ticket to Berlin, please.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Passiv Präsens',
    subtitle: 'Present Passive',
    bodyParagraphs: [
      'Used to focus on the action rather than the actor. Formed with **werden + Partizip II** (past participle) at the end of the clause.',
    ],
    exampleDe: 'Das Zimmer wird jeden Tag aufgeräumt.',
    exampleEn: 'The room is tidied up every day.',
  ),
  GrammarLesson(
    level: 'A2',
    title: 'Adjektivdeklination nach Artikeln',
    subtitle: 'Adjectives after articles',
    bodyParagraphs: [
      'Adjectives between an article and a noun must take declension endings based on case, gender, and number.',
      'After definite articles (weak declension): usually `-e` in nominative, `-en` in dative/genitive/accusative masculine.',
    ],
    exampleDe: 'Der große Tisch steht im Zimmer. Ich sitze an dem großen Tisch.',
    exampleEn: 'The big table stands in the room. I sit at the big table.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Plusquamperfekt',
    subtitle: 'Past before past',
    bodyParagraphs: [
      'Used to describe an action that happened before another past action. Conjunctions like *nachdem* (after) often link it.',
      'Formed with the Präteritum of haben/sein (hatte/war) + Partizip II.',
    ],
    exampleDe: 'Nachdem ich meine Hausarbeit gemacht hatte, ging ich schlafen.',
    exampleEn: 'After I had done my housework, I went to sleep.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Futur I',
    subtitle: 'The future tense',
    bodyParagraphs: [
      'Used to describe future events, intentions, promises, or moderate probabilities. Formed with **werden + Infinitiv** at the end.',
      'In everyday speech, present tense is often preferred if a time indicator (morgen, nächste Woche) is present.',
    ],
    exampleDe: 'Wir werden die Umwelt schützen müssen.',
    exampleEn: 'We will have to protect the environment.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Passiv Präteritum',
    subtitle: 'Simple Past Passive',
    bodyParagraphs: [
      'Used to describe passive actions in historical or written past narration. Formed with **wurde + Partizip II**.',
    ],
    exampleDe: 'Der Mietvertrag wurde gestern unterschrieben.',
    exampleEn: 'The rental contract was signed yesterday.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Passiv Perfekt',
    subtitle: 'Present Perfect Passive',
    bodyParagraphs: [
      'Used to describe completed passive actions with a present result. Formed with **ist + Partizip II + worden**.',
      'Notice that `worden` is used instead of `geworden`.',
    ],
    exampleDe: 'Die Kaution ist bereits bezahlt worden.',
    exampleEn: 'The deposit has already been paid.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Konjunktiv I (indirekte Rede)',
    subtitle: 'Reported speech',
    bodyParagraphs: [
      'Used in newspapers, news, and formal reports to represent what someone else said without quoting them directly.',
      'Formed by modifying the present tense endings to stem + -e (e.g. er habe, sie sei).',
    ],
    exampleDe: 'Der Minister sagte, die Wirtschaft wachse wieder.',
    exampleEn: 'The minister said that the economy was growing again.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Konjunktiv II (advanced)',
    subtitle: 'Unreal conditions & wishes',
    bodyParagraphs: [
      'Used to describe hypothetical conditions, impossible wishes, or counterfactual past situations.',
      'Often uses the past subjunctive forms (wäre, hätte, könnte) or **würde + Infinitiv**.',
    ],
    exampleDe: 'Wenn ich gestern Zeit gehabt hätte, wäre ich zum Konzert gekommen.',
    exampleEn: 'If I had had time yesterday, I would have come to the concert.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'N-Deklination',
    subtitle: 'Weak masculine nouns',
    bodyParagraphs: [
      'A small group of masculine nouns (like der Kunde, der Kollege, der Junge, der Mensch) must add an `-n` or `-en` ending in all cases except Nominative Singular.',
    ],
    exampleDe: 'Ich helfe dem neuen Kunden. Er hat mit dem Kollegen gesprochen.',
    exampleEn: 'I help the new customer. He spoke to the colleague.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Relativsätze mit Präposition',
    subtitle: 'Relative clauses with prepositions',
    bodyParagraphs: [
      'When a relative pronoun is combined with a preposition, the preposition stands at the beginning of the relative clause and dictates the case of the pronoun.',
    ],
    exampleDe: 'Das ist die Chefin, mit der ich gestern gesprochen habe.',
    exampleEn: 'That is the boss with whom I spoke yesterday.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Adjektivdeklination ohne Artikel',
    subtitle: 'Strong declension of adjectives',
    bodyParagraphs: [
      'Adjectives preceding nouns without an article must carry the case endings that the definite article would normally show.',
    ],
    exampleDe: 'Kaltes Wasser erfrischt. Wir trinken gern heißen Tee.',
    exampleEn: 'Cold water refreshes. We like to drink hot tea.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Konnektoren',
    subtitle: 'dennoch · außerdem · einerseits',
    bodyParagraphs: [
      'B1 level coordinators like *deshalb*, *dennoch*, *außerdem*, *trotzdem* act as adverbs (they count as slot 1, meaning the verb must sit directly after them).',
      'Two-part connectors like *entweder...oder*, *nicht nur...sondern auch*, *einerseits...andererseits* help structure complex thoughts.',
    ],
    exampleDe: 'Es regnete stark, dennoch gingen wir im Wald spazieren.',
    exampleEn: 'It rained heavily, nevertheless we went for a walk in the forest.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Infinitivkonstruktionen',
    subtitle: 'um … zu · ohne … zu · statt … zu',
    bodyParagraphs: [
      'Infinitives with *zu* are subordinate structures that omit the subject. The infinitive verb stands at the end preceded by *zu*.',
      'Key structures: um...zu (in order to), ohne...zu (without doing), statt...zu (instead of doing).',
    ],
    exampleDe: 'Er lernt fleißig, um die Prüfung zu bestehen.',
    exampleEn: 'He studies hard in order to pass the exam.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Wunschsätze',
    subtitle: 'Expressing wishes',
    bodyParagraphs: [
      'Hypothetical wishes formed using Konjunktiv II. Often started with particles like *doch*, *nur*, *bloß* and end with exclamation marks.',
    ],
    exampleDe: 'Wenn ich doch nur mehr Freizeit hätte!',
    exampleEn: 'If I only had more free time!',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Erweiterte Partizipialattribute',
    subtitle: 'Extended participles as adjectives',
    bodyParagraphs: [
      'Present or past participles can function as adjectives and be extended by prepositional phrases, preceding the noun.',
    ],
    exampleDe: 'Der am Bahnhof wartende Mann liest eine Zeitung.',
    exampleEn: 'The man waiting at the station is reading a newspaper.',
  ),
  GrammarLesson(
    level: 'B1',
    title: 'Nominalisierung',
    subtitle: 'Nouns made from verbs & adjectives',
    bodyParagraphs: [
      'Verbs and adjectives can be turned into nouns. Nominalized verbs are always neuter (das Essen, das Lesen).',
      'Adjectives nominalized take normal adjective declension endings (das Schöne, der Angestellte).',
    ],
    exampleDe: 'Das Lesen von Büchern macht viel Spaß.',
    exampleEn: 'Reading books is a lot of fun.',
  ),
];
