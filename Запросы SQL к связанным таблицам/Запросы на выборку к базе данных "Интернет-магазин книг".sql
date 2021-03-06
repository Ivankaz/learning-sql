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
