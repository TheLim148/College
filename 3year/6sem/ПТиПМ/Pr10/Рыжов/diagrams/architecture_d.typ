#import "@preview/tiago:0.1.0": *

#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Liberation Sans")

#let code = ```
direction: down

title: Архитектурная диаграмма системы {
  style: {
    font-size: 24
    bold: true
  }
}

users_group: Пользователи {
  direction: right
  style.fill: "#f5f7fa"

  manager: Руководитель
  master: Мастер
  receiver: Приемщик
  admin: Администратор
}

client_level: Клиентский уровень {
  direction: right
  style.fill: "#f5f7fa"

  settings: "Раздел «Настройки»"
  reports: "Раздел «Отчёты»"
  directories: "Разделы «Клиенты», «Устройства», «Сотрудники»"
  requests: "Раздел «Заявки»"
  auth_form: "Форма авторизации"
}

server_level: "Серверный уровень: ASP.NET Core" {
  direction: down
  style.fill: "#f5f7fa"

  api: "Web API контроллеры"

  services: "Сервисный слой\nAuthService, RequestService,\nReportService, AuditService"

  rules: "Валидация и правила\nбизнес-логики"

  repos: "Репозитории доступа\nк данным"
}

data_level: "Уровень данных и внешние сервисы" {
  direction: right
  style.fill: "#f5f7fa"

  db: "PostgreSQL 16\nединая база данных" {
    shape: cylinder
  }

  smtp: "SMTP-сервис\nуведомлений"

  excel: "Файлы Excel\nимпорт/экспорт"

  audit_log: "Журнал аудита\nи системных событий"
}

# Связи пользователей с формой авторизации
users_group.manager -> client_level.auth_form
users_group.master -> client_level.auth_form
users_group.receiver -> client_level.auth_form
users_group.admin -> client_level.auth_form

# Связи клиентского уровня с API
client_level.settings -> server_level.api
client_level.reports -> server_level.api
client_level.directories -> server_level.api
client_level.requests -> server_level.api
client_level.auth_form -> server_level.api

# Внутренняя серверная логика
server_level.api -> server_level.services
server_level.services -> server_level.rules
server_level.rules -> server_level.repos

# Доступ к данным и внешним сервисам
server_level.repos -> data_level.db
server_level.services -> data_level.smtp
server_level.services -> data_level.excel
server_level.services -> data_level.audit_log
```.text

#render(code)