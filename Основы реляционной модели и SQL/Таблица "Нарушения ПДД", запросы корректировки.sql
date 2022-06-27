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

-- выбираю тех водителей, которые на одной и той же машине
-- нарушили одно и то же правило 2 и более раз
SELECT name, number_plate, violation
FROM fine
-- группирую записи, у которых совпадают все три столбца
GROUP BY name, number_plate, violation
-- в строках групп оставляю только те, количество которых равно 2 или больше
HAVING COUNT(*) >= 2
-- сортирую в алфавитном порядке по трём столбцам
ORDER BY name, number_plate, violation;

-- для тех водителей, которые на одной и той же машине
-- нарушили одно и то же правило 2 и более раз
UPDATE fine f, (
    SELECT name, number_plate, violation
    FROM fine
    GROUP BY name, number_plate, violation
    HAVING COUNT(*) >= 2
    ) u
-- увеличиваю сумму штрафа в 2 раза
SET f.sum_fine = f.sum_fine * 2
WHERE f.name = u.name AND
      f.number_plate = u.number_plate AND
      f.violation = u.violation AND
      -- оставляю только неоплаченные штрафы
      date_payment IS NULL;
-- SELECT * FROM fine;

/*
В следующем запросе я проверяю,
можно ли вместо использования функции DATEDIFF просто отнимать даты друг от друга.

ВЫВОД: Разница между датами != использованию DATEDIFF
       Для вычисления разницы между датами нужно использовать DATEDIFF
*/
SELECT date_violation, date_payment,
       DATEDIFF(date_payment, date_violation) AS datediff,
       date_payment - date_violation AS date_difference
FROM payment;

-- обновляю таблицу с штрафами, используя данные об оплаченных штрафах
UPDATE fine f, payment p
-- добавляю в таблицу fine (штрафы) дату оплаты из таблицы payment (оплаченные штрафы)
SET f.date_payment = p.date_payment,
-- если штраф оплатили в течении 20 дней после совершения нарушения, то уменьшаю сумму штрафа в 2 раза
    f.sum_fine = IF(DATEDIFF(p.date_payment, p.date_violation) <= 20, f.sum_fine / 2, f.sum_fine)
-- отбираю только те штрафы, которые совпадают в обоих таблицах
WHERE f.name = p.name AND -- имя водителя
      f.number_plate = p.number_plate AND -- номер автомобиля
      f.violation = p.violation AND -- нарушение
      f.date_violation = p.date_violation; -- дата
-- SELECT * FROM fine;

-- создаю таблицу back_payment (задолженности)
CREATE TABLE back_payment
-- заношу в нее информациб о штрафах из таблицы fine,
-- которые не оплачены
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;
-- SELECT * FROM back_payment;

-- удаляю из таблицы fine штрафы,
-- которые были совершены до 1 февраля 2020 года
DELETE FROM fine
WHERE date_violation < '2020-02-01';
-- SELECT * FROM fine;
