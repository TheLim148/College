const list = document.getElementById('list');
const btn = document.getElementById('addItem');
const message = document.getElementById('message');
        
function getRandomColor() {
    return `rgb(${Math.floor(Math.random() * 256)}, ${Math.floor(Math.random() * 256)}, ${Math.floor(Math.random() * 256)})`;
}

function getRandomBorderRadius() {
    return `${Math.floor(Math.random() * 50)}px`;
}

btn.addEventListener('click', () => {
    if (list.children.length >= 5) {
        message.textContent = 'Максимум элементов!';
        return;
}

const newItem = document.createElement('li');
newItem.textContent = 'Новый элемент';
newItem.style.color = getRandomColor(); 
newItem.style.border = `2px solid ${getRandomColor()}`; 
newItem.style.borderRadius = getRandomBorderRadius(); 

list.appendChild(newItem);
});
