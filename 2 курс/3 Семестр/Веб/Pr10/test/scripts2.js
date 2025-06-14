const table = document.getElementById('table');
const deleteRow = document.getElementById('deleteRow');

deleteRow.addEventListener('click', () => {
    if (table.rows.length > 1) { 
        table.deleteRow(-1);
    }
});

table.addEventListener('dblclick', (event) => {
    const target = event.target;
    if (target.tagName === 'TD') {
        const value = prompt('Введите новое значение:', target.textContent);
    if (value !== null) {
        target.textContent = value;
    }
    }
});