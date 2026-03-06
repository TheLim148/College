const title = document.getElementById("title");
const button = document.getElementById("button");

button.addEventListener("click", () => {
    title.style.color = "crimson"; //При нажатии на кнопку заголовок меняет цвет на багровый
})

button.addEventListener("mouseover", () => {
    title.style.fontStyle = "italic"; //При наведении мыши на заголовок он меняет слой стиль на курсив
    title.style.fontSize = "42px";
})


