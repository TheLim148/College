#include <ncurses.h>

#include <algorithm>
#include <fstream>
#include <string>
#include <vector>

static std::vector<std::string> load_file(const std::string& path) {
    std::ifstream in(path);
    std::vector<std::string> lines;
    std::string s;
    while (std::getline(in, s)) lines.push_back(s);
    if (lines.empty()) lines.push_back("");
    return lines;
}

static bool save_file(const std::string& path, const std::vector<std::string>& lines) {
    std::ofstream out(path);
    if (!out.is_open()) return false;
    for (size_t i = 0; i < lines.size(); ++i) {
        out << lines[i];
        if (i + 1 < lines.size()) out << "\n";
    }
    return true;
}

static int digits(int x) {
    int d = 1;
    while (x >= 10) { x /= 10; d++; }
    return d;
}

static std::string input_line(const std::string& prompt, const std::string& initial) {
    int rows, cols;
    getmaxyx(stdscr, rows, cols);

    // строка ввода: предпоследняя
    int y = rows - 2;
    move(y, 0);
    clrtoeol();
    mvaddnstr(y, 0, prompt.c_str(), cols);

    // поле ввода справа от prompt
    int x0 = (int)prompt.size();
    int maxlen = std::max(0, cols - x0 - 1);

    echo();
    curs_set(1);

    std::string buf = initial;
    if ((int)buf.size() > maxlen) buf.resize(maxlen);

    // показать initial
    mvaddnstr(y, x0, buf.c_str(), maxlen);
    move(y, x0 + (int)buf.size());

    // читаем через getnstr в C-буфер
    std::vector<char> tmp((size_t)maxlen + 1, 0);
    std::copy(buf.begin(), buf.end(), tmp.begin());

    // getnstr читает до Enter
    getnstr(tmp.data(), maxlen);

    noecho();
    curs_set(0);

    return std::string(tmp.data());
}

static void draw(const std::string& filename,
                 const std::vector<std::string>& lines,
                 int cur, int top, bool dirty,
                 const std::string& msg) {
    int rows, cols;
    getmaxyx(stdscr, rows, cols);

    int text_rows = rows - 3; // 0..text_rows-1 текст, rows-2 ввод, rows-1 статус
    int lnw = digits((int)lines.size()) + 2;

    erase();

    for (int y = 0; y < text_rows; ++y) {
        int i = top + y;
        if (i >= (int)lines.size()) break;

        std::string ln = std::to_string(i + 1);
        while ((int)ln.size() < lnw - 2) ln = " " + ln;

        if (i == cur) attron(A_REVERSE);
        mvaddnstr(y, 0, ln.c_str(), lnw - 1);
        mvaddch(y, lnw - 1, ' ');

        int avail = cols - lnw;
        if (avail > 0) {
            mvaddnstr(y, lnw, lines[i].c_str(), avail);
        }
        if (i == cur) attroff(A_REVERSE);
    }

    // статус
    move(rows - 1, 0);
    clrtoeol();
    std::string s = filename + (dirty ? " *" : "") +
                    "  |  arrows:move  e:edit  a:add  d:del  s:save  q:quit";
    mvaddnstr(rows - 1, 0, s.c_str(), cols);

    // сообщение (над статусом можно, но тут в строке ввода показываем msg)
    move(rows - 2, 0);
    clrtoeol();
    if (!msg.empty()) mvaddnstr(rows - 2, 0, msg.c_str(), cols);

    refresh();
}

int main(int argc, char** argv) {
    std::string filename = (argc >= 2) ? argv[1] : "data.txt";
    auto lines = load_file(filename);

    int cur = 0;
    int top = 0;
    bool dirty = false;
    std::string msg;

    initscr();
    raw();
    noecho();
    keypad(stdscr, TRUE);
    curs_set(0);

    while (true) {
        int rows, cols;
        getmaxyx(stdscr, rows, cols);
        int text_rows = rows - 3;

        // удерживаем cur и top в допустимых пределах
        cur = std::clamp(cur, 0, (int)lines.size() - 1);
        if (cur < top) top = cur;
        if (cur >= top + text_rows) top = cur - text_rows + 1;
        if (top < 0) top = 0;

        draw(filename, lines, cur, top, dirty, msg);
        msg.clear();

        int ch = getch();

        if (ch == KEY_UP) cur--;
        else if (ch == KEY_DOWN) cur++;
        else if (ch == 'e') {
            std::string nl = input_line("edit: ", lines[cur]);
            if (nl != lines[cur]) {
                lines[cur] = nl;
                dirty = true;
            }
        } else if (ch == 'a') {
            std::string nl = input_line("add:  ", "");
            lines.insert(lines.begin() + cur + 1, nl);
            cur++;
            dirty = true;
        } else if (ch == 'd') {
            if (lines.size() > 1) {
                lines.erase(lines.begin() + cur);
                if (cur >= (int)lines.size()) cur = (int)lines.size() - 1;
            } else {
                lines[0].clear();
                cur = 0;
            }
            dirty = true;
        } else if (ch == 's') {
            if (save_file(filename, lines)) {
                dirty = false;
                msg = "saved";
            } else {
                msg = "save error";
            }
        } else if (ch == 'q') {
            if (!dirty) break;

            // простой confirm
            msg = "unsaved changes: press q again to quit, any key to cancel";
            draw(filename, lines, cur, top, dirty, msg);
            int ch2 = getch();
            if (ch2 == 'q') break;
        }
    }

    endwin();
    return 0;
}