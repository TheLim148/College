const express = require('express');//импорт экспресс 
const app = express();//экземпляр приложения экспресс
const PORT = process.env.PORT || 3003;//порт сервера

// Данные о студентах
let studentList = [
    { id: 1, firstName: 'Андрей', lastName: 'Кузьмин', middleName: 'Сергеевич' },
    { id: 2, firstName: 'Бокарев', lastName: 'Никита', middleName: 'Иванович' },
    { id: 3, firstName: 'Павел', lastName: 'Иванов', middleName: 'Андреевич' },
    { id: 4, firstName: 'Иван', lastName: 'Сидоров', middleName: 'Петрович' },
];
app.get('/api/students/:id/fullname', (req, res) => {// Эндпоинт для получения полного имени студента 
    const id = parseInt(req.params.id);
    let foundStudent = null;
    for (let i = 0; i < studentList.length; i++) {// Поиск студента. Если id совпали, то найденому студенту присвоим студента по данному индексу
        if (studentList[i].id === id) 
        {
            foundStudent = studentList[i];
            break;
        }
    }
    if (foundStudent) 
    { // Проверка, найден ли студент
        const fullName = foundStudent.lastName + ' ' + foundStudent.firstName + ' ' + foundStudent.middleName;//полное имя фамилия отчество
        res.json({ fullName: fullName });// Отправляем полное имя в формате JSON
    } 
    else 
    {
        res.status(404).json({ Сообщение: 'Студент не найден' });// Если студент не найден
    }
});
// Запуск сервера
app.listen(PORT, function() {
    console.log('Сервер запущен, порт ' + PORT);
});