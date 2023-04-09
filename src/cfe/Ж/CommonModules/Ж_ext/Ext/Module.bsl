﻿Функция Запиши(Событие, МалоеОписание, БольшоеОписание = "", Уровень = Неопределено) Экспорт
    Если
        НЕ ЗначениеЗаполнено(Уровень)
    Тогда
        Уровень             =   EventLogLevel.Information;
    КонецЕсли;
    ДТ                      =   Формат(ТекущаяДатаСеанса(), "ДЛФ = ДВ");
    МалоеОписание           =   ДТ + " " + МалоеОписание;
    ЗаписьЖурналаРегистрации(Событие, Уровень, , МалоеОписание, БольшоеОписание);
    Если
        Уровень = EventLogLevel.Error
    Тогда
        Сообщить(БольшоеОписание);
    Иначе
        Сообщить(МалоеОписание);
    КонецЕсли;
    Возврат МалоеОписание;
КонецФункции

Функция ЗапишиОшибку(ИнформацияОбОшибке, Событие = "Ошибка", МалоеОписание = "", БольшоеОписание = "", Уровень = "") Экспорт
    СимВКПС                 =   Символы.ВК + Символы.ПС;
    Если
        Не ЗначениеЗаполнено(Уровень)
    Тогда
        Уровень             =   EventLogLevel.Error;
    КонецЕсли;
    Если
        ЗначениеЗаполнено(МалоеОписание)
    Тогда
        МалоеОписание       =   ИнформацияОбОшибке.Описание + " " + МалоеОписание;
    Иначе
        МалоеОписание       =   ИнформацияОбОшибке.Описание;
    КонецЕсли;
    ЕстьПричина             =   ЕстьСвойство        (ИнформацияОбОшибке, "Причина")
                            И   Не ИнформацияОбОшибке.Причина = Неопределено
                            И   ЕстьСвойство        (ИнформацияОбОшибке.Причина, "Описание")
                            И   ЗначениеЗаполнено   (ИнформацияОбОшибке.Причина.Описание);
    код                     =   Ж_ext.СвернутьВ1Пробел(ИнформацияОбОшибке.ИсходнаяСтрока);
    Причина                 =   ?(ЕстьПричина,  ИнформацияОбОшибке.Причина.Описание, "");
    НомСтр                  =   Строка(ИнформацияОбОшибке.НомерСтроки);
    ErrTxt                  =   БольшоеОписание      + " "
                            +   "Описание        = " + ИнформацияОбОшибке.Описание  + СимВКПС
                            +   "Номер строки    = " + НомСтр                       + СимВКПС
                            +   "Причина         = " + Причина                      + СимВКПС
                            +   "Имя модуля      = " + ИнформацияОбОшибке.ИмяМодуля + СимВКПС
                            +   "Исходная строка = " + код                          + СимВКПС;
    Если
        ЗначениеЗаполнено(БольшоеОписание)
    Тогда
        БольшоеОписание     =   ErrTxt + СимВКПС + БольшоеОписание;
    Иначе
        БольшоеОписание     =   ErrTxt;
    КонецЕсли;
    Возврат Запиши(Событие, МалоеОписание, БольшоеОписание, Уровень);
КонецФункции

Функция ПричесатьДату(ЭтаДата, Язык = "") Экспорт
    Если
        ТипЗнч(ЭтаДата) = Тип("Строка")
    Тогда
        ЭтаДата             =   Дата(ЭтаДата);
    КонецЕсли;
    Если
        ЗначениеЗаполнено(Язык)
    Тогда
        DDate                   =   Формат(ЭтаДата, "ДЛФ = ДД; Л = " + Язык);
        DDate                   =   СокрЛП(DDate);
    Иначе
        DDate                   =   Формат(ЭтаДата, "ДЛФ = ДД");
        DDate                   =   СокрЛП(DDate);
        DDate                   =   ?(День(ЭтаДата) < 10, "0" + DDate, DDate);
    КонецЕсли;
    Возврат DDate;
КонецФункции

Функция ЕстьСвойство(пОбъект, пИмяРек, пТипЗначения = Неопределено) Экспорт
    КонтрольноеЗначение     =   Новый УникальныйИдентификатор;
    Попытка
        СтруктураРеквизита  =   Новый Структура(пИмяРек, КонтрольноеЗначение);
    Исключение
        Возврат Ложь;
    КонецПопытки;
    Если
        СтруктураРеквизита.Количество() > 1
    Тогда
        Возврат Ложь; // если передан список реквизитов, то создастся структура со списком ключей, что сигнатурой метода не предусмотрено
    КонецЕсли;
    ПроверятьТип            =   ТипЗНЧ(пТипЗначения) = Тип("Тип");
    Попытка
        ЗаполнитьЗначенияСвойств(СтруктураРеквизита, пОбъект);
    Исключение
        Возврат Ложь
    КонецПопытки;
    Результат               =   Ложь;
    Значение                =   СтруктураРеквизита[пИмяРек];
    Если
        Значение <> КонтрольноеЗначение
    Тогда
        Если
            ПроверятьТип
        Тогда
            Результат       =   пТипЗначения = ТипЗНЧ(Значение);
        Иначе
            Результат       =   Истина;
        КонецЕсли;
    КонецЕсли;
    Возврат Результат;
КонецФункции

Функция СвернутьВ1Пробел(ВхСтрока) Экспорт
    Рез                     =   "";
    Берём                   =   Ложь;
    LastSpace               =   Истина;
    ПредСимв                =   "";
    Игнор                   =   ".()";
    Для СтрЭлемН = 0
    По  СтрДлина(ВхСтрока)
    Цикл
        Сим                 =   Сред(ВхСтрока ,СтрЭлемН, 1);
        Если
            Сим = Символы.ВК
        Или Сим = Символы.ВТаб
        Или Сим = Символы.НПП
        Или Сим = Символы.ПС
        Или Сим = Символы.ПФ
        Или Сим = Символы.Таб
        Тогда
            Продолжить;
        КонецЕсли;
        Если
            Сим = " "
        Тогда
            Если
                LastSpace
            Тогда
                Продолжить;
            ИначеЕсли
                СтрНайти(Игнор, ПредСимв) > 0
            Тогда
                Берём       =   Ложь;
                LastSpace   =   Ложь;
                Продолжить;
            Иначе
                Берём       =   Истина;
                LastSpace   =   Истина;
            КонецЕсли;
        Иначе
            Берём           =   Истина;
            LastSpace       =   Ложь;
        КонецЕсли;
        Если
            Берём
        Тогда
            Рез             =   Рез + Сим;
            ПредСимв        =   Сим;
        КонецЕсли;
    КонецЦикла;
    Возврат Рез;
КонецФункции

Функция ПолучитьДопРеквизит(ЭтотОбъект, ИмяРеквизита, Текстом = Истина) Экспорт
    Попытка
        Для Каждого Реквизит
        Из          ЭтотОбъект.ДополнительныеРеквизиты
        Цикл
            Если
                Реквизит.Свойство.Заголовок = ИмяРеквизита
            Тогда
                Если
                    Ж_ext.ЕстьСвойство(Реквизит.Значение, "ПолноеНаименование")
                И   Текстом
                Тогда
                    Если
                        ЗначениеЗаполнено(Реквизит.Значение.ПолноеНаименование)
                    Тогда
                        Возврат Реквизит.Значение.ПолноеНаименование;
                    Иначе
                        Возврат Реквизит.Значение.Наименование;
                    КонецЕсли;
                Иначе
                    Возврат Реквизит.Значение;
                КонецЕсли
            КонецЕсли
        КонецЦикла;
    Исключение
        Инфа                =   ИнформацияОбОшибке();
        Ж_ext.ЗапишиОшибку(Инфа, "Ж_ext:СохранитьДопРеквизит");
    КонецПопытки;
    Возврат "";
КонецФункции

Процедура СохранитьДопРеквизит(МойОбъект, ИмяРеквизита, ЗначениеРеквизита) Экспорт
    Обработки.Ж_ДопРеквизиты.СохранитьДопРеквизит(МойОбъект, ИмяРеквизита, ЗначениеРеквизита);
КонецПроцедуры

Функция ПолучитьСвойствоРеквизита(МоёИмя, МойОбъект) Экспорт
    Возврат Обработки.Ж_ДопРеквизиты.ПолучитьСвойствоРеквизита(МоёИмя, МойОбъект);
КонецФункции

Функция ПолучитьСписокЗначенийДопРеквизита(ЗначениеОбъекта, НазваниеРеквизита) Экспорт
    Возврат Обработки.Ж_ДопРеквизиты.ПолучитьСписокЗначенийДопРеквизита(ЗначениеОбъекта, НазваниеРеквизита)
КонецФункции

Процедура Ожидание(Длительность) Экспорт
     Идентификатор          =   Новый УникальныйИдентификатор;
     НачатьТранзакцию();
     Блокировка             =   Новый БлокировкаДанных;
     Элемент                =   Блокировка.Добавить("РегистрСведений.Ж_Ожидание");
     Элемент.Режим          =   РежимБлокировкиДанных.Исключительный;
     Элемент.УстановитьЗначение("Идентификатор", Идентификатор);
     Блокировка.Заблокировать();
     мсвПараметров          =   Новый Массив;
     мсвПараметров.Добавить(Идентификатор);
     Задание                =   ФоновыеЗадания.Выполнить("Ж_ext.ВыполнитьПаузу",
                                                        мсвПараметров,
                                                        ,
                                                        "Выполнить паузу " + Длительность + " сек.");
     Попытка
          Задание.ОжидатьЗавершения(Длительность);
          Исключение
     КонецПопытки;
     ОтменитьТранзакцию();
 КонецПроцедуры

Процедура ВыполнитьПаузу(Идентификатор) Экспорт
     НачатьТранзакцию();
     Блокировка             =   Новый БлокировкаДанных;
     Элемент                =   Блокировка.Добавить("РегистрСведений.Ж_Ожидание");
     Элемент.Режим          =   РежимБлокировкиДанных.Исключительный;
     Элемент.УстановитьЗначение("Идентификатор", Идентификатор);
     Попытка
          Блокировка.Заблокировать();
     Исключение
     КонецПопытки;
     ОтменитьТранзакцию();
КонецПроцедуры

Функция ПочиститьАдрес(Адрес) Экспорт
    Пока
        СтрНайти(Адрес, "0,") > 0
    Или СтрНайти(Адрес, ",,") > 0
    Цикл
        Адрес               =   СтрЗаменить(Адрес, "0,", "");
        Адрес               =   СтрЗаменить(Адрес, ",,", ",");
    КонецЦикла;
    Адрес                   =   СокрЛП(Адрес);
    Если
        Прав(Адрес, 1) = ","
    Тогда
        Адрес               =   Лев(Адрес, СтрДлина(Адрес) - 1);
    КонецЕсли;
    Адрес                   =   СтрЗаменить(Адрес, ", ", ",");
    Адрес                   =   СтрЗаменить(Адрес, ",", ", ");
    Возврат Адрес;
КонецФункции

Функция РазницаДатВМесяцах(Дата1, Дата2) Экспорт
     ДатаНач                =   ?(Дата1 < Дата2, Дата1, Дата2);
     ДатаКон                =   ?(Дата1 < Дата2, Дата2, Дата1);
     Годы                   =   Год( датаКон ) - Год( датаНач );
     Месяцы                 =   Месяц( датаКон ) - Месяц( датаНач );
     Разность               =   месяцы + годы * 12;
     Возврат Разность;
 КонецФункции

Процедура СформироватьДерево(ЧтениеJSON, Дерево) Экспорт
    ИмяСвойства                                         =   Неопределено;
    Пока
        ЧтениеJSON.Прочитать()
    Цикл
        TипJSON                                         =   ЧтениеJSON.ТипТекущегоЗначения;
        Если
                        TипJSON = ТипЗначенияJSON.НачалоОбъекта
                    ИЛИ TипJSON = ТипЗначенияJSON.НачалоМассива
        Тогда
            НовыйОбъект                                 =   ?(TипJSON = ТипЗначенияJSON.НачалоОбъекта, Новый Соответствие, Новый Массив);
            Если
                 ТипЗнч(Дерево) = Тип("Массив")
            Тогда
                Дерево.Добавить(НовыйОбъект);
            ИначеЕсли
                 ТипЗнч(Дерево) = Тип("Соответствие")
            И   ЗначениеЗаполнено(ИмяСвойства)
            Тогда
                Дерево.Вставить(ИмяСвойства, НовыйОбъект);
            КонецЕсли;
            СформироватьДерево(ЧтениеJSON, НовыйОбъект);
            Если
                         Дерево = Неопределено
            Тогда
                Дерево                                  =   НовыйОбъект;
            КонецЕсли;
        ИначеЕсли
                        TипJSON = ТипЗначенияJSON.ИмяСвойства
        Тогда
            ИмяСвойства                                 =   ЧтениеJSON.ТекущееЗначение;
        ИначеЕсли
                        TипJSON = ТипЗначенияJSON.Число
                    ИЛИ TипJSON = ТипЗначенияJSON.Строка
                    ИЛИ TипJSON = ТипЗначенияJSON.Булево
                    ИЛИ TипJSON = ТипЗначенияJSON.Null
        Тогда
            Если
                 ТипЗнч(Дерево) = Тип("Массив")
            Тогда
                Дерево.Добавить(ЧтениеJSON.ТекущееЗначение);
            ИначеЕсли
                ТипЗнч(Дерево)                          =   Тип("Соответствие")
            Тогда
                Дерево.Вставить(ИмяСвойства, ЧтениеJSON.ТекущееЗначение);
            КонецЕсли;
        Иначе
            Возврат;
        КонецЕсли;
    КонецЦикла;
КонецПроцедуры
