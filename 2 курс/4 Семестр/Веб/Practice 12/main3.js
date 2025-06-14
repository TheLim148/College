document.addEventListener('DOMContentLoaded', function () {
    let money = parseInt(prompt('Введите бюджет:'), 10);
    if (isNaN(money) || money <= 0) {
        alert('Введите число больше 0!');
        return;
    }

    let left = money;
    const cost = document.getElementById('cost');
    const add = document.getElementById('add');
    const leftText = document.getElementById('left');

    leftText.textContent = `Остаток: ${left} рублей`;

    add.addEventListener('click', function () {
        let num = parseInt(cost.value, 10);
        if (isNaN(num) || num <= 0) {
            alert('Введите правильное число!');
            return;
        }

        if (num > left) {
            alert('Не хватает денег!');
            return;
        }

        left -= num;
        leftText.textContent = `Остаток: ${left} рублей`;
        cost.value = '';
    });
});
