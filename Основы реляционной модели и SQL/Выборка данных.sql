-- выбираю все записи из таблицы
SELECT * FROM book;

-- выбираю отдельные столбцы
SELECT author, title, price FROM book;

-- выбираю столбцы и присваиваю им новые имена
SELECT title AS Название, author AS Автор FROM book;

-- выбираю данные с вычисляемым столбцом pack
SELECT title, amount, 1.65 * amount AS pack FROM book;

-- выбираю данные с добавлением вычисляемого слолбца new_price,
-- в котором использую функцию ROUND для округления цены до 2 знаков после запятой
SELECT title, author, amount, ROUND(price - ((price / 100) * 30), 2) AS new_price FROM book;

-- выбираю данные с использованием логической функции IF в вычисляемом столбце new_price 
SELECT author, title, ROUND(IF(author = 'Булгаков М.А.', price*1.1, IF(author = 'Есенин С.А.', price*1.05, price)), 2) AS new_price FROM book;

-- выбираю строки, которые удовлетворяют условию после ключевого слова WHERE
SELECT author, title, price 
FROM book
WHERE amount < 10;

-- выбираю данные, которые удовлетворяют нескольким условиям,
-- объединённым с помощью логических операторов AND и OR
SELECT title, author, price, amount
FROM book
WHERE (price < 500 OR price > 600) AND (price * amount) >= 5000;

-- выбираю записи, которые удовлетворяют условию при котором,
-- цена находится в определённом промежутке (_ BETWEEN _ AND _)
-- и количество находится в определённом множестве (_ IN (_, _, _))
SELECT title, author
FROM book
WHERE (price BETWEEN 540.50 AND 800) AND (amount IN (2, 3, 5, 7));

-- выбираю данные и сортирую их
-- сначала по убыванию автора (в обратном алфавитном порядке),
-- потом по возрастанию названия книги (по алфавиту)
SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY author DESC, title ASC;

-- выбираю книги, у которых
-- название состоит хотя бы из 2 слов
-- и автор имеет букву "C" в инициалах
-- сортирую по названию книги по алфавиту
SELECT title, author
FROM book
WHERE title LIKE '_% _%' AND
      author LIKE '%_ %С.%'
ORDER BY title ASC

/* Задача:
Нужно получить стоимость всех экземпляров книг и
отсортировать их по убыванию этой стоимости
*/
SELECT title, author, price * amount AS total
FROM book
ORDER BY total DESC;

/* Задача:
Для книг, цена на которые от 0 до 500 увеличить цену на 10%.
Для книг, цена на которые от 700 уменьшить цену на 5%.
*/
SELECT title, author, IF(price BETWEEN 0 AND 500, ROUND(price*1.1, 2), IF(price > 700, ROUND(price*0.95, 2), price)) AS price, amount
FROM book;

/* Задача:
Выбрать таблицу со столбцамии на русском языке и добавить к ней столбец Статус.
Если книг до 5 включительно, статус = Заканчивается
Если книг от 5 до 10 включительно, статус = В наличии
Если книг от 10, статус = Много
*/
SELECT title AS Название, author AS Автор, price AS Цена, amount AS Количество, IF(amount <= 5, 'Заканчивается', IF(amount > 10, 'Много', 'В наличии')) AS Статус
FROM book;
