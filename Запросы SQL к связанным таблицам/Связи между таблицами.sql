-- создаю таблицу с авторами книг
CREATE TABLE author(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);

-- добавляю записи в таблицу author
INSERT INTO author(name_author)
VALUES ('Булгаков М.А.'),
       ('Достоевский Ф.М.'),
       ('Есенин С.А.'),
       ('Пастернак Б.Л.');
-- SELECT * FROM author;

-- создаю таблицу book с внешними ключами author_id и genre_id
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8, 2),
    amount INT,
    -- внешний ключ к таблице author (авторы)
    FOREIGN KEY (author_id) REFERENCES author(author_id),
    -- внешний ключ к таблице genre (жанры)
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);
-- SHOW FIELDS FROM book;

-- создаю такую же таблицу, как и в предыдущей задаче
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8, 2),
    amount INT,
    -- с помощью ON DELETE CASCADE указываю,
    -- что при удалении автора из таблицы author
    -- связанные с ним книги тоже нужно удалить
    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE,
    -- использую ON DELETE SET NULL,
    -- чтобы при удалении жанра из таблицы genre
    -- полю внешнего ключа genre_id присваивался NULL
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id) ON DELETE SET NULL
);
-- SHOW FIELDS FROM book;

-- добавляю записи в таблицу book и указываю внешние ключи author_id и genre_id
INSERT INTO book(title, author_id, genre_id, price, amount)
VALUES ('Стихотворения и поэмы', 3, 2, 650.00, 15),
       ('Черный человек', 3, 2, 570.20, 6),
       ('Лирика', 4, 2, 518.99, 2);
-- SELECT * FROM book;
