let cells = document.querySelectorAll(".cell"); //Выделяем все элементы с классом cell
let turn = "X"; //Первый ход крестика
let flag = false; //Флаг знаменующий окончание игры

cells.forEach(cell => {
  cell.onclick = () => { //Обработчик события, чтобы на каждую клетку можно было кликнуть
    if (cell.textContent === "" && !flag) { //Если клетка пустая и игра не закончена
      cell.textContent = turn; //В клетку записывается ход игрока
      check(); //Проврека на победителя
      if(turn === "X"){
          turn = "O"; //Если ход крестика, то следующий ход нолика
      }
      else{
          turn = "X"; //Наоборот
      }
    }
  }
});

function check() {
  let c = [];
  for (let i = 0; i < cells.length; i++) {
    c.push(cells[i].textContent); //Массив со всеми клетками, будь то они пустые, либо содержат чей-то ход
  }
  let lines = [ //Массив со всеми выигрышными позициями
    [0,1,2], [3,4,5], [6,7,8], //Строки
    [0,3,6], [1,4,7], [2,5,8], //Столбцы
    [0,4,8], [2,4,6]           //Диагонали
  ];
  lines.forEach(l => {
    if (c[l[0]] && c[l[0]] === c[l[1]] && c[l[1]] === c[l[2]]) { //Проверка на выигрышную позицию, чтобы все три символа были в одну линию / стоблец / диагональ
      let status = document.getElementById("status");
      status.style.fontSize = "50px";
      status.textContent = c[l[0]] + " победил!";
      flag = true;
    }
  });
}
    