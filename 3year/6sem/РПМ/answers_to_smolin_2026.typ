// ------------------------------------------------------------
// Ответы на теоретические вопросы
// Дисциплина: Разработка программных модулей
// Форматирование приближено к требованиям ГОСТ
// ------------------------------------------------------------

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#set page(
  margin: (
    top: 20mm,
    bottom: 20mm,
    left: 30mm,
    right: 10mm
  )
)

#set text(
  font: "Times New Roman",
  size: 14pt
)

#set heading(numbering: "1.")

#show raw: set text(
  font: "JetBrains Mono",
  size: 14pt
)

#outline(title: [Содержание])

#pagebreak()

= Жизненный цикл Java-программы

Жизненный цикл Java-программы включает несколько этапов: написание исходного кода, компиляцию, загрузку байт-кода, проверку и выполнение программы.

Сначала программист пишет исходный код в файле с расширением `.java`. Затем компилятор `javac` преобразует этот код в байт-код, который сохраняется в файле с расширением `.class`. Байт-код не является машинным кодом конкретного процессора, поэтому он может выполняться на разных операционных системах.

После компиляции программа запускается виртуальной машиной Java – JVM. JVM загружает байт-код, проверяет его безопасность и корректность, а затем выполняет программу. За счёт этого Java считается переносимым языком: один и тот же скомпилированный код может работать на Windows, Linux и других системах, если там установлена подходящая среда Java.

JVM (Java Virtual Machine) – виртуальная машина, которая выполняет байт-код Java.

JRE (Java Runtime Environment) – среда выполнения Java. Она включает JVM и стандартные библиотеки, необходимые для запуска программ.

JDK (Java Development Kit) – комплект разработчика. Он включает JRE, компилятор `javac`, отладочные инструменты и другие средства разработки.

Пример жизненного цикла:

#raw(
  lang: "text",
  "Main.java -> javac Main.java -> Main.class -> JVM -> выполнение программы"
)

Таким образом, JDK нужен для разработки, JRE – для запуска, а JVM – непосредственно для выполнения байт-кода.

= Типы данных и операторы в Java

В Java есть примитивные и ссылочные типы данных. Примитивные типы хранят простые значения, а ссылочные типы хранят ссылку на объект.

К примитивным типам относятся:

- `byte` – целое число малого размера;
- `short` – короткое целое число;
- `int` – основной тип для целых чисел;
- `long` – целое число большого размера;
- `float` – число с плавающей точкой одинарной точности;
- `double` – число с плавающей точкой двойной точности;
- `char` – один символ;
- `boolean` – логическое значение `true` или `false`.

Пример объявления переменных:

```java
int age = 20;
double price = 15.5;
char grade = 'A';
boolean active = true;
```


Операторы в Java используются для выполнения действий над переменными и значениями.

Арифметические операторы:

- `+` – сложение;
- `-` – вычитание;
- `*` – умножение;
- `/` – деление;
- `%` – остаток от деления.

Пример:

```java
int a = 10;
int b = 3;

int sum = a + b;
int remainder = a % b;
```

Логические операторы применяются для работы с условиями:

- `&&` – логическое И;
- `||` – логическое ИЛИ;
- `!` – логическое НЕ.

Пример:

```java
int age = 18;
boolean hasPassport = true;

boolean canRegister = age >= 18 && hasPassport;
```

Также часто используются операторы сравнения: `==`, `!=`, `>`, `<`, `>=`, `<=`.

= Основы ООП

ООП – объектно-ориентированное программирование. Это подход, при котором программа строится из объектов. Каждый объект объединяет данные и методы для работы с этими данными.

Класс – это шаблон, по которому создаются объекты. Объект – конкретный экземпляр класса.

Пример класса:

```java
class User {
    private String name;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
```

Основные принципы ООП:

1. Инкапсуляция – скрытие внутреннего состояния объекта. Обычно поля делают `private`, а доступ к ним дают через методы.
2. Наследование – возможность создавать новый класс на основе существующего.
3. Полиморфизм – возможность использовать разные объекты через общий тип.
4. Абстракция – выделение главных характеристик объекта без лишних деталей.

Пример наследования и полиморфизма:

```java
class Animal {
    void sound() {
        System.out.println("Sound");
    }
}

class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("Bark");
    }
}

Animal animal = new Dog();
animal.sound();
```

В этом примере переменная имеет тип `Animal`, но фактически хранит объект `Dog`. При вызове метода выполняется переопределённая версия из класса `Dog`.

ООП упрощает разработку больших программ, потому что код становится более структурированным, повторно используемым и удобным для сопровождения.

= Паттерны Singleton и Factory Method

Паттерны проектирования – это типовые решения часто встречающихся задач в программировании.

Singleton – паттерн, который гарантирует, что у класса будет только один объект. Обычно он используется для логирования, работы с настройками или объектами, которые должны существовать в единственном экземпляре.

Пример Singleton:

```java
class Logger {
    private static Logger instance;

    private Logger() {
    }

    public static Logger getInstance() {
        if (instance == null) {
            instance = new Logger();
        }

        return instance;
    }

    public void log(String message) {
        System.out.println(message);
    }
}
```

Использование:

```java
Logger logger = Logger.getInstance();
logger.log("Программа запущена");
```

Конструктор сделан `private`, поэтому объект нельзя создать через `new`. Получить объект можно только через метод `getInstance()`.

Factory Method – паттерн, который выносит создание объектов в отдельный метод или класс. Он полезен, когда программа должна создавать разные объекты в зависимости от условий.

Пример:

```java
interface Transport {
    void move();
}

class Car implements Transport {
    public void move() {
        System.out.println("Машина едет");
    }
}

class Bike implements Transport {
    public void move() {
        System.out.println("Велосипед едет");
    }
}

class TransportFactory {
    public Transport create(String type) {
        if (type.equals("car")) {
            return new Car();
        }

        if (type.equals("bike")) {
            return new Bike();
        }

        throw new IllegalArgumentException("Неизвестный тип");
    }
}
```

Factory Method уменьшает зависимость кода от конкретных классов и делает программу гибче.

= Коллекции Java

Коллекции в Java используются для хранения групп объектов. Они находятся в пакете `java.util`.

Основные виды коллекций:

- `List` – список, который хранит элементы в порядке добавления и допускает дубликаты;
- `Set` – множество, которое хранит только уникальные элементы;
- `Map` – структура, которая хранит пары ключ-значение.

Пример `List`:

```java
List<String> names = new ArrayList<>();

names.add("Анна");
names.add("Иван");
names.add("Анна");

System.out.println(names);
```

В `List` можно хранить одинаковые значения.

Пример `Set`:

```java
Set<String> cities = new HashSet<>();

cities.add("Москва");
cities.add("Казань");
cities.add("Москва");

System.out.println(cities);
```

В `Set` повторяющееся значение не будет добавлено второй раз.

Пример `Map`:

```java
Map<Integer, String> users = new HashMap<>();

users.put(1, "Анна");
users.put(2, "Иван");

System.out.println(users.get(1));
```

Для перебора коллекций можно использовать обычный цикл, расширенный `for`, `forEach` или `Iterator`.

Пример перебора:

```java
for (String name : names) {
    System.out.println(name);
}

users.forEach((id, name) -> {
    System.out.println(id + ": " + name);
});
```

Коллекции часто используются при работе с базами данных, REST API, списками пользователей, товарами, заказами и другими наборами данных.

= Исключения в Java

Исключения используются для обработки ошибок, которые возникают во время выполнения программы. Например, ошибка может появиться при делении на ноль, чтении несуществующего файла или неправильном вводе пользователя.

Конструкция `try-catch` позволяет перехватить ошибку и обработать её без аварийного завершения программы.

Пример:

```java
try {
    int result = 10 / 0;
    System.out.println(result);
} catch (ArithmeticException e) {
    System.out.println("Ошибка деления на ноль");
}
```

Блок `try` содержит код, в котором может возникнуть ошибка. Блок `catch` выполняется, если исключение действительно произошло.

Также можно использовать блок `finally`. Он выполняется всегда, независимо от того, была ошибка или нет.

```java
try {
    System.out.println("Работа с ресурсом");
} catch (Exception e) {
    System.out.println("Ошибка");
} finally {
    System.out.println("Завершение работы");
}
```

В Java можно создавать собственные исключения. Это удобно, когда нужно описать ошибку предметной области приложения.

Пример собственного исключения:

```java
class InvalidAgeException extends Exception {
    public InvalidAgeException(String message) {
        super(message);
    }
}
```

Использование:

```java
public void checkAge(int age) throws InvalidAgeException {
    if (age < 18) {
        throw new InvalidAgeException("Возраст меньше 18 лет");
    }
}
```

Исключения делают программу надёжнее, потому что позволяют заранее продумать обработку ошибочных ситуаций.

= Потоки ввода-вывода

Потоки ввода-вывода используются для чтения и записи данных. В Java для работы с файлами часто применяются `BufferedReader` и `BufferedWriter`.

`BufferedReader` позволяет читать текст из файла построчно. Это удобно, если файл содержит несколько строк данных.

Пример чтения файла:

```java
try (BufferedReader reader =
         new BufferedReader(new FileReader("input.txt"))) {

    String line;

    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }

} catch (IOException e) {
    System.out.println("Ошибка чтения файла");
}
```

`BufferedWriter` используется для записи текста в файл.

Пример записи:

```java
try (BufferedWriter writer =
         new BufferedWriter(new FileWriter("output.txt"))) {

    writer.write("Привет, Java!");
    writer.newLine();
    writer.write("Запись в файл выполнена");

} catch (IOException e) {
    System.out.println("Ошибка записи файла");
}
```

Конструкция `try-with-resources` автоматически закрывает файл после завершения работы. Это лучше, чем вручную вызывать `close()`.

Потоки ввода-вывода применяются для сохранения настроек, логов, отчётов, текстовых файлов и других данных.

= Многопоточность

Многопоточность позволяет выполнять несколько частей программы одновременно. Поток – это отдельная последовательность выполнения внутри программы.

В Java поток можно создать двумя основными способами:

1. Наследоваться от класса `Thread`.
2. Реализовать интерфейс `Runnable`.

Пример через `Thread`:

```java
class MyThread extends Thread {
    public void run() {
        System.out.println("Поток запущен");
    }
}

MyThread thread = new MyThread();
thread.start();
```

Метод `start()` запускает новый поток. Метод `run()` содержит код, который будет выполняться в этом потоке.

Пример через `Runnable`:

```java
Runnable task = () -> {
    System.out.println("Задача выполняется");
};

Thread thread = new Thread(task);
thread.start();
```

Если несколько потоков работают с общими данными, может возникнуть конфликт. Для защиты данных используется синхронизация.

Пример:

```java
class Counter {
    private int value = 0;

    public synchronized void increment() {
        value++;
    }

    public int getValue() {
        return value;
    }
}
```

Ключевое слово `synchronized` не даёт нескольким потокам одновременно выполнять один и тот же критический участок кода.

Многопоточность применяется в серверных приложениях, обработке запросов, фоновых задачах и асинхронных вычислениях.

= Основы Spring Boot

Spring Boot – это фреймворк, который упрощает создание приложений на Java. Он основан на Spring Framework, но избавляет разработчика от большого количества ручной настройки.

Главная аннотация Spring Boot-приложения:

```java
@SpringBootApplication
```

Эта аннотация объединяет несколько возможностей:

- автоматическую конфигурацию;
- поиск компонентов приложения;
- запуск Spring-контейнера.

Пример главного класса:

```java
@SpringBootApplication
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}
```

Spring Boot сам настраивает встроенный сервер, например Tomcat, поэтому приложение можно запустить как обычную Java-программу.

Аннотация `@RestController` используется для создания REST-контроллера.

Пример:

```java
@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello";
    }
}
```

После запуска приложения endpoint `/hello` будет доступен через браузер или Postman.

Spring Boot часто используется для создания REST API, веб-приложений, микросервисов и серверной части информационных систем.

= REST API в Spring Boot

REST API – это способ взаимодействия клиента и сервера через HTTP-запросы. Клиент отправляет запрос, а сервер возвращает ответ, чаще всего в формате JSON.

Основные HTTP-методы:

- `GET` – получение данных;
- `POST` – создание данных;
- `PUT` – полное обновление данных;
- `PATCH` – частичное обновление;
- `DELETE` – удаление данных.

Пример GET-запроса:

```java
@RestController
@RequestMapping("/users")
public class UserController {

    @GetMapping
    public List<String> getUsers() {
        return List.of("Анна", "Иван");
    }
}
```

Если открыть `/users`, сервер вернёт список пользователей.

Пример POST-запроса:

```java
@PostMapping
public String createUser(@RequestBody String name) {
    return "Создан пользователь: " + name;
}
```

Аннотация `@RequestBody` говорит Spring, что данные нужно взять из тела запроса. Обычно в теле запроса передаётся JSON.

Пример JSON:

```json
{
  "name": "Анна",
  "age": 20
}
```

REST API применяется для связи фронтенда с сервером, мобильных приложений с базой данных, а также для интеграции разных систем.

= Dependency Injection

Dependency Injection – это внедрение зависимостей. Суть в том, что объект не создаёт нужные ему зависимости самостоятельно, а получает их извне.

В Spring Boot объекты создаёт и хранит Spring-контейнер. Такие объекты называются бинами. Контейнер сам определяет, какие классы нужны друг другу, и внедряет зависимости.

Пример сервиса:

```java
@Service
public class UserService {

    public String getMessage() {
        return "Список пользователей";
    }
}
```

Пример внедрения через `@Autowired`:

```java
@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/message")
    public String message() {
        return userService.getMessage();
    }
}
```

Spring сам создаст объект `UserService` и передаст его в контроллер.

Также зависимости можно внедрять через конструктор:

```java
@RestController
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }
}
```

Внедрение через конструктор считается более удобным и безопасным, потому что сразу видно, какие зависимости нужны классу.

Dependency Injection уменьшает связанность кода, упрощает тестирование и делает приложение более гибким.

= Работа с базой данных через Spring Data JPA

Spring Data JPA используется для работы с базой данных через Java-объекты. Вместо того чтобы вручную писать SQL-запросы для простых операций, разработчик создаёт сущности и репозитории.

Сущность – это Java-класс, который соответствует таблице в базе данных. Для обозначения сущности используется аннотация `@Entity`.

Пример сущности:

```java
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;
}
```

Аннотация `@Id` показывает первичный ключ. Аннотация `@GeneratedValue` указывает, что значение ключа будет генерироваться автоматически.

Репозиторий используется для выполнения операций с базой данных.

```java
public interface UserRepository
        extends JpaRepository<User, Long> {
}
```

После создания такого интерфейса становятся доступны методы:

- `findAll()` – получить все записи;
- `findById()` – найти по id;
- `save()` – сохранить или обновить объект;
- `delete()` – удалить объект;
- `count()` – посчитать количество записей.

Пример использования:

```java
@Service
public class UserService {

    private final UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    public List<User> getAll() {
        return repository.findAll();
    }
}
```

Spring Data JPA удобен тем, что позволяет быстро создавать CRUD-функциональность и связывать приложение с базой данных.

= Тестирование с JUnit

JUnit – это библиотека для unit-тестирования Java-кода. Unit-тест проверяет небольшую часть программы, например один метод.

Главная цель тестирования – убедиться, что код работает правильно и не ломается после изменений.

Пример класса:

```java
public class Calculator {

    public int sum(int a, int b) {
        return a + b;
    }
}
```

Пример теста:

```java
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CalculatorTest {

    @Test
    void testSum() {
        Calculator calculator = new Calculator();

        int result = calculator.sum(2, 3);

        assertEquals(5, result);
    }
}
```

Аннотация `@Test` показывает, что метод является тестом. Метод `assertEquals()` сравнивает ожидаемый и фактический результат.

Если результат совпал, тест проходит успешно. Если нет – тест завершается ошибкой.

Unit-тесты помогают быстрее находить ошибки и повышают надёжность программы.

= Сериализация объектов в JSON

Сериализация – это преобразование объекта в другой формат, например в JSON. Десериализация – обратный процесс, когда JSON преобразуется обратно в объект.

JSON часто используется в REST API, потому что он удобен для обмена данными между клиентом и сервером.

Пример класса:

```java
public class User {
    private String name;
    private int age;

    public User() {
    }

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

Пример сериализации с Jackson:

```java
ObjectMapper mapper = new ObjectMapper();

User user = new User("Анна", 20);

String json = mapper.writeValueAsString(user);

System.out.println(json);
```

Пример результата:

```json
{
  "name": "Анна",
  "age": 20
}
```

Пример десериализации:

```java
String json = "{\"name\":\"Анна\",\"age\":20}";

User user = mapper.readValue(json, User.class);
```

В Spring Boot сериализация и десериализация часто выполняются автоматически при работе с `@RequestBody` и ответами REST-контроллеров.

= Основы безопасности

Безопасность приложения нужна для защиты данных пользователя и предотвращения неправильного доступа к функциям системы.

Основные меры безопасности:

- проверка входных данных;
- ограничение доступа к защищённым endpoint'ам;
- хранение паролей в виде хеша;
- защита от SQL-инъекций;
- разграничение ролей пользователей;
- использование HTTPS в реальных проектах.

Проверка данных пользователя нужна для того, чтобы в систему не попадали некорректные или опасные значения.

Пример простой проверки:

```java
public void register(String username, String password) {
    if (username == null || username.isBlank()) {
        throw new IllegalArgumentException("Логин не может быть пустым");
    }

    if (password.length() < 6) {
        throw new IllegalArgumentException("Пароль слишком короткий");
    }
}
```

Базовая авторизация использует логин и пароль. Пользователь передаёт данные для входа, а сервер проверяет их и решает, можно ли дать доступ к ресурсу.

В Spring Security можно ограничить доступ к endpoint'ам, например разрешить один адрес всем, а другой только авторизованным пользователям.

Безопасность особенно важна в приложениях, где есть личные данные, платежи, роли пользователей и административные функции.

= Асинхронные методы

Асинхронные методы позволяют выполнять задачу в отдельном потоке, не блокируя основной поток программы. Это удобно, если операция выполняется долго: отправка письма, обработка файла, расчёт отчёта или обращение к внешнему сервису.

В Spring Boot для асинхронных методов используется аннотация `@Async`.

Чтобы включить поддержку асинхронности, нужно добавить `@EnableAsync`.

Пример:

```java
@Configuration
@EnableAsync
public class AsyncConfig {
}
```

Асинхронный метод:

```java
@Service
public class NotificationService {

    @Async
    public void sendMessage() throws InterruptedException {
        Thread.sleep(2000);
        System.out.println("Сообщение отправлено");
    }
}
```

Вызов метода:

```java
@RestController
public class NotificationController {

    private final NotificationService service;

    public NotificationController(NotificationService service) {
        this.service = service;
    }

    @GetMapping("/send")
    public String send() throws InterruptedException {
        service.sendMessage();
        return "Запрос принят";
    }
}
```

В этом примере клиент сразу получит ответ, а отправка сообщения выполнится отдельно.

Асинхронность полезна для повышения отзывчивости приложения, но её нужно использовать аккуратно, особенно если метод работает с общими данными.

= Планирование задач

Планирование задач нужно для автоматического выполнения методов по расписанию. В Spring Boot для этого используется аннотация `@Scheduled`.

Чтобы включить планировщик, нужно добавить `@EnableScheduling`.

Пример:

```java
@Configuration
@EnableScheduling
public class ScheduleConfig {
}
```

Пример задачи:

```java
@Component
public class ReportTask {

    @Scheduled(fixedRate = 5000)
    public void printMessage() {
        System.out.println("Задача выполняется каждые 5 секунд");
    }
}
```

Параметр `fixedRate = 5000` означает, что метод будет запускаться каждые 5000 миллисекунд.

Также можно использовать `cron`.

Пример:

```java
@Scheduled(cron = "0 0 12 * * *")
public void runEveryDay() {
    System.out.println("Задача выполняется каждый день в 12:00");
}
```

Планировщик задач применяется для регулярной очистки данных, формирования отчётов, проверки статусов, отправки уведомлений и других повторяющихся действий.

= Конфигурация приложения

Конфигурация Spring Boot-приложения обычно хранится в файле `application.properties`. В нём задают порт сервера, имя приложения, настройки базы данных, логирования и другие параметры.

Пример:

#raw(
  lang: "properties",
  "server.port=8081
spring.application.name=demo-app

app.owner=Student"
)

Порт `8081` означает, что приложение будет запускаться не на стандартном `8080`, а на другом порту.

Получить значение из конфигурации можно через аннотацию `@Value`.

Пример:

```java
@Component
public class AppInfo {

    @Value("${spring.application.name}")
    private String appName;

    @Value("${app.owner}")
    private String owner;

    public void printInfo() {
        System.out.println(appName + " " + owner);
    }
}
```

Также в `application.properties` часто прописывают подключение к базе данных:

#raw(
  lang: "properties",
  "spring.datasource.url=jdbc:postgresql://localhost:5432/demo
spring.datasource.username=postgres
spring.datasource.password=1234"
)

Вынос настроек в отдельный файл удобен тем, что можно менять параметры приложения без изменения Java-кода.

= MVC-паттерн

MVC – это архитектурный паттерн, который разделяет приложение на три части: Model, View и Controller.

Model отвечает за данные и бизнес-логику. Например, это могут быть классы `User`, `Order`, `Product`.

View отвечает за отображение данных пользователю. В Spring MVC для этого часто используется Thymeleaf.

Controller принимает запросы пользователя, вызывает нужные сервисы и передаёт данные во View.

Пример модели:

```java
public class User {
    private String name;

    public User(String name) {
        this.name = name;
    }
}
```

Пример контроллера:

```java
@Controller
public class PageController {

    @GetMapping("/profile")
    public String profile(Model model) {
        model.addAttribute("name", "Анна");
        return "profile";
    }
}
```

Пример представления `profile.html`:

#raw(
  lang: "html",
  "<h1 th:text=\"${name}\"></h1>"
)

MVC делает приложение более понятным: контроллер не отвечает за хранение данных, модель не занимается отображением, а представление не содержит основную бизнес-логику.

Этот подход часто используется в веб-приложениях.

= Swagger

Swagger – это инструмент для документирования и тестирования REST API. В современных Spring Boot-проектах обычно используется OpenAPI через библиотеку `springdoc-openapi`.

Swagger UI показывает список endpoint'ов, методы запросов, параметры, структуры JSON и возможные ответы сервера.

Основные преимущества Swagger:

- автоматическая генерация документации;
- возможность тестировать API прямо из браузера;
- удобство для разработчиков фронтенда;
- наглядное описание входных и выходных данных.

Пример зависимости для Maven:

#raw(
  lang: "xml",
  "<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.5.0</version>
</dependency>"
)

Пример контроллера:

```java
@RestController
@RequestMapping("/users")
public class UserController {

    @GetMapping
    public List<String> getUsers() {
        return List.of("Анна", "Иван");
    }
}
```

После подключения Swagger UI обычно доступен по адресу:

#raw(
  lang: "text",
  "/swagger-ui/index.html"
)

Swagger особенно полезен при разработке REST API, потому что документация обновляется вместе с кодом.

= Аннотации в Java

Аннотации – это специальные метки, которые добавляют к коду метаданные. Они могут применяться к классам, методам, полям, параметрам и другим элементам.

Аннотации не всегда напрямую изменяют поведение кода, но они могут использоваться компилятором, фреймворками или инструментами анализа.

Примеры стандартных аннотаций:

- `@Override` – показывает, что метод переопределяет метод родительского класса;
- `@Deprecated` – показывает, что элемент устарел;
- `@SuppressWarnings` – подавляет предупреждения компилятора.

Пример `@Override`:

```java
class User {

    @Override
    public String toString() {
        return "User";
    }
}
```

Пример `@Deprecated`:

```java
@Deprecated
public void oldMethod() {
    System.out.println("Старый метод");
}
```

В Spring аннотации используются очень активно:

- `@Component`;
- `@Service`;
- `@Repository`;
- `@Controller`;
- `@RestController`;
- `@Autowired`;
- `@Entity`.

Можно создавать собственные аннотации.

Пример:

```java
public @interface MyAnnotation {
    String value();
}
```

Аннотации делают код более декларативным: разработчик описывает, что нужно сделать, а фреймворк выполняет это автоматически.

= Лямбда-выражения и функциональные интерфейсы

Лямбда-выражения позволяют передавать поведение как значение. Они делают код короче и удобнее, особенно при работе с коллекциями и Stream API.

Лямбда имеет общий вид:

```java
(параметры) -> действие
```

Пример:

```java
List<String> names = List.of("Анна", "Иван");

names.forEach(name -> System.out.println(name));
```

Функциональный интерфейс – это интерфейс, у которого есть только один абстрактный метод.

Пример:

```java
@FunctionalInterface
interface Operation {
    int apply(int a, int b);
}
```

Использование:

```java
Operation sum = (a, b) -> a + b;

int result = sum.apply(2, 3);
```

Java уже содержит готовые функциональные интерфейсы:

- `Predicate<T>` – проверяет условие;
- `Function<T, R>` – преобразует значение;
- `Consumer<T>` – принимает значение и ничего не возвращает;
- `Supplier<T>` – возвращает значение.

Пример `Predicate`:

```java
Predicate<Integer> isEven = x -> x % 2 == 0;

System.out.println(isEven.test(4));
```

Лямбда-выражения часто используются вместе со Streams API, коллекциями и обработчиками событий.

= Streams API

Streams API используется для обработки коллекций в функциональном стиле. Stream – это поток данных, над которым можно выполнять операции фильтрации, преобразования, сортировки и сбора результата.

Важно понимать, что Stream обычно не изменяет исходную коллекцию, а формирует новый результат.

Основные операции:

- `filter` – фильтрация элементов;
- `map` – преобразование элементов;
- `sorted` – сортировка;
- `limit` – ограничение количества;
- `reduce` – свёртка значений;
- `collect` – сбор результата в коллекцию.

Пример фильтрации:

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6);

List<Integer> even = numbers.stream()
    .filter(x -> x % 2 == 0)
    .toList();

System.out.println(even);
```

Результат:

#raw(
  lang: "text",
  "[2, 4, 6]"
)

Пример преобразования:

```java
List<String> names = List.of("anna", "ivan");

List<String> upperNames = names.stream()
    .map(String::toUpperCase)
    .toList();
```

Пример суммы:

```java
int sum = numbers.stream()
    .reduce(0, Integer::sum);
```

Streams API делает код короче и понятнее, если нужно выполнить несколько операций над коллекцией.

Например: получить список имён пользователей старше 18 лет, отсортировать их и вернуть клиенту через REST API.

= Generics в Java

Generics – это обобщения. Они позволяют создавать классы, интерфейсы и методы, которые работают с разными типами данных, но при этом сохраняют безопасность типов.

Без Generics пришлось бы часто использовать тип `Object`, а затем вручную приводить типы. Это неудобно и может привести к ошибкам.

Пример обобщённого класса:

```java
class Box<T> {
    private T value;

    public void setValue(T value) {
        this.value = value;
    }

    public T getValue() {
        return value;
    }
}
```

Использование:

```java
Box<String> stringBox = new Box<>();
stringBox.setValue("Java");

String value = stringBox.getValue();
```

Здесь `T` заменяется на `String`.

Generics активно используются в коллекциях:

```java
List<String> names = new ArrayList<>();
Map<Integer, String> users = new HashMap<>();
```

Можно ограничить тип.

Пример:

```java
class NumberBox<T extends Number> {
    private T value;
}
```

`T extends Number` означает, что вместо `T` можно использовать только `Number` или его наследников, например `Integer`, `Double`, `Long`.

Generics повышают безопасность кода и позволяют находить ошибки ещё на этапе компиляции.

= Работа с датой и временем

В современных версиях Java для работы с датой и временем используются классы из пакета `java.time`.

Основные классы:

- `LocalDate` – дата без времени;
- `LocalTime` – время без даты;
- `LocalDateTime` – дата и время;
- `DateTimeFormatter` – форматирование даты и времени.

Пример текущей даты:

```java
LocalDate date = LocalDate.now();

System.out.println(date);
```

Пример текущего времени:

```java
LocalTime time = LocalTime.now();

System.out.println(time);
```

Пример даты и времени:

```java
LocalDateTime dateTime = LocalDateTime.now();

System.out.println(dateTime);
```

Создание конкретной даты:

```java
LocalDate examDate = LocalDate.of(2026, 5, 20);
```

Форматирование:

```java
DateTimeFormatter formatter =
    DateTimeFormatter.ofPattern("dd.MM.yyyy");

String text = examDate.format(formatter);
```

Пример результата:

#raw(
  lang: "text",
  "20.05.2026"
)

Работа с датой и временем нужна в расписаниях, заказах, логах, отчётах, бронировании и других системах.

= Паттерн Builder

Builder – это паттерн проектирования, который используется для пошагового создания сложных объектов.

Он полезен, когда у класса много полей, и не хочется создавать огромный конструктор с большим количеством параметров.

Проблема обычного конструктора:

```java
User user = new User("Анна", 20, "anna@mail.ru", true);
```

По такому коду не всегда понятно, что означает каждый аргумент.

Пример Builder:

```java
class User {
    private String name;
    private int age;
    private String email;

    private User(Builder builder) {
        this.name = builder.name;
        this.age = builder.age;
        this.email = builder.email;
    }

    public static class Builder {
        private String name;
        private int age;
        private String email;

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder age(int age) {
            this.age = age;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public User build() {
            return new User(this);
        }
    }
}
```

Использование:

```java
User user = new User.Builder()
    .name("Анна")
    .age(20)
    .email("anna@mail.ru")
    .build();
```

Такой код лучше читается, потому что видно, какие значения каким полям соответствуют.

Builder часто применяется для DTO, конфигурационных объектов и классов с большим количеством параметров.

= Паттерн Observer

Observer – это паттерн проектирования, который используется для уведомления одних объектов об изменениях в другом объекте.

Есть объект-источник, за которым наблюдают, и есть наблюдатели. Когда состояние источника меняется, он уведомляет всех наблюдателей.

Пример интерфейса наблюдателя:

```java
interface Observer {
    void update(String message);
}
```

Пример наблюдателя:

```java
class EmailObserver implements Observer {
    public void update(String message) {
        System.out.println("Email: " + message);
    }
}
```

Пример источника событий:

```java
class NewsPublisher {
    private List<Observer> observers = new ArrayList<>();

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void notifyObservers(String news) {
        for (Observer observer : observers) {
            observer.update(news);
        }
    }
}
```

Использование:

```java
NewsPublisher publisher = new NewsPublisher();

publisher.addObserver(new EmailObserver());
publisher.notifyObservers("Новая новость");
```

Observer применяется в системах уведомлений, графических интерфейсах, подписках, событиях и реактивном программировании.

= Кэширование и оптимизация

Кэширование – это сохранение результата операции для повторного использования. Если метод часто возвращает одни и те же данные, результат можно сохранить в кэше и не выполнять тяжёлую операцию каждый раз заново.

В Spring для кэширования используется Spring Cache.

Чтобы включить кэширование, добавляют аннотацию `@EnableCaching`.

Пример:

```java
@Configuration
@EnableCaching
public class CacheConfig {
}
```

Пример метода с кэшем:

```java
@Service
public class UserService {

    @Cacheable("users")
    public List<String> getUsers() {
        System.out.println("Загрузка пользователей");
        return List.of("Анна", "Иван");
    }
}
```

Аннотация `@Cacheable` означает, что результат метода будет сохранён. При следующем вызове с теми же параметрами Spring может вернуть данные из кэша.

Кэширование уменьшает нагрузку на базу данных и ускоряет работу приложения.

Но кэш нужно использовать аккуратно. Если данные часто меняются, можно получить устаревший результат. Для очистки кэша используются аннотации `@CacheEvict` и `@CachePut`.

Пример:

```java
@CacheEvict(value = "users", allEntries = true)
public void clearCache() {
}
```

Кэширование применяют для справочников, редко изменяемых данных, настроек и тяжёлых вычислений.

= Транзакции в Spring

Транзакция – это группа операций, которая должна выполниться полностью или не выполниться вообще.

Например, при оплате заказа нужно:

1. Списать деньги.
2. Создать запись об оплате.
3. Изменить статус заказа.

Если одна из операций завершится ошибкой, остальные изменения нужно отменить. Для этого используются транзакции.

В Spring транзакции обычно задаются аннотацией `@Transactional`.

Пример:

```java
@Service
public class PaymentService {

    @Transactional
    public void pay(Long orderId) {
        savePayment(orderId);
        updateOrderStatus(orderId);
    }

    private void savePayment(Long orderId) {
        System.out.println("Оплата сохранена");
    }

    private void updateOrderStatus(Long orderId) {
        System.out.println("Статус заказа изменён");
    }
}
```

Если внутри метода `pay()` произойдёт ошибка, Spring откатит изменения.

Основные свойства транзакции:

- атомарность – операции выполняются как единое целое;
- согласованность – данные остаются корректными;
- изолированность – параллельные транзакции не должны мешать друг другу;
- долговечность – после фиксации данные сохраняются.

Аннотация `@Transactional` часто используется в сервисном слое, где выполняется бизнес-логика.

= Документирование REST API

Документирование REST API нужно для того, чтобы разработчики понимали, какие запросы поддерживает сервер, какие параметры нужно передавать и какие ответы можно получить.

В Spring Boot для этого часто используют Swagger/OpenAPI.

Документация API обычно содержит:

- список endpoint'ов;
- HTTP-методы;
- параметры запроса;
- структуру JSON;
- коды ответов;
- описание ошибок.

Пример REST-контроллера:

```java
@RestController
@RequestMapping("/products")
public class ProductController {

    @GetMapping
    public List<String> getProducts() {
        return List.of("Ноутбук", "Телефон");
    }

    @PostMapping
    public String createProduct(@RequestBody String name) {
        return "Товар создан: " + name;
    }
}
```

Swagger автоматически найдёт эти методы и покажет их в интерфейсе документации.

Swagger UI удобен тем, что можно не только читать описание API, но и отправлять тестовые запросы прямо из браузера.

Документирование особенно важно, если над проектом работает несколько человек: backend-разработчики, frontend-разработчики, тестировщики и аналитики.

OpenAPI также можно использовать для генерации клиентского кода и схем API.