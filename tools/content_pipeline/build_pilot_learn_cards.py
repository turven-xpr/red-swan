import json

def generate_pilot_learn_cards():
    cards = [
        # ─────────────────────────────────────────────────────────────
        # PILOT A: UNIT 1 (Lesson 10101 & 10102 - Intro Alphabet & Sounds)
        # ─────────────────────────────────────────────────────────────
        {
            "id": "card_u1_l10101_1",
            "lesson_id": 10101,
            "card_type": "concept",
            "sort_order": 1,
            "custom_prompt_de": "Hallo! Willkommen auf Deutsch!",
            "data_json": {
                "chunk_de": "Hallo! Willkommen auf Deutsch!",
                "sentence_en": "Hello! Welcome to German!",
                "sentence_ar": "\u2066مرحباً! أهلاً بك في الألمانية!\u2069",
                "sentence_es": "¡Hola! ¡Bienvenido al alemán!",
                "example_sentence_de": "Guten Tag! Ich lerne Deutsch.",
            }
        },
        {
            "id": "card_u1_l10101_2",
            "lesson_id": 10101,
            "card_type": "phonetic",
            "sort_order": 2,
            "custom_prompt_de": "ch",
            "data_json": {
                "mouth_tip_en": "Soft 'ch' (ich): smile and whisper 'yes'. Hard 'ch' (ach): back of throat like clearing throat.",
                "mouth_tip_ar": "\u2066صوت 'ch' ناعم بعد (e, i) كالهمس، وخشن بعد (a, o, u) من مؤخرة الحلق.\u2069",
                "mouth_tip_es": "'ch' suave tras e/i; 'ch' áspera tras a/o/u en la garganta.",
                "contrast_pairs": [
                    {"word_a": "ich", "word_b": "ach"},
                    {"word_a": "Milch", "word_b": "Buch"}
                ],
                "sample_words": ["ich", "nicht", "Milch", "Buch", "auch"]
            }
        },
        {
            "id": "card_u1_l10102_1",
            "lesson_id": 10102,
            "card_type": "phonetic",
            "sort_order": 1,
            "custom_prompt_de": "ä · ö · ü · ß",
            "data_json": {
                "mouth_tip_en": "ä = like 'bed'. ö = round lips and say 'ay'. ü = round lips and say 'ee'. ß = sharp double 's'.",
                "mouth_tip_ar": "\u2066حروف الإمالة الألمانية: ä كالفتحة الممتدة، ö و ü بتدوير الشفتين، و ß تعادل حرفي ss.\u2069",
                "mouth_tip_es": "ä suena como e abierta; ö y ü con labios redondeados; ß es una s sorda.",
                "contrast_pairs": [
                    {"word_a": "schon", "word_b": "schön"},
                    {"word_a": "Mutter", "word_b": "Mütter"}
                ],
                "sample_words": ["Äpfel", "schön", "über", "groß"]
            }
        },

        # ─────────────────────────────────────────────────────────────
        # PILOT B: A1 UNIT 5 (Lesson 10001 - Familie & Leute: Wortschatz 1)
        # ─────────────────────────────────────────────────────────────
        {
            "id": "card_u5_l10001_1",
            "lesson_id": 10001,
            "card_type": "noun_article",
            "sort_order": 1,
            "word_id": 1,  # Mutter (die)
            "data_json": {
                "example_sentence_de": "Meine Mutter kocht sehr gut.",
                "sentence_en": "My mother cooks very well.",
                "sentence_ar": "\u2066أمي تطبخ بشكل جيد جداً.\u2069",
                "sentence_es": "Mi madre cocina muy bien.",
                "tile_tokens": ["Meine", "Mutter", "kocht", "sehr", "gut"]
            }
        },
        {
            "id": "card_u5_l10001_2",
            "lesson_id": 10001,
            "card_type": "noun_article",
            "sort_order": 2,
            "word_id": 2,  # Vater (der)
            "data_json": {
                "example_sentence_de": "Mein Vater arbeitet gern.",
                "sentence_en": "My father likes to work.",
                "sentence_ar": "\u2066أبي يحب العمل.\u2069",
                "sentence_es": "A mi padre le gusta trabajar.",
                "tile_tokens": ["Mein", "Vater", "arbeitet", "gern"]
            }
        },
        {
            "id": "card_u5_l10001_3",
            "lesson_id": 10001,
            "card_type": "noun_article",
            "sort_order": 3,
            "word_id": 4,  # Kind (das)
            "data_json": {
                "example_sentence_de": "Das Kind spielt im Park.",
                "sentence_en": "The child is playing in the park.",
                "sentence_ar": "\u2066الطفل يلعب في الحديقة.\u2069",
                "sentence_es": "El niño juega en el parque.",
                "tile_tokens": ["Das", "Kind", "spielt", "im", "Park"]
            }
        },
        {
            "id": "card_u5_l10001_4",
            "lesson_id": 10001,
            "card_type": "noun_article",
            "sort_order": 4,
            "word_id": 7,  # Bruder (der)
            "data_json": {
                "example_sentence_de": "Mein Bruder wohnt in Berlin.",
                "sentence_en": "My brother lives in Berlin.",
                "sentence_ar": "\u2066أخي يعيش في برلين.\u2069",
                "sentence_es": "Mi hermano vive en Berlín.",
                "tile_tokens": ["Mein", "Bruder", "wohnt", "in", "Berlin"]
            }
        },
        {
            "id": "card_u5_l10001_5",
            "lesson_id": 10001,
            "card_type": "noun_article",
            "sort_order": 5,
            "word_id": 8,  # Schwester (die)
            "data_json": {
                "example_sentence_de": "Meine Schwester lernt Deutsch.",
                "sentence_en": "My sister is learning German.",
                "sentence_ar": "\u2066أختي تتعلم الألمانية.\u2069",
                "sentence_es": "Mi hermana aprende alemán.",
                "tile_tokens": ["Meine", "Schwester", "lernt", "Deutsch"]
            }
        },
        {
            "id": "card_u5_l10001_6",
            "lesson_id": 10001,
            "card_type": "phrase_chunk",
            "sort_order": 6,
            "data_json": {
                "chunk_de": "Ich habe einen Bruder",
                "highlight_token": "einen",
                "sentence_en": "I have a brother",
                "sentence_ar": "\u2066لدي أخ\u2069",
                "sentence_es": "Tengo un hermano",
                "grammatical_note_en": "The direct object (accusative) changes masculine 'ein' to 'einen': Ich habe einen Bruder.",
                "grammatical_note_ar": "\u2066المفعول به (حالة النصب Akkusativ) يحول أداة التنكير للمذكر من ein إلى einen: Ich habe einen Bruder.\u2069",
                "tile_tokens": ["Ich", "habe", "einen", "Bruder"]
            }
        }
    ]
    return cards

def main():
    content_path = 'assets/deutschy_content.json'
    with open(content_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    pilot_cards = generate_pilot_learn_cards()
    data['learn_cards'] = pilot_cards

    with open(content_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Successfully added {len(pilot_cards)} pilot learn cards into {content_path}")

if __name__ == '__main__':
    main()

