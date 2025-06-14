const title = document.getElementById('title');
const button = document.getElementById('btn');

button.addEventListener('click', () => {

    title.style.color = 'red';

});

title.addEventListener('mouseover', () => {

    title.style.fontSize = '36px'; 
    title.style.fontWeight = 'bold'; 

});