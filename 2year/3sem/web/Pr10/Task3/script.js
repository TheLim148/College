const title = document.getElementById("title");
const button = document.getElementById("button");

button.addEventListener("click", () => {
    title.style.color = "crimson";
})

button.addEventListener("mouseover", () => {
    title.style.fontStyle = "italic";
    title.style.fontSize = "42px";
})


