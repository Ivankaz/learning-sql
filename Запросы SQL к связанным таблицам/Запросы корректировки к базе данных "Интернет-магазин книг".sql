-- добавляю в таблицу нового клиента
INSERT INTO client(name_client, city_id, email)
SELECT 'Попов Илья', city_id, 'popov@test'
FROM city
WHERE name_city = 'Москва';

-- SELECT * FROM client;
