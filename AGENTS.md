# ZH1C

ZH1C holds the 1C:Enterprise 8.3 configuration extension `Ж` (object prefix `Ж_`, purpose `AddOn`, compatibility mode `Version8_3_11`): a small library of exported server-side helper functions that other 1C code calls. It covers event-log writing with formatted error details, date, string, number and JSON helpers, reading and writing БСП additional attributes (дополнительные реквизиты), and lookups for 1C:ЗУП-style configurations (person e-mail, person by e-mail, users by role through access groups). It is for 1C developers. Updates are rare (last commit 2024-11-04).

## Layout

- `src/cfe/Ж/` - extension source as a Designer dump to XML/BSL files. This is the source of truth.
  - `Configuration.xml` - extension properties, including `<Version>` (currently `2024.11.01W`).
  - `CommonModules/Ж_ext/Ext/Module.bsl` - general helpers: `Запиши`, `ЗапишиОшибку` (event log plus `Сообщить`), `ПричесатьДату`, `ЕстьСвойство`, `СвернутьВ1Пробел`, `ПолучитьДопРеквизит`, `СохранитьДопРеквизит`, `НайтиПозицииЗаглавныхСлов`, `РазницаДатВМесяцах`, `JsonString2Соответствие`, `ПолучитьЧислоИзСТроки`, `ПреобразоватьПоВозможностиСтрокуВДату` and others.
  - `CommonModules/Ж_ЗУП/Ext/Module.bsl` - `ПолучитьEmail`, `ПолучитьФизлицоПоEmail`, `СписокПользователейПоРолиЧерезГруппыДоступа`.
  - `DataProcessors/Ж_ДопРеквизиты/Ext/ManagerModule.bsl` - additional-attribute storage through `Справочник.НаборыДополнительныхРеквизитовИСведений`; `ObjectModule.bsl` is empty.
  - `Catalogs/*.xml`, `Enums/ТипыКонтактнойИнформации.xml` - adopted base-configuration objects (`ФизическиеЛица`, `ВидыКонтактнойИнформации`, `ГруппыДоступа`, `ПрофилиГруппДоступа`, `ИдентификаторыОбъектовРасширений`) used by the queries.
- `Ж.cfe` - built extension file, committed next to the source.
- `README.md` - short project description.

## Setup / Build / Run / Test

The repository has no build scripts, CI or automated tests. You need the 1C:Enterprise 8.3 platform with Designer and a test infobase whose configuration contains the adopted objects listed above.

- Install: load `Ж.cfe` into the infobase as a configuration extension.
- Use: call the exported functions from server code, for example `Ж_ext.Запиши("МоёСобытие", "Текст сообщения")`.
- Rebuild `Ж.cfe` after changing `src/cfe/Ж`: load the files into the extension with Designer and save the extension to `Ж.cfe`. No script exists; with standard Designer batch flags it is roughly (unverified):

  ```bat
  1cv8 DESIGNER /F<infobase> /LoadConfigFromFiles src\cfe\Ж -Extension Ж
  1cv8 DESIGNER /F<infobase> /DumpCfg Ж.cfe -Extension Ж
  ```

- Test manually in the test infobase.

## Conventions

- Code is 1C:Enterprise built-in language (BSL) with mostly Russian identifiers; assignments are column-aligned and `Если`/`Тогда` sit on separate lines.
- New extension objects get the `Ж_` prefix; adopted objects keep base-configuration names.
- Bump `<Version>` in `Configuration.xml` when the code changes and rebuild `Ж.cfe`.
- The additional-attribute helpers catch errors and write them with `Ж_ext.ЗапишиОшибку` under event names such as `Ж_ext:ПолучитьСвойство`; follow that pattern in new helpers.
- Default branch `main`. Commit messages are short and in Russian or dated (`2024.11.04 Actualization`).

## Gotchas and boundaries

- `Ж.cfe` is binary; never edit it by hand. Keep it in sync with `src/cfe/Ж`.
- `ConfigDumpInfo.xml` and the object `uuid` values come from Designer; do not invent or change UUIDs by hand.
- `Ж_ext` and `Ж_ЗУП` are compiled for Server only (not client, not external connection, no "Server call"), so they can be called only from server code.
- Additional-attribute helpers find attributes by their title (`Свойство.Заголовок`) and attribute sets by name, so they depend on data in the target infobase.
- Queries use predefined items of the base configuration (`Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица`, `Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты`); the extension will not work on configurations without them.
- No `.cursor/rules` or Copilot instructions exist in this repo.
