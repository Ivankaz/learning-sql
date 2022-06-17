-- создаю таблицу supply (поставки)
CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);

-- одним запросом вставляю 4 новые записи в таблицу
INSERT INTO supply(supply_id, title, author, price, amount)
VALUES (1, 'Лирика', 'Пастернак Б.Л.', 518.99, 2),
       (2, 'Черный человек', 'Есенин С.А.', 570.20, 6),
       (3, 'Белая гвардия', 'Булгаков М.А.', 540.50, 7),
       (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3);
-- SELECT * FROM supply;

-- вставляю все записи о книгах из таблицы supply в таблицу book,
-- кроме книг Булгакова и Достоевского
INSERT INTO book(title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN ('Булгаков М.А.', 'Достоевский Ф.М.');
-- SELECT * FROM book;

-- добавляю в таблицу book книги из таблицы supply только тех авторов,
-- которых нет в таблице book
INSERT INTO book(title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN (
    -- вложенный запрос, которым выбираю авторов таблицы book
    SELECT DISTINCT author
    FROM book
    );
-- SELECT * FROM book;

-- снижаю цену на 10% для тех книг,
-- количество которых от 5 до 10 включительно
UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN 5 AND 10;
-- SELECT * FROM book;

-- обновляю таблицу book
UPDATE book
-- если заказ покупателя больше количества экземпляров в наличии,
-- то устанавливаю заказ равным количеству всех экземпляров книги
SET buy = IF(buy > amount, amount, buy),
-- если на книгу нет заказов,
-- то уменьшаю цену на 10%
    price = IF(buy = 0, price * 0.9, price);
-- SELECT * FROM book;

-- обновляю таблицу book
UPDATE book, supply
-- количество экземпляров книги в таблице book суммирую с количеством на складе (supply)
SET book.amount = book.amount + supply.amount,
-- устанавливаю для книг среднюю цену между ценой из таблиц book и supply
    book.price = (book.price + supply.price) / 2
-- отбираю только те книги, которые есть и в book, и в supply
WHERE book.title = supply.title AND book.author = supply.author;
-- SELECT * FROM book;

-- удаляю записи о книгах из таблицы supply,
-- авторы которых имеют общее количество экземпляров больше 10
DELETE FROM supply
WHERE author IN (
    -- вложенный запрос, которым я отбираю авторов,
    -- у которых общее количество экземпляров книг больше 10
    SELECT author
    FROM book
    GROUP BY author
    HAVING SUM(amount) > 10
);
-- SELECT * FROM supply;

-- создаю таблицу ordering со значениями из таблицы book
CREATE TABLE ordering AS
SELECT author, title, (
    -- вложенный запрос, с помощью которого я получаю среднее количество экземпляров книг в таблице book
    SELECT ROUND(AVG(amount))
    FROM book
    ) AS amount
FROM book
-- оставляю только те книги, количество которых меньше среднего
WHERE amount < (
    -- вложенный запрос, с помощью которого я получаю среднее количество экземпляров книг в таблице book
    SELECT AVG(amount)
    FROM book
);
-- SELECT * FROM ordering;
