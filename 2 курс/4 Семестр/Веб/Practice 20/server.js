const express = require("express");
const cors = require("cors");
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

let products = [
  {
    id: 1,
    name: "Наушники",
    description: "Безпроводные наушники",
    price: 25000,
    stock: 10,
    type: "Безпроводные"
  }
];

app.get("/products", (req, res) => {
  res.json(products);
});

app.post("/products", (req, res) => {
  const newProduct = { ...req.body, id: Date.now()};
  products.push(newProduct);
  res.status(201).json(newProduct);
});

app.put("/products/:id", (req, res) => {
  const id = Number(req.params.id);
  const index = products.findIndex(p => p.id === id);
  if (index !== -1) {
    products[index] = { ...req.body, id };
    res.json(products[index]);
  }
  else {
    res.status(404).json({ error: "Товар не найден"});
  }
});

app.delete("/products/:id", (req, res) => {
  const id = Number(req.params.id);
  products = products.filter(p => p.id !== id);
  res.status(204).end();
});

app.listen(port, () => {
  console.log(`Сервер запущен на http://localhost:${port}`);
});
