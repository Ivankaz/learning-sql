-- добавляю в таблицу нового клиента
INSERT INTO client(name_client, city_id, email)
SELECT 'Попов Илья', city_id, 'popov@test'
FROM city
WHERE name_city = 'Москва';

-- SELECT * FROM client;

-- добавляю заказ для клиента Попов Илья
INSERT INTO buy(buy_description, client_id)
SELECT 'Связаться со мной по вопросу доставки', с.client_id
FROM client с
WHERE name_client = 'Попов Илья';

-- SELECT * FROM buy;
