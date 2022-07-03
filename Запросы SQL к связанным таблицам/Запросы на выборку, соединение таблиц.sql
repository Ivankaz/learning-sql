-- выбираю название, жанр и цену книги
SELECT title, name_genre, price
-- использую внутреннее соединение таблиц (INNER JOIN) по внешнему ключу genre_id,
-- чтобы объединить записи таблиц book и genre
FROM book INNER JOIN genre
     ON book.genre_id = genre.genre_id
-- оставляю только те книги, количество которых больше 8
WHERE amount > 8
-- сортирую книги по убыванию цены
ORDER BY price DESC;

-- выбираю жанры, которые не представлены в книгах на складе
SELECT name_genre
-- объединяю таблицы genre и book (как при INNER JOIN)
-- и для тех записей из genre, для которых не нашлось записей в book,
-- устанавливаю недостающие поля равными NULL
FROM genre LEFT JOIN book
     ON genre.genre_id = book.genre_id
-- оставляю только те жанры, для которых не нашлось книг в таблице book
WHERE title IS NULL;

-- выбираю таблицу с датами выставок для каждого города и автора
SELECT name_city, name_author,
       -- генерирую случайную дату в 2020 году
       -- RAND() - возвращает случайное вещественное число от 0 до 1
       -- FLOOR() - возвращает целую часть числа
       -- DATE_ADD('YYYY-MM-DD', INTERVAL [число] [ед. измерения]) - прибавляет к дате число дней/недель/месяцев/лет
       DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY) AS Дата
-- с помощью CROSS JOIN (перекрестное соединение
-- для каждой записи из таблицы city выбираю записи из author
FROM city CROSS JOIN author
-- сортирую записи сначала по городу по алфавиту, потом по убыванию даты выставки
ORDER BY name_city ASC, Дата DESC;

-- выбираю жанр, название и автора книги из нескольких таблиц
SELECT name_genre, title, name_author
-- объединяю 3 таблицы между собой с помощью последовательных INNER JOIN
FROM genre
     INNER JOIN book ON genre.genre_id = book.genre_id
     INNER JOIN author ON book.author_id = author.author_id
-- оставляю только те книги, жанр которых включает слово "роман"
WHERE name_genre LIKE '%роман%'
-- сортирую книги по алфавиту
ORDER BY title ASC;

-- подсчитываю количество экземпляров книг для каждого автора
SELECT name_author,
       SUM(amount) AS Количество
-- объединяю таблицу author с таблицей book так,
-- чтобы при отсутствии соответствующей записи в таблице book
-- автор все равно выводился, а недостающие поля принимали значение NULL
FROM author LEFT JOIN book
     ON author.author_id = book.author_id
GROUP BY name_author
-- вывожу только тех авторов, у которых меньше 10 экземпляров книг или их нет совсем
-- P.S. вместо 'COUNT(title) = 0' логичнее было бы написать 'Количество IS NULL'
HAVING Количество < 10 OR COUNT(title) = 0
-- сортирую по возрастанию количества экземпляров
ORDER BY Количество ASC;

-- получаю имена авторов, которые пишут только в 1 жанре
SELECT name_author
FROM author
WHERE author_id IN (
    -- получаю ID авторов, которые пишут только в 1 жанре
    SELECT author_id
    FROM book
    GROUP BY author_id
    -- DISTINCT() - оставляет только уникальные значения genre_id
    -- COUNT() - подсчитывает их количество
    HAVING COUNT(DISTINCT(genre_id)) = 1
    );
