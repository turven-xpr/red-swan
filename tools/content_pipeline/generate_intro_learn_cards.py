#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_intro_learn_cards.py
Generates clean, focused, slide-by-slide Learn Cards for Level Intro (Units 1-4)
and cleans spoiler prompts from exercises.
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
        ("Hotel", "das Hotel", "hotel", "فندق", "hotel", "Das Hotel ist modern."),
        ("Taxi", "das Taxi", "taxi", "سيارة أجرة", "taxi", "Das Taxi kommt gleich."),
        ("Radio", "das Radio", "radio", "مذياع", "radio", "Das Radio spielt Musik."),
        ("Bus", "der Bus", "bus", "حافلة", "autobús", "Der Bus fährt nach Berlin."),
        ("Musik", "die Musik", "music", "موسيقى", "música", "Wir hören gerne Musik."),
        ("Café", "das Café", "café", "مقهى", "cafetería", "Das Café ist geöffnet."),
    ]
    for i, (short, de, en, ar, es, ex) in enumerate(u1_cognates, 1):
        cards.append({
            "id": f"card_10101_{i}",
            "lesson_id": 10101,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
            }
        })

    # --- 10102: Buchstaben A–F ---
    u1_af = [
        ("A a", "der Apfel", "apple", "تفاحة", "manzana", "A wie Apfel", "Der Apfel ist rot."),
        ("B b", "der Ball", "ball", "كرة", "pelota", "B wie Ball", "Der Ball ist rund."),
        ("C c", "der Computer", "computer", "حاسوب", "ordenador", "C wie Computer", "Der Computer ist neu."),
        ("D d", "Danke", "thank you", "شكراً", "gracias", "D wie Danke", "Vielen Dank!"),
        ("E e", "der Elefant", "elephant", "فيل", "elefante", "E wie Elefant", "Der Elefant ist groß."),
        ("F f", "das Fahrrad", "bicycle", "دراجة", "bicicleta", "F wie Fahrrad", "Das Fahrrad fährt schnell."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex) in enumerate(u1_af, 1):
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
                "example_sentence_de": ex,
            }
        })

    # --- 10103: Buchstaben G–L ---
    u1_gl = [
        ("G g", "der Garten", "garden", "حديقة", "jardín", "G wie Garten", "Der Garten ist schön."),
        ("H h", "Hallo", "hello", "مرحباً", "hola", "H wie Hallo", "Hallo! Wie geht's?"),
        ("I i", "die Insel", "island", "جزيرة", "isla", "I wie Insel", "Die Insel ist ruhig."),
        ("J j", "Ja", "yes", "نعم", "sí", "J wie Ja", "Ja, bitte."),
        ("K k", "der Kaffee", "coffee", "قهوة", "café", "K wie Kaffee", "Der Kaffee ist heiß."),
        ("L l", "die Lampe", "lamp", "مصباح", "lámpara", "L wie Lampe", "Die Lampe ist hell."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex) in enumerate(u1_gl, 1):
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
                "example_sentence_de": ex,
            }
        })

    # --- 10104: Buchstaben M–R ---
    u1_mr = [
        ("M m", "die Milch", "milk", "حليب", "leche", "M wie Milch", "Ich trinke Milch."),
        ("N n", "Nein", "no", "لا", "no", "N wie Nein", "Nein, danke."),
        ("O o", "die Orange", "orange", "برتقال", "naranja", "O wie Orange", "Die Orange schmeckt gut."),
        ("P p", "die Post", "post office", "بريد", "correos", "P wie Post", "Die Post ist da."),
        ("Q q", "die Quelle", "source", "ينبوع", "fuente", "Q wie Quelle", "Die Quelle ist frisch."),
        ("R r", "rot", "red", "أحمر", "rojo", "R wie rot", "Der Apfel ist rot."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex) in enumerate(u1_mr, 1):
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
                "example_sentence_de": ex,
            }
        })

    # --- 10105: Buchstaben S–U ---
    u1_su = [
        ("S s", "die Sonne", "sun", "شمس", "sol", "S wie Sonne", "Die Sonne scheint."),
        ("T t", "der Tee", "tea", "شاي", "té", "T wie Tee", "Der Tee ist warm."),
        ("U u", "die Uhr", "clock / watch", "ساعة", "reloj", "U wie Uhr", "Wie viel Uhr ist es?"),
        ("Zahlen", "sieben", "seven (7)", "سبعة (7)", "siete (7)", "Die Zahl 7", "Ich habe sieben Bücher."),
        ("Gruß", "Guten Tag", "good day", "يوم سعيد", "buenos días", "Begrüßung", "Guten Tag, Herr Müller!"),
    ]
    for i, (letter, de, en, ar, es, anchor, ex) in enumerate(u1_su, 1):
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
                "example_sentence_de": ex,
            }
        })

    # --- 10106: Besondere Konsonanten (V, W, X, Y, Z) ---
    u1_vwxyz = [
        ("V v", "vier", "four (pronounced like 'F')", "أربعة (يُنطق مثل حرف الفاء F)", "cuatro (suena como F)", "V wie vier", "Vier Tassen Kaffee."),
        ("W w", "das Wasser", "water (pronounced like English 'V')", "ماء (يُنطق مثل V الإنجليزية)", "agua (suena como V)", "W wie Wasser", "Das Wasser ist kalt."),
        ("X x", "das Taxi", "taxi (contains 'ks' sound)", "تاكسي (صوت 'كس')", "taxi", "X im Taxi", "Ich nehme ein Taxi."),
        ("Y y", "das Yoga", "yoga", "يوغا", "yoga", "Y wie Yoga", "Yoga macht fit."),
        ("Z z", "der Zug", "train (pronounced like 'ts')", "قطار (يُنطق مثل 'تس' ts)", "tren (suena como ts)", "Z wie Zug", "Der Zug kommt jetzt."),
    ]
    for i, (letter, de, en, ar, es, anchor, ex) in enumerate(u1_vwxyz, 1):
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
                "example_sentence_de": ex,
            }
        })

    # --- 10107: Umlaute (ä, ö, ü) & Eszett (ß) ---
    u1_umlaute = [
        ("Ä ä", "der Käse", "cheese (ä sounds like 'e' in bed)", "جبن (ä تنطق كالفتحة الممتدة)", "queso", "Ä wie Käse", "Der Käse schmeckt gut.", "Mund leicht geöffnet wie beim 'e'"),
        ("Ö ö", "schön", "beautiful (round lips and say 'ay')", "جميل (تدوير الشفتين ونطق 'إي')", "hermoso", "Ö in schön", "Das Bild ist schön.", "Lippen runden wie für 'o', aber 'e' sprechen"),
        ("Ü ü", "fünf", "five (round lips and say 'ee')", "خمسة (تدوير الشفتين ونطق 'ي')", "cinco", "Ü in fünf", "Es ist fünf Uhr.", "Lippen spitzen wie für 'u', aber 'i' sprechen"),
        ("ß", "weiß", "white (sharp double 'ss')", "أبيض (حرف سين مشدد حاد)", "blanco", "ß in weiß", "Das Hemd ist weiß.", "Wird wie ein scharfes 'ss' gesprochen"),
    ]
    for i, (letter, de, en, ar, es, anchor, ex, tip) in enumerate(u1_umlaute, 1):
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
                "example_sentence_de": ex,
                "mouth_tip_en": tip,
                "mouth_tip_ar": bidi(f"نصيحة النطق: {tip}"),
            }
        })

    # --- 10108: Diphthonge & Laute (ei, ie, eu, au, sch, ch) ---
    u1_diphthongs = [
        ("ei", "eins", "one (sounds like 'eye')", "واحد (يُنطق مثل eye)", "uno", "ei wie eins", "Eins, zwei, drei."),
        ("ie", "sieben", "seven (long 'ee' sound)", "سبعة (ياء ممدودة طويلة)", "siete", "ie wie sieben", "Sieben Tage."),
        ("eu", "Euro", "euro (sounds like 'oy')", "يورو (يُنطق مثل 'أوي')", "euro", "eu wie Euro", "Drei Euro."),
        ("au", "das Auto", "car (sounds like 'ow')", "سيارة (يُنطق مثل 'أو')", "coche", "au wie Auto", "Das Auto fährt schnell."),
        ("sch", "die Schule", "school (sounds like 'sh')", "مدرسة (يُنطق مثل حرف الشين)", "escuela", "sch wie Schule", "Die Schule ist groß."),
        ("ch", "ich / ach", "soft after e/i, hard after a/o/u", "ناعم بعد e/i وخشن بعد a/o/u", "ch suave y dura", "Laut ch", "Ich bin hier. Das Buch ist alt."),
    ]
    for i, (sound, de, en, ar, es, anchor, ex) in enumerate(u1_diphthongs, 1):
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
                "example_sentence_de": ex,
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
            "sentence_en": "How do you spell that?",
            "sentence_ar": bidi("كيف تتهجى ذلك؟"),
            "sentence_es": "¿Cómo se deletrea eso?",
            "example_sentence_de": "H-O-T-E-L: Hotel.",
        }
    })

    # ═════════════════════════════════════════════════════════════════════
    # UNIT 2: Erste Wörter & Zahlen (Lessons 10201 - 10208)
    # ═════════════════════════════════════════════════════════════════════

    # --- 10201: Höflichkeit ---
    u2_polite = [
        ("Danke", "thank you", "شكراً", "gracias", "Danke schön!"),
        ("Bitte", "please / you're welcome", "من فضلك / عفواً", "por favor / de nada", "Bitte sehr!"),
        ("Hallo", "hello", "مرحباً", "hola", "Hallo! Schön dich zu sehen."),
        ("Tschüss", "bye", "مع السلامة", "adiós", "Tschüss! Bis morgen."),
        ("Entschuldigung", "excuse me / sorry", "معذرة / عذراً", "disculpe", "Entschuldigung, wo ist der Bahnhof?"),
    ]
    for i, (word, en, ar, es, ex) in enumerate(u2_polite, 1):
        cards.append({
            "id": f"card_10201_{i}",
            "lesson_id": 10201,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": word,
            "data_json": {
                "chunk_de": word,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
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
                "sentence_en": f"{digit} = {en}",
                "sentence_ar": bidi(f"{digit} = {ar}"),
                "sentence_es": f"{digit} = {es}",
                "example_sentence_de": f"Ich zähle: {de}.",
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
                "sentence_en": f"{digit} = {en}",
                "sentence_ar": bidi(f"{digit} = {ar}"),
                "sentence_es": f"{digit} = {es}",
                "example_sentence_de": f"Zimmer {de}.",
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
                "sentence_en": f"{digit} = {en}",
                "sentence_ar": bidi(f"{digit} = {ar}"),
                "sentence_es": f"{digit} = {es}",
                "example_sentence_de": f"Bus Nummer {de}.",
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
                "sentence_en": f"{digit} = {en}",
                "sentence_ar": bidi(f"{digit} = {ar}"),
                "sentence_es": f"{digit} = {es}",
                "example_sentence_de": f"Das kostet {de} Euro.",
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
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": f"Heute ist {de}.",
            }
        })

    # --- 10207: Farben ---
    u2_colors = [
        ("blau", "#1E88E5", "blue", "أزرق", "azul", "Der Himmel ist blau."),
        ("rot", "#E53935", "red", "أحمر", "rojo", "Der Apfel ist rot."),
        ("grün", "#43A047", "green", "أخضر", "verde", "Das Gras ist grün."),
        ("gelb", "#FDD835", "yellow", "أصفر", "amarillo", "Die Sonne ist gelb."),
        ("schwarz", "#212121", "black", "أسود", "negro", "Der Kaffee ist schwarz."),
        ("weiß", "#EEEEEE", "white", "أبيض", "blanco", "Der Schnee ist weiß."),
        ("grau", "#9E9E9E", "gray", "رمادي", "gris", "Die Wolke ist grau."),
        ("braun", "#6D4C41", "brown", "بني", "marrón", "Die Schokolade ist braun."),
        ("orange", "#FB8C00", "orange", "برتقالي", "naranja", "Die Orange ist orange."),
    ]
    for i, (de, hex_code, en, ar, es, ex) in enumerate(u2_colors, 1):
        cards.append({
            "id": f"card_10207_{i}",
            "lesson_id": 10207,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "swatch_hex": hex_code,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
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
            "sentence_en": "Numbers & Colors Review",
            "sentence_ar": bidi("مراجعة الأرقام والألوان"),
            "sentence_es": "Repaso de números y colores",
            "example_sentence_de": "Drei rote Äpfel.",
        }
    })

    # ═════════════════════════════════════════════════════════════════════
    # UNIT 3: Begrüßung, Verben & Fragestellung (Lessons 10301 - 10308)
    # ═════════════════════════════════════════════════════════════════════

    # --- 10301: Begrüßung & Verabschiedung ---
    u3_greetings = [
        ("Guten Morgen", "Good morning (morning greeting)", "صباح الخير", "Buenos días", "Guten Morgen! Haben Sie gut geschlafen?"),
        ("Guten Tag", "Good day (standard daytime greeting)", "يوم سعيد / مرحباً", "Buenas tardes", "Guten Tag, Herr Meier!"),
        ("Guten Abend", "Good evening (evening greeting)", "مساء الخير", "Buenas noches (al llegar)", "Guten Abend allerseits!"),
        ("Gute Nacht", "Good night (said before sleeping)", "تصبح على خير", "Buenas noches (al despedirse)", "Gute Nacht und schlaf gut!"),
        ("Auf Wiedersehen", "Goodbye (formal)", "إلى اللقاء (رسمي)", "Hasta la vista", "Auf Wiedersehen, Frau Schmidt!"),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u3_greetings, 1):
        cards.append({
            "id": f"card_10301_{i}",
            "lesson_id": 10301,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
            }
        })

    # --- 10302: Wie geht's? ---
    u3_howareyou = [
        ("Wie geht's?", "How are you? (informal)", "كيف حالك؟", "¿Cómo estás?", "Hallo Anna, wie geht's?"),
        ("Sehr gut, danke!", "Very good, thank you!", "بخير جداً، شكراً!", "¡Muy bien, gracias!", "Mir geht es sehr gut, danke!"),
        ("Es geht.", "So-so / Not bad.", "على ما يرام / لا بأس.", "Ahí vamos.", "Wie geht's? — Es geht."),
        ("Nicht so gut.", "Not so good.", "لست بخير / ليس جيداً.", "No tan bien.", "Heute geht es mir nicht so gut."),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u3_howareyou, 1):
        cards.append({
            "id": f"card_10302_{i}",
            "lesson_id": 10302,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
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
        ("Ich verstehe nicht.", "I do not understand.", "أنا لا أفهم.", "No entiendo.", "Ich verstehe nicht."),
        ("Sprechen Sie Englisch?", "Do you speak English?", "هل تتحدث الإنجليزية؟", "¿Habla inglés?", "Entschuldigung, sprechen Sie Englisch?"),
        ("Bitte langsamer.", "Please more slowly.", "من فضلك تحدث ببطء أكثر.", "Más despacio, por favor.", "Können Sie bitte langsamer sprechen?"),
        ("Wie bitte?", "Pardon? / Could you repeat?", "عفواً؟ ماذا قلت؟", "¿Cómo?", "Wie bitte? Ich habe das nicht gehört."),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u3_survival, 1):
        cards.append({
            "id": f"card_10306_{i}",
            "lesson_id": 10306,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
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
            "sentence_en": "Good day! My name is Karim. And what is your name?",
            "sentence_ar": bidi("يوم سعيد! اسمي كريم. وما اسم حضرتك؟"),
            "sentence_es": "¡Buenos días! Me llamo Karim. ¿Y cómo se llama usted?",
            "example_sentence_de": "Ich heiße Anna. Freut mich!",
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
            "sentence_en": "Greetings & Verbs Mastery Check",
            "sentence_ar": bidi("اختبار التحيات وتصريف الأفعال"),
            "sentence_es": "Examen de saludos y verbos",
            "example_sentence_de": "Hallo, ich heiße Karim und komme aus Syrien.",
        }
    })

    # ═════════════════════════════════════════════════════════════════════
    # UNIT 4: Persönliche Angaben, Formulare & möchten (Lessons 10311 - 10317)
    # ═════════════════════════════════════════════════════════════════════

    # --- 10311: Länder & Sprachen ---
    u4_countries = [
        ("Deutschland", "Germany", "ألمانيا", "Alemania", "Deutschland ist in Europa."),
        ("Deutsch", "German (language)", "اللغة الألمانية", "alemán", "Ich lerne Deutsch."),
        ("Syrien", "Syria", "سوريا", "Siria", "Er kommt aus Syrien."),
        ("Marokko", "Morocco", "المغرب", "Marruecos", "Sie kommt aus Marokko."),
        ("Arabisch", "Arabic (language)", "اللغة العربية", "árabe", "Meine Muttersprache ist Arabisch."),
        ("Englisch", "English (language)", "اللغة الإنجليزية", "inglés", "Wir sprechen Englisch."),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u4_countries, 1):
        cards.append({
            "id": f"card_10311_{i}",
            "lesson_id": 10311,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
            }
        })

    # --- 10312: Persönliche Angaben ---
    u4_personal = [
        ("der Vorname", "first name", "الاسم الأول / الشخصي", "nombre de pila", "Mein Vorname ist Karim."),
        ("der Familienname", "surname / last name", "اللقب / اسم العائلة", "apellido", "Mein Familienname ist Mansour."),
        ("das Alter", "age", "العمر / السن", "edad", "Mein Alter ist 25 Jahre."),
        ("der Wohnort", "place of residence", "مكان الإقامة", "lugar de residencia", "Mein Wohnort ist Berlin."),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u4_personal, 1):
        cards.append({
            "id": f"card_10312_{i}",
            "lesson_id": 10312,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
            }
        })

    # --- 10313: Adresse & Kontakt ---
    u4_contact = [
        ("die Straße", "street", "الشارع", "calle", "Ich wohne in der Goethestraße."),
        ("die Hausnummer", "house number", "رقم المنزل", "número de casa", "Meine Hausnummer ist 14."),
        ("die Postleitzahl", "postal code (PLZ)", "الرمز البريدي", "código postal", "Die Postleitzahl ist 10115."),
        ("die Telefonnummer", "phone number", "رقم الهاتف", "número de teléfono", "Meine Telefonnummer ist 0151..."),
        ("die E-Mail-Adresse", "email address", "عنوان البريد الإلكتروني", "correo electrónico", "Meine E-Mail-Adresse ist..."),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u4_contact, 1):
        cards.append({
            "id": f"card_10313_{i}",
            "lesson_id": 10313,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
            }
        })

    # --- 10314: Familienstand & Beruf ---
    u4_status = [
        ("ledig", "single (unmarried)", "أعزب / عزباء", "soltero/a", "Ich bin ledig."),
        ("verheiratet", "married", "متزوج / متزوجة", "casado/a", "Er ist verheiratet."),
        ("der Student", "student (male)", "طالب جامعي", "estudiante (m)", "Ich bin Student an der Universität."),
        ("der Arzt", "doctor (physician)", "طبيب", "médico", "Der Arzt arbeitet im Krankenhaus."),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u4_status, 1):
        cards.append({
            "id": f"card_10314_{i}",
            "lesson_id": 10314,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
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
        ("das Formular", "form", "استمارة رسمية", "formulario", "Bitte füllen Sie das Formular aus."),
        ("ausfüllen", "to fill out", "يملأ استمارة", "rellenar / completar", "Ich fülle das Anmeldeformular aus."),
        ("der Geburtsort", "place of birth", "مكان الولادة", "lugar de nacimiento", "Mein Geburtsort ist Damaskus."),
        ("das Geburtsdatum", "date of birth", "تاريخ الولادة", "fecha de nacimiento", "Mein Geburtsdatum ist 12.05.1998."),
        ("die Unterschrift", "signature", "التوقيع", "firma", "Ihre Unterschrift bitte hier unten."),
    ]
    for i, (de, en, ar, es, ex) in enumerate(u4_formular, 1):
        cards.append({
            "id": f"card_10316_{i}",
            "lesson_id": 10316,
            "card_type": "concept",
            "sort_order": i,
            "custom_prompt_de": de,
            "data_json": {
                "chunk_de": de,
                "sentence_en": en,
                "sentence_ar": bidi(ar),
                "sentence_es": es,
                "example_sentence_de": ex,
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
            "sentence_en": "You are ready for the Intro Checkpoint!",
            "sentence_ar": bidi("أنت الآن مستعد لاختبار إنهاء المستوى التمهيدي!"),
            "sentence_es": "¡Estás listo para el examen de nivel Intro!",
            "example_sentence_de": "Ich möchte mich vorstellen: Mein Name ist Karim.",
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
