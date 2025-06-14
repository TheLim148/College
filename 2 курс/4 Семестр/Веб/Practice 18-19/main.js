const express = require("express"); //Устанавливаем экспресс
const app = express();
const port = 3000;

app.use(express.json());

let products = []; //Массив для продуктов
let nextId = 1; //Индексация массива

app.get("/products", (req, res) => {
  res.json(products); //Запрашиваем массив продуктов
});

app.get("/products/:id", (req, res) => { //Эндпоинт на получение элемента из массива по айди
  const id = parseInt(req.params.id); //Переменная которая запрашивает айди элемента
  const product = products.find(p => p.id === id); //Сравнивает запрошенный айди
  if (!product) {
    return res.status(404).json({ error: "Товар не найден" }); //Если такого не оказалось, то будет выведено сообщение
  }
  res.json(product); //Возвращение продукта по айди при удачном его поиске
});

app.post("/products", (req, res) => { //Эндпоинт на отправку продукта
  const { name, category, price } = req.body; //В запросе на отправку будет имя, категория и цена товара
  const newProduct = { id: nextId++, name, category, price }; //Создание нового продукта с айдти, именем, категорией и ценой
  products.push(newProduct); //Пушинг этого элемента в массив
  res.status(201).json(newProduct); //Возврат этого элемента
});

app.put("/products/:id", (req, res) => { //Запрос по айди
  const id = parseInt(req.params.id);
  const product = products.find(p => p.id === id); //Проверка запрошенного айди
  if (!product) {
    return res.status(404).json({ error: "Товар не найден"}); //При неудаче высвечивается сообщение о не найденном товаре
  }
  const { name, category, price } = req.body; //Создаются те-же имя, категория и цена для товара
  product.name = name ?? product.name;
  product.category = category ?? product.category; //В этих срочках происходит сравнение. Если пользователь указал Имя, Категорию и/или цену
  // то они будут присвоены товару с нужным айди. Иначе будет null
  product.price = price ?? product.price;
  res.json(product); //Отправление измененного товара
});

app.delete("/products/:id", (req, res) => {
  const id = parseInt(req.params.id); //Получение айди
  const index = products.findIndex(p => p.id === id); //Переменная с индексо
  if (index === -1) {
    return res.status(404).json({ error: "Товар не найден" }); //Если индекс равен -1, то товар не найден
  }
  products.splice(index, 1);
  res.json({ message: "Товар удалён" }); //Иначе будет удалён
});

app.listen(port, () => {
  console.log(`Сервер запущен на http://localhost:${port}`); //Сообщение о успешном подключении к серверу
});
