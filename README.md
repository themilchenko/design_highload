# Highload Instagram

> [Методические указания](https://github.com/init/highload/blob/main/homework_architecture.md)

## Тема и целевая аудитория

**Instagram** — американская социальная сеть для обмена фотографиями и видео, основанная Кевином Систромом и Майком Кригером.

### Факты про целевую аудиторию

Целевой аудиторией являются люди, имеющие отношение к бизнесу, большие компании, общеизвестные деятели и просто люди, которые хотят делиться своей жизнью в социальных сетях.

- В среднем количество активных пользователей достигает 2-х биллионов;
- Пользователи проводят в среднем 11 часов в месяц в соц. сети;
- 30.8% аудитории - люди от 18 до 24 лет, а  30.3% - люди от 25 до 34 года.

Страны лидеры по размеру аудитории на момент января 2023 года:

| Страна      | Пользователей в год, млн. |
| ----------- | ------------------------- |
| Индия       | 229.25                    |
| США         | 143.35                    |
| Бразилия    | 143.35                    |
| Индонезия   | 89.15                     |
| Турция      | 48.65                     |
| Япония      | 45.7                      |
| Мексика     | 36.7                      |

Распределние пользователей за последний месяц (Январь 2023):

| Страна                | Пользователей в месяц, млн. | Пользователей в месяц, %  |
| --------------------- | --------------------------- | ------------------------- |
| CША                   | 435                         | 16.65                     |
| Индия                 | 403.7                       | 10.90                     |
| Бразилия              | 200.2                       | 10.22                     |
| Турция                | 162.4                       | 3.55                      |
| Индонезия             | 161.5                       | 3.50                      |
| Остальные страны      | 1 500                       | 55.18                     |

### Минимально жизнеспособный продукт

1. Создание, редактирование, просмотр профиля;
2. Публикация фото и видео с продолжительностью не более 60 секунд;
3. Возможность поставить лайк и оставить комментарий к посту;
4. Возможность просматривать ленту с подписками.

## Расчет нагрузки

### Продуктовые метрики

1. Месячная аудитория: 2 биллиона.
2. Дневная аудитроия: 500 миллионов.
3. Среднее время онлайна пользователя - 7 мин. 42 сек. За это время пользователю удается просмотреть 10 страниц.
4. Средний размер хранилища пользователя:

Так как информацию насчет среднего количества входов в аккаунт и регистраций найти не удалось, прибегну к приблизительным расчетам.
Будем считать, что так как в среднем за день имеется 500 млн. активных пользователей, то и авторизаций производится столько же.

Перейдем к регистрации: за 2021 год было насчитано 1.21 биллиона пользователей, когда за 2022 1.3 биллиона. Это значит, что за год прибавилось 90 000 млн. пользователей. Значит, грубой оценкой можно посчитать среднее количество регистраций в день: `9 * 10^10 / 365 = 246 575 342`. То есть количество регистраций в день достигает 246 млн.

Информация о лайках и комментариях была найдена в источнике:

- Среднее количество лайков, оставляемых под постом: 1 261, но всего среднее кол-во лайков в день 2 биллиона;
- Среднее количество комментариев, оставляемых под постом: 24.5, но всего среднее кол-комментариев в день 38 миллиона;

Чтобы посчитать среднее кол-во запросов на загрузку, предположу, что вся дневная аудитория будет загружать ленту хотя бы один раз. Пусть 1/4 пользователей загрузит ленту  один раз, вторая четверть два раза, третья четверть 3 раза и оставшаяся 4 раза. Итого, выходит: `0.25 * 500 000 000 * (1 + 2 + 3 + 4) = 1 250 000 000`

#### Сводная таблица по среднему количеству действий пользователя по типам в день

| Тип запроса               | Среднее количество действий (в день) |
| ------------------------- | ------------------------------------ |
| Авторизация / регистрация | 246 млн.                             |
| Публикайия фото / видео   | 95 млн.                              |
| Проставление лайков       | 2 биллиона                           |
| Проставление комментариев | 38 млн.                              |
| Просмотр ленты            | 1 250 млн.                           |

### Технические метрики

#### Размер хранения в разбивке по типам данных

- Размер Постов

Начну с размера поста с фотографией: средний размер фотографии 2 Мб, описание к посту займет около 20 байт (возьмем в среднем 10 символов по 2 байта). Итого, пост с картинкой будет весить 2.2 Мб. В случае с видео - возьмем видео в 10 секунд, которое будет весить 8 Мб и пост будет уже весить 8.2 Мб.

С момента запуска приложения было насчитано около 50 миллиардов фотографий, в секунду загружается 1 074 фотографий. Значит, возьмем 3/4 постов с фотографией и 1/4 с видео и посчитаем приблизительный суммарный размер базы, которая будет хранить все посты:

`50 000 000 000 * (0.75 * 2.2 + 0.25 * 8.2) = 185 000 000 000 Мб = 176 429.75 Тб`

- Информация о пользователе

У пользователя будут следующие поля:

`Имя, Фамилия, Никнейм` - все по 32 символа, каждый из которых весит байт.

`Почта, Дата рождения` - 4 байта.

`Пароль` - в захэгированном виде 32 байта.

`Описание` - 64 симовла по байту каждый.

`30 + 30 + 30 + 4 * 125 000 + 4 + 4 = 500 098 байт = 4 Мб` на одного пользователя
<ScrollWheelUp>
На всех пользователей понадобится `1 300 000 000 000 * 4 = 5.2 * 10^12 Мб = 4 959 106 Тб`

#### Сетевой трафик

Взглянем на авторизацию/регистрацию и посчитаем нагрузку:

`246 000 000 (в день) * 4 Мб / (24 * 3600) = 11 388 Мб/с = 88 Гбит/с`

Рассмотрим загрузку поста. Зная, что за секунду загружается 1 074 постов, посчитаем нагрузку на сеть:

`1 074 * (0.75 * 2.2 + 0.25 * 8.2) = 3 973.8 Мб/с = 31 Гбит/с`

Теперь посчитаем загрузку ленты. Ссылаясь на проделанные расчеты выше, получим:

`[1 250 000 000 (в день) * 60 (кол-во просмотренных постов) * (0.75 * 2.2 + 0.25 * 8.2)] / (24 * 3 600) = 3 211 805 Мб/с = 25 092 Гбит/с`

Так как остальные запросы будут не настолько дорогие относительно этих двух, заложу на них 5 Гбит/с.

Итого, получу итоговую сетевую нагрузку - `88 + 31 + 25 092 = 25 211 Гбит/с`
Суточная нагрузка на сеть - `3 151 Гб * 3600 * 24 = 272 246 400 Гб/с`

### RPS в разбивке по типам запросов

Уже по полученным данным посчитаем кол-во запросов в секунду:

- Регистрация/Авторизация:   `246 000 000 / (24 * 3600) = 2 847 rps`
- Публикайия фото / видео:   `95 000 000 / (24 * 3600) = 1 099 rps`
- Проставление лайков:       `2 000 000 000 / (24 * 3600) = 23 148 rps`
- Проставление комментариев: `38 000 000 / (24 * 3600) = 439 rps`
- Просмотр ленты:            `1 250 000 000 / (24 * 3600) = 14 467 rps`

| Тип запроса               | Запросов в секунду                   |
| ------------------------- | ------------------------------------ |
| Авторизация / регистрация | 2 847                                |
| Публикайия фото / видео   | 1 099                                |
| Проставление лайков       | 23 148                               |
| Проставление комментариев | 439                                  |
| Просмотр ленты            | 14 467                               |
| **Итого**                 | **41 700**                           |

## Логическая схема

![Логическая схема](/img/logical_schema.png)

### Описание таблиц

1. Пользователи (users) - таблица со всеми необходимыми данными о пользователе.
    - Primary key: id пользователяj
2. Посты (posts) - таблица с постами пользователями, которая включает в себя все необходимое для отображения поста.
    - Primary key: id поста;
    - Foreign key: user_id.
3. Лайки (likes) - таблица с информацией, что i-й пользователь поставил лайк j-му посту.
    - Foreign key: user_id, post_id.
4. Комментарии (comments) - таблица с информацией, что i-й пользователь поставил лайк j-му посту с непустым сообщением.
    - Foreign key: user_id, post_id.
5. Подписки (subscriptions) - таблица с информацией о том, что i-й пользователь подписан на j-го. 
    - Foreign key: creator_id, follower_id.
6. Сессии (sessions) - таблица со всеми сессиями пользователей.
    - Foreign key: user_id.

## Физическая схема

 ![Физическая схема](/img/physical_schema.png)

### Выбор БД

1. Сессии пользователей

 Сессии пользователей будут очень часто изменяться по очевидным причиам. Из-за этого нужно осуществить быстрый доступ на получение текущих пользователей, быстрое удаление и добавление. Таким образом их лучше всего хранить в оперативной памяти, с чем прекрасно будет справляться нереляцонная in-memory база данных - `Redis`. В данном случае, ключом будет значение сессии, а значением - id пользователя и дата истечения сессии.

2. Пользователи и посты

 Пользователи же будут находиться в реляционной базе `PostgreSQL`, так как она представляет возможность делать сложные запросы, устанавливать отношения для легкой организации и связывания данных, а также поддерживает обширный функционал для масштабирования. Однако аватарки пользователей хранить там же не представляется возможным за счет большого размера картинок всех пользователей, что будет заметно замедлять работу базы. Поэтому для хранения аватарок будет использоваться `Amazon S3-хранилище`, который имеет высокую скорость чтения, высокую доступность и долговечных данных. В самой же реляционной базе будем хранить ссылку на картунку в S3.

 Аналогично пользователям данные постов будем хранить в `PostgreSQL`, а картинки/видео в `S3-хранилище`.

3. Комментарии, лайки, подписки

 Данные хорошо ложаться на реляционную модель, поэтому будем хранить их в `PostgreSQL`.

### Индексы

 - Индекс на поле `nickname` в таблице `users` будет нужен в случае того, если пользователь решит найти другого по никнейму. Таким образом индекс увеличит селективность по этому полю;
 - Индекс на поле `user_id` в таблице `posts` нужен для быстрого поиска пользователя, пост которого был увиден;
 - Индекс на поле `post_id` в таблице `comments` нужен для быстрой подгрузки всех комментраиев у посту;
 - Индексы на поля `creator_id` и `follower_id` в таблице `subscriptions` будут полезны для улучшения селективности подписчиков и подписок соответственно.

### Шардирование

 - Users: шардирование будет проводиться по range-based принципу для более равномерного распределения данных;
 - Posts: здесь можно применить партиционирование по принципу range-based, а шардировать по разным инстансам по дате создания поста. Таким образом новые посты будут находиться в одном месте, что позволит быстро получать их для прогрузкки ленты или первых постов на странице пользователя. Старые же посты так же будут доставляться быстро;
 - Comments: комментарии будет логично шардировать по такому же принципу, что и посты для согласованности данных, то есть на том же инстансе, что и посты нужной даты.

### Репликация

Для PostgreSQL будет сделана 1 Master, 2 Slaves репликация. Таким образом, когда на Master базу будут записываться данные, с Slave баз будет читаться информация. Также при отказе одного Slave узла чтение может продолжится посредством переключения на другой узел. 

## Технологии

| Технология    | Область применения   | Мотивация      |
|-------------- | -------------------- | -------------- |
| Golang        | Backend dev          | Популярный, быстрый, читаемый, поддерживающий многопоточную и асинхронную работу язык. За счет своей опулярности имеет множество готовых решений для backend-разработки |
|-------------- | -------------------- | -------------- |
| TS / React    | Frontend dev         | TS за счет своей типизации позволит писать более понятный и читаемый код. React фреймворк имеет множество инструментов для эффективной разработки |
|-------------- | -------------------- | -------------- |
| Item1         | Item1                | Item1          |
|-------------- | -------------------- | -------------- |
| Item1         | Item1                | Item1          |
|-------------- | -------------------- | -------------- |
| Item1         | Item1                | Item1          |

## Источники

1. [Статистика по пользователям](https://www.statista.com/topics/1882/instagram)
