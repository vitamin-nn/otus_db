## Задание 4
### Задача
Цель:
Реализовать спроектированную схему в postgres

Используя операторы DDL создайте на примере схемы интернет-магазина:
* Базу данных.
* Табличные пространства и роли.
* Схему данных.
* Таблицы своего проекта, распределив их по схемам и табличным пространствам.

### Реализация
В файле  [ddl.sql](ddl.sql) представлен лог операций при создании всех сущностей в БД.
Помимо пользователя создана роль otus_db_role. Владельцем всех объектов установлена эта роль - так будет удобнее при создании новых пользователей: мы просто можем дать им права на эту роль и для доступа к созданным объектам никаких прав отдельно проставлять не потребуется.