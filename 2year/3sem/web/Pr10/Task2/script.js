const list = document.getElementById("list");
const button = document.getElementById("addItem");
const message = document.getElementById("message");

// function getRandomColor() {
//     var letters = '0123456789ABCDEF';
//     var color = '#';
//     for (var i = 0; i < 6; i++) {
//       color += letters[Math.floor(Math.random() * 16)];
//     }
//     return color;
//   }

button.addEventListener("click", () => {
    if(list.children.length == 5) {
        message.textContent = "Maximum elements >:d"; //Условие. Если элемент списка равен 5, то выводиться сообщение о невозможности добавления новых элементов
        return;
    }

    const newItem = document.createElement('li');
    newItem.textContent = "New element";
    // newItem.style.color = getRandomColor; //Добавление самого элемента. Описывается переменная, которая создает элемент списка, с определенным текстом и границей в 2 пикселя. Функция рандомного цвета не работает.
    newItem.style.border = "solid 2px"
    list.appendChild(newItem);
})



