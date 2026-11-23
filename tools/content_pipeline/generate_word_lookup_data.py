#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_word_lookup_data.py
Creates canonical trilingual dictionary covering all words across Level Intro example sentences.
Generates:
  1. lib/src/features/study/domain/word_lookup_service.dart
  2. Injects card-level word_translations into assets/deutschy_content.json
  3. Copies to build/flutter_assets and build/web
"""

import json
import re
import os

def bidi(text: str) -> str:
    clean = text.replace('\u2066', '').replace('\u2069', '').strip()
    return f"\u2066{clean}\u2069"

CANONICAL_DICT = {
    # Articles & Demonstratives
    'das': ('das', 'das', 'das', 'art', 'the (neuter)', bidi('الـ (للمحايد)'), 'el / la (neutro)'),
    'der': ('der', 'der', 'der', 'art', 'the (masculine)', bidi('الـ (للمذكر)'), 'el'),
    'die': ('die', 'die', 'die', 'art', 'the (feminine / plural)', bidi('الـ (للمؤنث / الجمع)'), 'la / las'),
    'ein': ('ein', 'ein', '', 'art', 'a / an (masculine / neuter)', bidi('أداة تنكير (مذكر / محايد)'), 'un'),
    'eine': ('eine', 'eine', '', 'art', 'a / an (feminine)', bidi('أداة تنكير (مؤنث)'), 'una'),
    'einen': ('einen', 'ein', '', 'art', 'a / an (accusative masculine)', bidi('أداة تنكير منصوبة (مذكر)'), 'un'),

    # Pronouns
    'ich': ('ich', 'ich', '', 'pron', 'I', bidi('أنا'), 'yo'),
    'du': ('du', 'du', '', 'pron', 'you (informal)', bidi('أنتَ / أنتِ'), 'tú'),
    'er': ('er', 'er', '', 'pron', 'he', bidi('هو'), 'él'),
    'sie': ('sie', 'sie', '', 'pron', 'she / they / You (formal)', bidi('هي / هم / حضرتك'), 'ella / ellos / usted'),
    'es': ('es', 'es', '', 'pron', 'it', bidi('هو / هي (للمحايد)'), 'ello / él / ella'),
    'wir': ('wir', 'wir', '', 'pron', 'we', bidi('نحن'), 'nosotros'),
    'ihr': ('ihr', 'ihr', '', 'pron', 'you (plural informal)', bidi('أنتم'), 'vosotros'),
    'mein': ('mein', 'mein', '', 'pron', 'my (masculine / neuter)', bidi('ـي (ياء الملكية للمذكر/المحايد)'), 'mi'),
    'meine': ('meine', 'mein', '', 'pron', 'my (feminine / plural)', bidi('ـي (ياء الملكية للمؤنث/الجمع)'), 'mis / mi'),
    'ihre': ('Ihre', 'ihr', '', 'pron', 'your (formal)', bidi('خاص بحضرتك'), 'su (de usted)'),
    'mich': ('mich', 'ich', '', 'pron', 'me / myself (accusative)', bidi('نفسي / ياء المتكلم'), 'me / a mí'),
    'mir': ('mir', 'ich', '', 'pron', 'me (dative)', bidi('لي / معي'), 'a mí / me'),
    'dich': ('dich', 'du', '', 'pron', 'you (accusative)', bidi('إياك / كاف المخاطب'), 'te / a ti'),

    # Verbs
    'ist': ('ist', 'sein', '', 'verb', 'is', bidi('يكون / هو'), 'es / está'),
    'bin': ('bin', 'sein', '', 'verb', 'am', bidi('أكون / أنا'), 'soy / estoy'),
    'habe': ('habe', 'haben', '', 'verb', 'have (1st person)', bidi('عندي / لدي'), 'tengo'),
    'haben': ('haben', 'haben', '', 'verb', 'have', bidi('لديك / لديكم / يملكون'), 'tienen / tiene'),
    'kommt': ('kommt', 'kommen', '', 'verb', 'comes / is arriving', bidi('يأتي / قادم'), 'viene / llega'),
    'komme': ('komme', 'kommen', '', 'verb', 'come', bidi('آتي / أنا قادم'), 'vengo'),
    'spielt': ('spielt', 'spielen', '', 'verb', 'plays', bidi('يلعب / يعزف'), 'juega / toca'),
    'fährt': ('fährt', 'fahren', '', 'verb', 'drives / travels', bidi('يسير / يقود / يسافر'), 'conduce / viaja'),
    'hören': ('hören', 'hören', '', 'verb', 'hear / listen', bidi('نستمع / نسمع'), 'escuchamos'),
    'trinke': ('trinke', 'trinken', '', 'verb', 'drink', bidi('أشرب'), 'bebo'),
    'scheint': ('scheint', 'scheinen', '', 'verb', 'shines', bidi('تشرق / يسطع'), 'brilla'),
    'macht': ('macht', 'machen', '', 'verb', 'makes', bidi('يجعل / يفعل'), 'hace'),
    'schmeckt': ('schmeckt', 'schmecken', '', 'verb', 'tastes (good)', bidi('طعمه / مذاقه'), 'sabe bien'),
    'zählen': ('zählen', 'zählen', '', 'verb', 'to count', bidi('يعد / يحصي'), 'contar'),
    'zähle': ('zähle', 'zählen', '', 'verb', 'count', bidi('أعد / أحصي'), 'cuento'),
    'kostet': ('kostet', 'kosten', '', 'verb', 'costs', bidi('يكلف / سعره'), 'cuesta'),
    'heiße': ('heiße', 'heißen', '', 'verb', 'am called / my name is', bidi('اسمي / أُدعى'), 'me llamo'),
    'heißen': ('heißen', 'heißen', '', 'verb', 'are called', bidi('تُدعى / يُسمى'), 'se llama'),
    'geht': ('geht', 'gehen', '', 'verb', 'goes / walks', bidi('يسير / يمضي'), 'va'),
    "geht's": ("geht's", 'gehen', '', 'phrase', "how is it going", bidi('كيف الحال'), '¿cómo va?'),
    'verstehe': ('verstehe', 'verstehen', '', 'verb', 'understand', bidi('أفهم'), 'entiendo'),
    'sprechen': ('sprechen', 'sprechen', '', 'verb', 'speak', bidi('نتحدث / يتكلم'), 'hablamos / habla'),
    'können': ('können', 'können', '', 'verb', 'can / could', bidi('يمكنك / تستطيع'), 'puede'),
    'möchte': ('möchte', 'möchten', '', 'verb', 'would like', bidi('أود / أرغب'), 'quisiera / me gustaría'),
    'gehört': ('gehört', 'hören', '', 'verb', 'heard', bidi('سمعت'), 'oído / escuchado'),
    'geschlafen': ('geschlafen', 'schlafen', '', 'verb', 'slept', bidi('نمت'), 'dormido'),
    'schlaf': ('schlaf', 'schlafen', '', 'verb', 'sleep (imperative)', bidi('نَمْ'), 'duerme'),
    'lerne': ('lerne', 'lernen', '', 'verb', 'learn', bidi('أتعلم'), 'aprendo'),
    'lernt': ('lernt', 'lernen', '', 'verb', 'learns', bidi('تتعلم / يتعلم'), 'aprende'),
    'wohne': ('wohne', 'wohnen', '', 'verb', 'live / reside', bidi('أسكن / أعيش'), 'vivo'),
    'wohnt': ('wohnt', 'wohnen', '', 'verb', 'lives / resides', bidi('يسكن / يعيش'), 'vive'),
    'arbeitet': ('arbeitet', 'arbeiten', '', 'verb', 'works', bidi('يعمل'), 'trabaja'),
    'kocht': ('kocht', 'kochen', '', 'verb', 'cooks', bidi('تطبخ / يطبخ'), 'cocina'),
    'füllen': ('füllen', 'ausfüllen', '', 'verb', 'fill out (formal)', bidi('املأ / املؤوا'), 'rellenen / complete'),
    'fülle': ('fülle', 'ausfüllen', '', 'verb', 'fill out', bidi('أملأ'), 'completo / relleno'),
    'ausfüllen': ('ausfüllen', 'ausfüllen', '', 'verb', 'to fill out', bidi('ملء الاستمارة'), 'rellenar'),
    'vorstellen': ('vorstellen', 'vorstellen', '', 'verb', 'introduce', bidi('أُعرّف / أُقدّم نفسي'), 'presentar'),
    'sehen': ('sehen', 'sehen', '', 'verb', 'to see', bidi('أرى / رؤية'), 'ver'),
    'nehme': ('nehme', 'nehmen', '', 'verb', 'take', bidi('آخذ'), 'tomo'),
    'freut': ('freut', 'freuen', '', 'verb', 'pleased (nice to meet you)', bidi('يسعدني / تشرفت'), 'mucho gusto / encantado'),

    # Prepositions, Conjunctions & Particles
    'in': ('in', 'in', '', 'prep', 'in', bidi('في'), 'en'),
    'im': ('im', 'in dem', '', 'prep', 'in the', bidi('في الـ'), 'en el'),
    'an': ('an', 'an', '', 'prep', 'at / on', bidi('في / عند'), 'en'),
    'aus': ('aus', 'aus', '', 'prep', 'from', bidi('من'), 'de / desde'),
    'nach': ('nach', 'nach', '', 'prep', 'to / towards', bidi('إلى'), 'hacia / a'),
    'und': ('und', 'und', '', 'conj', 'and', bidi('و'), 'y'),
    'da': ('da', 'da', '', 'adv', 'there / here', bidi('هنا / هناك'), 'ahí / aquí'),
    'hier': ('hier', 'hier', '', 'adv', 'here', bidi('هنا'), 'aquí'),
    'jetzt': ('jetzt', 'jetzt', '', 'adv', 'now', bidi('الآن'), 'ahora'),
    'gleich': ('gleich', 'gleich', '', 'adv', 'soon / right away', bidi('حالاً / بعد قليل'), 'pronto / enseguida'),
    'nicht': ('nicht', 'nicht', '', 'adv', 'not', bidi('لا / ليس'), 'no'),
    'so': ('so', 'so', '', 'adv', 'so / that', bidi('هكذا / إلى هذا الحد'), 'tan / así'),
    'sehr': ('sehr', 'sehr', '', 'adv', 'very', bidi('جداً'), 'muy'),
    'gern': ('gern', 'gern', '', 'adv', 'gladly / likes to', bidi('بسرور / يحب أن'), 'con gusto'),
    'gerne': ('gerne', 'gerne', '', 'adv', 'gladly', bidi('بسرور / بكل سرور'), 'con gusto'),
    'langsamer': ('langsamer', 'langsam', '', 'adv', 'more slowly', bidi('ببطء أكثر'), 'más despacio'),
    'bitte': ('bitte', 'bitte', '', 'part', 'please / you are welcome', bidi('من فضلك / تفضل'), 'por favor / de nada'),
    'danke': ('danke', 'danken', '', 'part', 'thank you', bidi('شكراً'), 'gracias'),
    'dank': ('Dank', 'Dank', 'der', 'noun', 'thanks', bidi('شكر'), 'agradecimiento'),
    'vielen': ('vielen', 'viel', '', 'adj', 'many (vielen Dank = thank you very much)', bidi('جزيل / كثير'), 'muchas'),
    'ja': ('Ja', 'ja', '', 'part', 'yes', bidi('نعم'), 'sí'),
    'nein': ('Nein', 'nein', '', 'part', 'no', bidi('لا'), 'no'),
    'hallo': ('Hallo', 'hallo', '', 'part', 'hello', bidi('مرحباً'), 'hola'),
    'tschüss': ('Tschüss', 'tschüss', '', 'part', 'bye', bidi('مع السلامة'), 'adiós'),
    'entschuldigung': ('Entschuldigung', 'Entschuldigung', 'die', 'noun', 'excuse me / sorry', bidi('معذرة / عذراً'), 'disculpe / perdón'),
    'wiedersehen': ('Wiedersehen', 'Wiedersehen', 'das', 'noun', 'seeing again (Auf Wiedersehen = goodbye)', bidi('لقاء (إلى اللقاء)'), 'vista (hasta la vista)'),
    'auf': ('auf', 'auf', '', 'prep', 'on / until', bidi('إلى / على'), 'hasta / sobre'),
    'bis': ('bis', 'bis', '', 'prep', 'until (Bis morgen = see you tomorrow)', bidi('حتى / إلى (إلى الغد)'), 'hasta (hasta mañana)'),
    'morgen': ('morgen', 'morgen', '', 'adv', 'tomorrow', bidi('غداً'), 'mañana'),
    'heute': ('heute', 'heute', '', 'adv', 'today', bidi('اليوم'), 'hoy'),
    'wie': ('wie', 'wie', '', 'adv', 'how / what', bidi('كيف / ما'), 'cómo'),
    'wo': ('wo', 'wo', '', 'adv', 'where', bidi('أين'), 'dónde'),
    'viel': ('viel', 'viel', '', 'adj', 'much / how much', bidi('كم / كثير'), 'mucho'),
    'unten': ('unten', 'unten', '', 'adv', 'down below / at the bottom', bidi('بالأسفل'), 'abajo'),
    'allerseits': ('allerseits', 'allerseits', '', 'adv', 'everyone / all', bidi('للجميع / كافّة'), 'a todos'),
    'zu': ('zu', 'zu', '', 'prep', 'to / at', bidi('إلى / لـ'), 'a / para'),

    # Nouns
    'hotel': ('Hotel', 'das Hotel', 'das', 'noun', 'hotel', bidi('فندق'), 'hotel'),
    'taxi': ('Taxi', 'das Taxi', 'das', 'noun', 'taxi', bidi('سيارة أجرة'), 'taxi'),
    'radio': ('Radio', 'das Radio', 'das', 'noun', 'radio', bidi('مذياع'), 'radio'),
    'bus': ('Bus', 'der Bus', 'der', 'noun', 'bus', bidi('حافلة'), 'autobús'),
    'musik': ('Musik', 'die Musik', 'die', 'noun', 'music', bidi('موسيقى'), 'música'),
    'café': ('Café', 'das Café', 'das', 'noun', 'café', bidi('مقهى'), 'cafetería'),
    'apfel': ('Apfel', 'der Apfel', 'der', 'noun', 'apple', bidi('تفاحة'), 'manzana'),
    'äpfel': ('Äpfel', 'der Apfel', 'die', 'noun', 'apples', bidi('تفاح'), 'manzanas'),
    'ball': ('Ball', 'der Ball', 'der', 'noun', 'ball', bidi('كرة'), 'pelota'),
    'computer': ('Computer', 'der Computer', 'der', 'noun', 'computer', bidi('حاسوب'), 'ordenador'),
    'elefant': ('Elefant', 'der Elefant', 'der', 'noun', 'elephant', bidi('فيل'), 'elefante'),
    'fahrrad': ('Fahrrad', 'das Fahrrad', 'das', 'noun', 'bicycle', bidi('دراجة هوائية'), 'bicicleta'),
    'garten': ('Garten', 'der Garten', 'der', 'noun', 'garden', bidi('حديقة'), 'jardín'),
    'insel': ('Insel', 'die Insel', 'die', 'noun', 'island', bidi('جزيرة'), 'isla'),
    'kaffee': ('Kaffee', 'der Kaffee', 'der', 'noun', 'coffee', bidi('قهوة'), 'café'),
    'lampe': ('Lampe', 'die Lampe', 'die', 'noun', 'lamp', bidi('مصباح'), 'lámpara'),
    'milch': ('Milch', 'die Milch', 'die', 'noun', 'milk', bidi('حليب'), 'leche'),
    'orange': ('Orange', 'die Orange', 'die', 'noun', 'orange', bidi('برتقالة'), 'naranja'),
    'post': ('Post', 'die Post', 'die', 'noun', 'post office / mail', bidi('بريد'), 'correo'),
    'quelle': ('Quelle', 'die Quelle', 'die', 'noun', 'spring / source', bidi('ينبوع'), 'fuente'),
    'sonne': ('Sonne', 'die Sonne', 'die', 'noun', 'sun', bidi('شمس'), 'sol'),
    'tee': ('Tee', 'der Tee', 'der', 'noun', 'tea', bidi('شاي'), 'té'),
    'uhr': ('Uhr', 'die Uhr', 'die', 'noun', 'clock / o’clock', bidi('ساعة'), 'reloj / hora'),
    'bücher': ('Bücher', 'das Buch', 'die', 'noun', 'books', bidi('كتب'), 'libros'),
    'tag': ('Tag', 'der Tag', 'der', 'noun', 'day', bidi('يوم'), 'día'),
    'tage': ('Tage', 'der Tag', 'die', 'noun', 'days', bidi('أيام'), 'días'),
    'herr': ('Herr', 'der Herr', 'der', 'noun', 'Mr. / gentleman', bidi('سيد'), 'señor'),
    'frau': ('Frau', 'die Frau', 'die', 'noun', 'Mrs. / woman', bidi('سيدة / امرأة'), 'señora / mujer'),
    'mann': ('Mann', 'der Mann', 'der', 'noun', 'man', bidi('رجل'), 'hombre'),
    'kind': ('Kind', 'das Kind', 'das', 'noun', 'child', bidi('طفل'), 'niño'),
    'müller': ('Müller', 'Müller', '', 'noun', 'Müller (German surname)', bidi('مولر (لقب ألماني)'), 'Müller'),
    'meier': ('Meier', 'Meier', '', 'noun', 'Meier (German surname)', bidi('ماير (لقب ألماني)'), 'Meier'),
    'schmidt': ('Schmidt', 'Schmidt', '', 'noun', 'Schmidt (German surname)', bidi('شميت (لقب ألماني)'), 'Schmidt'),
    'karim': ('Karim', 'Karim', '', 'noun', 'Karim (personal name)', bidi('كريم (اسم شخصي)'), 'Karim'),
    'anna': ('Anna', 'Anna', '', 'noun', 'Anna (personal name)', bidi('آنّا (اسم شخصي)'), 'Anna'),
    'mansour': ('Mansour', 'Mansour', '', 'noun', 'Mansour (surname)', bidi('منصور (لقب عائلي)'), 'Mansour'),
    'berlin': ('Berlin', 'Berlin', 'das', 'noun', 'Berlin (capital of Germany)', bidi('برلين (عاصمة ألمانيا)'), 'Berlín'),
    'deutschland': ('Deutschland', 'Deutschland', 'das', 'noun', 'Germany', bidi('ألمانيا'), 'Alemania'),
    'syrien': ('Syrien', 'Syrien', 'das', 'noun', 'Syria', bidi('سوريا'), 'Siria'),
    'marokko': ('Marokko', 'Marokko', 'das', 'noun', 'Morocco', bidi('المغرب'), 'Marruecos'),
    'europa': ('Europa', 'Europa', 'das', 'noun', 'Europe', bidi('أوروبا'), 'Europa'),
    'damaskus': ('Damaskus', 'Damaskus', 'das', 'noun', 'Damascus', bidi('دمشق'), 'Damasco'),
    'goethestraße': ('Goethestraße', 'die Goethestraße', 'die', 'noun', 'Goethe Street', bidi('شارع غوته'), 'calle Goethe'),
    'tassen': ('Tassen', 'die Tasse', 'die', 'noun', 'cups', bidi('فناجين'), 'tazas'),
    'wasser': ('Wasser', 'das Wasser', 'das', 'noun', 'water', bidi('ماء'), 'agua'),
    'yoga': ('Yoga', 'das Yoga', 'das', 'noun', 'yoga', bidi('يوغا'), 'yoga'),
    'zug': ('Zug', 'der Zug', 'der', 'noun', 'train', bidi('قطار'), 'tren'),
    'käse': ('Käse', 'der Käse', 'der', 'noun', 'cheese', bidi('جبن'), 'queso'),
    'bild': ('Bild', 'das Bild', 'das', 'noun', 'picture / painting', bidi('صورة / لوحة'), 'imagen / cuadro'),
    'hemd': ('Hemd', 'das Hemd', 'das', 'noun', 'shirt', bidi('قميص'), 'camisa'),
    'euro': ('Euro', 'der Euro', 'der', 'noun', 'euro', bidi('يورو'), 'euro'),
    'auto': ('Auto', 'das Auto', 'das', 'noun', 'car', bidi('سيارة'), 'coche / auto'),
    'schule': ('Schule', 'die Schule', 'die', 'noun', 'school', bidi('مدرسة'), 'escuela'),
    'bahnhof': ('Bahnhof', 'der Bahnhof', 'der', 'noun', 'train station', bidi('محطة القطار'), 'estación de tren'),
    'zimmer': ('Zimmer', 'das Zimmer', 'das', 'noun', 'room', bidi('غرفة'), 'habitación'),
    'nummer': ('Nummer', 'die Nummer', 'die', 'noun', 'number', bidi('رقم'), 'número'),
    'himmel': ('Himmel', 'der Himmel', 'der', 'noun', 'sky', bidi('سماء'), 'cielo'),
    'gras': ('Gras', 'das Gras', 'das', 'noun', 'grass', bidi('عشب'), 'hierba / césped'),
    'schnee': ('Schnee', 'der Schnee', 'der', 'noun', 'snow', bidi('ثلج'), 'nieve'),
    'wolke': ('Wolke', 'die Wolke', 'die', 'noun', 'cloud', bidi('سحابة'), 'nube'),
    'schokolade': ('Schokolade', 'die Schokolade', 'die', 'noun', 'chocolate', bidi('شوكولاتة'), 'chocolate'),
    'morgen_noun': ('Morgen', 'der Morgen', 'der', 'noun', 'morning', bidi('صباح'), 'mañana'),
    'abend': ('Abend', 'der Abend', 'der', 'noun', 'evening', bidi('مساء'), 'tarde / noche'),
    'nacht': ('Nacht', 'die Nacht', 'die', 'noun', 'night', bidi('ليلة'), 'noche'),
    'deutsch': ('Deutsch', 'Deutsch', 'das', 'noun', 'German (language)', bidi('اللغة الألمانية'), 'alemán'),
    'arabisch': ('Arabisch', 'Arabisch', 'das', 'noun', 'Arabic (language)', bidi('اللغة العربية'), 'árabe'),
    'englisch': ('Englisch', 'Englisch', 'das', 'noun', 'English (language)', bidi('اللغة الإنجليزية'), 'inglés'),
    'muttersprache': ('Muttersprache', 'die Muttersprache', 'die', 'noun', 'native language', bidi('اللغة الأم'), 'lengua materna'),
    'vorname': ('Vorname', 'der Vorname', 'der', 'noun', 'first name', bidi('الاسم الأول'), 'nombre de pila'),
    'familienname': ('Familienname', 'der Familienname', 'der', 'noun', 'last name / surname', bidi('اللقب / اسم العائلة'), 'apellido'),
    'name': ('Name', 'der Name', 'der', 'noun', 'name', bidi('اسم'), 'nombre'),
    'alter': ('Alter', 'das Alter', 'das', 'noun', 'age', bidi('عمر / سن'), 'edad'),
    'jahre': ('Jahre', 'das Jahr', 'die', 'noun', 'years', bidi('سنوات'), 'años'),
    'wohnort': ('Wohnort', 'der Wohnort', 'der', 'noun', 'place of residence', bidi('مكان السكن'), 'lugar de residencia'),
    'straße': ('Straße', 'die Straße', 'die', 'noun', 'street', bidi('شارع'), 'calle'),
    'hausnummer': ('Hausnummer', 'die Hausnummer', 'die', 'noun', 'house number', bidi('رقم المنزل'), 'número de casa'),
    'postleitzahl': ('Postleitzahl', 'die Postleitzahl', 'die', 'noun', 'postal code', bidi('الرمز البريدي'), 'código postal'),
    'telefonnummer': ('Telefonnummer', 'die Telefonnummer', 'die', 'noun', 'phone number', bidi('رقم الهاتف'), 'número de teléfono'),
    'mail': ('Mail', 'die Mail', 'die', 'noun', 'mail', bidi('بريد'), 'correo'),
    'adresse': ('Adresse', 'die Adresse', 'die', 'noun', 'address', bidi('عنوان'), 'dirección'),
    'e-mail-adresse': ('E-Mail-Adresse', 'die E-Mail-Adresse', 'die', 'noun', 'email address', bidi('عنوان البريد الإلكتروني'), 'dirección de correo electrónico'),
    'student': ('Student', 'der Student', 'der', 'noun', 'student (male)', bidi('طالب جامعي'), 'estudiante'),
    'universität': ('Universität', 'die Universität', 'die', 'noun', 'university', bidi('جامعة'), 'universidad'),
    'arzt': ('Arzt', 'der Arzt', 'der', 'noun', 'doctor / physician', bidi('طبيب'), 'médico'),
    'krankenhaus': ('Krankenhaus', 'das Krankenhaus', 'das', 'noun', 'hospital', bidi('مستشفى'), 'hospital'),
    'formular': ('Formular', 'das Formular', 'das', 'noun', 'form', bidi('استمارة رسمية'), 'formulario'),
    'anmeldeformular': ('Anmeldeformular', 'das Anmeldeformular', 'das', 'noun', 'registration form', bidi('استمارة تسجيل'), 'formulario de inscripción'),
    'geburtsort': ('Geburtsort', 'der Geburtsort', 'der', 'noun', 'place of birth', bidi('مكان الولادة'), 'lugar de nacimiento'),
    'geburtsdatum': ('Geburtsdatum', 'das Geburtsdatum', 'das', 'noun', 'date of birth', bidi('تاريخ الولادة'), 'fecha de nacimiento'),
    'unterschrift': ('Unterschrift', 'die Unterschrift', 'die', 'noun', 'signature', bidi('توقيع'), 'firma'),
    'mutter': ('Mutter', 'die Mutter', 'die', 'noun', 'mother', bidi('أم'), 'madre'),
    'vater': ('Vater', 'der Vater', 'der', 'noun', 'father', bidi('أب'), 'padre'),
    'bruder': ('Bruder', 'der Bruder', 'der', 'noun', 'brother', bidi('أخ'), 'hermano'),
    'schwester': ('Schwester', 'die Schwester', 'die', 'noun', 'sister', bidi('أخت'), 'hermana'),
    'park': ('Park', 'der Park', 'der', 'noun', 'park', bidi('حديقة عامة'), 'parque'),

    # Adjectives
    'modern': ('modern', 'modern', '', 'adj', 'modern', bidi('حديث / عصري'), 'moderno'),
    'neu': ('neu', 'neu', '', 'adj', 'new', bidi('جديد'), 'nuevo'),
    'rot': ('rot', 'rot', '', 'adj', 'red', bidi('أحمر'), 'rojo'),
    'rote': ('rote', 'rot', '', 'adj', 'red (inflected)', bidi('حمراء'), 'rojas / rojos'),
    'rund': ('rund', 'rund', '', 'adj', 'round', bidi('مستدير'), 'redondo'),
    'groß': ('groß', 'groß', '', 'adj', 'big / large', bidi('كبير / ضخم'), 'grande'),
    'schnell': ('schnell', 'schnell', '', 'adj', 'fast / quickly', bidi('سريع / بسرعة'), 'rápido'),
    'schön': ('schön', 'schön', '', 'adj', 'beautiful / nice', bidi('جميل'), 'hermoso / bonito'),
    'ruhig': ('ruhig', 'ruhig', '', 'adj', 'quiet / peaceful', bidi('هادئ'), 'tranquilo'),
    'heiß': ('heiß', 'heiß', '', 'adj', 'hot', bidi('ساخن'), 'caliente'),
    'hell': ('hell', 'hell', '', 'adj', 'bright', bidi('ساطع / مضيء'), 'brillante'),
    'gut': ('gut', 'gut', '', 'adj', 'good / well', bidi('جيد / لذيذ / بخير'), 'bueno / bien'),
    'gute': ('Gute', 'gut', '', 'adj', 'good (feminine)', bidi('طيبة (ليلة طيبة)'), 'buena (buenas noches)'),
    'guten': ('Guten', 'gut', '', 'adj', 'good (accusative)', bidi('سعيد / طيب'), 'buenos / buen'),
    'frisch': ('frisch', 'frisch', '', 'adj', 'fresh', bidi('عذب / طازج'), 'fresco'),
    'warm': ('warm', 'warm', '', 'adj', 'warm', bidi('دافئ'), 'cálido / tibio'),
    'kalt': ('kalt', 'kalt', '', 'adj', 'cold', bidi('بارد'), 'frío'),
    'fit': ('fit', 'fit', '', 'adj', 'fit', bidi('رشيق'), 'en forma'),
    'weiß': ('weiß', 'weiß', '', 'adj', 'white', bidi('أبيض'), 'blanco'),
    'blau': ('blau', 'blau', '', 'adj', 'blue', bidi('أزرق'), 'azul'),
    'grün': ('grün', 'grün', '', 'adj', 'green', bidi('أخضر'), 'verde'),
    'gelb': ('gelb', 'gelb', '', 'adj', 'yellow', bidi('أصفر'), 'amarillo'),
    'schwarz': ('schwarz', 'schwarz', '', 'adj', 'black', bidi('أسود'), 'negro'),
    'grau': ('grau', 'grau', '', 'adj', 'gray', bidi('رمادي'), 'gris'),
    'braun': ('braun', 'braun', '', 'adj', 'brown', bidi('بني'), 'marrón'),
    'geöffnet': ('geöffnet', 'öffnen', '', 'adj', 'open', bidi('مفتوح'), 'abierto'),
    'ledig': ('ledig', 'ledig', '', 'adj', 'single', bidi('أعزب / عزباء'), 'soltero/a'),
    'verheiratet': ('verheiratet', 'verheiratet', '', 'adj', 'married', bidi('متزوج / متزوجة'), 'casado/a'),

    # Numbers
    'null': ('null', 'null', '', 'num', 'zero (0)', bidi('صفر (0)'), 'cero'),
    'eins': ('eins', 'eins', '', 'num', 'one (1)', bidi('واحد (1)'), 'uno'),
    'zwei': ('zwei', 'zwei', '', 'num', 'two (2)', bidi('اثنان (2)'), 'dos'),
    'drei': ('drei', 'drei', '', 'num', 'three (3)', bidi('ثلاثة (3)'), 'tres'),
    'vier': ('vier', 'vier', '', 'num', 'four (4)', bidi('أربعة (4)'), 'cuatro'),
    'fünf': ('fünf', 'fünf', '', 'num', 'five (5)', bidi('خمسة (5)'), 'cinco'),
    'sechs': ('sechs', 'sechs', '', 'num', 'six (6)', bidi('ستة (6)'), 'seis'),
    'sieben': ('sieben', 'sieben', '', 'num', 'seven (7)', bidi('سبعة (7)'), 'siete'),
    'acht': ('acht', 'acht', '', 'num', 'eight (8)', bidi('ثمانية (8)'), 'ocho'),
    'neun': ('neun', 'neun', '', 'num', 'nine (9)', bidi('تسعة (9)'), 'nueve'),
    'zehn': ('zehn', 'zehn', '', 'num', 'ten (10)', bidi('عشرة (10)'), 'diez'),
    'elf': ('elf', 'elf', '', 'num', 'eleven (11)', bidi('أحد عشر (11)'), 'once'),
    'zwölf': ('zwölf', 'zwölf', '', 'num', 'twelve (12)', bidi('اثنا عشر (12)'), 'doce'),
    'dreizehn': ('dreizehn', 'dreizehn', '', 'num', 'thirteen (13)', bidi('ثلاثة عشر (13)'), 'trece'),
    'vierzehn': ('vierzehn', 'vierzehn', '', 'num', 'fourteen (14)', bidi('أربعة عشر (14)'), 'catorce'),
    'fünfzehn': ('fünfzehn', 'fünfzehn', '', 'num', 'fifteen (15)', bidi('خمسة عشر (15)'), 'quince'),
    'sechzehn': ('sechzehn', 'sechzehn', '', 'num', 'sixteen (16)', bidi('ستة عشر (16)'), 'dieciséis'),
    'siebzehn': ('siebzehn', 'siebzehn', '', 'num', 'seventeen (17)', bidi('سبعة عشر (17)'), 'diecisiete'),
    'zwanzig': ('zwanzig', 'zwanzig', '', 'num', 'twenty (20)', bidi('عشرون (20)'), 'veinte'),
    'dreißig': ('dreißig', 'dreißig', '', 'num', 'thirty (30)', bidi('ثلاثون (30)'), 'treinta'),
    'vierzig': ('vierzig', 'vierzig', '', 'num', 'forty (40)', bidi('أربعون (40)'), 'cuarenta'),
    'fünfzig': ('fünfzig', 'fünfzig', '', 'num', 'fifty (50)', bidi('خمسون (50)'), 'cincuenta'),
    'sechzig': ('sechzig', 'sechzig', '', 'num', 'sixty (60)', bidi('ستون (60)'), 'sesenta'),
    'siebzig': ('siebzig', 'siebzig', '', 'num', 'seventy (70)', bidi('سبعون (70)'), 'setenta'),
    'achtzig': ('achtzig', 'achtzig', '', 'num', 'eighty (80)', bidi('ثمانون (80)'), 'ochenta'),
    'neunzig': ('neunzig', 'neunzig', '', 'num', 'ninety (90)', bidi('تسعون (90)'), 'noventa'),
    'hundert': ('hundert', 'hundert', '', 'num', 'one hundred (100)', bidi('مئة (100)'), 'cien'),

    # Weekdays
    'montag': ('Montag', 'Montag', 'der', 'noun', 'Monday', bidi('الإثنين'), 'lunes'),
    'dienstag': ('Dienstag', 'Dienstag', 'der', 'noun', 'Tuesday', bidi('الثلاثاء'), 'martes'),
    'mittwoch': ('Mittwoch', 'Mittwoch', 'der', 'noun', 'Wednesday', bidi('الأربعاء'), 'miércoles'),
    'donnerstag': ('Donnerstag', 'Donnerstag', 'der', 'noun', 'Thursday', bidi('الخميس'), 'jueves'),
    'freitag': ('Freitag', 'Freitag', 'der', 'noun', 'Friday', bidi('الجمعة'), 'viernes'),
    'samstag': ('Samstag', 'Samstag', 'der', 'noun', 'Saturday', bidi('السبت'), 'sábado'),
    'sonntag': ('Sonntag', 'Sonntag', 'der', 'noun', 'Sunday', bidi('الأحد'), 'domingo'),

    # Spelling / letter tokens
    'h': ('H', 'H', '', 'noun', 'Letter H', bidi('حرف H'), 'letra H'),
    'o': ('O', 'O', '', 'noun', 'Letter O', bidi('حرف O'), 'letra O'),
    't': ('T', 'T', '', 'noun', 'Letter T', bidi('حرف T'), 'letra T'),
    'l': ('L', 'L', '', 'noun', 'Letter L', bidi('حرف L'), 'letra L'),
    'h-o-t-e-l': ('H-O-T-E-L', 'Hotel', '', 'noun', 'spelling of Hotel', bidi('تهجئة كلمة فندق'), 'deletreo de Hotel'),
}

def clean_token(token: str) -> str:
    c = re.sub(r'^[.,!?:;\-\–\—\(\)\"\'`]+|[.,!?:;\-\–\—\(\)\"\'`]+$', '', token).strip()
    return c

def lookup_token(raw: str):
    c = clean_token(raw)
    if not c or c in ['—', '-', '–']:
        return None
    lower = c.lower()
    if lower == 'morgen':
        if raw.startswith('M'):
            return CANONICAL_DICT.get('morgen_noun')
        return CANONICAL_DICT.get('morgen')
    if lower in CANONICAL_DICT:
        return CANONICAL_DICT[lower]
    # Check numbers or date
    if re.match(r'^\d+(\.\d+)*$', c):
        if '.' in c:
            return (c, c, '', 'num', f'Date {c}', bidi(f'تاريخ {c}'), f'Fecha {c}')
        return (c, c, '', 'num', f'Number {c}', bidi(f'الرقم {c}'), f'Número {c}')
    return None

def build_card_word_glossary(sentence_de: str):
    glossary = {}
    tokens = sentence_de.split()
    for tok in tokens:
        c = clean_token(tok)
        if not c or c in ['—', '-', '–']:
            continue
        entry = lookup_token(c)
        if entry:
            de, lemma, gender, pos, en, ar, es = entry
            glossary[c] = {
                'de': de,
                'lemma': lemma if lemma != de else '',
                'gender': gender,
                'pos': pos,
                'en': en,
                'ar': ar,
                'es': es
            }
        else:
            print(f"Warning: unmapped token '{c}' in sentence: '{sentence_de}'")
    return glossary

def generate_dart_service():
    """Generates lib/src/features/study/domain/word_lookup_service.dart."""
    dart_code = """// ignore_for_file: text_direction_code_point_in_literal, text_direction_code_point_in_comment
import '../data/content_repository.dart';
import 'curriculum_models.dart';
import 'feedback_translations_data.dart';

/// Structured word translation result returned when learner taps a word in an example sentence.
class WordTranslationResult {
  const WordTranslationResult({
    required this.german,
    this.lemma,
    this.gender,
    this.pos,
    required this.en,
    required this.ar,
    required this.es,
  });

  final String german;
  final String? lemma;
  final String? gender;
  final String? pos;
  final String en;
  final String ar;
  final String es;

  String localized(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return ar.contains('\u2066') ? ar : '\u2066$ar\u2069';
      case 'es':
        return es.isNotEmpty ? es : en;
      default:
        return en;
    }
  }

  String get isolatedAr => ar.contains('\u2066') ? ar : '\u2066$ar\u2069';
}

/// Dynamic word lookup engine that provides instantaneous, isolated word-by-word
/// translations across English, Arabic (with BiDi isolates), and Spanish.
class WordLookupService {
  WordLookupService._();

  /// Looks up a word using:
  /// 1. Card-level custom `word_translations` map (if provided in card data_json)
  /// 2. Canonical Intro dictionary (`kCanonicalWordDictionary`)
  /// 3. ContentRepository curriculum words (`_words` list)
  /// 4. Global feedback translations (`kGermanTranslations`)
  static WordTranslationResult? lookup(
    String rawToken, {
    required String languageCode,
    CurriculumLearnCard? card,
    ContentRepository? repo,
  }) {
    final clean = cleanToken(rawToken);
    if (clean.isEmpty || clean == '—' || clean == '-') return null;

    // 1. Check card-level explicit word_translations
    if (card != null) {
      final cardGlossary = card.dataJson['word_translations'];
      if (cardGlossary is Map && cardGlossary[clean] is Map) {
        final m = Map<String, dynamic>.from(cardGlossary[clean] as Map);
        return WordTranslationResult(
          german: m['de'] as String? ?? clean,
          lemma: (m['lemma'] as String?)?.isNotEmpty == true ? m['lemma'] as String : null,
          gender: (m['gender'] as String?)?.isNotEmpty == true ? m['gender'] as String : null,
          pos: (m['pos'] as String?)?.isNotEmpty == true ? m['pos'] as String : null,
          en: m['en'] as String? ?? clean,
          ar: m['ar'] as String? ?? clean,
          es: m['es'] as String? ?? clean,
        );
      }
    }

    // 2. Check canonical dictionary
    final lower = clean.toLowerCase();
    // Special handling for Morgen (noun) vs morgen (adverb)
    if (lower == 'morgen') {
      if (rawToken.trim().startsWith('M')) {
        return kCanonicalWordDictionary['morgen_noun'];
      }
      return kCanonicalWordDictionary['morgen'];
    }

    final canonical = kCanonicalWordDictionary[lower];
    if (canonical != null) {
      return canonical;
    }

    // Numbers & dates fallback
    if (RegExp(r'^[0-9]+(\\.[0-9]+)*$').hasMatch(clean)) {
      final isDate = clean.contains('.');
      return WordTranslationResult(
        german: clean,
        pos: 'num',
        en: isDate ? 'Date $clean' : 'Number $clean',
        ar: isDate ? 'تاريخ $clean' : 'الرقم $clean',
        es: isDate ? 'Fecha $clean' : 'Número $clean',
      );
    }

    // 3. Check ContentRepository curriculum words
    if (repo != null) {
      final match = repo.findWordByLemma(clean);
      if (match != null) {
        return WordTranslationResult(
          german: match.lemma,
          gender: match.gender,
          pos: match.pos,
          en: match.translationEn,
          ar: match.translationAr,
          es: match.translationEs ?? match.translationEn,
        );
      }
    }

    // 4. Check global kGermanTranslations
    final kEntry = kGermanTranslations[lower];
    if (kEntry != null) {
      return WordTranslationResult(
        german: kEntry.de,
        en: kEntry.en,
        ar: kEntry.ar,
        es: kEntry.es,
      );
    }

    return null;
  }

  /// Cleans punctuation around word tokens while keeping internal hyphens/accents.
  static String cleanToken(String raw) {
    var s = raw.trim();
    while (s.isNotEmpty && _isPunctuation(s.codeUnitAt(0))) {
      s = s.substring(1);
    }
    while (s.isNotEmpty && _isPunctuation(s.codeUnitAt(s.length - 1))) {
      s = s.substring(0, s.length - 1);
    }
    return s.trim();
  }

  static bool _isPunctuation(int cu) {
    return cu == 46 || cu == 44 || cu == 33 || cu == 63 || cu == 58 || cu == 59 ||
           cu == 45 || cu == 40 || cu == 41 || cu == 91 || cu == 93 ||
           cu == 34 || cu == 39 || cu == 96 || cu == 8211 || cu == 8212 ||
           cu == 171 || cu == 187 || cu == 8222 || cu == 8220;
  }
}

/// Canonical dictionary of Level Intro words mapped to trilingual translations.
const Map<String, WordTranslationResult> kCanonicalWordDictionary = {
"""
    for key, (de, lemma, gender, pos, en, ar, es) in sorted(CANONICAL_DICT.items()):
        key_esc = key.replace("'", "\\'")
        de_esc = de.replace("'", "\\'")
        lemma_esc = lemma.replace("'", "\\'") if lemma else ""
        lemma_code = f"'{lemma_esc}'" if lemma and lemma != de else "null"
        gender_code = f"'{gender}'" if gender else "null"
        pos_code = f"'{pos}'" if pos else "null"
        # escape single quotes and strip invisible BiDi control chars for clean Dart analyzer
        en_esc = en.replace("'", "\\'")
        ar_esc = ar.replace('\u2066', '').replace('\u2069', '').replace("'", "\\'")
        es_esc = es.replace("'", "\\'")
        dart_code += f"  '{key_esc}': WordTranslationResult(german: '{de_esc}', lemma: {lemma_code}, gender: {gender_code}, pos: {pos_code}, en: '{en_esc}', ar: '{ar_esc}', es: '{es_esc}'),\n"

    dart_code += "};\n"
    return dart_code

def main():
    content_file = 'assets/deutschy_content.json'
    with open(content_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    cards = data.get('learn_cards', [])
    updated_count = 0
    missing_tokens = set()

    for c in cards:
        dj = c.get('data_json', {})
        ex_de = dj.get('example_sentence_de')
        if ex_de:
            glossary = build_card_word_glossary(ex_de)
            dj['word_translations'] = glossary
            updated_count += 1
            for tok in ex_de.split():
                cl = clean_token(tok)
                if cl and cl not in ['—', '-', '–'] and cl not in glossary:
                    missing_tokens.add(cl)

    print(f"Added word_translations glossary to {updated_count} cards.")
    if missing_tokens:
        print(f"Missing tokens ({len(missing_tokens)}): {missing_tokens}")
    else:
        print("SUCCESS: 100% of all tokens across all example sentences are mapped!")

    # Save to assets/deutschy_content.json
    with open(content_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    # Sync to build folders
    build_flutter = 'build/flutter_assets/assets/deutschy_content.json'
    build_web = 'build/web/assets/assets/deutschy_content.json'
    if os.path.exists(os.path.dirname(build_flutter)):
        with open(build_flutter, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"Synced to {build_flutter}")
    if os.path.exists(os.path.dirname(build_web)):
        with open(build_web, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"Synced to {build_web}")

    # Generate Dart service
    dart_service_path = 'lib/src/features/study/domain/word_lookup_service.dart'
    with open(dart_service_path, 'w', encoding='utf-8') as f:
        f.write(generate_dart_service())
    print(f"Generated {dart_service_path}")

if __name__ == '__main__':
    main()
