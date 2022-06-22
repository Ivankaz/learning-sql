-- создаю таблицу fine (штрафы)
CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE,
    date_payment DATE
);
-- с помощью следующей команды можно посмотреть настройки полей таблицы
-- SHOW FIELDS FROM fine;

-- вставляю 3 записи в таблицу fine
INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', Null, '2020-02-14', Null),
       ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', Null, '2020-02-23', Null),
       ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', Null, '2020-03-03', Null);
-- SELECT * FROM fine;

-- обновляю суммы в таблице штрафов (fine)
-- в соответствии с таблицей нарушений ПДД (traffic_violation)
-- использую алиасы для таблиц
UPDATE fine f, traffic_violation tv
SET f.sum_fine = tv.sum_fine
-- для тех штрафов, для которых ещё не установили сумму
WHERE f.sum_fine IS NULL AND f.violation = tv.violation;
-- SELECT * FROM fine;
