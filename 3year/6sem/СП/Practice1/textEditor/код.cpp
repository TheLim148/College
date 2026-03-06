#include <iostream>
#include <fstream>
#include <windows.h>

using namespace std;

const int MAX_LINES = 200;
const int MAX_COLS = 200;

const int COLOR_DEFAULT = 7; // белый
const int COLOR_STATUS = 10; // зеленый
const int COLOR_ERROR = 12; // красный
const int COLOR_CURRENT = 14; // желтый
const int COLOR_NUMBER = 8; // серый
const int COLOR_INSERT = 13; // розовый
const int COLOR_SEPARATOR = 11; // голубой

void setColor(int color) {
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color);
}

const char BASE_PATH[] = "C:\\Users\\Admin\\Desktop\\myVim\\";

int slen(const char s[]) { // длина строки
    int i = 0;
    while (s[i] != '\0') i++;
    return i;
}

void scopy(char dst[], const char src[]) { // копирование строки
    int i = 0;
    while (src[i] != '\0' && i < MAX_COLS - 1) {
        dst[i] = src[i];
        i++;
    }
    dst[i] = '\0';
}

bool streq(const char* a, const char* b) { // сравнение строк
    int i = 0;
    while (a[i] && b[i]) {
        if (a[i] != b[i]) return false;
        i++;
    }
    return a[i] == '\0' && b[i] == '\0';
}

void build_full_path(char full[], const char name[]) { // путь к файлу
    int i = 0, j = 0;
    while (BASE_PATH[i] != '\0') full[i] = BASE_PATH[i], i++;
    while (name[j] != '\0' && i < 511) full[i] = name[j], i++, j++;
    full[i] = '\0';
}

void load_file(const char* filepath, char lines[][MAX_COLS], int& n) { // загрузка и сохранение файлов
    ifstream in(filepath);
    n = 0;
    if (!in.is_open()) {
        n = 1;
        lines[0][0] = '\0';
        return;
    }
    while (n < MAX_LINES && in.getline(lines[n], MAX_COLS)) n++;
    if (n == 0) {
        n = 1;
        lines[0][0] = '\0';
    }
    in.close();
}

void save_file(const char* filepath, char lines[][MAX_COLS], int n) {
    ofstream out(filepath);
    for (int i = 0; i < n; i++) out << lines[i] << "\n";
    out.close();
}

void clear_screen() {
    system("cls");
}

void print_screen(char lines[][MAX_COLS], int n, int cur, bool insertMode, const char* filename, bool dirty) {
    clear_screen();

    setColor(insertMode ? COLOR_INSERT : COLOR_STATUS);
    cout << (insertMode ? "-- INSERT --" : "-- NORMAL --");
    setColor(COLOR_DEFAULT);
    cout << "   file: ";
    setColor(COLOR_STATUS);
    cout << filename;
    if (dirty) {
        setColor(COLOR_ERROR);
        cout << " *";
    }
    setColor(COLOR_DEFAULT);
    cout << "\n";

    setColor(COLOR_SEPARATOR);
    cout << "j/k move | i insert | o new line | dd delete line | :w :q :wq :o file :q!\n";

    setColor(COLOR_NUMBER);
    cout << "-------------------------------------------------------------\n";
    setColor(COLOR_DEFAULT);

    for (int i = 0; i < n; i++) {
        setColor(COLOR_NUMBER);
        if (i + 1 < 10)       cout << "  ";
        else if (i + 1 < 100) cout << " ";
        cout << (i + 1) << " | ";

        if (i == cur) {
            setColor(COLOR_CURRENT);
            cout << "> ";
        }
        else {
            setColor(COLOR_NUMBER);
            cout << "  ";
        }

        setColor(i == cur ? COLOR_CURRENT : COLOR_DEFAULT);
        cout << lines[i] << "\n";
    }

    setColor(COLOR_NUMBER);
    cout << "-------------------------------------------------------------\n";
    setColor(COLOR_DEFAULT);

    if (!insertMode) { // строка ожидания команды
        setColor(COLOR_STATUS);
        cout << "I need you command: ";
        setColor(COLOR_DEFAULT);
    }
}

void delete_line(char lines[][MAX_COLS], int& n, int& cur) {
    if (n <= 1) {
        lines[0][0] = '\0';
        cur = 0;
        return;
    }
    for (int i = cur; i < n - 1; i++) scopy(lines[i], lines[i + 1]);
    n--;
    if (cur >= n) cur = n - 1;
}

void insert_line_below(char lines[][MAX_COLS], int& n, int& cur) {
    if (n >= MAX_LINES) return;
    for (int i = n; i > cur + 1; i--) scopy(lines[i], lines[i - 1]);
    lines[cur + 1][0] = '\0';
    n++;
    cur++;
}

int main() {
    SetConsoleOutputCP(1251);
    SetConsoleCP(1251);

    setColor(COLOR_STATUS);
    cout << "Файлы в папке: ";
    setColor(COLOR_DEFAULT);
    cout << BASE_PATH << "\n\n";

    char filename[256];
    setColor(COLOR_CURRENT);
    cout << "Имя файла + .txt : ";
    setColor(COLOR_DEFAULT);
    cin.getline(filename, 256);

    char fullpath[512];
    char lines[MAX_LINES][MAX_COLS];
    int n = 0;

    build_full_path(fullpath, filename);
    load_file(fullpath, lines, n);

    int cur = 0;
    bool insertMode = false;
    bool dirty = false;

    while (true) {
        print_screen(lines, n, cur, insertMode, filename, dirty);

        if (insertMode) {
            setColor(COLOR_INSERT);
            cout << "Edit line " << (cur + 1) << ": ";
            setColor(COLOR_DEFAULT);

            char buf[MAX_COLS];
            cin.getline(buf, MAX_COLS);

            scopy(lines[cur], buf);
            dirty = true;
            insertMode = false;
            continue;
        }

        char cmdline[128];
        cin.getline(cmdline, 128);

        if (cmdline[0] == ':') {
            if (streq(cmdline, ":wq")) {
                build_full_path(fullpath, filename);
                save_file(fullpath, lines, n);
                setColor(COLOR_STATUS);
                cout << "\nСохранено) Выход...\n";
                setColor(COLOR_DEFAULT);
                break;
            }
            else if (streq(cmdline, ":w")) {
                build_full_path(fullpath, filename);
                save_file(fullpath, lines, n);
                dirty = false;
                continue;
            }
            else if (streq(cmdline, ":q!")) {
                break;
            }
            else if (streq(cmdline, ":q")) {
                if (dirty) {
                    setColor(COLOR_ERROR);
                    cout << "Есть несохранённые изменения :(\n Сохрани :w или выйди :wq / :q!\n";
                    cout << "Жми Enter";
                    setColor(COLOR_DEFAULT);
                    cin.get();
                    continue;
                }
                break;
            }
            else if (cmdline[1] == 'o' && cmdline[2] == ' ') {
                int i = 3, j = 0;
                while (cmdline[i] != '\0' && j < 255) filename[j] = cmdline[i], i++, j++;
                filename[j] = '\0';

                build_full_path(fullpath, filename);
                load_file(fullpath, lines, n);
                cur = 0;
                dirty = false;
                continue;
            }
            continue;
        }

        if (streq(cmdline, "dd")) {
            delete_line(lines, n, cur);
            dirty = true;
        }
        else if (streq(cmdline, "j")) {
            if (cur < n - 1) cur++;
        }
        else if (streq(cmdline, "k")) {
            if (cur > 0) cur--;
        }
        else if (streq(cmdline, "i")) {
            insertMode = true;
        }
        else if (streq(cmdline, "o")) {
            insert_line_below(lines, n, cur);
            dirty = true;
            insertMode = true;
        }
    }

    return 0;
}