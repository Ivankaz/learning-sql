-- выбираю книги авторов,
-- цены на которые меньше либо равны средней цене книг на складе
-- сортирую по убыванию цены
SELECT author, title, price
FROM book
WHERE price <= (
    -- вложенный запрос для получения средней цены
    SELECT AVG(price)
    FROM book
    )
ORDER BY price DESC;

-- выбираю книги, цена на которые не превышает минимальную цену более чем на 150 рублей
-- сортирую по возрастанию цены
SELECT author, title, price
FROM book
WHERE price - (
    -- вложенный запрос для получения минимальной цены
    SELECT MIN(price) FROM book
    ) <= 150
ORDER BY price ASC;

-- выбираю книги, количество экземпляров которых больше не повторяется в таблице
SELECT author, title, amount
FROM book
WHERE amount IN (
    -- вложенный запрос, который оставляет только то количество книг,
    -- которое повторяется в таблице только 1 раз
    SELECT amount
    FROM book
    GROUP BY amount
    HAVING COUNT(amount) = 1
    );
