# Charset Enigma
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE3..10.3%20Rio-blue.svg)
![Platforms](https://img.shields.io/badge/Platforms-Windows,%20Android,%20iOs,%20MacOS,%20Linux-green.svg)
![Version](https://img.shields.io/badge/dynamic/json?color=blue&label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fms301%2Fcharset-enigma%2Fmaster%2Fboss.json)

Delphi charset detector Community Edition
### For install in your project using [boss](https://github.com/HashLoad/boss):
``` sh
$ boss install github.com/ms301/charset-enigma
```
# Docs
The following charsets are supported:

|    Encoding            | BOM      | Lite     | Full     |
| ---------------------- | -------- | -------- | -------- |
| ASCII                  | -        | +        | +        |
| Big-5                  | -        | +        | +        |
| BOCU-1                 | +        | -        | -        |
| CP949                  | -        | -        | +        |
| EUC-KR                 | -        | +        | +        |
| EUC-JP                 | -        | +        | +        |
| EUC-TW                 | -        | +        | +        |
| gb18030                | +        | +        | +        |    
| HZ-GB-2312             | -        | +        | +        |
| IBM852                 | -        | -        | +        |
| IBM855                 | -        | +        | +        |
| IBM866                 | -        | +        | +        |
| ISO-2022-JP            | -        | +        | +        |
| ISO-2022-KR            | -        | +        | +        |
| ISO-2022-CN            | -        | +        | +        |
| ISO-8859-1             | -        | -        | +        |
| ISO-8859-2             | -        | -        | +        |
| ISO-8859-3             | -        | -        | +        |
| ISO-8859-4             | -        | -        | +        |
| ISO-8859-5             | -        | +        | +        |
| ISO-8859-6             | -        | -        | +        |
| ISO-8859-7             | -        | +        | +        |
| ISO-8859-8             | -        | +        | +        |
| ISO-8859-9             | -        | -        | +        |
| ISO-8859-10            | -        | -        | +        |
| ISO-8859-11            | -        | -        | +        |
| ISO-8859-13            | -        | -        | +        |
| ISO-8859-15            | -        | -        | +        |
| ISO-8859-16            | -        | -        | +        |
| KOI8-R                 | -        | +        | +        |
| MAC-CENTRALEUROPE      | -        | -        | +        |
| Shift-JIS              | -        | +        | +        |
| SCSU                   | +        | -        | -        |
| TIS-620                | -        | -        | +        |
| UTF-1                  | +        | -        | -        |
| UTF-7                  | +        | -        | -        |
| UTF-8                  | +        | +        | +        |
| UTF-16LE               | +        | +        | +        |
| UTF-16BE               | +        | +        | +        |
| UTF-32LE               | +        | +        | +        |
| UTF-32BE               | +        | +        | +        |
| UTF-EBCDIC             | +        | -        | -        |
| VISCII                 | -        | -        | +        |
| windows-1250           | -        | +        | +        |
| windows-1251           | -        | +        | +        |
| windows-1252           | -        | +        | +        |
| windows-1253           | -        | +        | +        |
| windows-1255           | -        | +        | +        |
| windows-1256           | -        | -        | +        |
| windows-1257           | -        | -        | +        |
| windows-1258           | -        | -        | +        |
| X-ISO-10646-UCS-4-2143 | +        | ?        | ?        |
| X-ISO-10646-UCS-4-3412 | +        | ?        | ?        |
| x-mac-cyrillic         | -        | +        | +        |
