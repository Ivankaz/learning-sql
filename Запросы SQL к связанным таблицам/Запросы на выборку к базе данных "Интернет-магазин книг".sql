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
