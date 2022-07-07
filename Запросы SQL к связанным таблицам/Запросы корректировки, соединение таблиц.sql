-- обновляю информацию в таблицах book и supply
-- связываю авторов с книгами по author_id
UPDATE author a
       INNER JOIN book b
       USING(author_id)
       -- соединяю информацию о книге на складе (book) и в поставке (supply)
       -- по названию и автору книги
       INNER JOIN supply s
       ON b.title = s.title AND
          a.name_author = s.author
-- увеличиваю количество экземпляров книги на складе на количество книг в поставке
SET b.amount = b.amount + s.amount,
    -- обнуляю количество экземпляров книги в поставке
    s.amount = 0,
    -- обновляю цену книги на складе
    b.price = ROUND((b.price * b.amount + s.price * s.amount) / (b.amount + s.amount), 2)
-- только для тех книг, цена которых отличается на складе и в поставке
WHERE b.price <> s.price;

-- SELECT * FROM book;
-- SELECT * FROM supply;

-- добавляю авторов в таблицу author,
-- которые есть в поставке, но отсутствуют в таблице author
INSERT INTO author(name_author)
-- выбираю новых авторов с помощью LEFT JOIN
SELECT author
FROM supply LEFT JOIN author
     ON supply.author = author.name_author
WHERE name_author IS NULL;
    
-- SELECT * FROM author;

-- добавляю на склад (book) новые книги из поставки (supply)
INSERT INTO book(title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM supply INNER JOIN author
     ON supply.author = author.name_author
WHERE amount <> 0;

-- SELECT * FROM book;

-- указываю жанр для книги Лермонтова "Стихотворения и поэмы"
UPDATE book
SET genre_id = (
    -- получаю ID жанра из таблицы genre
    SELECT genre_id
    FROM genre
    WHERE name_genre = 'Поэзия'
    )
WHERE title = 'Стихотворения и поэмы'
      AND author_id IN (
          -- получаю ID автора из таблицы author
          SELECT author_id
          FROM author
          WHERE name_author LIKE 'Лермонтов%'
      );

-- указываю жанр для книги Стивенсона "Остров сокровищ"
UPDATE book
SET genre_id = (
    -- получаю ID жанра из таблицы genre
    SELECT genre_id
    FROM genre
    WHERE name_genre = 'Приключения'
    )
WHERE title = 'Остров сокровищ'
      AND author_id IN (
          -- получаю ID автора из таблицы author
          SELECT author_id
          FROM author
          WHERE name_author LIKE 'Стивенсон%'
      );

-- SELECT * FROM book;

-- удаляю всех авторов и все их книги, общее количество книг которых меньше 20
DELETE FROM author
WHERE author_id IN (
    -- выбираю ID авторов, количество книг которых меньше 20
    SELECT author_id
    FROM book
    GROUP BY author_id
    HAVING SUM(amount) < 20
    );

-- SELECT * FROM author;
-- SELECT * FROM book;
