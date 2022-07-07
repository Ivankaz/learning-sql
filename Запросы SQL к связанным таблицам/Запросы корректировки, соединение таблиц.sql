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
