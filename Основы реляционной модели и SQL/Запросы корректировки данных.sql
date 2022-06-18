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

/* Задача:
1. Создать новую таблицу all_books, в которую добавить все книги из таблиц book и supply. Для повторяющихся книг цену устанавливать наибольшую, количество складывать.
2. Создать новую таблицу ordering и добавить в неё книги из таблицы all_books, количество которых меньше 10. Новая таблица должна иметь столбцы ordering_id (первичный ключ), title, author, price, need_to_order. В столбце need_to_order вычислить разницу между суммарным количеством экземпляров книги и 10, т.е. какое количество книг нужно заказать, чтобы оно стало равно 10. Вывести таблицу ordering.
*/

-- создаю таблицу all_books и добавляю в неё все записи о книгах из таблицы book
CREATE TABLE all_books(
    all_books_id INT PRIMARY KEY AUTO_INCREMENT
) AS
SELECT title, author, price, amount
FROM book;
-- SELECT * FROM all_books;

-- обновляю количество и цены у книг, которые есть и в таблице all_books, и в таблице supply
UPDATE all_books, supply
-- количество экземпляров складываю
SET all_books.amount = all_books.amount + supply.amount,
-- цену книги выбираю максимальную с помощью функции GREATEST
    all_books.price = GREATEST(all_books.price, supply.price)
-- применяю обновление только для тех книг, которые есть в обоих таблицах
WHERE all_books.title = supply.title AND all_books.author = supply.author;
-- SELECT * FROM all_books;

-- вставляю в таблицу all_books книги из таблицы supply,
-- которых нет в таблице all_books
INSERT INTO all_books(title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE title NOT IN (
    -- вложенный запрос, который выбирает все книги из таблицы all_books
    SELECT title
    FROM all_books
    ) OR author NOT IN (
    -- вложенный запрос, который выбирает все книги из таблицы all_books
    SELECT author
    FROM all_books
    );
-- SELECT * FROM all_books;

-- создаю новую таблицу ordering (книги, которые нужно заказать)
CREATE TABLE ordering(
    ordering_id INT PRIMARY KEY AUTO_INCREMENT,
    need_to_order INT
) AS
-- в поле need_to_order вычисляю количество книг, которое нужно докупить,
-- чтобы в наличии магазина было минимум 10 экземпляров
SELECT title, author, price, (10 - amount) AS need_to_order
FROM all_books
-- оставляю только те книги, количество которых меньше 10
WHERE amount < 10;
SELECT * FROM ordering;
