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
