-- выбираю записи о командировках сотрудников,
-- фамилия которых заканчивается на "а"
SELECT name, city, per_diem, date_first, date_last
FROM trip
WHERE name LIKE '%а _._.'
-- сортирую по убыванию даты окончания командировки 
ORDER BY date_last DESC;

-- выбираю фамилии сотрудников,
-- которые были в командировке в Москве 
SELECT DISTINCT name
FROM trip
WHERE city = 'Москва'
-- сортирую по алфавиту
ORDER BY name ASC;

-- выбираю города и подсчитываю количество командировок в каждый город
SELECT city, COUNT(city) AS Количество
FROM trip
GROUP BY city
-- сортирую города в алфавитном порядке
ORDER BY city;

-- выбираю 2 города, в которые чаще всего были командировки
SELECT city, COUNT(city) AS Количество
FROM trip
GROUP BY city
-- сортирую города по убыванию количества командировок 
ORDER BY Количество DESC
LIMIT 2;

-- выбираю командировки сотрудников и подсчитываю их длительность с помощью функции DATEDIFF
SELECT name, city, (DATEDIFF(date_last, date_first) + 1) AS Длительность
FROM trip
-- выбираю все города кроме Москвы и Санкт-Петербурга
WHERE city NOT IN ('Москва', 'Санкт-Петербург')
-- сортирую по убыванию длительности и города (в обратном алфавитном порядке)
ORDER BY Длительность DESC, city DESC;

-- выбираю командировки сотрудника(-ов),
-- которые были наименьшей длительности
SELECT name, city, date_first, date_last
FROM trip
WHERE (DATEDIFF(date_last, date_first) + 1) = (
    -- вложенный запрос, которым я получаю минимальную длительность командировки
    -- длительность командировки подсчитываю с помощью функции DATEDIFF
    SELECT MIN(DATEDIFF(date_last, date_first) + 1) FROM trip
    );

-- выбираю записи о командировках,
-- которые начались и закончились в одном месяце (при этом год может быть разным)
SELECT name, city, date_first, date_last
FROM trip
-- с помощью функции MONTH получаю номер месяца
WHERE MONTH(date_first) = MONTH(date_last)
-- сортирую записи сначала по городу, потом по фамилии сотрудника
ORDER BY city ASC, name ASC;

-- подсчитываю количество командировок для каждого месяца
-- функция MONTHNAME возвращает название месяца на английском языке
SELECT MONTHNAME(date_first) AS Месяц, COUNT(date_first) AS Количество
FROM trip
GROUP BY MONTHNAME(date_first)
-- сортирую по убыванию количества командировок,
-- и затем по названию месяца в алфавитном порядке
ORDER BY Количество DESC, Месяц ASC;

-- подсчитываю сумму суточных для командировок в феврале и марте 2020 года
SELECT name, city, date_first,
       (DATEDIFF(date_last, date_first) + 1) * per_diem AS Сумма
FROM trip
WHERE MONTH(date_first) IN (2, 3) AND YEAR(date_first) = 2020
-- сортирую по фамилии сотрудника в алфавитном порялке и по убыванию суммы суточных
ORDER BY name ASC, Сумма DESC;

-- вывожу суммы суточных сотрудников
SELECT name,
       SUM((DATEDIFF(date_last, date_first) + 1) * per_diem) AS Сумма
FROM trip
GROUP BY name
-- оставляю только тех сотрудников, которые были в командировках более 3 раз
HAVING COUNT(name) > 3
-- сортирую по убыванию суммы суточных
ORDER BY Сумма DESC;
