#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_intro_learn_cards.py
Generates clean, focused, slide-by-slide Learn Cards for Level Intro (Units 1-4)
and cleans spoiler prompts from exercises.
Includes full trilingual (EN, AR with BiDi isolation, ES) translations for all anchor
words and example sentences.
"""

import json
import re

def bidi(text: str) -> str:
    """Wraps text in Unicode Left-to-Right / Right-to-Left isolates safely."""
    clean = text.replace('\u2066', '').replace('\u2069', '').strip()
    return f"\u2066{clean}\u2069"

def generate_intro_cards():
    cards = []

    # ═════════════════════════════════════════════════════════════════════
    # UNIT 1: Das Alphabet & Aussprache (Lessons 10101 - 10109)
    # ═════════════════════════════════════════════════════════════════════

    # --- 10101: Deutsch entdecken (International Cognates) ---
    u1_cognates = [
        ("Hotel", "das Hotel", "hotel", "فندق", "hotel", "Das Hotel ist modern.", "The hotel is modern.", "الفندق حديث.", "El hotel es moderno."),
        ("Taxi", "das Taxi", "taxi", "سيارة أجرة", "taxi", "Das Taxi kommt gleich.", "The taxi is coming soon.", "سيارة الأجرة قادمة حالاً.", "El taxi viene pronto."),
        ("Radio", "das Radio", "radio", "مذياع", "radio", "Das Radio spielt Musik.", "The radio is playing music.", "المذياع يعزف الموسيقى.", "La radio reproduce música."),
        ("Bus", "der Bus", "bus", "حافلة", "autobús", "Der Bus fährt nach Berlin.", "The bus goes to Berlin.", "الحافلة تتجه إلى برلين.", "El autobús va a Berlín."),
        ("Musik", "die Musik", "music", "موسيقى", "música", "Wir hören gerne Musik.", "We like listening to music.", "نحن نحب الاستماع إلى الموسيقى.", "Nos gusta escuchar música."),
        ("Café", "das Café", "café", "مقهى", "cafetería", "Das Café ist geöffnet.", "The café is open.", "المقهى مفتوح.", "La cafetería está abierta."),
    ]
    for i, (short, de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u1_cognates, 1):
        cards.append({
            "id": f"card_10101_{i}",
            "lesson_id": 10101,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10102: Buchstaben A–F ---
    u1_af = [
        ("A a", "der Apfel", "apple", "تفاحة", "manzana", "A wie Apfel", "Der Apfel ist rot.", "The apple is red.", "التفاحة حمراء.", "La manzana es roja."),
        ("B b", "der Ball", "ball", "كرة", "pelota", "B wie Ball", "Der Ball ist rund.", "The ball is round.", "الكرة مستديرة.", "La pelota es redonda."),
        ("C c", "der Computer", "computer", "حاسوب", "ordenador", "C wie Computer", "Der Computer ist neu.", "The computer is new.", "الحاسوب جديد.", "El ordenador es nuevo."),
        ("D d", "Danke", "thank you", "شكراً", "gracias", "D wie Danke", "Vielen Dank!", "Thank you very much!", "شكراً جزيلاً!", "¡Muchas gracias!"),
        ("E e", "der Elefant", "elephant", "فيل", "elefante", "E wie Elefant", "Der Elefant ist groß.", "The elephant is big.", "الفيل ضخم.", "El elefante es grande."),
        ("F f", "das Fahrrad", "bicycle", "دراجة", "bicicleta", "F wie Fahrrad", "Das Fahrrad fährt schnell.", "The bicycle goes fast.", "الدراجة تسير بسرعة.", "La bicicleta va rápido."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex_de, ex_en, ex_ar, ex_es) in enumerate(u1_af, 1):
        cards.append({
            "id": f"card_10102_{i}",
            "lesson_id": 10102,
            "card_type": "phonetic",
            "sort_order": i,
            "custom_prompt_de": letter,
            "data_json": {
                "chunk_de": anchor,
                "anchor_word_de": de,
                "anchor_word_en": en,
                "anchor_word_ar": bidi(ar),
                "anchor_word_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10103: Buchstaben G–L ---
    u1_gl = [
        ("G g", "der Garten", "garden", "حديقة", "jardín", "G wie Garten", "Der Garten ist schön.", "The garden is beautiful.", "الحديقة جميلة.", "El jardín es hermoso."),
        ("H h", "Hallo", "hello", "مرحباً", "hola", "H wie Hallo", "Hallo! Wie geht's?", "Hello! How are you?", "مرحباً! كيف حالك؟", "¡Hola! ¿Cómo estás?"),
        ("I i", "die Insel", "island", "جزيرة", "isla", "I wie Insel", "Die Insel ist ruhig.", "The island is peaceful.", "الجزيرة هادئة.", "La isla es tranquila."),
        ("J j", "Ja", "yes", "نعم", "sí", "J wie Ja", "Ja, bitte.", "Yes, please.", "نعم، من فضلك.", "Sí, por favor."),
        ("K k", "der Kaffee", "coffee", "قهوة", "café", "K wie Kaffee", "Der Kaffee ist heiß.", "The coffee is hot.", "القهوة ساخنة.", "El café está caliente."),
        ("L l", "die Lampe", "lamp", "مصباح", "lámpara", "L wie Lampe", "Die Lampe ist hell.", "The lamp is bright.", "المصباح ساطع.", "La lámpara es brillante."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex_de, ex_en, ex_ar, ex_es) in enumerate(u1_gl, 1):
        cards.append({
            "id": f"card_10103_{i}",
            "lesson_id": 10103,
            "card_type": "phonetic",
            "sort_order": i,
            "custom_prompt_de": letter,
            "data_json": {
                "chunk_de": anchor,
                "anchor_word_de": de,
                "anchor_word_en": en,
                "anchor_word_ar": bidi(ar),
                "anchor_word_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10104: Buchstaben M–R ---
    u1_mr = [
        ("M m", "die Milch", "milk", "حليب", "leche", "M wie Milch", "Ich trinke Milch.", "I drink milk.", "أنا أشرب الحليب.", "Bebo leche."),
        ("N n", "Nein", "no", "لا", "no", "N wie Nein", "Nein, danke.", "No, thank you.", "لا، شكراً.", "No, gracias."),
        ("O o", "die Orange", "orange", "برتقال", "naranja", "O wie Orange", "Die Orange schmeckt gut.", "The orange tastes good.", "البرتقالة طعمها لذيذ.", "La naranja sabe bien."),
        ("P p", "die Post", "post office", "بريد", "correos", "P wie Post", "Die Post ist da.", "The mail is here.", "وصل البريد.", "El correo está aquí."),
        ("Q q", "die Quelle", "source", "ينبوع", "fuente", "Q wie Quelle", "Die Quelle ist frisch.", "The spring is fresh.", "ينبوع الماء عذب.", "La fuente es fresca."),
        ("R r", "rot", "red", "أحمر", "rojo", "R wie rot", "Der Apfel ist rot.", "The apple is red.", "التفاحة حمراء.", "La manzana es roja."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex_de, ex_en, ex_ar, ex_es) in enumerate(u1_mr, 1):
        cards.append({
            "id": f"card_10104_{i}",
            "lesson_id": 10104,
            "card_type": "phonetic",
            "sort_order": i,
            "custom_prompt_de": letter,
            "data_json": {
                "chunk_de": anchor,
                "anchor_word_de": de,
                "anchor_word_en": en,
                "anchor_word_ar": bidi(ar),
                "anchor_word_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10105: Buchstaben S–U ---
    u1_su = [
        ("S s", "die Sonne", "sun", "شمس", "sol", "S wie Sonne", "Die Sonne scheint.", "The sun is shining.", "الشمس مشرقة.", "El sol brilla."),
        ("T t", "der Tee", "tea", "شاي", "té", "T wie Tee", "Der Tee ist warm.", "The tea is warm.", "الشاي دافئ.", "El té está caliente."),
        ("U u", "die Uhr", "clock / watch", "ساعة", "reloj", "U wie Uhr", "Wie viel Uhr ist es?", "What time is it?", "كم الساعة؟", "¿Qué hora es?"),
        ("Zahlen", "sieben", "seven (7)", "سبعة (7)", "siete (7)", "Die Zahl 7", "Ich habe sieben Bücher.", "I have seven books.", "لدي سبعة كتب.", "Tengo siete libros."),
        ("Gruß", "Guten Tag", "good day", "يوم سعيد", "buenos días", "Begrüßung", "Guten Tag, Herr Müller!", "Good day, Mr. Müller!", "يوم سعيد، سيد مولر!", "¡Buenos días, señor Müller!"),
    ]
    for i, (letter, de, en, ar, es, anchor, ex_de, ex_en, ex_ar, ex_es) in enumerate(u1_su, 1):
        cards.append({
            "id": f"card_10105_{i}",
            "lesson_id": 10105,
            "card_type": "phonetic",
            "sort_order": i,
            "custom_prompt_de": letter,
            "data_json": {
                "chunk_de": anchor,
                "anchor_word_de": de,
                "anchor_word_en": en,
                "anchor_word_ar": bidi(ar),
                "anchor_word_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10106: Besondere Konsonanten (V, W, X, Y, Z) ---
    u1_vwxyz = [
        ("V v", "vier", "four (pronounced like 'F')", "أربعة (يُنطق مثل حرف الفاء F)", "cuatro (suena como F)", "V wie vier", "Vier Tassen Kaffee.", "Four cups of coffee.", "أربعة فناجين قهوة.", "Cuatro tazas de café."),
        ("W w", "das Wasser", "water (pronounced like English 'V')", "ماء (يُنطق مثل V الإنجليزية)", "agua (suena como V)", "W wie Wasser", "Das Wasser ist kalt.", "The water is cold.", "الماء بارد.", "El agua está fría."),
        ("X x", "das Taxi", "taxi (contains 'ks' sound)", "تاكسي (صوت 'كس')", "taxi", "X im Taxi", "Ich nehme ein Taxi.", "I'll take a taxi.", "سآخذ سيارة أجرة.", "Tomo un taxi."),
        ("Y y", "das Yoga", "yoga", "يوغا", "yoga", "Y wie Yoga", "Yoga macht fit.", "Yoga keeps you fit.", "اليوغا تبقيك رشيقاً.", "El yoga te pone en forma."),
        ("Z z", "der Zug", "train (pronounced like 'ts')", "قطار (يُنطق مثل 'تس' ts)", "tren (suena como ts)", "Z wie Zug", "Der Zug kommt jetzt.", "The train is coming now.", "القطار قادم الآن.", "El tren llega ahora."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex_de, ex_en, ex_ar, ex_es) in enumerate(u1_vwxyz, 1):
        cards.append({
            "id": f"card_10106_{i}",
            "lesson_id": 10106,
            "card_type": "phonetic",
            "sort_order": i,
            "custom_prompt_de": letter,
            "data_json": {
                "chunk_de": anchor,
                "anchor_word_de": de,
                "anchor_word_en": en,
                "anchor_word_ar": bidi(ar),
                "anchor_word_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10107: Umlaute (ä, ö, ü) & Eszett (ß) ---
    u1_umlaute = [
        ("Ä ä", "der Käse", "cheese (ä sounds like 'e' in bed)", "جبن (ä تنطق كالفتحة الممتدة)", "queso", "Ä wie Käse", "Der Käse schmeckt gut.", "The cheese tastes good.", "الجبن طعمه لذيذ.", "El queso sabe bien.", "Mund leicht geöffnet wie beim 'e'"),
        ("Ö ö", "schön", "beautiful (round lips and say 'ay')", "جميل (تدوير الشفتين ونطق 'إي')", "hermoso", "Ö in schön", "Das Bild ist schön.", "The picture is beautiful.", "الصورة جميلة.", "El cuadro es hermoso.", "Lippen runden wie für 'o', aber 'e' sprechen"),
        ("Ü ü", "fünf", "five (round lips and say 'ee')", "خمسة (تدوير الشفتين ونطق 'ي')", "cinco", "Ü in fünf", "Es ist fünf Uhr.", "It is five o'clock.", "إنها الساعة الخامسة.", "Son las cinco.", "Lippen spitzen wie für 'u', aber 'i' sprechen"),
        ("ß", "weiß", "white (sharp double 'ss')", "أبيض (حرف سين مشدد حاد)", "blanco", "ß in weiß", "Das Hemd ist weiß.", "The shirt is white.", "القميص أبيض.", "La camisa es blanca.", "Wird wie ein scharfes 'ss' gesprochen"),
    ]
    for i, (letter, de, en, ar, es, anchor, ex_de, ex_en, ex_ar, ex_es, tip) in enumerate(u1_umlaute, 1):
        cards.append({
            "id": f"card_10107_{i}",
            "lesson_id": 10107,
            "card_type": "phonetic",
            "sort_order": i,
            "custom_prompt_de": letter,
            "data_json": {
                "chunk_de": anchor,
                "anchor_word_de": de,
                "anchor_word_en": en,
                "anchor_word_ar": bidi(ar),
                "anchor_word_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
                "mouth_tip_en": tip,
                "mouth_tip_ar": bidi(f"نصيحة النطق: {tip}"),
            }
        })

    # --- 10108: Diphthonge & Laute (ei, ie, eu, au, sch, ch) ---
    u1_diphthongs = [
        ("ei", "eins", "one (sounds like 'eye')", "واحد (يُنطق مثل eye)", "uno", "ei wie eins", "Eins, zwei, drei.", "One, two, three.", "واحد، اثنان، ثلاثة.", "Uno, dos, tres."),
        ("ie", "sieben", "seven (long 'ee' sound)", "سبعة (ياء ممدودة طويلة)", "siete", "ie wie sieben", "Sieben Tage.", "Seven days.", "سبعة أيام.", "Siete días."),
        ("eu", "Euro", "euro (sounds like 'oy')", "يورو (يُنطق مثل 'أوي')", "euro", "eu wie Euro", "Drei Euro.", "Three euros.", "ثلاثة يورو.", "Tres euros."),
        ("au", "das Auto", "car (sounds like 'ow')", "سيارة (يُنطق مثل 'أو')", "coche", "au wie Auto", "Das Auto fährt schnell.", "The car drives fast.", "السيارة تسير بسرعة.", "El coche va rápido."),
        ("sch", "die Schule", "school (sounds like 'sh')", "مدرسة (يُنطق مثل حرف الشين)", "escuela", "sch wie Schule", "Die Schule ist groß.", "The school is big.", "المدرسة كبيرة.", "La escuela es grande."),
        ("ch", "ich / ach", "soft after e/i, hard after a/o/u", "ناعم بعد e/i وخشن بعد a/o/u", "ch suave y dura", "Laut ch", "Ich bin hier.", "I am here.", "أنا هنا.", "Estoy aquí."),
    ]
    for i, (sound, de, en, ar, es, anchor, ex_de, ex_en, ex_ar, ex_es) in enumerate(u1_diphthongs, 1):
        cards.append({
            "id": f"card_10108_{i}",
            "lesson_id": 10108,
            "card_type": "phonetic",
            "sort_order": i,
            "custom_prompt_de": sound,
            "data_json": {
                "chunk_de": anchor,
                "anchor_word_de": de,
                "anchor_word_en": en,
                "anchor_word_ar": bidi(ar),
                "anchor_word_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10109: Buchstabieren & Checkpoint 1 ---
    cards.append({
        "id": "card_10109_1",
        "lesson_id": 10109,
        "card_type": "concept",
        "sort_order": 1,
        "custom_prompt_de": "Buchstabieren",
        "data_json": {
            "chunk_de": "Wie buchstabiert man das?",
            "translation_en": "How do you spell that?",
            "translation_ar": bidi("كيف تتهجى ذلك؟"),
            "translation_es": "¿Cómo se deletrea eso?",
            "example_sentence_de": "H-O-T-E-L: Hotel.",
            "example_sentence_en": "H-O-T-E-L: Hotel.",
            "example_sentence_ar": bidi("H-O-T-E-L: فندق."),
            "example_sentence_es": "H-O-T-E-L: Hotel.",
            "sentence_en": "H-O-T-E-L: Hotel.",
            "sentence_ar": bidi("H-O-T-E-L: فندق."),
            "sentence_es": "H-O-T-E-L: Hotel.",
        }
    })

    # ═════════════════════════════════════════════════════════════════════
    # UNIT 2: Erste Wörter & Zahlen (Lessons 10201 - 10208)
    # ═════════════════════════════════════════════════════════════════════

    # --- 10201: Höflichkeit ---
    u2_polite = [
        ("Danke", "thank you", "شكراً", "gracias", "Danke schön!", "Thank you very much!", "شكراً جزيلاً!", "¡Muchas gracias!"),
        ("Bitte", "please / you're welcome", "من فضلك / عفواً", "por favor / de nada", "Bitte sehr!", "You're very welcome!", "على الرحب والسعة!", "¡De nada!"),
        ("Hallo", "hello", "مرحباً", "hola", "Hallo! Schön dich zu sehen.", "Hello! Nice to see you.", "مرحباً! يسعدني أن أراك.", "¡Hola! Qué bueno verte."),
        ("Tschüss", "bye", "مع السلامة", "adiós", "Tschüss! Bis morgen.", "Bye! See you tomorrow.", "مع السلامة! إلى الغد.", "¡Adiós! Hasta mañana."),
        ("Entschuldigung", "excuse me / sorry", "معذرة / عذراً", "disculpe", "Entschuldigung, wo ist der Bahnhof?", "Excuse me, where is the train station?", "عذراً، أين تقع محطة القطار؟", "Disculpe, ¿dónde está la estación?"),
    ]
    for i, (word, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u2_polite, 1):
        cards.append({
            "id": f"card_10201_{i}",
            "lesson_id": 10201,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": word,
            "data_json": {
                "chunk_de": word,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10202: Zahlen 0–6 ---
    u2_z0_6 = [
        ("0", "null", "zero", "صفر", "cero"),
        ("1", "eins", "one", "واحد", "uno"),
        ("2", "zwei", "two", "اثنان", "dos"),
        ("3", "drei", "three", "ثلاثة", "tres"),
        ("4", "vier", "four", "أربعة", "cuatro"),
        ("5", "fünf", "five", "خمسة", "cinco"),
        ("6", "sechs", "six", "ستة", "seis"),
    ]
    for i, (digit, de, en, ar, es) in enumerate(u2_z0_6, 1):
        cards.append({
            "id": f"card_10202_{i}",
            "lesson_id": 10202,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": f"{digit} · {de}",
            "data_json": {
                "chunk_de": de,
                "translation_en": f"{digit} = {en}",
                "translation_ar": bidi(f"{digit} = {ar}"),
                "translation_es": f"{digit} = {es}",
                "example_sentence_de": f"Ich zähle: {de}.",
                "example_sentence_en": f"I count: {en}.",
                "example_sentence_ar": bidi(f"أنا أعد: {ar}."),
                "example_sentence_es": f"Cuento: {es}.",
                "sentence_en": f"I count: {en}.",
                "sentence_ar": bidi(f"أنا أعد: {ar}."),
                "sentence_es": f"Cuento: {es}.",
            }
        })

    # --- 10203: Zahlen 7–12 ---
    u2_z7_12 = [
        ("7", "sieben", "seven", "سبعة", "siete"),
        ("8", "acht", "eight", "ثمانية", "ocho"),
        ("9", "neun", "nine", "تسعة", "nueve"),
        ("10", "zehn", "ten", "عشرة", "diez"),
        ("11", "elf", "eleven", "أحد عشر", "once"),
        ("12", "zwölf", "twelve", "اثنا عشر", "doce"),
    ]
    for i, (digit, de, en, ar, es) in enumerate(u2_z7_12, 1):
        cards.append({
            "id": f"card_10203_{i}",
            "lesson_id": 10203,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": f"{digit} · {de}",
            "data_json": {
                "chunk_de": de,
                "translation_en": f"{digit} = {en}",
                "translation_ar": bidi(f"{digit} = {ar}"),
                "translation_es": f"{digit} = {es}",
                "example_sentence_de": f"Zimmer {de}.",
                "example_sentence_en": f"Room {en}.",
                "example_sentence_ar": bidi(f"غرفة {ar}."),
                "example_sentence_es": f"Habitación {es}.",
                "sentence_en": f"Room {en}.",
                "sentence_ar": bidi(f"غرفة {ar}."),
                "sentence_es": f"Habitación {es}.",
            }
        })

    # --- 10204: Zahlen 13–20 ---
    u2_z13_20 = [
        ("13", "dreizehn", "thirteen", "ثلاثة عشر", "trece"),
        ("14", "vierzehn", "fourteen", "أربعة عشر", "catorce"),
        ("15", "fünfzehn", "fifteen", "خمسة عشر", "quince"),
        ("16", "sechzehn", "sixteen", "ستة عشر", "dieciséis"),
        ("17", "siebzehn", "seventeen", "سبعة عشر", "diecisiete"),
        ("20", "zwanzig", "twenty", "عشرون", "veinte"),
    ]
    for i, (digit, de, en, ar, es) in enumerate(u2_z13_20, 1):
        cards.append({
            "id": f"card_10204_{i}",
            "lesson_id": 10204,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": f"{digit} · {de}",
            "data_json": {
                "chunk_de": de,
                "translation_en": f"{digit} = {en}",
                "translation_ar": bidi(f"{digit} = {ar}"),
                "translation_es": f"{digit} = {es}",
                "example_sentence_de": f"Bus Nummer {de}.",
                "example_sentence_en": f"Bus number {en}.",
                "example_sentence_ar": bidi(f"حافلة رقم {ar}."),
                "example_sentence_es": f"Autobús número {es}.",
                "sentence_en": f"Bus number {en}.",
                "sentence_ar": bidi(f"حافلة رقم {ar}."),
                "sentence_es": f"Autobús número {es}.",
            }
        })

    # --- 10205: Zehnerzahlen bis 100 ---
    u2_z_tens = [
        ("30", "dreißig", "thirty", "ثلاثون", "treinta"),
        ("40", "vierzig", "forty", "أربعون", "cuarenta"),
        ("50", "fünfzig", "fifty", "خمسون", "cincuenta"),
        ("60", "sechzig", "sixty", "ستون", "sesenta"),
        ("70", "siebzig", "seventy", "سبعون", "setenta"),
        ("80", "achtzig", "eighty", "ثمانون", "ochenta"),
        ("90", "neunzig", "ninety", "تسعون", "noventa"),
        ("100", "hundert", "one hundred", "مئة", "cien"),
    ]
    for i, (digit, de, en, ar, es) in enumerate(u2_z_tens, 1):
        cards.append({
            "id": f"card_10205_{i}",
            "lesson_id": 10205,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": f"{digit} · {de}",
            "data_json": {
                "chunk_de": de,
                "translation_en": f"{digit} = {en}",
                "translation_ar": bidi(f"{digit} = {ar}"),
                "translation_es": f"{digit} = {es}",
                "example_sentence_de": f"Das kostet {de} Euro.",
                "example_sentence_en": f"That costs {en} euros.",
                "example_sentence_ar": bidi(f"هذا يكلف {ar} يورو."),
                "example_sentence_es": f"Eso cuesta {es} euros.",
                "sentence_en": f"That costs {en} euros.",
                "sentence_ar": bidi(f"هذا يكلف {ar} يورو."),
                "sentence_es": f"Eso cuesta {es} euros.",
            }
        })

    # --- 10206: Wochentage ---
    u2_days = [
        ("Montag", "Monday", "الإثنين", "lunes"),
        ("Dienstag", "Tuesday", "الثلاثاء", "martes"),
        ("Mittwoch", "Wednesday", "الأربعاء", "miércoles"),
        ("Donnerstag", "Thursday", "الخميس", "jueves"),
        ("Freitag", "Friday", "الجمعة", "viernes"),
        ("Samstag", "Saturday", "السبت", "sábado"),
        ("Sonntag", "Sunday", "الأحد", "domingo"),
    ]
    for i, (de, en, ar, es) in enumerate(u2_days, 1):
        cards.append({
            "id": f"card_10206_{i}",
            "lesson_id": 10206,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": f"Heute ist {de}.",
                "example_sentence_en": f"Today is {en}.",
                "example_sentence_ar": bidi(f"اليوم هو {ar}."),
                "example_sentence_es": f"Hoy es {es}.",
                "sentence_en": f"Today is {en}.",
                "sentence_ar": bidi(f"اليوم هو {ar}."),
                "sentence_es": f"Hoy es {es}.",
            }
        })

    # --- 10207: Farben ---
    u2_colors = [
        ("blau", "#1E88E5", "blue", "أزرق", "azul", "Der Himmel ist blau.", "The sky is blue.", "السماء زرقاء.", "El cielo es azul."),
        ("rot", "#E53935", "red", "أحمر", "rojo", "Der Apfel ist rot.", "The apple is red.", "التفاحة حمراء.", "La manzana es roja."),
        ("grün", "#43A047", "green", "أخضر", "verde", "Das Gras ist grün.", "The grass is green.", "العشب أخضر.", "La hierba es verde."),
        ("gelb", "#FDD835", "yellow", "أصفر", "amarillo", "Die Sonne ist gelb.", "The sun is yellow.", "الشمس صفراء.", "El sol es amarillo."),
        ("schwarz", "#212121", "black", "أسود", "negro", "Der Kaffee ist schwarz.", "The coffee is black.", "القهوة سوداء.", "El café es negro."),
        ("weiß", "#EEEEEE", "white", "أبيض", "blanco", "Der Schnee ist weiß.", "The snow is white.", "الثلج أبيض.", "La nieve es blanca."),
        ("grau", "#9E9E9E", "gray", "رمادي", "gris", "Die Wolke ist grau.", "The cloud is gray.", "السحابة رمادية.", "La nube es gris."),
        ("braun", "#6D4C41", "brown", "بني", "marrón", "Die Schokolade ist braun.", "The chocolate is brown.", "الشوكولاتة بنية.", "El chocolate es marrón."),
        ("orange", "#FB8C00", "orange", "برتقالي", "naranja", "Die Orange ist orange.", "The orange is orange.", "البرتقالة برتقالية اللون.", "La naranja es naranja."),
    ]
    for i, (de, hex_code, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u2_colors, 1):
        cards.append({
            "id": f"card_10207_{i}",
            "lesson_id": 10207,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "swatch_hex": hex_code,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10208: Review & Checkpoint 2 ---
    cards.append({
        "id": "card_10208_1",
        "lesson_id": 10208,
        "card_type": "concept",
        "sort_order": 1,
        "custom_prompt_de": "Zahlen & Farben",
        "data_json": {
            "chunk_de": "Zahlen & Farben",
            "translation_en": "Numbers & Colors Review",
            "translation_ar": bidi("مراجعة الأرقام والألوان"),
            "translation_es": "Repaso de números y colores",
            "example_sentence_de": "Drei rote Äpfel.",
            "example_sentence_en": "Three red apples.",
            "example_sentence_ar": bidi("ثلاث تفاحات حمراء."),
            "example_sentence_es": "Tres manzanas rojas.",
            "sentence_en": "Three red apples.",
            "sentence_ar": bidi("ثلاث تفاحات حمراء."),
            "sentence_es": "Tres manzanas rojas.",
        }
    })

    # ═════════════════════════════════════════════════════════════════════
    # UNIT 3: Begrüßung, Verben & Fragestellung (Lessons 10301 - 10308)
    # ═════════════════════════════════════════════════════════════════════

    # --- 10301: Begrüßung & Verabschiedung ---
    u3_greetings = [
        ("Guten Morgen", "Good morning", "صباح الخير", "Buenos días", "Guten Morgen! Haben Sie gut geschlafen?", "Good morning! Did you sleep well?", "صباح الخير! هل نمت جيداً؟", "¡Buenos días! ¿Durmió bien?"),
        ("Guten Tag", "Good day", "يوم سعيد / مرحباً", "Buenas tardes", "Guten Tag, Herr Meier!", "Good day, Mr. Meier!", "يوم سعيد، سيد ماير!", "¡Buenas tardes, señor Meier!"),
        ("Guten Abend", "Good evening", "مساء الخير", "Buenas noches (al llegar)", "Guten Abend allerseits!", "Good evening everyone!", "مساء الخير للجميع!", "¡Buenas noches a todos!"),
        ("Gute Nacht", "Good night", "تصبح على خير", "Buenas noches (al despedirse)", "Gute Nacht und schlaf gut!", "Good night and sleep well!", "تصبح على خير ونم جيداً!", "¡Buenas noches y que duermas bien!"),
        ("Auf Wiedersehen", "Goodbye", "إلى اللقاء", "Hasta la vista", "Auf Wiedersehen, Frau Schmidt!", "Goodbye, Mrs. Schmidt!", "إلى اللقاء، سيدة شميت!", "¡Hasta luego, señora Schmidt!"),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u3_greetings, 1):
        cards.append({
            "id": f"card_10301_{i}",
            "lesson_id": 10301,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10302: Wie geht's? ---
    u3_howareyou = [
        ("Wie geht's?", "How are you?", "كيف حالك؟", "¿Cómo estás?", "Hallo Anna, wie geht's?", "Hello Anna, how are you?", "مرحباً آنّا، كيف حالك؟", "Hola Anna, ¿cómo estás?"),
        ("Sehr gut, danke!", "Very good, thank you!", "بخير جداً، شكراً!", "¡Muy bien, gracias!", "Mir geht es sehr gut, danke!", "I'm doing very well, thank you!", "أنا بأفضل حال، شكراً!", "¡Me va muy bien, gracias!"),
        ("Es geht.", "So-so / Not bad.", "على ما يرام / لا بأس.", "Ahí vamos.", "Wie geht's? — Es geht.", "How are you? — So-so.", "كيف الحال؟ — على ما يرام.", "¿Cómo estás? — Ahí vamos."),
        ("Nicht so gut.", "Not so good.", "لست بخير / ليس جيداً.", "No tan bien.", "Heute geht es mir nicht so gut.", "Today I'm not doing so well.", "اليوم لست بخير تماماً.", "Hoy no me siento tan bien."),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u3_howareyou, 1):
        cards.append({
            "id": f"card_10302_{i}",
            "lesson_id": 10302,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10303: Ich bin / Ich heiße ---
    u3_name = [
        ("Ich heiße Karim.", "My name is Karim.", "اسمي كريم.", "Me llamo Karim.", "Ich heiße", "Verb 'heißen' (to be called): ich heiße Karim."),
        ("Wie heißen Sie?", "What is your name? (formal)", "ما اسم حضرتك؟ (رسمي)", "¿Cómo se llama usted?", "Wie heißen Sie", "Formelle Frage nach dem Namen."),
        ("Ich bin Anna.", "I am Anna.", "أنا آنّا.", "Soy Anna.", "Ich bin", "Verb 'sein' (to be): ich bin Anna."),
    ]
    for i, (de, en, ar, es, token, note) in enumerate(u3_name, 1):
        cards.append({
            "id": f"card_10303_{i}",
            "lesson_id": 10303,
            "card_type": "phrase_chunk",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "highlight_token": token,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "grammatical_note_en": note,
                "grammatical_note_ar": bidi(note),
            }
        })

    # --- 10304: Woher kommst du? ---
    u3_origin = [
        ("Woher kommst du?", "Where do you come from? (informal)", "من أين أنت؟ (غير رسمي)", "¿De dónde eres?", "Woher kommst du", "Frage nach der Herkunft (du)."),
        ("Woher kommen Sie?", "Where do you come from? (formal)", "من أين حضرتك؟ (رسمي)", "¿De dónde es usted?", "Woher kommen Sie", "Formelle Frage nach der Herkunft (Sie)."),
        ("Ich komme aus Syrien.", "I come from Syria.", "أنا قادم من سوريا.", "Vengo de Siria.", "komme aus", "Präposition 'aus' für das Herkunftsland."),
        ("Ich komme aus Marokko.", "I come from Morocco.", "أنا قادم من المغرب.", "Vengo de Marruecos.", "komme aus", "Präposition 'aus'."),
    ]
    for i, (de, en, ar, es, token, note) in enumerate(u3_origin, 1):
        cards.append({
            "id": f"card_10304_{i}",
            "lesson_id": 10304,
            "card_type": "phrase_chunk",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "highlight_token": token,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "grammatical_note_en": note,
                "grammatical_note_ar": bidi(note),
            }
        })

    # --- 10305: Das ist ein / eine ---
    u3_articles = [
        ("Das ist ein Mann.", "This is a man.", "هذا رجل.", "Este es un hombre.", "ein Mann", "Maskulin: ein Mann (der Mann)"),
        ("Das ist eine Frau.", "This is a woman.", "هذه امرأة.", "Esta es una mujer.", "eine Frau", "Feminin: eine Frau (die Frau)"),
        ("Das ist ein Kind.", "This is a child.", "هذا طفل.", "Este es un niño.", "ein Kind", "Neutral: ein Kind (das Kind)"),
    ]
    for i, (de, en, ar, es, token, note) in enumerate(u3_articles, 1):
        cards.append({
            "id": f"card_10305_{i}",
            "lesson_id": 10305,
            "card_type": "phrase_chunk",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "highlight_token": token,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "grammatical_note_en": note,
                "grammatical_note_ar": bidi(note),
            }
        })

    # --- 10306: Überlebenssätze ---
    u3_survival = [
        ("Ich verstehe nicht.", "I do not understand.", "أنا لا أفهم.", "No entiendo.", "Ich verstehe nicht.", "I do not understand.", "أنا لا أفهم.", "No entiendo."),
        ("Sprechen Sie Englisch?", "Do you speak English?", "هل تتحدث الإنجليزية؟", "¿Habla inglés?", "Entschuldigung, sprechen Sie Englisch?", "Excuse me, do you speak English?", "عذراً، هل تتحدث الإنجليزية؟", "Disculpe, ¿habla inglés?"),
        ("Bitte langsamer.", "Please more slowly.", "من فضلك تحدث ببطء أكثر.", "Más despacio, por favor.", "Können Sie bitte langsamer sprechen?", "Could you please speak more slowly?", "هل يمكنك التحدث ببطء أكثر من فضلك؟", "¿Puede hablar más despacio, por favor?"),
        ("Wie bitte?", "Pardon? / Could you repeat?", "عفواً؟ ماذا قلت؟", "¿Cómo?", "Wie bitte? Ich habe das nicht gehört.", "Pardon? I didn't hear that.", "عفواً؟ لم أسمع ذلك.", "¿Cómo? No escuché eso."),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u3_survival, 1):
        cards.append({
            "id": f"card_10306_{i}",
            "lesson_id": 10306,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10307: Erstes Gespräch ---
    cards.append({
        "id": "card_10307_1",
        "lesson_id": 10307,
        "card_type": "concept",
        "sort_order": 1,
        "custom_prompt_de": "Erstes Gespräch",
        "data_json": {
            "chunk_de": "Guten Tag! Ich heiße Karim. Und wie heißen Sie?",
            "translation_en": "Good day! My name is Karim. And what is your name?",
            "translation_ar": bidi("يوم سعيد! اسمي كريم. وما اسم حضرتك؟"),
            "translation_es": "¡Buenos días! Me llamo Karim. ¿Y cómo se llama usted?",
            "example_sentence_de": "Ich heiße Anna. Freut mich!",
            "example_sentence_en": "My name is Anna. Pleased to meet you!",
            "example_sentence_ar": bidi("اسمي آنّا. تشرفت بمعرفتك!"),
            "example_sentence_es": "Me llamo Anna. ¡Mucho gusto!",
            "sentence_en": "My name is Anna. Pleased to meet you!",
            "sentence_ar": bidi("اسمي آنّا. تشرفت بمعرفتك!"),
            "sentence_es": "Me llamo Anna. ¡Mucho gusto!",
        }
    })

    # --- 10308: Checkpoint 3 ---
    cards.append({
        "id": "card_10308_1",
        "lesson_id": 10308,
        "card_type": "concept",
        "sort_order": 1,
        "custom_prompt_de": "Begrüßung & Verben",
        "data_json": {
            "chunk_de": "Begrüßung & Verben Checkpoint",
            "translation_en": "Greetings & Verbs Mastery Check",
            "translation_ar": bidi("اختبار التحيات وتصريف الأفعال"),
            "translation_es": "Examen de saludos y verbos",
            "example_sentence_de": "Hallo, ich heiße Karim und komme aus Syrien.",
            "example_sentence_en": "Hello, my name is Karim and I come from Syria.",
            "example_sentence_ar": bidi("مرحباً، اسمي كريم وأنا من سوريا."),
            "example_sentence_es": "Hola, me llamo Karim y soy de Siria.",
            "sentence_en": "Hello, my name is Karim and I come from Syria.",
            "sentence_ar": bidi("مرحباً، اسمي كريم وأنا من سوريا."),
            "sentence_es": "Hola, me llamo Karim y soy de Siria.",
        }
    })

    # ═════════════════════════════════════════════════════════════════════
    # UNIT 4: Persönliche Angaben, Formulare & möchten (Lessons 10311 - 10317)
    # ═════════════════════════════════════════════════════════════════════

    # --- 10311: Länder & Sprachen ---
    u4_countries = [
        ("Deutschland", "Germany", "ألمانيا", "Alemania", "Deutschland ist in Europa.", "Germany is in Europe.", "ألمانيا في أوروبا.", "Alemania está en Europa."),
        ("Deutsch", "German (language)", "اللغة الألمانية", "alemán", "Ich lerne Deutsch.", "I am learning German.", "أنا أتعلم الألمانية.", "Estoy aprendiendo alemán."),
        ("Syrien", "Syria", "سوريا", "Siria", "Er kommt aus Syrien.", "He comes from Syria.", "هو من سوريا.", "Él viene de Siria."),
        ("Marokko", "Morocco", "المغرب", "Marruecos", "Sie kommt aus Marokko.", "She comes from Morocco.", "هي من المغرب.", "Ella viene de Marruecos."),
        ("Arabisch", "Arabic (language)", "اللغة العربية", "árabe", "Meine Muttersprache ist Arabisch.", "My native language is Arabic.", "لغتي الأم هي العربية.", "Mi lengua materna es el árabe."),
        ("Englisch", "English (language)", "اللغة الإنجليزية", "inglés", "Wir sprechen Englisch.", "We speak English.", "نحن نتحدث الإنجليزية.", "Hablamos inglés."),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u4_countries, 1):
        cards.append({
            "id": f"card_10311_{i}",
            "lesson_id": 10311,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10312: Persönliche Angaben ---
    u4_personal = [
        ("der Vorname", "first name", "الاسم الأول / الشخصي", "nombre de pila", "Mein Vorname ist Karim.", "My first name is Karim.", "اسمي الأول كريم.", "Mi nombre de pila es Karim."),
        ("der Familienname", "surname / last name", "اللقب / اسم العائلة", "apellido", "Mein Familienname ist Mansour.", "My last name is Mansour.", "لقب عائلتي منصور.", "Mi apellido es Mansour."),
        ("das Alter", "age", "العمر / السن", "edad", "Mein Alter ist 25 Jahre.", "My age is 25 years.", "عمري 25 سنة.", "Mi edad es de 25 años."),
        ("der Wohnort", "place of residence", "مكان الإقامة", "lugar de residencia", "Mein Wohnort ist Berlin.", "My place of residence is Berlin.", "مكان سكني برلين.", "Mi lugar de residencia es Berlín."),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u4_personal, 1):
        cards.append({
            "id": f"card_10312_{i}",
            "lesson_id": 10312,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10313: Adresse & Kontakt ---
    u4_contact = [
        ("die Straße", "street", "الشارع", "calle", "Ich wohne in der Goethestraße.", "I live in Goethe Street.", "أنا أسكن في شارع غوته.", "Vivo en la calle Goethe."),
        ("die Hausnummer", "house number", "رقم المنزل", "número de casa", "Meine Hausnummer ist 14.", "My house number is 14.", "رقم منزلي 14.", "Mi número de casa es 14."),
        ("die Postleitzahl", "postal code (PLZ)", "الرمز البريدي", "código postal", "Die Postleitzahl ist 10115.", "The postal code is 10115.", "الرمز البريدي 10115.", "El código postal es 10115."),
        ("die Telefonnummer", "phone number", "رقم الهاتف", "número de teléfono", "Meine Telefonnummer ist 0151...", "My phone number is 0151...", "رقم هاتفي هو 0151...", "Mi número de teléfono es 0151..."),
        ("die E-Mail-Adresse", "email address", "عنوان البريد الإلكتروني", "correo electrónico", "Meine E-Mail-Adresse ist...", "My email address is...", "عنوان بريدي الإلكتروني هو...", "Mi dirección de correo electrónico es..."),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u4_contact, 1):
        cards.append({
            "id": f"card_10313_{i}",
            "lesson_id": 10313,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10314: Familienstand & Beruf ---
    u4_status = [
        ("ledig", "single (unmarried)", "أعزب / عزباء", "soltero/a", "Ich bin ledig.", "I am single.", "أنا أعزب.", "Soy soltero/a."),
        ("verheiratet", "married", "متزوج / متزوجة", "casado/a", "Er ist verheiratet.", "He is married.", "هو متزوج.", "Él está casado."),
        ("der Student", "student (male)", "طالب جامعي", "estudiante (m)", "Ich bin Student an der Universität.", "I am a student at the university.", "أنا طالب في الجامعة.", "Soy estudiante en la universidad."),
        ("der Arzt", "doctor (physician)", "طبيب", "médico", "Der Arzt arbeitet im Krankenhaus.", "The doctor works in the hospital.", "الطبيب يعمل في المستشفى.", "El médico trabaja en el hospital."),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u4_status, 1):
        cards.append({
            "id": f"card_10314_{i}",
            "lesson_id": 10314,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10315: Der Wunsch: möchten & Satzklammer ---
    u4_moechten = [
        ("Ich möchte einen Kaffee.", "I would like a coffee.", "أود فنجان قهوة.", "Quisiera un café.", "Ich möchte", "Höflicher Wunsch mit 'möchten'."),
        ("Ich möchte Deutsch lernen.", "I would like to learn German.", "أود أن أتعلم الألمانية.", "Quisiera aprender alemán.", "lernen", "Satzklammer: Hilfsverb an Position 2, Infinitiv am Ende."),
        ("Möchten Sie etwas trinken?", "Would you like something to drink?", "هل تود حضرتك شرب شيء؟", "¿Quisiera tomar algo?", "Möchten Sie", "Höfliche Frage an den Gast."),
    ]
    for i, (de, en, ar, es, token, note) in enumerate(u4_moechten, 1):
        cards.append({
            "id": f"card_10315_{i}",
            "lesson_id": 10315,
            "card_type": "phrase_chunk",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "highlight_token": token,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "grammatical_note_en": note,
                "grammatical_note_ar": bidi(note),
            }
        })

    # --- 10316: Goethe Formular-Training ---
    u4_formular = [
        ("das Formular", "form", "استمارة رسمية", "formulario", "Bitte füllen Sie das Formular aus.", "Please fill out the form.", "يرجى ملء الاستمارة.", "Por favor complete el formulario."),
        ("ausfüllen", "to fill out", "يملأ استمارة", "rellenar / completar", "Ich fülle das Anmeldeformular aus.", "I am filling out the registration form.", "أنا أملأ استمارة التسجيل.", "Estoy completando el formulario de inscripción."),
        ("der Geburtsort", "place of birth", "مكان الولادة", "lugar de nacimiento", "Mein Geburtsort ist Damaskus.", "My place of birth is Damascus.", "مكان ولادتي دمشق.", "Mi lugar de nacimiento es Damasco."),
        ("das Geburtsdatum", "date of birth", "تاريخ الولادة", "fecha de nacimiento", "Mein Geburtsdatum ist 12.05.1998.", "My date of birth is 12.05.1998.", "تاريخ ولادتي 12.05.1998.", "Mi fecha de nacimiento es 12.05.1998."),
        ("die Unterschrift", "signature", "التوقيع", "firma", "Ihre Unterschrift bitte hier unten.", "Your signature down here, please.", "توقيعك هنا بالأسفل من فضلك.", "Su firma aquí abajo, por favor."),
    ]
    for i, (de, en, ar, es, ex_de, ex_en, ex_ar, ex_es) in enumerate(u4_formular, 1):
        cards.append({
            "id": f"card_10316_{i}",
            "lesson_id": 10316,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "translation_en": en,
                "translation_ar": bidi(ar),
                "translation_es": es,
                "example_sentence_de": ex_de,
                "example_sentence_en": ex_en,
                "example_sentence_ar": bidi(ex_ar),
                "example_sentence_es": ex_es,
                "sentence_en": ex_en,
                "sentence_ar": bidi(ex_ar),
                "sentence_es": ex_es,
            }
        })

    # --- 10317: Intro Foundations Checkpoint ---
    cards.append({
        "id": "card_10317_1",
        "lesson_id": 10317,
        "card_type": "concept",
        "sort_order": 1,
        "custom_prompt_de": "Intro Checkpoint",
        "data_json": {
            "chunk_de": "Intro Level Checkpoint",
            "translation_en": "You are ready for the Intro Checkpoint!",
            "translation_ar": bidi("أنت الآن مستعد لاختبار إنهاء المستوى التمهيدي!"),
            "translation_es": "¡Estás listo para el examen de nivel Intro!",
            "example_sentence_de": "Ich möchte mich vorstellen: Mein Name ist Karim.",
            "example_sentence_en": "I'd like to introduce myself: My name is Karim.",
            "example_sentence_ar": bidi("أود أن أقدم نفسي: اسمي كريم."),
            "example_sentence_es": "Me gustaría presentarme: Mi nombre es Karim.",
            "sentence_en": "I'd like to introduce myself: My name is Karim.",
            "sentence_ar": bidi("أود أن أقدم نفسي: اسمي كريم."),
            "sentence_es": "Me gustaría presentarme: Mi nombre es Karim.",
        }
    })

    # ═════════════════════════════════════════════════════════════════════
    # Retain Pilot B from Unit 5 (Familie & Leute: Lesson 10001)
    # ═════════════════════════════════════════════════════════════════════
    u5_cards = [
        {
            "id": "card_u5_l10001_1",
            "lesson_id": 10001,
            "card_type": "noun_article",
            "sort_order": 1,
            "word_id": 1,  # Mutter (die)
            "data_json": {
                "example_sentence_de": "Meine Mutter kocht sehr gut.",
                "example_sentence_en": "My mother cooks very well.",
                "example_sentence_ar": bidi("أمي تطبخ بشكل جيد جداً."),
                "example_sentence_es": "Mi madre cocina muy bien.",
                "sentence_en": "My mother cooks very well.",
                "sentence_ar": bidi("أمي تطبخ بشكل جيد جداً."),
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
                "example_sentence_en": "My father likes to work.",
                "example_sentence_ar": bidi("أبي يحب العمل."),
                "example_sentence_es": "A mi padre le gusta trabajar.",
                "sentence_en": "My father likes to work.",
                "sentence_ar": bidi("أبي يحب العمل."),
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
                "example_sentence_en": "The child is playing in the park.",
                "example_sentence_ar": bidi("الطفل يلعب في الحديقة."),
                "example_sentence_es": "El niño juega en el parque.",
                "sentence_en": "The child is playing in the park.",
                "sentence_ar": bidi("الطفل يلعب في الحديقة."),
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
                "example_sentence_en": "My brother lives in Berlin.",
                "example_sentence_ar": bidi("أخي يعيش في برلين."),
                "example_sentence_es": "Mi hermano vive en Berlín.",
                "sentence_en": "My brother lives in Berlin.",
                "sentence_ar": bidi("أخي يعيش في برلين."),
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
                "example_sentence_en": "My sister is learning German.",
                "example_sentence_ar": bidi("أختي تتعلم الألمانية."),
                "example_sentence_es": "Mi hermana aprende alemán.",
                "sentence_en": "My sister is learning German.",
                "sentence_ar": bidi("أختي تتعلم الألمانية."),
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
                "sentence_ar": bidi("لدي أخ"),
                "sentence_es": "Tengo un hermano",
                "grammatical_note_en": "The direct object (accusative) changes masculine 'ein' to 'einen': Ich habe einen Bruder.",
                "grammatical_note_ar": bidi("المفعول به (حالة النصب Akkusativ) يحول أداة التنكير للمذكر من ein إلى einen: Ich habe einen Bruder."),
                "tile_tokens": ["Ich", "habe", "einen", "Bruder"]
            }
        }
    ]
    cards.extend(u5_cards)

    return cards

def clean_exercise_spoilers(exercises):
    """Cleans spoiler parentheticals from exercise prompts in Level Intro."""
    cleaned_count = 0
    spoilers = [
        r'\s*\(Letter D\)',
        r'\s*\(Greeting starting with H\)',
        r'\s*\(Yes or no\?\)',
        r'\s*\(möchte\)',
        r'\s*\(möchtest\)',
        r'\s*\(ausfüllen\)',
        r'\s*\(Unterschrift\)',
        r'\s*\(verheiratet\)',
    ]

    for ex in exercises:
        prompt_str = ex.get('prompt', '')
        if not prompt_str.startswith('{'):
            continue
        try:
            p = json.loads(prompt_str)
            modified = False
            for key in ['sentence_de', 'de', 'question_ar', 'question_en']:
                if key in p and isinstance(p[key], str):
                    original = p[key]
                    for pattern in spoilers:
                        p[key] = re.sub(pattern, '', p[key])
                    # Also fix question_ar leaking answer like 'متزوج': 'verheiratet'
                    if key == 'question_ar' and "'verheiratet'" in p[key]:
                        p[key] = p[key].replace(": ⁦'verheiratet'⁩", "")
                    if key == 'question_ar' and "'Unterschrift'" in p[key]:
                        p[key] = p[key].replace(": ⁦'Unterschrift'⁩", "")
                    if key == 'question_ar' and "'ausfüllen'" in p[key]:
                        p[key] = p[key].replace(": ⁦'ausfüllen'⁩", "")
                    if key == 'question_ar' and "'möchte'" in p[key]:
                        p[key] = p[key].replace(": ⁦'möchte'⁩", "")
                    if key == 'question_ar' and "'möchtest'" in p[key]:
                        p[key] = p[key].replace(": ⁦'möchtest'⁩", "")

                    if p[key] != original:
                        modified = True

            if modified:
                ex['prompt'] = json.dumps(p, ensure_ascii=False)
                cleaned_count += 1
        except Exception:
            pass

    return cleaned_count

def main():
    content_path = 'assets/deutschy_content.json'
    with open(content_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # 1. Generate Intro Learn Cards
    cards = generate_intro_cards()
    data['learn_cards'] = cards
    print(f"Generated {len(cards)} high-quality Learn Cards across Intro (Units 1-4) & Unit 5 Pilot!")

    # 2. Clean Exercise Spoilers
    cleaned = clean_exercise_spoilers(data.get('exercises', []))
    print(f"Cleaned spoilers from {cleaned} exercise prompts.")

    # 3. Save
    with open(content_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Successfully saved updated content to {content_path}")

if __name__ == '__main__':
    main()
