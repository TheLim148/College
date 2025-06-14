// server.js
const express = require("express");
const app = express();
const port = 3000;

app.use(express.json());

// Временное хранилище товаров в памяти
let products = [];
let nextId = 1;

// Получить все товары
app.get("/products", (req, res) => {
  res.json(products);
});

// Получить товар по ID
app.get("/products/:id", (req, res) => {
  const id = parseInt(req.params.id);
  const product = products.find(p => p.id === id);
  if (!product) return res.status(404).json({ error: "Товар не найден" });
  res.json(product);
});

// Создать новый товар
app.post("/products", (req, res) => {
  const { name, category, price } = req.body;
  const newProduct = { id: nextId++, name, category, price };
  products.push(newProduct);
  res.status(201).json(newProduct);
});

// Обновить товар по ID
app.put("/products/:id", (req, res) => {
  const id = parseInt(req.params.id);
  const product = products.find(p => p.id === id);
  if (!product) return res.status(404).json({ error: "Товар не найден" });

  const { name, category, price } = req.body;
  product.name = name ?? product.name;
  product.category = category ?? product.category;
  product.price = price ?? product.price;

  res.json(product);
});

// Удалить товар по ID
app.delete("/products/:id", (req, res) => {
  const id = parseInt(req.params.id);
  const index = products.findIndex(p => p.id === id);
  if (index === -1) return res.status(404).json({ error: "Товар не найден" });

  products.splice(index, 1);
  res.json({ message: "Товар удалён" });
});

// Запуск сервера
app.listen(port, () => {
  console.log(`Сервер запущен на http://localhost:${port}`);
});
