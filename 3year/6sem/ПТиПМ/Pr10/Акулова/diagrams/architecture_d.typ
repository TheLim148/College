#import "@preview/tiago:0.1.0": *

#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Liberation Sans")

#let code = ```
direction: down

title: Архитектурная диаграмма системы бронирования {
  style: {
    font-size: 22
    bold: true
  }
}

users: Пользователи {
  style.fill: "#f5f7fa"

  roles: "администратор • учебный отдел • преподаватель"
}

ui: "Клиентский интерфейс\nформы, списки, календарь, отчеты" {
  style.fill: "#eaf4ff"
}

api: "Серверное приложение ASP.NET Core Web API\nприем JSON-запросов и вызов бизнес-логики" {
  style.fill: "#eef2ff"
}

settings: "Настройки\nрабочие часы, праздники"
rooms: "Аудитории\nи оборудование"
requests: "Заявки\nна бронирование"
auth: "Авторизация\nи роли"
audit: "Аудит\nи логирование"
calendar: "Календарь\nзанятости"
overlap: "Проверка\nпересечений"
reports: "Отчеты\nи Excel"

dal: "Слой доступа к данным\nрепозитории / ORM" {
  style.fill: "#edf7f3"
}

excel: "Microsoft Excel\nимпорт аудиторий / экспорт отчетов" {
  style.fill: "#edf7f3"
}

db: "PostgreSQL 16\nпользователи, роли, аудитории,\nоборудование, заявки, статусы, события" {
  shape: cylinder
  style.fill: "#edf7f3"
}

users -> ui: "работа с интерфейсом"
ui -> api: JSON

api -> rooms
api -> requests
api -> auth
api -> settings
api -> audit
api -> reports

requests -> calendar
requests -> overlap
calendar -> overlap

settings -> dal
rooms -> dal
requests -> dal
auth -> dal
audit -> dal
calendar -> dal
overlap -> dal
reports -> dal

reports -> excel: экспорт
excel -> rooms: импорт

dal -> db
```.text

#render(code)