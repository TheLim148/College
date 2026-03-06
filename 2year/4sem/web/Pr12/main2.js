const ul = document.getElementById("list");
const btn = document.getElementById("button");



btn.addEventListener("click", () => {
    const li = document.createElement("li");
    ul.appendChild(li);
    li.textContent = "Element";
    li.style.border = "solid 1px";
    li.className = "highlight";
    return;
}) 
