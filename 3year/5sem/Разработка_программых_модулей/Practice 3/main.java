import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
import java.io.PrintStream;
import java.io.BufferedOutputStream;
import java.nio.charset.StandardCharsets;

public class Main {
    public static void main(String[] args) throws Exception {
        // форсируем UTF-8 для вывода
        System.setOut(new PrintStream(new BufferedOutputStream(System.out, 8192), true, StandardCharsets.UTF_8));
        System.setErr(new PrintStream(new BufferedOutputStream(System.err, 8192), true, StandardCharsets.UTF_8));

        SmartHomeDemo.main(args); // запускаем твою демо-программу
    }
}

/* =========================
   1. CORE & CONTROLLER
   ========================= */

// Интерфейс устройства
interface Device {
    void turnOn();
    void turnOff();
    String getStatus();
    String getName();
}

// Singleton — центр управления
class SmartHomeController {
    private static volatile SmartHomeController instance;
    private final List<Device> devices;

    private SmartHomeController() {
        // Инициализировать список устройств
        this.devices = new CopyOnWriteArrayList<>();
        System.out.println("Система умного дома инициализирована");
    }

    public static SmartHomeController getInstance() {
        // Double-Checked Locking
        if (instance == null) {
            synchronized (SmartHomeController.class) {
                if (instance == null) {
                    instance = new SmartHomeController();
                }
            }
        }
        return instance;
    }

    public void registerDevice(Device device) {
        if (device != null) {
            devices.add(device);
        }
    }

    public void listDevices() {
        if (devices.isEmpty()) {
            System.out.println("Устройства не зарегистрированы");
            return;
        }
        System.out.println("=== Список устройств ===");
        for (Device d : devices) {
            System.out.println("- " + d.getName() + " | " + d.getStatus());
        }
    }

    public List<Device> getDevices() {
        return devices;
    }
}

/* =========================
   1.2 FACTORY METHOD
   ========================= */

abstract class DeviceFactory {
    public abstract Device createDevice(String name);

    public Device createAndRegister(String name) {
        Device device = createDevice(name);
        SmartHomeController.getInstance().registerDevice(device);
        System.out.println("Устройство " + name + " создано и зарегистрировано");
        return device;
    }
}

// Light
class Light implements Device {
    private final String name;
    private boolean isOn;

    public Light(String name) {
        this.name = name;
        this.isOn = false;
    }

    @Override
    public void turnOn() {
        isOn = true;
        System.out.println(name + " включена");
    }

    @Override
    public void turnOff() {
        isOn = false;
        System.out.println(name + " выключена");
    }

    @Override
    public String getStatus() {
        return "Свет: " + (isOn ? "включен" : "выключен");
    }

    @Override
    public String getName() {
        return name;
    }
}

// Thermostat
class Thermostat implements Device {
    private final String name;
    private boolean isOn;
    private int temperature = 20;

    public Thermostat(String name) {
        this.name = name;
    }

    public void setTemperature(int temp) {
        this.temperature = temp;
        System.out.println(name + " установлена температура: " + temperature + "°C");
    }

    public int getTemperature() {
        return temperature;
    }

    @Override
    public void turnOn() {
        isOn = true;
        System.out.println(name + " включен");
    }

    @Override
    public void turnOff() {
        isOn = false;
        System.out.println(name + " выключен");
    }

    @Override
    public String getStatus() {
        return "Термостат: " + (isOn ? "включен" : "выключен") + ", " + temperature + "°C";
    }

    @Override
    public String getName() {
        return name;
    }
}

// Camera
class Camera implements Device {
    private final String name;
    private boolean isOn;
    private boolean recording;

    public Camera(String name) {
        this.name = name;
    }

    public void startRecording() {
        recording = true;
        System.out.println(name + " запись начата");
    }

    public void stopRecording() {
        recording = false;
        System.out.println(name + " запись остановлена");
    }

    @Override
    public void turnOn() {
        isOn = true;
        System.out.println(name + " включена");
    }

    @Override
    public void turnOff() {
        isOn = false;
        recording = false;
        System.out.println(name + " выключена");
    }

    @Override
    public String getStatus() {
        return "Камера: " + (isOn ? "включена" : "выключена") + (isOn ? (recording ? ", пишет" : ", не пишет") : "");
    }

    @Override
    public String getName() {
        return name;
    }
}

// Конкретные фабрики
class LightFactory extends DeviceFactory {
    @Override
    public Device createDevice(String name) {
        return new Light(name);
    }
}

class ThermostatFactory extends DeviceFactory {
    @Override
    public Device createDevice(String name) {
        return new Thermostat(name);
    }
}

class CameraFactory extends DeviceFactory {
    @Override
    public Device createDevice(String name) {
        return new Camera(name);
    }
}

/* =========================
   1.3 BUILDER
   ========================= */

class SmartHomeConfiguration {
    private final String homeName;
    private final String ownerName;
    private final int roomCount;
    private final boolean hasSecuritySystem;
    private final boolean hasClimateControl;
    private final String wifiSSID;

    private SmartHomeConfiguration(Builder builder) {
        this.homeName = builder.homeName;
        this.ownerName = builder.ownerName;
        this.roomCount = builder.roomCount;
        this.hasSecuritySystem = builder.hasSecuritySystem;
        this.hasClimateControl = builder.hasClimateControl;
        this.wifiSSID = builder.wifiSSID;
    }

    public static class Builder {
        private final String homeName;
        private final String ownerName;

        private int roomCount = 1;
        private boolean hasSecuritySystem = false;
        private boolean hasClimateControl = false;
        private String wifiSSID = "SmartHome_Default";

        public Builder(String homeName, String ownerName) {
            this.homeName = homeName;
            this.ownerName = ownerName;
        }

        public Builder roomCount(int count) {
            this.roomCount = Math.max(1, count);
            return this;
        }

        public Builder withSecuritySystem() {
            this.hasSecuritySystem = true;
            return this;
        }

        public Builder withClimateControl() {
            this.hasClimateControl = true;
            return this;
        }

        public Builder wifiSSID(String ssid) {
            if (ssid != null && !ssid.isEmpty()) {
                this.wifiSSID = ssid;
            }
            return this;
        }

        public SmartHomeConfiguration build() {
            return new SmartHomeConfiguration(this);
        }
    }

    @Override
    public String toString() {
        return "Конфигурация:\n" +
               "Дом: " + homeName + "\n" +
               "Владелец: " + ownerName + "\n" +
               "Комнат: " + roomCount + "\n" +
               "Система безопасности: " + (hasSecuritySystem ? "Да" : "Нет") + "\n" +
               "Климат-контроль: " + (hasClimateControl ? "Да" : "Нет") + "\n" +
               "WiFi: " + wifiSSID;
    }
}

/* =========================
   2.1 ADAPTER
   ========================= */

// Legacy lamp
class LegacyLamp {
    private final String name;
    private boolean powered;

    public LegacyLamp(String name) {
        this.name = name;
        this.powered = false;
    }

    public void switchOn() {
        powered = true;
        System.out.println("Старая лампа " + name + " включена");
    }

    public void switchOff() {
        powered = false;
        System.out.println("Старая лампа " + name + " выключена");
    }

    public boolean isPowered() {
        return powered;
    }

    public String getLampName() {
        return name;
    }
}

class LegacyLampAdapter implements Device {
    private final LegacyLamp legacyLamp;

    public LegacyLampAdapter(LegacyLamp legacyLamp) {
        this.legacyLamp = legacyLamp;
    }

    @Override
    public void turnOn() {
        legacyLamp.switchOn();
    }

    @Override
    public void turnOff() {
        legacyLamp.switchOff();
    }

    @Override
    public String getStatus() {
        return "LegacyLamp: " + (legacyLamp.isPowered() ? "включена" : "выключена");
    }

    @Override
    public String getName() {
        return legacyLamp.getLampName();
    }
}

/* =========================
   2.2 DECORATOR
   ========================= */

abstract class DeviceDecorator implements Device {
    protected final Device decoratedDevice;

    public DeviceDecorator(Device device) {
        this.decoratedDevice = device;
    }

    @Override
    public void turnOn() {
        decoratedDevice.turnOn();
    }

    @Override
    public void turnOff() {
        decoratedDevice.turnOff();
    }

    @Override
    public String getStatus() {
        return decoratedDevice.getStatus();
    }

    @Override
    public String getName() {
        return decoratedDevice.getName();
    }
}

class LoggingDecorator extends DeviceDecorator {
    public LoggingDecorator(Device device) { super(device); }

    @Override
    public void turnOn() {
        System.out.println("[LOG] Включение устройства: " + getName());
        System.out.println("[LOG] Время: " + java.time.LocalDateTime.now());
        super.turnOn();
    }

    @Override
    public void turnOff() {
        System.out.println("[LOG] Выключение устройства: " + getName());
        System.out.println("[LOG] Время: " + java.time.LocalDateTime.now());
        super.turnOff();
    }
}

class EnergySavingDecorator extends DeviceDecorator {
    private int energySaved;

    public EnergySavingDecorator(Device device) {
        super(device);
        this.energySaved = 0;
    }

    @Override
    public void turnOn() {
        System.out.println("[ENERGY] Режим энергосбережения активен для " + getName());
        super.turnOn();
        energySaved += 10;
    }

    @Override
    public String getStatus() {
        return decoratedDevice.getStatus() + " | EnergySaved=" + energySaved;
    }

    public int getEnergySaved() { return energySaved; }
}

// SecurityDecorator (пароль, лог, блокировка после 3 попыток)
class SecurityDecorator extends DeviceDecorator {
    private final String passwordHash;
    private int failedAttempts = 0;
    private boolean locked = false;
    private String attemptToken = ""; // сюда "подаём" попытку извне

    public SecurityDecorator(Device device, String passwordPlain) {
        super(device);
        this.passwordHash = Integer.toString(Objects.requireNonNullElse(passwordPlain, "").hashCode());
    }

    public void setAttempt(String attemptPlain) {
        this.attemptToken = attemptPlain == null ? "" : attemptPlain;
    }

    private boolean check() {
        if (locked) {
            System.out.println("[SECURITY] Устройство заблокировано: " + getName());
            return false;
        }
        boolean ok = passwordHash.equals(Integer.toString(attemptToken.hashCode()));
        if (!ok) {
            failedAttempts++;
            System.out.println("[SECURITY] Неудачная попытка доступа к " + getName() +
                               " (" + failedAttempts + "/3)");
            if (failedAttempts >= 3) {
                locked = true;
                System.out.println("[SECURITY] " + getName() + " заблокировано");
            }
        } else {
            failedAttempts = 0; // успешный вход сбрасывает счётчик
        }
        return ok;
    }

    @Override
    public void turnOn() {
        System.out.println("[SECURITY] Проверка доступа к " + getName());
        if (check()) {
            System.out.println("[SECURITY] Доступ разрешён");
            super.turnOn();
        } else {
            System.out.println("[SECURITY] Доступ запрещён");
        }
    }

    @Override
    public void turnOff() {
        // Выключение без проверки (можно поменять по требованию)
        super.turnOff();
    }

    public boolean isLocked() { return locked; }
}

/* =========================
   2.3 FACADE
   ========================= */

class SmartHomeFacade {
    private final SmartHomeController controller;
    private final LightFactory lightFactory;
    private final ThermostatFactory thermostatFactory;
    private final CameraFactory cameraFactory;

    public SmartHomeFacade() {
        this.controller = SmartHomeController.getInstance();
        this.lightFactory = new LightFactory();
        this.thermostatFactory = new ThermostatFactory();
        this.cameraFactory = new CameraFactory();
    }

    public void morningRoutine() {
        System.out.println("=== Запуск утреннего режима ===");
        for (Device d : controller.getDevices()) {
            if (d instanceof Light) d.turnOn();
            if (d instanceof Thermostat) ((Thermostat) d).setTemperature(22);
            if (d instanceof Camera) d.turnOff();
        }
    }

    public void eveningRoutine() {
        System.out.println("=== Запуск вечернего режима ===");
        for (Device d : controller.getDevices()) {
            if (d instanceof Light) {
                d.turnOn();
                System.out.println(d.getName() + ": свет приглушён (симуляция)");
            }
            if (d instanceof Thermostat) ((Thermostat) d).setTemperature(20);
            if (d instanceof Camera) d.turnOn();
        }
    }

    public void leaveHome() {
        System.out.println("=== Режим 'Ухожу из дома' ===");
        for (Device d : controller.getDevices()) {
            if (d instanceof Light) d.turnOff();
            if (d instanceof Thermostat) ((Thermostat) d).setTemperature(18);
            if (d instanceof Camera) d.turnOn();
        }
        System.out.println("Система безопасности: активирована (симуляция)");
    }

    public void arriveHome() {
        System.out.println("=== Режим 'Возвращение домой' ===");
        for (Device d : controller.getDevices()) {
            if (d instanceof Light && d.getName().toLowerCase().contains("прихож")) {
                d.turnOn();
            }
            if (d instanceof Thermostat) ((Thermostat) d).setTemperature(21);
        }
        System.out.println("Система безопасности: деактивирована (симуляция)");
    }
}

/* =========================
   3.1 COMMAND
   ========================= */

interface Command {
    void execute();
    void undo();
    String getDescription();
}

class TurnOnCommand implements Command {
    private final Device device;

    public TurnOnCommand(Device device) {
        this.device = device;
    }

    @Override
    public void execute() {
        device.turnOn();
    }

    @Override
    public void undo() {
        device.turnOff();
    }

    @Override
    public String getDescription() {
        return "Включение " + device.getName();
    }
}

class TurnOffCommand implements Command {
    private final Device device;

    public TurnOffCommand(Device device) {
        this.device = device;
    }

    @Override
    public void execute() {
        device.turnOff();
    }

    @Override
    public void undo() {
        device.turnOn();
    }

    @Override
    public String getDescription() {
        return "Выключение " + device.getName();
    }
}

class SetTemperatureCommand implements Command {
    private final Thermostat thermostat;
    private final int newTemp;
    private int prevTemp;

    public SetTemperatureCommand(Thermostat thermostat, int newTemp) {
        this.thermostat = thermostat;
        this.newTemp = newTemp;
        this.prevTemp = thermostat.getTemperature();
    }

    @Override
    public void execute() {
        prevTemp = thermostat.getTemperature();
        thermostat.setTemperature(newTemp);
    }

    @Override
    public void undo() {
        thermostat.setTemperature(prevTemp);
    }

    @Override
    public String getDescription() {
        return "Установка температуры " + thermostat.getName() + " -> " + newTemp + "°C";
    }
}

class MacroCommand implements Command {
    private final List<Command> commands;

    public MacroCommand() {
        this.commands = new ArrayList<>();
    }

    public void addCommand(Command command) {
        if (command != null) commands.add(command);
    }

    @Override
    public void execute() {
        System.out.println("Выполнение макрокоманды...");
        for (Command c : commands) c.execute();
    }

    @Override
    public void undo() {
        System.out.println("Отмена макрокоманды...");
        ListIterator<Command> it = commands.listIterator(commands.size());
        while (it.hasPrevious()) it.previous().undo();
    }

    @Override
    public String getDescription() {
        return "Макрокоманда (" + commands.size() + " команд)";
    }
}

class RemoteControl {
    private Command lastCommand;
    private final Stack<Command> commandHistory;

    public RemoteControl() {
        this.commandHistory = new Stack<>();
    }

    public void executeCommand(Command command) {
        command.execute();
        lastCommand = command;
        commandHistory.push(command);
        System.out.println("Выполнена команда: " + command.getDescription());
    }

    public void undoLastCommand() {
        if (!commandHistory.isEmpty()) {
            Command cmd = commandHistory.pop();
            System.out.println("Отмена команды: " + cmd.getDescription());
            cmd.undo();
        } else {
            System.out.println("История пуста");
        }
    }

    public void showHistory() {
        System.out.println("=== История команд ===");
        int i = 1;
        for (Command c : commandHistory) {
            System.out.println(i++ + ". " + c.getDescription());
        }
    }
}

/* =========================
   3.2 OBSERVER
   ========================= */

interface SmartHomeObserver {
    void update(String event, String deviceName);
}

interface SmartHomeSubject {
    void attach(SmartHomeObserver observer);
    void detach(SmartHomeObserver observer);
    void notifyObservers(String event, String deviceName);
}

class MonitoringSystem implements SmartHomeSubject {
    private final List<SmartHomeObserver> observers;

    public MonitoringSystem() {
        this.observers = new ArrayList<>();
    }

    @Override
    public void attach(SmartHomeObserver observer) {
        observers.add(observer);
        System.out.println("Наблюдатель подключен к системе мониторинга");
    }

    @Override
    public void detach(SmartHomeObserver observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers(String event, String deviceName) {
        for (SmartHomeObserver o : observers) {
            o.update(event, deviceName);
        }
    }

    public void registerDeviceEvent(String event, String deviceName) {
        System.out.println("[MONITOR] Событие: " + event + " для " + deviceName);
        notifyObservers(event, deviceName);
    }
}

class EmailNotifier implements SmartHomeObserver {
    private final String email;
    public EmailNotifier(String email) { this.email = email; }
    @Override
    public void update(String event, String deviceName) {
        System.out.println("[EMAIL to " + email + "] Устройство " + deviceName + ": " + event);
    }
}

class MobileAppNotifier implements SmartHomeObserver {
    private final String username;
    public MobileAppNotifier(String username) { this.username = username; }
    @Override
    public void update(String event, String deviceName) {
        System.out.println("[PUSH to " + username + "] " + deviceName + ": " + event);
    }
}

class EventLogger implements SmartHomeObserver {
    @Override
    public void update(String event, String deviceName) {
        String timestamp = java.time.LocalDateTime.now().toString();
        System.out.println("[LOG " + timestamp + "] " + deviceName + " - " + event);
    }
}

// SecurityAlertObserver
class SecurityAlertObserver implements SmartHomeObserver {
    private int alertCount = 0;

    @Override
    public void update(String event, String deviceName) {
        if (event.toLowerCase().contains("тревога") || event.toLowerCase().contains("взлом")) {
            alertCount++;
            System.out.println("[ALERT] КРИТИЧЕСКОЕ СОБЫТИЕ: " + deviceName + " -> " + event);
            System.out.println("[ALERT-LOG] (симуляция записи в файл) " + java.time.LocalDateTime.now()
                    + " | " + deviceName + " | " + event + " | total=" + alertCount);
        }
    }

    public int getAlertCount() { return alertCount; }
}

/* =========================
   3.3 STRATEGY
   ========================= */

interface EnergyStrategy {
    void applyStrategy(List<Device> devices);
    String getStrategyName();
}

class PerformanceStrategy implements EnergyStrategy {
    @Override
    public void applyStrategy(List<Device> devices) {
        System.out.println("Применение режима максимальной производительности");
        for (Device d : devices) d.turnOn();
    }
    @Override public String getStrategyName() { return "Максимальная производительность"; }
}

class EcoStrategy implements EnergyStrategy {
    @Override
    public void applyStrategy(List<Device> devices) {
        System.out.println("Применение режима энергосбережения");
        for (Device d : devices) {
            if (d instanceof Camera) {
                d.turnOn(); // камеры оставляем включёнными
            } else {
                d.turnOff();
            }
            if (d instanceof Thermostat) {
                ((Thermostat) d).setTemperature(18);
            }
        }
    }
    @Override public String getStrategyName() { return "Энергосбережение"; }
}

class BalancedStrategy implements EnergyStrategy {
    @Override
    public void applyStrategy(List<Device> devices) {
        System.out.println("Применение сбалансированного режима");
        for (int i = 0; i < devices.size(); i++) {
            Device d = devices.get(i);
            if (i % 2 == 0) d.turnOn(); else d.turnOff();
            if (d instanceof Thermostat) ((Thermostat) d).setTemperature(21);
        }
    }
    @Override public String getStrategyName() { return "Сбалансированный режим"; }
}

class EnergyManager {
    private EnergyStrategy strategy;
    private final List<Device> devices;

    public EnergyManager(List<Device> devices) {
        this.devices = devices;
        this.strategy = new BalancedStrategy(); // по умолчанию
    }

    public void setStrategy(EnergyStrategy strategy) {
        this.strategy = strategy;
        System.out.println("Стратегия изменена на: " + strategy.getStrategyName());
    }

    public void executeStrategy() {
        if (strategy != null) strategy.applyStrategy(devices);
    }
}

/* =========================
   4. DEMO / INTEGRATION
   ========================= */

class SmartHomeDemo {
    private static SmartHomeController controller;
    private static SmartHomeConfiguration config;
    private static MonitoringSystem monitoring;
    private static SmartHomeFacade facade;
    private static EnergyManager energyManager;

    // Для демонстрации декораторов
    private static Device decoratedLamp;

    public static void main(String[] args) {
        System.out.println("=== Инициализация системы умного дома ===\n");

        // 1. Singleton
        controller = SmartHomeController.getInstance();

        // 2. Builder
        config = new SmartHomeConfiguration.Builder("Мой умный дом", "Иван Иванов")
                .roomCount(4)
                .withSecuritySystem()
                .withClimateControl()
                .wifiSSID("MyHomeWiFi")
                .build();
        System.out.println(config + "\n");

        // 3. Factory Method — создание устройств
        System.out.println("=== Создание устройств ===");
        LightFactory lightFactory = new LightFactory();
        ThermostatFactory thermostatFactory = new ThermostatFactory();
        CameraFactory cameraFactory = new CameraFactory();

        Device light1 = lightFactory.createAndRegister("Лампа в гостиной");
        Device light2 = lightFactory.createAndRegister("Лампа в прихожей");
        Thermostat thermostat = (Thermostat) thermostatFactory.createAndRegister("Термостат");
        Camera camEntrance = (Camera) cameraFactory.createAndRegister("Камера на входе");

        // 4. Adapter — интеграция старого устройства
        LegacyLamp legacy = new LegacyLamp("Старая лампа в кабинете");
        Device legacyAdapted = new LegacyLampAdapter(legacy);
        controller.registerDevice(legacyAdapted);
        System.out.println("Legacy-устройство адаптировано и зарегистрировано");

        // 5. Decorator — добавляем функциональность к лампе
        System.out.println("\n=== Демонстрация паттерна Decorator ===");
        Device logged = new LoggingDecorator(light1);
        decoratedLamp = new EnergySavingDecorator(logged);
        decoratedLamp.turnOn(); // лог + энергосбережение + включение

        // SecurityDecorator демонстрация
        Device securedCamera = new SecurityDecorator(camEntrance, "1234");
        ((SecurityDecorator) securedCamera).setAttempt("0000"); // неверно
        securedCamera.turnOn();
        ((SecurityDecorator) securedCamera).setAttempt("1111"); // неверно
        securedCamera.turnOn();
        ((SecurityDecorator) securedCamera).setAttempt("1234"); // верно
        securedCamera.turnOn();

        // 6. Observer — система уведомлений
        System.out.println("\n=== Демонстрация паттерна Observer ===");
        monitoring = new MonitoringSystem();
        monitoring.attach(new EmailNotifier("user@example.com"));
        monitoring.attach(new MobileAppNotifier("Иван"));
        monitoring.attach(new EventLogger());
        SecurityAlertObserver alertObserver = new SecurityAlertObserver();
        monitoring.attach(alertObserver);

        monitoring.registerDeviceEvent("Включено", "Лампа в гостиной");
        monitoring.registerDeviceEvent("Тревога: движение у входа", "Камера на входе");

        // 7. Command — команды и пульт
        System.out.println("\n=== Демонстрация паттерна Command ===");
        RemoteControl remote = new RemoteControl();
        Command onThermo = new TurnOnCommand(thermostat);
        Command offCam = new TurnOffCommand(camEntrance);
        Command setTemp = new SetTemperatureCommand(thermostat, 22);

        remote.executeCommand(onThermo);
        remote.executeCommand(setTemp);
        remote.executeCommand(offCam);
        remote.showHistory();
        remote.undoLastCommand(); // отмена выключения камеры (включит её)

        // Macro
        MacroCommand morning = new MacroCommand();
        morning.addCommand(new TurnOnCommand(light2));
        morning.addCommand(new SetTemperatureCommand(thermostat, 21));
        remote.executeCommand(morning);
        remote.undoLastCommand();

        // 8. Strategy — режимы энергопотребления
        System.out.println("\n=== Демонстрация паттерна Strategy ===");
        energyManager = new EnergyManager(controller.getDevices());
        energyManager.executeStrategy(); // balanced по умолчанию
        energyManager.setStrategy(new EcoStrategy());
        energyManager.executeStrategy();
        energyManager.setStrategy(new PerformanceStrategy());
        energyManager.executeStrategy();

        // 9. Facade — упрощённые сценарии
        System.out.println("\n=== Демонстрация паттерна Facade ===");
        facade = new SmartHomeFacade();
        facade.morningRoutine();
        facade.eveningRoutine();
        facade.leaveHome();
        facade.arriveHome();

        // Финал
        System.out.println();
        controller.listDevices();
    }
}
