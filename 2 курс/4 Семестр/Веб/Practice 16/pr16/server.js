const express = require('express'); //Подключение экспресса
const app = express();
const port = 3000;

//Массив с книгами
const books = [
  {id: 1, title: 'Понедельник начинается в субботу', author: 'Братья Стругацкие'},
  {id: 2, title: 'Божественная комендия', author: 'Данте Алигьери'},
  {id: 3, title: 'Флатландия', author: 'Эдвин Э. Эбботт'},
  {id: 4, title: 'Сферландия', author: 'Дионис Бюргер'},
  {id: 5, title: 'Энеида', author: 'Веригилий '},
];

//Эндпоинт на получение ФИО студента
app.get('/student', (req, res) => {
  res.json({fullName: 'Магер Капитолина Емельяновна'});
});

//Эндпоинт на получение массива с книгами
app.get('/data', (req, res) => {
  res.json(books);
});

//Сообщение в консоль о запуске сервера по заданному адресу
app.listen(port, () => {
  console.log(`Сервер запущен на http://localhost:${port}`);
});