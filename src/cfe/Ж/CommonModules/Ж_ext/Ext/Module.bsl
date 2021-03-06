Функция  Запиши                                 (   Событие     ,   Мало        ,   Много = ""      ,   Уровень =   Неопределено        )   Экспорт
Если                НЕ  ЗначениеЗаполнено       (                                                       Уровень )                   Тогда
        Уровень     =                                                                                   EventLogLevel.Information       ;
КонецЕсли                                                                                                                               ;
        ДТ          =   Формат                  (
                        ТекущаяДатаСеанса       (             ) ,  "ДЛФ = ДВ"   )                   +   " "                             ;
        Мало        =                               ДТ          +   Мало                                                                ;
                        ЗаписьЖурналаРегистрации(   Событие                                         ,   Уровень                         ,
                                                                                ,   Много                                               ,
                                                                    Мало                                                               );
Если                    Уровень = EventLogLevel.Error
Тогда                   Сообщить                (                                   Много                                              );
Иначе                   Сообщить                (                   Мало                                                               );
КонецЕсли;
Возврат                                                             Мало                                                    ;КонецФункции

Функция ЗапишиОшибку                            (   Err         ,   С = "Ошибка",   Мало = ""       ,   Много = ""  ,   Уровень =  ""   )   Экспорт
Если                НЕ  ЗначениеЗаполнено       (                                                       Уровень )                   Тогда
        Уровень     =                                                                                   EventLogLevel.Error             ;
КонецЕсли                                                                                                                               ;
Если                    ЗначениеЗаполнено       (                   Мало                                                                )
Тогда   Мало        =                               Err.Описание+   Мало
Иначе   Мало        =                               Err.Описание                                                                        ;
        СимВКПС     =                               Символы.ВК  +   Символы.ПС                                                          ;
КонецЕсли                                                                                                                               ;
        ЕстьПричина =   ЕстьСвойство            (   Err         ,   "Причина"   )
        И               Не                          Err.Причина =   Неопределено
        И               ЕстьСвойство            (   Err.Причина ,   "Описание"  )
        И               ЗначениеЗаполнено       (   Err.Причина.Описание       );
        код         =   Ж_ext.СвернутьВ1Пробел  (   Err.ИсходнаяСтрока         );
        Причина     =   ?                       (   ЕстьПричина ,   Err.Причина.Описание            ,   ""                             );
        НомСтр      =   Строка                  (   Err.НомерСтроки             );
        ErrTxt      =                                                               Много
                    +                               "Описание        = "        +   Err.Описание    +   СимВКПС
                    +                               "Номер строки    = "        +   НомСтр          +   СимВКПС
                    +                               "Причина         = "        +   Причина         +   СимВКПС
                    +                               "Имя модуля      = "        +   Err.ИмяМодуля   +   СимВКПС
                    +                               "Исходная строка = "        +   код             +   СимВКПС                         ;
Если                    ЗначениеЗаполнено       (                                   Много                                               )
Тогда   Много       =                               ErrTxt      +   СимВКПС     +   Много
Иначе   Много       =                               ErrTxt                                                                              ;
КонецЕсли                                                                                                                               ;
Возврат                 Запиши                  (   С           ,   Мало        ,   Много           ,   Уровень            );КонецФункции

Функция ПричесатьДату                           (   ЭтаДата     )                                                                           Экспорт
        DDate       =   Формат                  (   ЭтаДата     ,   "ДЛФ = ДД"  )                                                       ;
        DDate       =   СокрЛП                  (   DDate       )                                                                       ;
        DDate       =   ?(СтрДлина              (   DDate       ) = 1           ,   "0" + DDate         ,   DDate   )                   ;
Возврат                                                                                                                DDate;КонецФункции

Функция ЕстьСвойство                            (   Переменная                   ,               ИмяСвойства                            )   Экспорт
                СтруктураПроверка                                                =         Новый Структура                              ;
                СтруктураПроверка               .   Вставить                    (                ИмяСвойства  ,                    NULL);
                ЗаполнитьЗначенияСвойств        (СтруктураПроверка              ,                Переменная                            );
    Возврат     ?                               (СтруктураПроверка              [ИмяСвойства] =  NULL         , Ложь            , Истина)
КонецФункции

Функция СвернутьВ1Пробел                        (   ВхСтрока                                                                            )   Экспорт
    Рез                     =                               ""                                                       ;
    Берём                   =                               Ложь;
    LastSpace               =                               Истина;
    ПредСимв                =                               "";
    Игнор                   =                               ".()";
Для     СтрЭлемН            =                               0
По      СтрДлина(ВхСтрока)
Цикл
    Сим                     =   Сред(ВхСтрока ,СтрЭлемН, 1);
    Если                        Сим =   Символы.ВК
                            Или Сим =   Символы.ВТаб
                            Или Сим =   Символы.НПП
                            Или Сим =   Символы.ПС
                            Или Сим =   Символы.ПФ
                            Или Сим =   Символы.Таб
    Тогда
        Продолжить;
    КонецЕсли;
    Если                        Сим =   " "
    Тогда
        Если                    LastSpace
        Тогда
            Продолжить;
        ИначеЕсли               СтрНайти(Игнор,ПредСимв) > 0
        Тогда
            Берём           =                               Ложь;
            LastSpace       =                               Ложь;
            Продолжить;
        Иначе
            Берём           =                               Истина;
            LastSpace       =                               Истина;
        КонецЕсли;
    Иначе
        Берём               =                               Истина;
        LastSpace           =                               Ложь;
    КонецЕсли;
    Если                        Берём
    Тогда
        Рез                 =   Рез                    +    Сим;
        ПредСимв            =   ПредСимв;
    КонецЕсли;
КонецЦикла;
Возврат                         Рез;
КонецФункции
