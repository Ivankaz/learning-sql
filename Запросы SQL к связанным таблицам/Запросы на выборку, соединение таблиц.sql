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
