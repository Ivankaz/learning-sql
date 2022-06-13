-- выбираю уникальные элементы столбца amount
SELECT DISTINCT amount
FROM book;

-- группирую книги по автору и с помощью групповых функций
-- подсчитываю их количество (COUNT)
-- и количество экземпляров книг (SUM)
SELECT author AS Автор,
       COUNT(title) AS Различных_книг,
       SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY author;

-- группирую книги по автору
-- и подсчитываю их минимальную, максимальную и среднюю цену
SELECT author,
       MIN(price) AS Минимальная_цена,
       MAX(price) AS Максимальная_цена,
       AVG(price) AS Средняя_цена
FROM book
GROUP BY author;

-- использую групповую функцию SUM вместе с вычисляемыми столбцами
SELECT author,
       SUM(price * amount) AS Стоимость,
       ROUND(((SUM(price * amount) * 18 / 100) / (1 + 18/100)), 2) AS НДС,
       ROUND((SUM(price * amount) / (1 + 18 / 100)), 2) AS Стоимость_без_НДС
FROM book
GROUP BY author;

-- использую групповые функции для всей таблицы (без группировки с помощью GROUP BY)
SELECT MIN(price) AS Минимальная_цена,
       MAX(price) AS Максимальная_цена,
       ROUND(AVG(price), 2) AS Средняя_цена
FROM book;

-- использую групповые функции для записей, которые удовлетворяют условию после ключевого слова WHERE
SELECT ROUND(AVG(price), 2) AS Средняя_цена,
       ROUND(SUM(price * amount), 2) AS Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14;

-- подсчитываю стоимость книг авторов,
-- книги которых не входят в множество (WHERE _ NOT IN (_, _))
-- и суммарная стоимость которых, больше 5000 (HAVING SUM(_) > 5000)
-- сортирую по убыванию стоимости книг
SELECT author,
       SUM(price * amount) AS Стоимость
FROM book
WHERE title NOT IN ('Идиот', 'Белая гвардия')
GROUP BY author
HAVING SUM(price * amount) > 5000
ORDER BY Стоимость DESC;

/* Задача:
Вывести столбцы Автор и Количество_дорогих_книг. В столбце Количество_дорогих_книг подсчитать для каждого автора количество книг, которые стоят больше 500 рублей.
*/
SELECT author AS Автор, COUNT(title) AS Количество_дорогих_книг
FROM book
WHERE price > 500
GROUP BY author;
