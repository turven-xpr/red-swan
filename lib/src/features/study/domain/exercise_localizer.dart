/// Comprehensive localization utility for curriculum exercises, question prompts,
/// vocabulary options, sentence hints, and skill badges across English, Arabic, and Spanish.
class ExerciseLocalizer {
  const ExerciseLocalizer._();

  /// Maps English vocabulary translations to Arabic and Spanish
  static const Map<String, ({String ar, String es})> _vocabularyMap = {
    'mother': (ar: 'أمّ', es: 'madre'),
    'father': (ar: 'أب', es: 'padre'),
    'parents': (ar: 'والدان', es: 'padres'),
    'child': (ar: 'طفل', es: 'niño'),
    'son': (ar: 'ابن', es: 'hijo'),
    'daughter': (ar: 'ابنة', es: 'hija'),
    'brother': (ar: 'أخ', es: 'hermano'),
    'sister': (ar: 'أخت', es: 'hermana'),
    'grandmother': (ar: 'جدّة', es: 'abuela'),
    'grandfather': (ar: 'جدّ', es: 'abuelo'),
    'uncle': (ar: 'عمّ / خال', es: 'tío'),
    'aunt': (ar: 'عمّة / خالة', es: 'tía'),
    'male cousin': (ar: 'ابن عمّ / ابن خال', es: 'primo'),
    'female cousin': (ar: 'بنت عمّ / بنت خال', es: 'prima'),
    'grandson': (ar: 'حفيد', es: 'nieto'),
    'granddaughter': (ar: 'حفيدة', es: 'nieta'),
    'nephew': (ar: 'ابن الأخ / الأخت', es: 'sobrino'),
    'niece': (ar: 'بنت الأخ / الأخت', es: 'sobrina'),
    'husband': (ar: 'زوج', es: 'esposo'),
    'wife': (ar: 'زوجة', es: 'esposa'),
    'baby': (ar: 'رضيع', es: 'bebé'),
    'family': (ar: 'عائلة', es: 'familia'),
    'person / human': (ar: 'إنسان', es: 'persona'),
    'woman': (ar: 'امرأة', es: 'mujer'),
    'man': (ar: 'رجل', es: 'hombre'),
    'girl': (ar: 'فتاة', es: 'niña'),
    'boy': (ar: 'ولد', es: 'niño'),
    'friend (male)': (ar: 'صديق', es: 'amigo'),
    'friend (female)': (ar: 'صديقة', es: 'amiga'),
    'neighbor (male)': (ar: 'جار', es: 'vecino'),
    'neighbor (female)': (ar: 'جارة', es: 'vecina'),
    'wedding': (ar: 'حفل زفاف', es: 'boda'),
    'birthday': (ar: 'عيد ميلاد', es: 'cumpleaños'),
    'birth': (ar: 'ولادة', es: 'nacimiento'),
    'home': (ar: 'منزل / بيت', es: 'hogar'),
    'name': (ar: 'اسم', es: 'nombre'),
    'age': (ar: 'عمر', es: 'edad'),
    'to love': (ar: 'يُحِبّ', es: 'amar'),
    'to marry': (ar: 'يتزوّج', es: 'casarse'),
    'to know (a person)': (ar: 'يعرف', es: 'conocer'),
    'to visit': (ar: 'يزور', es: 'visitar'),
    'to help': (ar: 'يُساعِد', es: 'ayudar'),
    'to play': (ar: 'يلعب', es: 'jugar'),
    'to live / reside': (ar: 'يسكن', es: 'vivir / residir'),
    'to live / be alive': (ar: 'يعيش', es: 'vivir'),
    'to speak': (ar: 'يتكلّم', es: 'hablar'),
    'to invite': (ar: 'يدعو', es: 'invitar'),
    'to introduce': (ar: 'يُقدِّم', es: 'presentar'),
    'to take care of': (ar: 'يعتني بـ', es: 'cuidar de'),
    'to care / worry': (ar: 'يهتمّ بـ', es: 'preocuparse'),
    'to miss (someone)': (ar: 'يشتاق إلى', es: 'extrañar'),
    'to raise / bring up': (ar: 'يُربّي', es: 'educar / criar'),
    'to argue': (ar: 'يتشاجر', es: 'discutir'),
    'young': (ar: 'شابّ', es: 'joven'),
    'old': (ar: 'كبير في السنّ', es: 'mayor / viejo'),
    'married': (ar: 'متزوّج', es: 'casado'),
    'single / unmarried': (ar: 'أعزب', es: 'soltero'),
    'pregnant': (ar: 'حامل', es: 'embarazada'),
    'nice / kind': (ar: 'لطيف', es: 'amable'),
    'friendly': (ar: 'ودود', es: 'amigable'),
    'lieb': (ar: 'حبيب / عزيز', es: 'querido'),
    'dear / sweet': (ar: 'حبيب / عزيز', es: 'querido'),
    'adult / grown-up': (ar: 'بالِغ', es: 'adulto'),
    'related': (ar: 'قريب (عائلي)', es: 'pariente'),
    'together': (ar: 'معاً', es: 'juntos'),
    'alone': (ar: 'وحيداً', es: 'solo'),
  };

  /// Maps English sentence hints to Spanish
  static const Map<String, String> _spanishHints = {
    'My mother cooks very well.': 'Mi madre cocina muy bien.',
    'The mother is reading a book.': 'La madre está leyendo un libro.',
    'I love my mother.': 'Amo a mi madre.',
    'My father works in Berlin.': 'Mi padre trabaja en Berlín.',
    'The father plays with the child.': 'El padre juega con el niño.',
    'My brother is twelve years old.': 'Mi hermano tiene doce años.',
    'I have a brother.': 'Tengo un hermano.',
    'My sister lives in Munich.': 'Mi hermana vive en Múnich.',
    'The sister is very nice.': 'La hermana es muy agradable.',
    'The child plays in the garden.': 'El niño juega en el jardín.',
    'We have two children.': 'Tenemos dos hijos.',
    'The child is tired.': 'El niño está cansado.',
    'My parents come from Syria.': 'Mis padres vienen de Siria.',
    'The parents are proud.': 'Los padres están orgullosos.',
    'My son goes to school.': 'Mi hijo va a la escuela.',
    'The son helps his father.': 'El hijo ayuda a su padre.',
    'My daughter is learning German.': 'Mi hija está aprendiendo alemán.',
    'The daughter is five years old.': 'La hija tiene cinco años.',
    'My grandmother makes the best cake.': 'Mi abuela hace el mejor pastel.',
    'The grandmother tells a story.': 'La abuela cuenta una historia.',
    'My grandfather reads the newspaper.': 'Mi abuelo lee el periódico.',
    'The grandfather is eighty years old.': 'El abuelo tiene ochenta años.',
    'The baby is sleeping.': 'El bebé está durmiendo.',
    'The baby is crying.': 'El bebé está llorando.',
    'My uncle lives in Hamburg.': 'Mi tío vive en Hamburgo.',
    'The uncle comes to visit.': 'El tío viene de visita.',
    'My aunt has three children.': 'Mi tía tiene tres hijos.',
    'The aunt brings gifts.': 'La tía trae regalos.',
    'My cousin studies medicine.': 'Mi primo estudia medicina.',
    'The cousin comes from Morocco.': 'El primo viene de Marruecos.',
    'My cousin (f.) is a teacher.': 'Mi prima es profesora.',
    'The man drinks coffee.': 'El hombre bebe café.',
    'My husband works a lot.': 'Mi esposo trabaja mucho.',
    'The woman reads a book.': 'La mujer lee un libro.',
    'My wife speaks three languages.': 'Mi esposa habla tres idiomas.',
    'My friend is called Ali.': 'Mi amigo se llama Ali.',
    'I am meeting my friend.': 'Me encuentro con mi amigo.',
    'My friend (f.) is coming today.': 'Mi amiga viene hoy.',
    'My neighbor is very friendly.': 'Mi vecino es muy amable.',
    'The neighbor has a dog.': 'El vecino tiene un perro.',
    'My family is big.': 'Mi familia es grande.',
    'The family eats together.': 'La familia come junta.',
    'Family is important.': 'La familia es importante.',
    'I have three siblings.': 'Tengo tres hermanos.',
    'The siblings play together.': 'Los hermanos juegan juntos.',
    'Her husband is a doctor.': 'Su esposo es médico.',
    'His wife is an engineer.': 'Su esposa es ingeniera.',
    'The couple lives in Cologne.': 'La pareja vive en Colonia.',
    'Every person is different.': 'Cada persona es diferente.',
    'The human needs water.': 'El ser humano necesita agua.',
    'The people are nice here.': 'La gente es agradable aquí.',
    'Many people speak German.': 'Mucha gente habla alemán.',
    'The boy plays football.': 'El niño juega al fútbol.',
    'The girl laughs.': 'La niña se ríe.',
    'The girl likes to read.': 'A la niña le gusta leer.',
    'What is your name?': '¿Cómo se llama usted?',
    'My name is Deutschy.': 'Mi nombre es Deutschy.',
    'Today is my birthday.': 'Hoy es mi cumpleaños.',
    'Happy birthday!': '¡Feliz cumpleaños!',
    'The wedding is in June.': 'La boda es en junio.',
    'The gift is beautiful.': 'El regalo es hermoso.',
    'I bring a gift.': 'Traigo un regalo.',
    'We take a photo.': 'Tomamos una foto.',
    'We are getting visitors.': 'Vamos a recibir visitas.',
    'The conversation is interesting.': 'La conversación es interesante.',
    'Thank you for the invitation.': 'Gracias por la invitación.',
    'My relatives live in Egypt.': 'Mis parientes viven en Egipto.',
    'I love my family.': 'Amo a mi familia.',
    'She loves chocolate.': 'A ella le encanta el chocolate.',
    'We live in Germany.': 'Vivimos en Alemania.',
    'He lives alone.': 'Él vive solo.',
    'I live in Berlin.': 'Vivo en Berlín.',
    'Where do you live?': '¿Dónde vives?',
    'I speak German and Arabic.': 'Hablo alemán y árabe.',
    'Do you speak English?': '¿Hablas inglés?',
    'The children play outside.': 'Los niños juegan afuera.',
    'I visit my grandmother.': 'Visito a mi abuela.',
    'We visit friends.': 'Visitamos amigos.',
    'Can you help me?': '¿Puedes ayudarme?',
    'The daughter helps the mother.': 'La hija ayuda a la madre.',
    'I know this family.': 'Conozco a esta familia.',
    'We celebrate a birthday.': 'Celebramos un cumpleaños.',
    'I invite you.': 'Te invito.',
    'May I introduce myself?': '¿Puedo presentarme?',
    'He tells a story.': 'Él cuenta una historia.',
    'The children laugh loudly.': 'Los niños se ríen fuerte.',
    'The baby cries loudly.': 'El bebé llora fuerte.',
    'They are getting married in summer.': 'Se casan en verano.',
    'I miss my family.': 'Extraño a mi familia.',
    'My grandfather is old.': 'Mi abuelo es mayor.',
    'How old are you?': '¿Cuántos años tienes?',
    'The mother is still young.': 'La madre todavía es joven.',
    'My brother is very tall.': 'Mi hermano es muy alto.',
    'The child is still small.': 'El niño todavía es pequeño.',
    'The neighbor (f.) is very nice.': 'La vecina es muy agradable.',
    'The people are friendly.': 'La gente es amable.',
    'She is a dear child.': 'Ella es una niña encantadora.',
    'He is married.': 'Él está casado.',
    'She is single.': 'Ella está soltera.',
    'We eat together.': 'Comemos juntos.',
    'We live together.': 'Vivimos juntos.',
    'I like to play with the children.': 'Me gusta jugar con los niños.',
  };

  /// Localizes an option for display in multiple-choice exercises
  static String localizeOption(String option, String languageCode) {
    final cleanKey = option.trim().toLowerCase();
    final entry = _vocabularyMap[cleanKey];
    if (entry != null) {
      if (languageCode == 'ar') return entry.ar;
      if (languageCode == 'es') return entry.es;
    }
    return option;
  }

  /// Localizes question prompt titles across English, Arabic, and Spanish
  static String localizeQuestion(
    Map<String, dynamic> promptMap,
    String languageCode,
    String fallback,
  ) {
    if (languageCode == 'ar') {
      final qAr = promptMap['question_ar'] as String?;
      if (qAr != null && qAr.trim().isNotEmpty) return qAr.trim();
      return 'اختر الإجابة الصحيحة';
    }

    if (languageCode == 'es') {
      final qEs = promptMap['question_es'] as String?;
      if (qEs != null && qEs.trim().isNotEmpty) return qEs.trim();

      final qEn = (promptMap['question_en'] as String?)?.trim();
      if (qEn == 'What does this word mean?') return '¿Qué significa esta palabra?';
      if (qEn == 'Listen and choose the correct sentence.') return 'Escucha y elige la frase correcta.';
      if (qEn == 'Type the missing word.') return 'Escribe la palabra que falta.';
      if (qEn == 'Listen and repeat the sentence aloud.') return 'Escucha y repite la frase en voz alta.';
      return 'Elige la respuesta correcta';
    }

    // Default: English
    final qEn = promptMap['question_en'] as String?;
    if (qEn != null && qEn.trim().isNotEmpty) return qEn.trim();
    return fallback;
  }

  /// Localizes exercise hints (e.g. for fill-in-the-blank or speaking)
  static String? localizeHint(Map<String, dynamic> promptMap, String languageCode) {
    if (languageCode == 'ar') {
      final hintAr = promptMap['hint_ar'] as String?;
      if (hintAr != null && hintAr.trim().isNotEmpty) return hintAr.trim();
    }

    if (languageCode == 'es') {
      final hintEs = promptMap['hint_es'] as String?;
      if (hintEs != null && hintEs.trim().isNotEmpty) return hintEs.trim();

      final hintEn = promptMap['hint_en'] as String?;
      if (hintEn != null && _spanishHints.containsKey(hintEn.trim())) {
        return _spanishHints[hintEn.trim()];
      }
    }

    return promptMap['hint_en'] as String?;
  }

  /// Localizes an English sentence to Spanish if available, else returns the original
  static String localizeSentence(String englishSentence) {
    final clean = englishSentence.trim();
    if (_spanishHints.containsKey(clean)) {
      return _spanishHints[clean]!;
    }
    return englishSentence;
  }

  /// Localizes skill badges
  static String localizeSkill(String skill, String languageCode) {
    switch (skill) {
      case 'listening':
        if (languageCode == 'ar') return 'استماع';
        if (languageCode == 'es') return 'Escucha';
        return 'Listening';
      case 'reading':
        if (languageCode == 'ar') return 'قراءة';
        if (languageCode == 'es') return 'Lectura';
        return 'Reading';
      case 'writing':
        if (languageCode == 'ar') return 'كتابة';
        if (languageCode == 'es') return 'Escritura';
        return 'Writing';
      case 'speaking':
        if (languageCode == 'ar') return 'محادثة';
        if (languageCode == 'es') return 'Habla';
        return 'Speaking';
      default:
        if (languageCode == 'ar') return 'تمرين';
        if (languageCode == 'es') return 'Práctica';
        return 'Practice';
    }
  }
}
