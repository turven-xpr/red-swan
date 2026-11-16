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
    'and': (ar: 'و', es: 'y'),
    'art': (ar: 'فن', es: 'arte'),
    'au (sounds like ow)': (ar: 'au (يُنطق أو)', es: 'au (se pronuncia como au)'),
    'bad.': (ar: 'سيء.', es: 'mal.'),
    'bank': (ar: 'بنك / مصرف', es: 'banco'),
    'beautiful': (ar: 'جميل', es: 'hermoso'),
    'big': (ar: 'كبير', es: 'grande'),
    'black': (ar: 'أسود', es: 'negro'),
    'blue': (ar: 'أزرق', es: 'azul'),
    'book': (ar: 'كتاب', es: 'libro'),
    'brown': (ar: 'بني', es: 'marrón'),
    'but': (ar: 'لكن', es: 'pero'),
    'bye (informal)': (ar: 'وداعاً (غير رسمي)', es: 'adiós (informal)'),
    'café': (ar: 'مقهى', es: 'cafetería'),
    'camera': (ar: 'كاميرا', es: 'cámara'),
    'cinema': (ar: 'سينما', es: 'cine'),
    'clock / watch': (ar: 'ساعة', es: 'reloj'),
    'cloud': (ar: 'سحابة', es: 'nube'),
    'coffee': (ar: 'قهوة', es: 'café'),
    'computer': (ar: 'حاسوب', es: 'computadora'),
    'dance': (ar: 'رقص', es: 'baile'),
    'do you speak english? (formal)': (ar: 'هل تتحدث الإنجليزية؟ (صيغة رسمية)', es: '¿habla inglés? (formal)'),
    'do you speak german?': (ar: 'هل تتحدث الألمانية؟', es: '¿hablas alemán?'),
    'do you understand?': (ar: 'هل تفهم؟', es: '¿entiendes?'),
    'ei (sounds like eye)': (ar: 'ei (يُنطق مثل آي)', es: 'ei (se pronuncia como ai)'),
    'eu (sounds like oy)': (ar: 'eu (يُنطق أوي)', es: 'eu (se pronuncia como oi)'),
    'excuse me / sorry': (ar: 'معذرة / آسف', es: 'disculpe / perdón'),
    'faster, please.': (ar: 'أسرع، من فضلك.', es: 'más rápido, por favor.'),
    'friday': (ar: 'الجمعة', es: 'viernes'),
    'from germany': (ar: 'من ألمانيا', es: 'de Alemania'),
    'from morocco': (ar: 'من المغرب', es: 'de Marruecos'),
    'good day': (ar: 'يوم سعيد', es: 'buen día'),
    'good day / hello': (ar: 'يوم سعيد / أهلاً', es: 'buen día / hola'),
    'good evening': (ar: 'مساء الخير', es: 'buenas tardes'),
    'good morning': (ar: 'صباح الخير', es: 'buenos días'),
    'good night': (ar: 'تصبح على خير', es: 'buenas noches'),
    'good, thanks.': (ar: 'بخير، شكراً.', es: 'bien, gracias.'),
    'goodbye': (ar: 'مع السلامة', es: 'adiós'),
    'goodbye (formal)': (ar: 'إلى اللقاء (صيغة رسمية)', es: 'adiós (formal)'),
    'great.': (ar: 'رائع.', es: 'genial.'),
    'green': (ar: 'أخضر', es: 'verde'),
    'grey': (ar: 'رمادي', es: 'gris'),
    'he is...': (ar: 'هو...', es: 'él es...'),
    'hello': (ar: 'مرحباً', es: 'hola'),
    'hospital': (ar: 'مستشفى', es: 'hospital'),
    'hotel': (ar: 'فندق', es: 'hotel'),
    'how are you?': (ar: 'كيف حالك؟', es: '¿cómo estás?'),
    'how old are you?': (ar: 'كم عمرك؟', es: '¿cuántos años tienes?'),
    'i am a student.': (ar: 'أنا طالب.', es: 'soy estudiante.'),
    'i am from morocco.': (ar: 'أنا من المغرب.', es: 'soy de Marruecos.'),
    'i am...': (ar: 'أنا...', es: 'yo soy...'),
    'i cannot hear.': (ar: 'لا أستطيع السماع.', es: 'no puedo oír.'),
    'i come from germany.': (ar: 'أنا آتي من ألمانيا.', es: 'vengo de Alemania.'),
    'i come from morocco.': (ar: 'أنا آتي من المغرب.', es: 'vengo de Marruecos.'),
    'i do not understand.': (ar: 'أنا لا أفهم.', es: 'no entiendo.'),
    'i don\'t know.': (ar: 'لا أعرف.', es: 'no lo sé.'),
    'i live in berlin.': (ar: 'أعيش في برلين.', es: 'vivo en Berlín.'),
    'i live in morocco.': (ar: 'أعيش في المغرب.', es: 'vivo en Marruecos.'),
    'i speak arabic.': (ar: 'أتحدث العربية.', es: 'hablo árabe.'),
    'i speak english.': (ar: 'أتحدث الإنجليزية.', es: 'hablo inglés.'),
    'i speak german.': (ar: 'أتحدث الألمانية.', es: 'hablo alemán.'),
    'i understand.': (ar: 'أنا أفهم.', es: 'entiendo.'),
    'ie (sounds like ee)': (ar: 'ie (يُنطق ياء ممدودة إي)', es: 'ie (se pronuncia como i larga)'),
    'in berlin': (ar: 'في برلين', es: 'en Berlín'),
    'juice': (ar: 'عصير', es: 'jugo'),
    'library': (ar: 'مكتبة', es: 'biblioteca'),
    'louder, please.': (ar: 'بصوت أعلى، من فضلك.', es: 'más alto, por favor.'),
    'maybe': (ar: 'ربما', es: 'quizás'),
    'mobile': (ar: 'هاتف محمول', es: 'móvil'),
    'monday': (ar: 'الإثنين', es: 'lunes'),
    'moon': (ar: 'قمر', es: 'luna'),
    'music': (ar: 'موسيقى', es: 'música'),
    'my name is karim.': (ar: 'اسمي كريم.', es: 'mi nombre es Karim.'),
    'no': (ar: 'لا', es: 'no'),
    'not so good.': (ar: 'لست بخير.', es: 'no muy bien.'),
    'once again, please.': (ar: 'مرة أخرى، من فضلك.', es: 'otra vez, por favor.'),
    'or': (ar: 'أو', es: 'o'),
    'orange': (ar: 'برتقالي', es: 'naranja'),
    'pen': (ar: 'قلم', es: 'bolígrafo'),
    'phone': (ar: 'هاتف', es: 'teléfono'),
    'pink': (ar: 'وردي', es: 'rosa'),
    'please': (ar: 'من فضلك', es: 'por favor'),
    'please / you\'re welcome': (ar: 'من فضلك / عفواً', es: 'por favor / de nada'),
    'post office': (ar: 'مكتب بريد', es: 'oficina de correos'),
    'pronounced [b]': (ar: 'يُنطق [b] مثل حرف الباء', es: 'se pronuncia [b]'),
    'pronounced [f]': (ar: 'يُنطق [f] مثل حرف الفاء', es: 'se pronuncia [f]'),
    'pronounced [f] in \'vier\'': (ar: 'يُنطق [f] مثل الفاء في كلمة \'vier\'', es: 'se pronuncia [f] como en \'vier\''),
    'pronounced [v] like \'wasser\'': (ar: 'يُنطق [v] مثل حرف V في \'Wasser\'', es: 'se pronuncia [v] como en \'Wasser\''),
    'pronounced [w]': (ar: 'يُنطق [w] مثل الواو', es: 'se pronuncia [w]'),
    'pronounced like \'ts\' in cats': (ar: 'يُنطق \'ts\' مثل التاء والسين معاً', es: 'se pronuncia \'ts\' como en \'cats\''),
    'pronounced like english \'f\'': (ar: 'يُنطق مثل حرف الفاء [f]', es: 'se pronuncia como la \'f\''),
    'pronounced like english \'j\'': (ar: 'يُنطق مثل حرف الياء [j]', es: 'se pronuncia como la \'y\''),
    'pronounced like english \'s\'': (ar: 'يُنطق مثل حرف السين [s]', es: 'se pronuncia como la \'s\''),
    'pronounced like english \'v\'': (ar: 'يُنطق مثل حرف الفاء [f]', es: 'se pronuncia como la \'f\''),
    'pronounced like english \'w\'': (ar: 'يُنطق مثل حرف [v]', es: 'se pronuncia como la \'v\''),
    'pronounced like english \'z\'': (ar: 'يُنطق مثل \'ts\' (تاء وسين)', es: 'se pronuncia como \'ts\''),
    'purple': (ar: 'بنفسجي', es: 'púrpura'),
    'red': (ar: 'أحمر', es: 'rojo'),
    'saturday': (ar: 'السبت', es: 'sábado'),
    'school': (ar: 'مدرسة', es: 'escuela'),
    'sea': (ar: 'بحر', es: 'mar'),
    'see you soon': (ar: 'أراك قريباً', es: 'hasta pronto'),
    'sharp double-s sound (ss)': (ar: 'صوت سين مشددة حادة (ss)', es: 'sonido fuerte de doble s (ss)'),
    'silent': (ar: 'صامت', es: 'silencioso'),
    'sky': (ar: 'سماء', es: 'cielo'),
    'slower, please.': (ar: 'أبطأ، من فضلك.', es: 'más despacio, por favor.'),
    'small': (ar: 'صغير', es: 'pequeño'),
    'so': (ar: 'لذلك', es: 'así que'),
    'sorry': (ar: 'آسف / معذرة', es: 'lo siento / perdón'),
    'sounds like english \'ay\'': (ar: 'يُنطق إي ممدودة', es: 'se pronuncia como ey'),
    'sounds like english \'ee\'': (ar: 'يُنطق ياء ممدودة', es: 'se pronuncia como i larga'),
    'sounds like english \'eye\'': (ar: 'يُنطق آي', es: 'se pronuncia como ai'),
    'sounds like english \'oo\'': (ar: 'يُنطق واو ممدودة', es: 'se pronuncia como u larga'),
    'sounds like english \'ow\'': (ar: 'يُنطق أو', es: 'se pronuncia como au'),
    'sounds like english \'oy\' in boy': (ar: 'يُنطق أوي', es: 'se pronuncia como oi'),
    'sounds like long english \'ee\'': (ar: 'يُنطق ياء ممدودة طويلة', es: 'se pronuncia como i larga'),
    'source / spring': (ar: 'ينبوع', es: 'manantial'),
    'sport': (ar: 'رياضة', es: 'deporte'),
    'star': (ar: 'نجم', es: 'estrella'),
    'station': (ar: 'محطة', es: 'estación'),
    'stop, please.': (ar: 'توقف، من فضلك.', es: 'alto, por favor.'),
    'sun': (ar: 'شمس', es: 'sol'),
    'sunday': (ar: 'الأحد', es: 'domingo'),
    'supermarket': (ar: 'سوبرماركت', es: 'supermercado'),
    'table': (ar: 'طاولة', es: 'mesa'),
    'tea': (ar: 'شاي', es: 'té'),
    'television': (ar: 'تلفاز', es: 'televisión'),
    'thank you': (ar: 'شكراً لك', es: 'gracias'),
    'thank you.': (ar: 'شكراً لك.', es: 'gracias.'),
    'thanks': (ar: 'شكراً', es: 'gracias'),
    'theater': (ar: 'مسرح', es: 'teatro'),
    'theatre': (ar: 'مسرح', es: 'teatro'),
    'there is no difference': (ar: 'لا يوجد فرق', es: 'no hay diferencia'),
    'this is a baby.': (ar: 'هذا رضيع.', es: 'este es un bebé.'),
    'this is a boy.': (ar: 'هذا ولد.', es: 'este es un niño.'),
    'this is a child.': (ar: 'هذا طفل.', es: 'este es un niño.'),
    'this is a girl.': (ar: 'هذه فتاة.', es: 'esta es una niña.'),
    'this is a man.': (ar: 'هذا رجل.', es: 'este es un hombre.'),
    'this is a mother.': (ar: 'هذه أم.', es: 'esta es una madre.'),
    'this is a teacher.': (ar: 'هذا معلم.', es: 'este es un profesor.'),
    'this is a woman.': (ar: 'هذه امرأة.', es: 'esta es una mujer.'),
    'thursday': (ar: 'الخميس', es: 'jueves'),
    'to germany': (ar: 'إلى ألمانيا', es: 'a Alemania'),
    'tree': (ar: 'شجرة', es: 'árbol'),
    'tuesday': (ar: 'الثلاثاء', es: 'martes'),
    'ugly': (ar: 'قبيح', es: 'feo'),
    'use \'du\' for everyone': (ar: 'استخدم "du" مع الجميع', es: 'usa "du" para todos'),
    'use \'sie\' for strangers and officials': (ar: 'استخدم "Sie" مع الغرباء والمسؤولين', es: 'usa "Sie" con desconocidos y cargos formales'),
    'use \'sie\' only for family': (ar: 'استخدم "Sie" مع العائلة فقط', es: 'usa "Sie" solo para la familia'),
    'very good.': (ar: 'جيد جداً.', es: 'muy bien.'),
    'water': (ar: 'ماء', es: 'agua'),
    'we are...': (ar: 'نحن...', es: 'nosotros somos...'),
    'wednesday': (ar: 'الأربعاء', es: 'miércoles'),
    'welcome': (ar: 'أهلاً وسهلاً', es: 'bienvenido'),
    'what do you do?': (ar: 'ماذا تعمل؟', es: '¿a qué te dedicas?'),
    'what is your name?': (ar: 'ما اسمك؟', es: '¿cómo te llamas?'),
    'where are you from?': (ar: 'من أين أنت؟', es: '¿de dónde eres?'),
    'where are you going?': (ar: 'إلى أين تذهب؟', es: '¿adónde vas?'),
    'where do you come from?': (ar: 'من أين تأتي؟', es: '¿de dónde vienes?'),
    'where do you live?': (ar: 'أين تسكن؟', es: '¿dónde vives?'),
    'white': (ar: 'أبيض', es: 'blanco'),
    'who are you?': (ar: 'من أنت؟', es: '¿quién eres?'),
    'yellow': (ar: 'أصفر', es: 'amarillo'),
    'yes': (ar: 'نعم', es: 'sí'),
    'yes, please.': (ar: 'نعم، من فضلك.', es: 'sí, por favor.'),
    'you are...': (ar: 'أنت...', es: 'tú eres...'),
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
