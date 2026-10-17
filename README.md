# ZH1C

ZH1C is a small 1C:Enterprise 8.3 configuration extension (`Ж`, object prefix `Ж_`) with reusable server-side helper functions for 1C developers: event-log writing with formatted error details, date, string, number and JSON helpers, reading and writing БСП additional attributes (дополнительные реквизиты), and lookups for 1C:ЗУП-style configurations (person e-mail, person by e-mail, users by role through access groups).

## Contents

- `Ж.cfe` - the extension, ready to load into an infobase.
- `src/cfe/Ж/` - the same extension dumped to XML/BSL files by Designer.
  - `CommonModules/Ж_ext` - general helpers (`Запиши`, `ЗапишиОшибку`, `ПричесатьДату`, `ЕстьСвойство`, `ПолучитьДопРеквизит`, `СохранитьДопРеквизит`, `JsonString2Соответствие` and others).
  - `CommonModules/Ж_ЗУП` - `ПолучитьEmail`, `ПолучитьФизлицоПоEmail`, `СписокПользователейПоРолиЧерезГруппыДоступа`.
  - `DataProcessors/Ж_ДопРеквизиты` - additional-attribute storage.

## Requirements

- 1C:Enterprise 8.3 with extension compatibility mode 8.3.11 or later.
- A base configuration that contains the adopted objects: catalogs `ФизическиеЛица`, `ВидыКонтактнойИнформации`, `ГруппыДоступа`, `ПрофилиГруппДоступа`, `ИдентификаторыОбъектовРасширений` and enum `ТипыКонтактнойИнформации` (as in 1C:ЗУП and other БСП-based configurations).

## Usage

1. Load `Ж.cfe` into the infobase as a configuration extension.
2. Call the exported functions from server code, for example:

   ```bsl
   Ж_ext.Запиши("МоёСобытие", "Текст сообщения");
   Email = Ж_ЗУП.ПолучитьEmail(ФизическоеЛицо);
   ```
