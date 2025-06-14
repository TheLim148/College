document.getElementById("button").addEventListener("click", function() {
    const inputText = document.getElementById('name').value.trim();
    const inputAge = document.getElementById('age').value.trim();
    if(inputText && inputAge) {
        const li = document.createElement("li");
        const color = document.getElementById("color");
        li.appendChild(document.createTextNode(inputText));
        li.addEventListener("click", function() {
            this.remove();
        })
        
        document.getElementById("list").appendChild(li);
        li.style.color = color.value;
    }
})

document.getElementById("delete-button").addEventListener("click", function() {
    document.getElementById("list").innerHTML = "";
})