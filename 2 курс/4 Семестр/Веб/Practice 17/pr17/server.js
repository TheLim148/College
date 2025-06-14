const express = require('express'); //Подключаем экспресс
const app = express();
const port = 3000;

app.use(express.json());

let tasks = []; //Создаём массив с заданиям
let nextId = 1; //Описываем переменную с индексом

//Получение списка задач
app.get('/tasks', (req, res) => {
    res.json(tasks);
});

//Добавление новой задачи
app.post('/tasks', (req, res) => {
    const newTask = { //Описываем переменную для нового задания с тремя полями
        id: nextId++,
        description: req.body.description,
        completed: false
    };
    tasks.push(newTask); //Пушим задание в массив
    res.json({ message: 'Задача успешно добавлена', task: newTask });
});

//Обновление статуса задачи
app.put('/tasks/:id', (req, res) => {
    const task = tasks.find(t => t.id === parseInt(req.params.id)); //Ищем задание
    if (!task) { //Если не нашли то прокидываем ошибку
        return res.status(404).json({ message: 'Задача не найдена' });
    }
    task.completed = req.body.completed;
    res.json({ message: 'Статус задачи обновлён', task });
});

//Удаление задачи
app.delete('/tasks/:id', (req, res) => {
    const index = tasks.findIndex(t => t.id === parseInt(req.params.id)); //Ищем айди задания
    if (index === -1) { //При неудаче вновь прокидываем ошибку
        return res.status(404).json({ message: 'Задача не найдена' });
    }
    tasks.splice(index, 1);
    res.json({ message: 'Задача успешно удалена' });
});

//Пишем в консоль об успешном запуске сервера
app.listen(port, () => {
    console.log(`Сервер запущен на http://localhost:${port}`);
});