import java.time.LocalDateTime;
import java.util.*;
import java.util.function.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;

/* ======================= БАЗА ======================= */

abstract class Participant {
    protected String name;
    protected int rating;
    protected LocalDateTime registrationDate;

    public Participant(String name) { this(name, 0, LocalDateTime.now()); }
    public Participant(String name, int rating) { this(name, rating, LocalDateTime.now()); }
    public Participant(String name, int rating, LocalDateTime registrationDate) {
        this.name = Objects.requireNonNull(name, "name");
        this.rating = rating;
        this.registrationDate = Objects.requireNonNull(registrationDate, "registrationDate");
    }

    public String getName() { return name; }
    public int getRating() { return rating; }
    public LocalDateTime getRegistrationDate() { return registrationDate; }
    public void setRating(int rating) { this.rating = rating; }

    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Participant that)) return false;
        return Objects.equals(name, that.name) && this.getClass().equals(that.getClass());
    }
    @Override public int hashCode() { return Objects.hash(getClass(), name); }
    @Override public String toString() {
        return "%s{name='%s', rating=%d, registered=%s}".formatted(getType(), name, rating, registrationDate);
    }

    public abstract String getType();
}

/* ======================= МУЗЫКА: ЖАНР/РОЛИ ======================= */

enum MusicGenre { ROCK, POP, JAZZ, METAL, INDIE, ELECTRONIC }

enum BandRole {
    VOCALS(true, "Вокал"),
    GUITAR(false, "Гитара"),
    BASS(false, "Бас"),
    DRUMS(false, "Ударные"),
    KEYBOARD(false, "Клавиши"),
    DJ(false, "DJ"),
    PRODUCER(false, "Продюсер"),
    MANAGER(false, "Менеджер");

    private final boolean frontman;
    private final String ru;
    BandRole(boolean frontman, String ru) { this.frontman = frontman; this.ru = ru; }
    public boolean isFrontman() { return frontman; }
    public String ru() { return ru; }
}

/* ======================= МУЗЫКАНТ/ГРУППА ======================= */

class Musician extends Participant {
    private final String nickname;
    private final BandRole role;
    private final int skillMonths;

    // «Свои методы»: оценки выступлений (0–10)
    private final List<Integer> performanceRatings = new ArrayList<>();

    public Musician(String name, String nickname, BandRole role, int skillMonths) {
        super(name);
        if (!ValidationUtils.isValidNickname(nickname)) throw new IllegalArgumentException("Неверный никнейм: " + nickname);
        if (skillMonths < 0) throw new IllegalArgumentException("Опыт не может быть отрицательным");
        this.nickname = nickname;
        this.role = Objects.requireNonNull(role, "role");
        this.skillMonths = skillMonths;
    }

    public Musician(String name, String nickname, BandRole role, int skillMonths, int rating) {
        super(name, rating);
        if (!ValidationUtils.isValidNickname(nickname)) throw new IllegalArgumentException("Неверный никнейм: " + nickname);
        if (skillMonths < 0) throw new IllegalArgumentException("Опыт не может быть отрицательным");
        this.nickname = nickname;
        this.role = Objects.requireNonNull(role, "role");
        this.skillMonths = skillMonths;
    }

    public String getNickname() { return nickname; }
    public BandRole getRole() { return role; }
    public int getSkillMonths() { return skillMonths; }

    // Свой метод: учесть оценку выступления
    public void addPerformanceRating(int score0to10) {
        if (score0to10 < 0 || score0to10 > 10) throw new IllegalArgumentException("Оценка должна быть 0..10");
        performanceRatings.add(score0to10);
    }
    // Свой метод: средняя оценка выступлений
    public OptionalDouble avgPerformanceRating() {
        return performanceRatings.stream().mapToInt(Integer::intValue).average();
    }

    @Override public String getType() { return "Musician"; }
    @Override public String toString() {
        return "Musician{name='%s', nick='%s', role=%s, exp=%d, rating=%d}"
                .formatted(name, nickname, role, skillMonths, rating);
    }
}

class Band extends Participant {
    public static final int MAX_MEMBERS = 8;
    private final List<Musician> members;
    private Musician frontman;
    private final String originCity;

    public Band(String name, String originCity) { this(name, originCity, new ArrayList<>(), null, 0); }
    public Band(String name, String originCity, List<Musician> members) { this(name, originCity, members, null, 0); }
    public Band(String name, String originCity, List<Musician> members, Musician frontman, int rating) {
        super(validateBandName(name), rating);
        this.originCity = Objects.requireNonNull(originCity, "originCity");
        this.members = new ArrayList<>();
        if (members != null) {
            if (members.size() > MAX_MEMBERS) throw new IllegalArgumentException("В группе максимум %d участников".formatted(MAX_MEMBERS));
            this.members.addAll(members);
        }
        if (frontman != null) setFrontman(frontman);
    }

    private static String validateBandName(String name) {
        if (!ValidationUtils.isValidTeamName(name)) throw new IllegalArgumentException("Неверное название группы: " + name);
        return name;
    }

    public List<Musician> getMembers() { return Collections.unmodifiableList(members); }
    public String getOriginCity() { return originCity; }
    public Optional<Musician> getFrontman() { return Optional.ofNullable(frontman); }

    public void addMusician(Musician m) {
        Objects.requireNonNull(m, "musician");
        if (members.size() >= MAX_MEMBERS) throw new IllegalStateException("Достигнут лимит участников: " + MAX_MEMBERS);
        if (members.contains(m)) throw new IllegalArgumentException("Музыкант уже в группе: " + m.getNickname());
        members.add(m);
    }
    public void removeMusician(Musician m) {
        if (!members.remove(m)) return;
        if (frontman != null && frontman.equals(m)) frontman = null;
    }
    public void setFrontman(Musician m) {
        if (!members.contains(m)) throw new IllegalArgumentException("Фронтмен должен быть из состава группы");
        this.frontman = m;
    }

    // Свой метод: автоназначение фронтмена по роли (VOCALS)
    public boolean autoAssignFrontmanByRole() {
    return members.stream()
            .filter(m -> m.getRole().isFrontman())
            .findFirst()
            .map(m -> { setFrontman(m); return true; })
            .orElse(false);
    }

    // Свой метод: средний рейтинг участников
    public double avgRating() {
        if (members.isEmpty()) return 0;
        return members.stream().mapToInt(Musician::getRating).average().orElse(0);
    }
    // Свой метод: выборка участников по условию
    public List<Musician> membersByRole(Predicate<Musician> predicate) {
        return members.stream().filter(predicate).toList();
    }

    @Override public String getType() { return "Band"; }
    @Override public String toString() {
        return "Band{name='%s', city='%s', rating=%d, members=%d, frontman=%s}"
                .formatted(name, originCity, rating, members.size(), frontman == null ? "-" : frontman.getNickname());
    }
}

/* ======================= РЕЗУЛЬТАТЫ БАТТЛОВ ======================= */

record BattleResult(
        String bandAName,
        String bandBName,
        int judgesA,     // голоса судей за A
        int judgesB,     // голоса судей за B
        int audienceA,   // очки зрителей за A
        int audienceB,   // очки зрителей за B
        LocalDateTime time,
        MusicGenre genre
) {
    public BattleResult {
        Objects.requireNonNull(bandAName, "bandAName");
        Objects.requireNonNull(bandBName, "bandBName");
        Objects.requireNonNull(time, "time");
        Objects.requireNonNull(genre, "genre");
        if (!ValidationUtils.isValidTeamName(bandAName)) throw new IllegalArgumentException("Неверное имя группы A: " + bandAName);
        if (!ValidationUtils.isValidTeamName(bandBName)) throw new IllegalArgumentException("Неверное имя группы B: " + bandBName);
        if (bandAName.equals(bandBName)) throw new IllegalArgumentException("Группы не могут совпадать");
        if (judgesA < 0 || judgesB < 0 || audienceA < 0 || audienceB < 0) throw new IllegalArgumentException("Очки не могут быть отрицательными");
        if (judgesA == 0 && judgesB == 0 && audienceA == 0 && audienceB == 0) throw new IllegalArgumentException("Пустой результат");
    }
    public int totalA(int wJudges, int wAudience) { return judgesA * wJudges + audienceA * wAudience; }
    public int totalB(int wJudges, int wAudience) { return judgesB * wJudges + audienceB * wAudience; }
    public int margin(int wJudges, int wAudience) { return Math.abs(totalA(wJudges, wAudience) - totalB(wJudges, wAudience)); }

    public Optional<String> winnerName(int wJudges, int wAudience) {
        int a = totalA(wJudges, wAudience), b = totalB(wJudges, wAudience);
        if (a > b) return Optional.of(bandAName);
        if (b > a) return Optional.of(bandBName);
        return Optional.empty();
    }
}

/* ======================= ТУРНИР ======================= */

class Tournament<T extends Participant> {
    private final String name;
    private final MusicGenre genre;
    private final List<T> participants = new ArrayList<>();
    private final List<BattleResult> battles = new ArrayList<>();

    public Tournament(String name, MusicGenre genre) {
        this.name = Objects.requireNonNull(name, "name");
        this.genre = Objects.requireNonNull(genre, "genre");
    }

    public String getName() { return name; }
    public MusicGenre getGenre() { return genre; }
    public List<T> getParticipants() { return Collections.unmodifiableList(participants); }
    public List<BattleResult> getBattles() { return Collections.unmodifiableList(battles); }

    public boolean addParticipant(T p) {
        Objects.requireNonNull(p, "participant");
        boolean exists = participants.stream().anyMatch(x -> x.getName().equals(p.getName()));
        if (exists) return false;
        return participants.add(p);
    }
    public boolean addParticipants(Collection<? extends T> ps) {
        boolean all = true;
        for (T p : ps) all &= addParticipant(p);
        return all;
    }
    public void addBattleResult(BattleResult result) { battles.add(Objects.requireNonNull(result, "result")); }

    public List<T> findParticipants(Predicate<T> predicate) {
        return participants.stream().filter(predicate).toList();
    }

    public static Tournament<Band> musicBandTournament(String name, MusicGenre genre) { return new Tournament<>(name, genre); }
    public static Tournament<Musician> soloistTournament(String name, MusicGenre genre) { return new Tournament<>(name, genre); }

    public List<T> filterParticipants(Predicate<T> condition) { return participants.stream().filter(condition).toList(); }
    public List<String> getParticipantNames(Function<T, String> nameExtractor) { return participants.stream().map(nameExtractor).toList(); }
    public void updateRatings(Consumer<T> ratingUpdater) { participants.forEach(ratingUpdater); }
}

/* ======================= ФУНКЦИОНАЛЬНЫЕ ИНТЕРФЕЙСЫ ======================= */

@FunctionalInterface
interface MusicScoringPolicy {
    // Возвращает дельту рейтинга для участника (с учётом победы и величины преимущества)
    int ratingDelta(BattleResult result, boolean isWinner, int wJudges, int wAudience);
}

@FunctionalInterface
interface BattleValidator { boolean isValid(Band a, Band b); }

@FunctionalInterface
interface RatingCalculator {
    int calculateNewRating(int oldRating, BattleResult result, boolean isWinner, int wJudges, int wAudience);
}

/* ======================= ВАЛИДАЦИЯ/РЕГЭКСПЫ ======================= */

class ValidationUtils {
    private static final String NICKNAME_PATTERN = "^[A-Za-z0-9_-]{3,16}$";
    private static final String TEAM_NAME_PATTERN = "^[A-Za-zА-Яа-я0-9 .,'&-]{2,40}$";
    private static final Pattern NICK_PATTERN = Pattern.compile(NICKNAME_PATTERN);
    private static final Pattern TEAM_PATTERN = Pattern.compile(TEAM_NAME_PATTERN);

    public static boolean isValidNickname(String nickname) {
        return nickname != null && NICK_PATTERN.matcher(nickname).matches();
    }
    public static boolean isValidTeamName(String teamName) {
        return teamName != null && TEAM_PATTERN.matcher(teamName).matches();
    }

    // Парсим строку баттла: "Band A 3+120:2+95 Band B"
    public static BattleResult parseMusicBattleResult(String s, MusicGenre genre) {
        String pattern = "^(?<a>.+?)\\s+(?<jA>\\d{1,2})\\s*\\+\\s*(?<audA>\\d{1,5})\\s*:\\s*(?<jB>\\d{1,2})\\s*\\+\\s*(?<audB>\\d{1,5})\\s+(?<b>.+)$";
        Matcher m = Pattern.compile(pattern).matcher(Objects.requireNonNull(s, "line"));
        if (!m.matches()) throw new IllegalArgumentException("Ожидался формат: BandA J+A : J+B BandB");

        String bandA = m.group("a").trim();
        String bandB = m.group("b").trim();
        int jA = Integer.parseInt(m.group("jA"));
        int jB = Integer.parseInt(m.group("jB"));
        int audA = Integer.parseInt(m.group("audA"));
        int audB = Integer.parseInt(m.group("audB"));

        if (!isValidTeamName(bandA) || !isValidTeamName(bandB))
            throw new IllegalArgumentException("Неверные названия групп: '%s' vs '%s'".formatted(bandA, bandB));

        return new BattleResult(bandA, bandB, jA, jB, audA, audB, LocalDateTime.now(), genre);
    }
}

/* ======================= КОНСОЛЬНОЕ МЕНЮ ======================= */

public class Main {
    private static final Scanner SC = new Scanner(System.in);

    public static void main(String[] args) {
        System.setOut(new PrintStream(System.out, true, StandardCharsets.UTF_8));
        Tournament<Band> tournament = Tournament.musicBandTournament("Local Music League", MusicGenre.ROCK);

        while (true) {
            System.out.println("\n=== Система управления МУЗЫКАЛЬНОЙ лигой ===");
            System.out.println("1. Зарегистрировать группу");
            System.out.println("2. Добавить музыканта в группу");
            System.out.println("3. Записать баттл (ввести результат)");
            System.out.println("4. Показать статистику");
            System.out.println("5. Выход");
            System.out.print("\nВыберите действие: ");

            String choice = SC.nextLine().trim();
            try {
                switch (choice) {
                    case "1" -> registerBand(tournament);
                    case "2" -> addMusicianToBand(tournament);
                    case "3" -> recordBattle(tournament);
                    case "4" -> showStats(tournament);
                    case "5" -> { System.out.println("До встречи!"); return; }
                    default -> System.out.println("Неизвестный пункт меню.");
                }
            } catch (Exception ex) {
                System.out.println("Ошибка: " + ex.getMessage());
            }
        }
    }

    /* 1. Регистрация группы */
    private static void registerBand(Tournament<Band> tour) {
        System.out.print("Введите название группы: ");
        String name = SC.nextLine().trim();
        System.out.print("Город/страна: ");
        String city = SC.nextLine().trim();

        Band band = new Band(name, city);
        boolean ok = tour.addParticipant(band);
        if (ok) System.out.println("Группа успешно зарегистрирована!");
        else System.out.println("Группа с таким названием уже есть в лиге.");
    }

    /* 2. Добавление музыканта */
    private static void addMusicianToBand(Tournament<Band> tour) {
        System.out.print("Введите ник музыканта: ");
        String nick = SC.nextLine().trim();

        System.out.print("Введите роль (VOCALS/GUITAR/BASS/DRUMS/KEYBOARD/DJ/PRODUCER/MANAGER): ");
        BandRole role = BandRole.valueOf(SC.nextLine().trim().toUpperCase(Locale.ROOT));

        System.out.print("Выберите группу: ");
        String bandName = SC.nextLine().trim();

        Band band = findBand(tour, bandName).orElseThrow(() -> new IllegalArgumentException("Группа не найдена: " + bandName));

        // name музыканта — пусть совпадает с ником
        Musician m = new Musician(nick, nick, role, 0, 0);
        band.addMusician(m);

        // Если фронтмен не назначен — пытаемся автоназначить по роли
        if (band.getFrontman().isEmpty()) {
            if (!band.autoAssignFrontmanByRole()) band.setFrontman(m);
        }
        System.out.println("Музыкант добавлен в группу!");
    }

    /* 3. Запись баттла */
    private static void recordBattle(Tournament<Band> tour) {
        System.out.println("Формат результата: BandA J+A : J+B BandB (пример: The Foxes 3+120:2+95 Night Owls)");
        System.out.print("Введите результат: ");
        String line = SC.nextLine();

        BattleResult result = ValidationUtils.parseMusicBattleResult(line, tour.getGenre());

        Band a = findBand(tour, result.bandAName()).orElseThrow(() -> new IllegalArgumentException("Группа не найдена: " + result.bandAName()));
        Band b = findBand(tour, result.bandBName()).orElseThrow(() -> new IllegalArgumentException("Группа не найдена: " + result.bandBName()));

        BattleValidator validator = (x, y) -> !x.getName().equals(y.getName()) && x.getFrontman().isPresent() && y.getFrontman().isPresent();
        if (!validator.isValid(a, b)) throw new IllegalStateException("Баттл некорректен (нужны разные группы и фронтмены).");

        tour.addBattleResult(result);

        // Политика начисления рейтинга: судьи важнее зрителей (веса)
        final int W_JUDGES = 10;
        final int W_AUDIENCE = 1;

        MusicScoringPolicy policy = (res, isWinner, wJ, wA) -> {
            int margin = res.margin(wJ, wA);
            if (margin == 0) return 0;                      // ничья
            int base = 12;
            int bonus = Math.min(10, margin / 20);          // чем больше разрыв — тем больше бонус, но ограничим
            int delta = base + bonus;
            return isWinner ? delta : -(delta / 2);
        };
        RatingCalculator rc = (oldRating, res, isWinner, wJ, wA) ->
                Math.max(0, oldRating + policy.ratingDelta(res, isWinner, wJ, wA));

        String winner = result.winnerName(W_JUDGES, W_AUDIENCE).orElse(null);
        tour.updateRatings(t -> {
            if (t.getName().equals(a.getName()) || t.getName().equals(b.getName())) {
                boolean isWinner = winner != null && t.getName().equals(winner);
                t.setRating(rc.calculateNewRating(t.getRating(), result, isWinner, W_JUDGES, W_AUDIENCE));
            }
        });

        System.out.println("Баттл сохранён. " + (winner == null ? "Ничья." : "Победитель: " + winner));
    }

    /* 4. Статистика */
    private static void showStats(Tournament<Band> tour) {
        System.out.println("\n--- Группы ---");
        if (tour.getParticipants().isEmpty()) {
            System.out.println("Пока нет зарегистрированных групп.");
        } else {
            for (Band t : tour.getParticipants()) {
                System.out.printf(Locale.ROOT, "%s | Город: %s | Рейтинг: %d | Состав: %d | Фронтмен: %s | AvgRating: %.1f%n",
                        t.getName(), t.getOriginCity(), t.getRating(), t.getMembers().size(),
                        t.getFrontman().map(Musician::getNickname).orElse("-"), t.avgRating());
            }
        }

        System.out.println("\n--- Последние баттлы ---");
        if (tour.getBattles().isEmpty()) {
            System.out.println("Баттлов пока нет.");
        } else {
            for (BattleResult br : tour.getBattles()) {
                System.out.printf("%s %d+%d : %d+%d %s [%s]%n",
                        br.bandAName(), br.judgesA(), br.audienceA(), br.judgesB(), br.audienceB(),
                        br.bandBName(), br.genre());
            }
        }
    }

    private static Optional<Band> findBand(Tournament<Band> tour, String name) {
        return tour.getParticipants().stream().filter(t -> t.getName().equals(name)).findFirst();
    }
}
