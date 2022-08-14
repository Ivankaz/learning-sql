-- выбираю ID заказа, название, цену и количество книг,
-- которые заказал Баринов Павел
SELECT buy_id, title, price, buy_book.amount
-- объединяю 4 таблицы
FROM client
     INNER JOIN buy USING(client_id)
     INNER JOIN buy_book USING(buy_id)
     INNER JOIN book USING(book_id)
WHERE name_client = 'Баранов Павел'
-- сначала сортирую по ID заказа, затем по названию книги
ORDER BY buy_id, title;

-- выбираю автора, название книги и количество раз, которое её заказали
SELECT name_author, title, COUNT(buy_id) AS Количество
FROM buy_book
     -- использую внешнее соединение RIGHT (OUTER) JOIN,
     -- чтобы получить INNER JOIN + все записи из таблицы справа, т.е. book
     RIGHT JOIN book USING(book_id)
     INNER JOIN author USING(author_id)
GROUP BY book_id
-- сортирую по автору и названию книги
ORDER BY name_author, title;

-- выбираю города, в которых живут клиенты, которые совершали заказы
SELECT name_city,
       -- подсчитываю количество заказов для каждого города
       COUNT(*) AS Количество
-- объединяю таблицы с помощью внутреннего соединения
FROM city
     INNER JOIN client USING(city_id)
     INNER JOIN buy USING(client_id)
GROUP BY name_city
-- сортирую сначала по убыванию количества заказов,
-- затем по городу в алфавитном порядке
ORDER BY Количество DESC, name_city ASC;

-- выбираю ID и дату оплаченных заказов
SELECT buy_id, date_step_end
FROM buy_step
     INNER JOIN step USING(step_id)
-- оставляю только те заказы, которые находятся на шаге "Оплата"
-- и имеют дату окончания шага, т.е. заказ оплачен
WHERE name_step = 'Оплата' AND
      date_step_end IS NOT NULL;

-- выбираю все заказы и подсчитываю их итоговую стоимость
SELECT buy_id, name_client,
       SUM(price * buy_book.amount) AS Стоимость
FROM book
     JOIN buy_book USING(book_id)
     JOIN buy USING(buy_id)
     JOIN client USING(client_id)
GROUP BY buy_id
-- сортирую по номеру заказа
ORDER BY buy_id;

-- выбираю ID заказов и их статус
SELECT buy_id, name_step
-- объединяю таблицы step (этапы) и buy_step (заказам по отношению к этапам)
FROM step INNER JOIN buy_step USING(step_id)
-- оставляю только те этапы, у которых есть дата начала, но нет даты конца
WHERE date_step_beg IS NOT NULL AND
      date_step_end IS NULL
-- сортирую по ID заказа по возрастанию
ORDER BY buy_id ASC;

-- выбираю ID заказа,
-- количество дней, которое он доставлялся,
-- и разницу реального срока доставки с прогнозируемым сроком доставки (опоздание)
SELECT buy_id,
       DATEDIFF(date_step_end, date_step_beg) AS Количество_дней,
       IF(DATEDIFF(date_step_end, date_step_beg) - days_delivery > 0, DATEDIFF(date_step_end, date_step_beg) - days_delivery, 0) AS Опоздание
FROM city
     INNER JOIN client USING(city_id)
     INNER JOIN buy USING(client_id)
     INNER JOIN buy_step USING(buy_id)
     INNER JOIN step USING(step_id)
-- оставляю только те заказы, которые прошли этап транспортировки
WHERE name_step = 'Транспортировка' AND
      date_step_end IS NOT NULL;

-- выбираю всех клиентов, которые заказывали книги Достоевского
SELECT DISTINCT name_client
FROM author
     JOIN book USING(author_id)
     JOIN buy_book USING(book_id)
     JOIN buy USING(buy_id)
     JOIN client USING(client_id)
-- оставляю только заказы книг Достоевского
WHERE name_author LIKE '%Достоевский%'
-- сортирую клиентов по возрастанию
ORDER BY name_client ASC;

-- выбираю жанры с максимальным количеством купленных экземпляров книг
SELECT name_genre,
       SUM(buy_book.amount) AS Количество
FROM genre
     INNER JOIN book USING(genre_id)
     INNER JOIN buy_book USING(book_id)
-- группирую купленные книги по жанру
GROUP BY name_genre
-- оставляю только те жанры, количество купленных книг которых совпадает с максимальным
HAVING SUM(buy_book.amount) = (
    -- с помощью вложенного запроса получаю максимальное купленное количество книг в одном жанре
    SELECT SUM(buy_book.amount) AS max_count
    FROM genre
         INNER JOIN book USING(genre_id)
         INNER JOIN buy_book USING(book_id)
    GROUP BY name_genre
    ORDER BY max_count DESC
    LIMIT 1
    );

-- получаю выручку за 2020 год
SELECT 2020 AS Год,
       -- получаю название месяца из даты с помощью функции MONTHNAME
       MONTHNAME(buy_step.date_step_end) AS Месяц,
       -- подсчитываю суммарную стоимость всех проданных книг
       SUM(price * buy_book.amount) AS Сумма
-- объединяю таблицы внутренним соединением
-- этапы + этапы заказов + заказанные книги + книги
FROM step
     INNER JOIN buy_step USING(step_id)
     INNER JOIN buy_book USING(buy_id)
     INNER JOIN book USING(book_id)
-- оставляю только те заказы, которые оплатили
WHERE name_step = 'Оплата' AND date_step_end IS NOT NULL
-- группирую записи по месяцу
GROUP BY Месяц
-- объединяю выборки и оставляю только различающиеся строки
UNION
-- выбираю выручку за 2019 год
SELECT 2019 AS Год,
       MONTHNAME(date_payment) AS Месяц,
       SUM(price * amount) AS Сумма
FROM buy_archive
GROUP BY Месяц
-- сортирую записи в результирующей выборке (после UNION) по возрастанию месяца и года
ORDER BY Месяц ASC, Год ASC;

SELECT title,
       SUM(Количество) AS Количество,
       SUM(Сумма) AS Сумма
-- вложенный запрос, в котором я получаю книги, проданные в текущем и предыдущем годах
FROM (
    -- для каждой отдельной книги вывожу количество и стоимость проданных экзепляров
    -- за текущий год
    SELECT title,
           SUM(buy_book.amount) AS Количество,
           SUM(buy_book.amount * price) AS Сумма
    FROM book
         JOIN buy_book USING(book_id)
         JOIN buy_step USING(buy_id)
         JOIN step USING(step_id)
    -- выбираю книги, которые оплатили
    WHERE name_step = "Оплата" AND date_step_end IS NOT NULL
    GROUP BY title
    -- объединяю все записи в одну выборку
    UNION ALL
    -- за прошлый год
    SELECT title,
           SUM(buy_archive.amount) AS Количество,
           SUM(buy_archive.amount * buy_archive.price) AS Сумма
    FROM book
         JOIN buy_archive USING(book_id)
    GROUP BY title
    ) AS sold_books
-- группирую записи из вложенного запроса по названию книги
GROUP BY title
-- сортирую книги по убыванию суммы, на которую их продали
ORDER BY Сумма DESC;

-- получаю книги, которые ни разу не купили
SELECT title
FROM book
WHERE book_id NOT IN (
    -- вложенный запрос, в котором я выбираю ID книг, которые купили
    SELECT DISTINCT(book_id)
    FROM buy_book
    )
-- сортирую книги по возрастанию
ORDER BY title ASC;
