import java.time.LocalDateTime;
import java.util.*;
import java.util.function.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.io.PrintStream;
import java.nio.charset.StandardCharsets;

abstract class Participant {
    protected String name;
    protected int rating;
    protected LocalDateTime registrationDate;

    // TODO: Добавить конструкторы с перегрузкой
    public Participant(String name) {
        this(name, 0, LocalDateTime.now());
    }

    public Participant(String name, int rating) {
        this(name, rating, LocalDateTime.now());
    }

    public Participant(String name, int rating, LocalDateTime registrationDate) {
        this.name = Objects.requireNonNull(name, "name");
        this.rating = rating;
        this.registrationDate = Objects.requireNonNull(registrationDate, "registrationDate");
    }

    // Геттеры/сеттеры по необходимости
    public String getName() { return name; }
    public int getRating() { return rating; }
    public LocalDateTime getRegistrationDate() { return registrationDate; }
    public void setRating(int rating) { this.rating = rating; }

    // TODO: Реализовать equals(), hashCode(), toString()
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Participant that)) return false;
        // Считаем уникальность по типу и имени (имена в системе уникальны в рамках типа)
        return Objects.equals(name, that.name) && this.getClass().equals(that.getClass());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getClass(), name);
    }

    @Override
    public String toString() {
        return "%s{name='%s', rating=%d, registered=%s}"
                .formatted(getType(), name, rating, registrationDate);
    }

    // TODO: Добавить абстрактный метод getType()
    public abstract String getType();
}

class Player extends Participant {
    private final String nickname;
    private final PlayerRole role;
    private final int experience; // в месяцах

    public Player(String name, String nickname, PlayerRole role, int experience) {
        super(name);
        if (!ValidationUtils.isValidNickname(nickname)) {
            throw new IllegalArgumentException("Неверный никнейм: " + nickname);
        }
        if (experience < 0) {
            throw new IllegalArgumentException("Опыт не может быть отрицательным");
        }
        this.nickname = nickname;
        this.role = Objects.requireNonNull(role, "role");
        this.experience = experience;
    }

    public Player(String name, String nickname, PlayerRole role, int experience, int rating) {
        super(name, rating);
        if (!ValidationUtils.isValidNickname(nickname)) {
            throw new IllegalArgumentException("Неверный никнейм: " + nickname);
        }
        if (experience < 0) {
            throw new IllegalArgumentException("Опыт не может быть отрицательным");
        }
        this.nickname = nickname;
        this.role = Objects.requireNonNull(role, "role");
        this.experience = experience;
    }

    public String getNickname() { return nickname; }
    public PlayerRole getRole() { return role; }
    public int getExperience() { return experience; }

    @Override
    public String getType() { return "Player"; }

    @Override
    public String toString() {
        return "Player{name='%s', nick='%s', role=%s, exp=%d, rating=%d}"
                .formatted(name, nickname, role, experience, rating);
    }
}

class Team extends Participant {
    private final List<Player> players;
    private Player captain;
    private final String region;

    public static final int MAX_PLAYERS = 5;

    // Пустая команда (без игроков, капитан не назначен)
    public Team(String name, String region) {
        this(name, region, new ArrayList<>(), null, 0);
    }

    // Команда с набором игроков, без капитана (или капитан будет назначен позже)
    public Team(String name, String region, List<Player> players) {
        this(name, region, players, null, 0);
    }

    // Полный конструктор с рейтингом и капитаном
    public Team(String name, String region, List<Player> players, Player captain, int rating) {
        super(validateTeamName(name), rating);
        this.region = Objects.requireNonNull(region, "region");
        this.players = new ArrayList<>();
        if (players != null) {
            if (players.size() > MAX_PLAYERS) {
                throw new IllegalArgumentException("В команде максимум %d игроков".formatted(MAX_PLAYERS));
            }
            this.players.addAll(players);
        }
        if (captain != null) {
            setCaptain(captain); // проверит членство капитана в составе
        }
    }

    private static String validateTeamName(String name) {
        if (!ValidationUtils.isValidTeamName(name)) {
            throw new IllegalArgumentException("Неверное название команды: " + name);
        }
        return name;
    }

    public List<Player> getPlayers() { return Collections.unmodifiableList(players); }
    public String getRegion() { return region; }
    public Optional<Player> getCaptain() { return Optional.ofNullable(captain); }

    public void addPlayer(Player p) {
        Objects.requireNonNull(p, "player");
        if (players.size() >= MAX_PLAYERS) {
            throw new IllegalStateException("Достигнут лимит игроков: " + MAX_PLAYERS);
        }
        if (players.contains(p)) {
            throw new IllegalArgumentException("Игрок уже в команде: " + p.getNickname());
        }
        players.add(p);
    }

    public void removePlayer(Player p) {
        if (!players.remove(p)) return;
        if (captain != null && captain.equals(p)) {
            captain = null; // сняли игрока — снимаем капитана
        }
    }

    public void setCaptain(Player p) {
        if (!players.contains(p)) {
            throw new IllegalArgumentException("Капитан должен быть из состава команды");
        }
        this.captain = p;
    }

    @Override
    public String getType() { return "Team"; }

    @Override
    public String toString() {
        return "Team{name='%s', region='%s', rating=%d, players=%d, captain=%s}"
                .formatted(name, region, rating, players.size(),
                        captain == null ? "-" : captain.getNickname());
    }
}

enum PlayerRole {
    ENTRY_FRAGGER("Открывающий"),
    SUPPORT("Поддержка"),
    AWP("Снайпер"),
    IN_GAME_LEADER("Лидер"),
    RIFLER("Стрелок");

    // TODO: Добавить поля и методы
    private final String russianName;

    PlayerRole(String russianName) {
        this.russianName = russianName;
    }

    public String getRussianName() {
        return russianName;
    }

    public boolean isLeader() {
        return this == IN_GAME_LEADER;
    }
}

enum GameDiscipline {
    CS2, DOTA2, LOL, VALORANT
}

enum MatchStatus {
    SCHEDULED, IN_PROGRESS, FINISHED, CANCELLED
}

interface Captain {
    void makeStrategyDecision(String strategy);
    List<Player> selectStartingLineup();
}

interface Coach {
    void giveAdvice(Team team);
    void analyzeOpponent(Team opponent);
}

record MatchResult(
        String teamAName,
        String teamBName,
        int scoreA,
        int scoreB,
        LocalDateTime matchTime,
        GameDiscipline discipline
) {
    // TODO: Добавить методы для определения победителя
    public boolean isDraw() {
        return scoreA == scoreB;
    }

    public Optional<String> winnerName() {
        if (scoreA > scoreB) return Optional.of(teamAName);
        if (scoreB > scoreA) return Optional.of(teamBName);
        return Optional.empty();
    }

    public Optional<String> loserName() {
        if (scoreA < scoreB) return Optional.of(teamAName);
        if (scoreB < scoreA) return Optional.of(teamBName);
        return Optional.empty();
    }

    public int winnerScore() {
        if (scoreA > scoreB) return scoreA;
        if (scoreB > scoreA) return scoreB;
        throw new IllegalStateException("Ничья — победителя нет");
    }

    public int loserScore() {
        if (scoreA > scoreB) return scoreB;
        if (scoreB > scoreA) return scoreA;
        throw new IllegalStateException("Ничья — проигравшего нет");
    }

    // TODO: Валидация в конструкторе (компактный конструктор)
    public MatchResult {
        Objects.requireNonNull(teamAName, "teamAName");
        Objects.requireNonNull(teamBName, "teamBName");
        Objects.requireNonNull(matchTime, "matchTime");
        Objects.requireNonNull(discipline, "discipline");
        if (!ValidationUtils.isValidTeamName(teamAName))
            throw new IllegalArgumentException("Неверное имя команды A: " + teamAName);
        if (!ValidationUtils.isValidTeamName(teamBName))
            throw new IllegalArgumentException("Неверное имя команды B: " + teamBName);
        if (teamAName.equals(teamBName))
            throw new IllegalArgumentException("Команды не могут совпадать");
        if (scoreA < 0 || scoreB < 0)
            throw new IllegalArgumentException("Счет не может быть отрицательным");
    }
}

record PlayerStats(
        String playerNickname,
        int kills,
        int deaths,
        int assists,
        double rating
) {
    // TODO: Добавить вычисляемые методы (KDR, KAD)
    public double kdr() {
        // Kill-Death Ratio (если deaths == 0, считаем как kills)
        return deaths == 0 ? kills : (double) kills / deaths;
    }

    public double kad() {
        // (Kills + Assists) / Deaths (если deaths == 0, считаем как kills+assists)
        int ka = kills + assists;
        return deaths == 0 ? ka : (double) ka / deaths;
    }

    public PlayerStats {
        Objects.requireNonNull(playerNickname, "playerNickname");
        if (!ValidationUtils.isValidNickname(playerNickname))
            throw new IllegalArgumentException("Неверный никнейм: " + playerNickname);
        if (kills < 0 || deaths < 0 || assists < 0)
            throw new IllegalArgumentException("Статистика не может быть отрицательной");
        if (rating < 0)
            throw new IllegalArgumentException("Рейтинг не может быть отрицательным");
    }
}

class Tournament<T extends Participant> {
    private final String name;
    private final GameDiscipline discipline;
    private final List<T> participants;
    private final List<MatchResult> matches;

    public Tournament(String name, GameDiscipline discipline) {
        this.name = Objects.requireNonNull(name, "name");
        this.discipline = Objects.requireNonNull(discipline, "discipline");
        this.participants = new ArrayList<>();
        this.matches = new ArrayList<>();
    }

    public String getName() { return name; }
    public GameDiscipline getDiscipline() { return discipline; }
    public List<T> getParticipants() { return Collections.unmodifiableList(participants); }
    public List<MatchResult> getMatches() { return Collections.unmodifiableList(matches); }

    // TODO: Реализовать методы добавления участников
    public boolean addParticipant(T p) {
        Objects.requireNonNull(p, "participant");
        // Ограничение: имена в турнире должны быть уникальными внутри типа T
        boolean exists = participants.stream().anyMatch(x -> x.getName().equals(p.getName()));
        if (exists) return false;
        return participants.add(p);
    }

    public boolean addParticipants(Collection<? extends T> ps) {
        boolean all = true;
        for (T p : ps) {
            all &= addParticipant(p);
        }
        return all;
    }

    public void addMatchResult(MatchResult result) {
        Objects.requireNonNull(result, "result");
        matches.add(result);
    }

    // TODO: Создать метод для поиска участников по критериям
    public List<T> findParticipants(Predicate<T> predicate) {
        return participants.stream().filter(predicate).toList();
    }

    // TODO: Добавить ограничения на типы участников
    // В качестве простого и понятного ограничения — фабрики:
    public static Tournament<Team> teamTournament(String name, GameDiscipline discipline) {
        return new Tournament<>(name, discipline);
    }

    public static Tournament<Player> playerTournament(String name, GameDiscipline discipline) {
        return new Tournament<>(name, discipline);
    }

    // Фильтрация участников по условию
    public List<T> filterParticipants(Predicate<T> condition) {
        // TODO: Использовать Predicate для фильтрации
        return participants.stream().filter(condition).toList();
    }

    // Преобразование участников в строковое представление
    public List<String> getParticipantNames(Function<T, String> nameExtractor) {
        // TODO: Использовать Function для преобразования
        return participants.stream().map(nameExtractor).toList();
    }

    // Обновление рейтингов после матчей
    public void updateRatings(Consumer<T> ratingUpdater) {
        // TODO: Использовать Consumer для обновления
        participants.forEach(ratingUpdater);
    }
}

@FunctionalInterface
interface MatchValidator {
    boolean isValidMatch(Team teamA, Team teamB);
}

@FunctionalInterface
interface RatingCalculator {
    int calculateNewRating(int oldRating, MatchResult result, boolean isWinner);
}

class ValidationUtils {
    // Никнейм: латиница, цифры, _, -, длина 3-16 символов
    private static final String NICKNAME_PATTERN = "^[A-Za-z0-9_-]{3,16}$"; // TODO

    // Название команды: буквы/цифры/пробелы/знаки .,'&- , длина 2-30
    private static final String TEAM_NAME_PATTERN = "^.{2,30}$"; // TODO

    private static final Pattern NICK_PATTERN = Pattern.compile(NICKNAME_PATTERN);
    private static final Pattern TEAM_PATTERN = Pattern.compile(TEAM_NAME_PATTERN);

    public static boolean isValidNickname(String nickname) {
        // TODO: Использовать Pattern.matches()
        return nickname != null && NICK_PATTERN.matcher(nickname).matches();
    }

    public static boolean isValidTeamName(String teamName) {
        // TODO: Реализовать валидацию
        return teamName != null && TEAM_PATTERN.matcher(teamName).matches();
    }

    // Формат: "TeamA 16:14 TeamB"
    public static MatchResult parseMatchResult(String resultString) {
        String pattern = "^(?<teamA>.+?)\\s+(?<a>\\d{1,2})\\s*:\\s*(?<b>\\d{1,2})\\s+(?<teamB>.+)$"; // TODO
        // TODO: Использовать Pattern и Matcher
        Pattern p = Pattern.compile(pattern);
        Matcher m = p.matcher(Objects.requireNonNull(resultString, "resultString"));
        if (!m.matches()) {
            throw new IllegalArgumentException("Строка результата не распознана: " + resultString);
        }
        // TODO: Извлечь названия команд и счет
        String teamA = m.group("teamA").trim();
        String teamB = m.group("teamB").trim();
        int scoreA = Integer.parseInt(m.group("a"));
        int scoreB = Integer.parseInt(m.group("b"));

        if (!isValidTeamName(teamA) || !isValidTeamName(teamB)) {
            throw new IllegalArgumentException("Неверные названия команд: '%s' vs '%s'".formatted(teamA, teamB));
        }
        // Дисциплину и время в сигнатуре не передали — зададим разумные значения по умолчанию
        return new MatchResult(teamA, teamB, scoreA, scoreB, LocalDateTime.now(), GameDiscipline.CS2);
    }
}

class Main {
    private static final Scanner SC = new Scanner(System.in);

    public static void main(String[] args) {
        System.setOut(new PrintStream(System.out, true, StandardCharsets.UTF_8));
        Tournament<Team> tournament = Tournament.teamTournament("Demo Cup", GameDiscipline.CS2);

        while (true) {
            System.out.println("\n=== Система управления турниром ===");
            System.out.println("1. Зарегистрировать команду");
            System.out.println("2. Добавить игрока в команду");
            System.out.println("3. Создать матч");
            System.out.println("4. Показать статистику");
            System.out.println("5. Выход");
            System.out.print("\nВыберите действие: ");

            String choice = SC.nextLine().trim();
            try {
                switch (choice) {
                    case "1" -> registerTeam(tournament);
                    case "2" -> addPlayerToTeam(tournament);
                    case "3" -> createMatch(tournament);
                    case "4" -> showStats(tournament);
                    case "5" -> { System.out.println("До встречи!"); return; }
                    default -> System.out.println("Неизвестный пункт меню.");
                }
            } catch (Exception ex) {
                System.out.println("Ошибка: " + ex.getMessage());
            }
        }
    }

    /* === 1. Регистрация команды === */
    private static void registerTeam(Tournament<Team> tour) {
        System.out.print("Введите название команды: ");
        String name = SC.nextLine().trim();
        System.out.print("Введите регион: ");
        String region = SC.nextLine().trim();

        Team team = new Team(name, region);
        boolean ok = tour.addParticipant(team);
        if (ok) System.out.println("Команда успешно зарегистрирована!");
        else System.out.println("Команда с таким названием уже есть в турнире.");
    }

    /* === 2. Добавление игрока === */
    private static void addPlayerToTeam(Tournament<Team> tour) {
        System.out.print("Введите никнейм игрока: ");
        String nick = SC.nextLine().trim();

        System.out.print("Введите роль (ENTRY_FRAGGER/SUPPORT/AWP/IN_GAME_LEADER/RIFLER): ");
        String roleStr = SC.nextLine().trim().toUpperCase(Locale.ROOT);
        PlayerRole role = PlayerRole.valueOf(roleStr);

        System.out.print("Выберите команду: ");
        String teamName = SC.nextLine().trim();

        Team team = findTeam(tour, teamName)
                .orElseThrow(() -> new IllegalArgumentException("Команда не найдена: " + teamName));

        // name игрока заполняем ником, опыт/рейтинг по умолчанию
        Player p = new Player(nick, nick, role, 0, 0);
        team.addPlayer(p);

        // Если капитан ещё не назначен — назначим первого добавленного
        if (team.getCaptain().isEmpty()) {
            team.setCaptain(p);
        }
        System.out.println("Игрок добавлен в команду!");
    }

    /* === 3. Создание матча по строке "TeamA 16:14 TeamB" === */
    private static void createMatch(Tournament<Team> tour) {
        System.out.print("Введите результат матча (например: TeamA 16:14 TeamB): ");
        String line = SC.nextLine();

        MatchResult result = ValidationUtils.parseMatchResult(line);

        // Проверим, что обе команды зарегистрированы
        Team a = findTeam(tour, result.teamAName())
                .orElseThrow(() -> new IllegalArgumentException("Команда не найдена: " + result.teamAName()));
        Team b = findTeam(tour, result.teamBName())
                .orElseThrow(() -> new IllegalArgumentException("Команда не найдена: " + result.teamBName()));

        // Простой валидатор матча: у обеих есть капитан, названия различаются
        MatchValidator validator = (x, y) ->
                !x.getName().equals(y.getName()) && x.getCaptain().isPresent() && y.getCaptain().isPresent();
        if (!validator.isValidMatch(a, b)) {
            throw new IllegalStateException("Матч некорректен (нужны разные команды и капитаны).");
        }

        tour.addMatchResult(result);

        // Простейшее обновление рейтинга
        RatingCalculator rc = (oldRating, res, isWinner) -> {
            if (res.isDraw()) return oldRating;
            int delta = 18;
            return isWinner ? oldRating + delta : Math.max(0, oldRating - delta / 2);
        };

        String winner = result.winnerName().orElse(null);
        tour.updateRatings(t -> {
            if (t.getName().equals(a.getName()) || t.getName().equals(b.getName())) {
                boolean isWinner = winner != null && t.getName().equals(winner);
                t.setRating(rc.calculateNewRating(t.getRating(), result, isWinner));
            }
        });

        System.out.println(
                "Матч создан. " +
                (winner == null ? "Ничья." : "Победитель: " + winner)
        );
    }

    /* === 4. Показ статистики === */
    private static void showStats(Tournament<Team> tour) {
        System.out.println("\n--- Команды ---");
        if (tour.getParticipants().isEmpty()) {
            System.out.println("Пока нет зарегистрированных команд.");
        } else {
            for (Team t : tour.getParticipants()) {
                System.out.printf(Locale.ROOT,
                        "%s | Регион: %s | Рейтинг: %d | Игроков: %d | Капитан: %s%n",
                        t.getName(), t.getRegion(), t.getRating(), t.getPlayers().size(),
                        t.getCaptain().map(Player::getNickname).orElse("-"));
            }
        }

        System.out.println("\n--- Последние матчи ---");
        if (tour.getMatches().isEmpty()) {
            System.out.println("Матчей пока нет.");
        } else {
            for (MatchResult mr : tour.getMatches()) {
                System.out.printf("%s %d:%d %s [%s]%n",
                        mr.teamAName(), mr.scoreA(), mr.scoreB(), mr.teamBName(), mr.discipline());
            }
        }
    }

    private static Optional<Team> findTeam(Tournament<Team> tour, String name) {
        return tour.getParticipants().stream()
                .filter(t -> t.getName().equals(name))
                .findFirst();
    }
}
