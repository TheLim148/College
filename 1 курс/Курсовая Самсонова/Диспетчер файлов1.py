import os
import shutil
import tkinter as tk
from tkinter import filedialog, messagebox, simpledialog
from tkinter import ttk
import zipfile
import time

class FileManager(tk.Tk):
    def __init__(self):
        super().__init__()

        # Настройка главного окна
        self.title("Файловый менеджер")  # Установка заголовка окна
        self.geometry("800x600")  # Установка размеров окна

        # Создание Treeview для отображения файлов и папок
        self.tree = ttk.Treeview(self, columns=("Name", "Size", "Date"))  # Создание виджета Treeview
        self.tree.heading("#0", text="Путь")  # Установка заголовка для первой колонки
        self.tree.heading("Name", text="Имя")  # Установка заголовка для колонки с именем файла/папки
        self.tree.heading("Size", text="Размер")  # Установка заголовка для колонки с размером файла
        self.tree.heading("Date", text="Дата")  # Установка заголовка для колонки с датой изменения
        self.tree.column("#0", width=300)  # Установка ширины первой колонки
        self.tree.pack(fill=tk.BOTH, expand=True)  # Заполнение окна виджетом Treeview

        # Создание меню
        self.menu = tk.Menu(self)  # Создание меню
        self.config(menu=self.menu)  # Установка меню в главное окно

        # Добавление пунктов меню "Файл"
        self.file_menu = tk.Menu(self.menu, tearoff=0)  # Создание подменю "Файл"
        self.menu.add_cascade(label="Файл", menu=self.file_menu)  # Добавление подменю "Файл" в меню
        self.file_menu.add_command(label="Новый каталог", command=self.create_directory)  # Добавление команды "Новый каталог"
        self.file_menu.add_command(label="Копировать", command=self.copy_item)  # Добавление команды "Копировать"
        self.file_menu.add_command(label="Переместить", command=self.move_item)  # Добавление команды "Переместить"
        self.file_menu.add_command(label="Удалить", command=self.delete_item)  # Добавление команды "Удалить"
        self.file_menu.add_command(label="Свойства", command=self.show_properties)  # Добавление команды "Свойства"
        self.file_menu.add_separator()  # Добавление разделителя
        self.file_menu.add_command(label="Вверх", command=self.go_up)  # Добавление команды "Вверх"
        self.file_menu.add_command(label="Выход", command=self.quit)  # Добавление команды "Выход"

        # Добавление пунктов меню "Архив"
        self.archive_menu = tk.Menu(self.menu, tearoff=0)  # Создание подменю "Архив"
        self.menu.add_cascade(label="Архив", menu=self.archive_menu)  # Добавление подменю "Архив" в меню
        self.archive_menu.add_command(label="Создать архив", command=self.create_archive)  # Добавление команды "Создать архив"
        self.archive_menu.add_command(label="Распаковать архив", command=self.extract_archive)  # Добавление команды "Распаковать архив"

        # Создание кнопок
        self.button_frame = tk.Frame(self)  # Создание фрейма для кнопок
        self.button_frame.pack(fill=tk.X)  # Заполнение горизонтально фрейма для кнопок

        self.copy_button = tk.Button(self.button_frame, text="Копировать", command=self.copy_item)  # Создание кнопки "Копировать"
        self.copy_button.pack(side=tk.LEFT)  # Размещение кнопки "Копировать" слева

        self.move_button = tk.Button(self.button_frame, text="Переместить", command=self.move_item)  # Создание кнопки "Переместить"
        self.move_button.pack(side=tk.LEFT)  # Размещение кнопки "Переместить" слева

        self.paste_button = tk.Button(self.button_frame, text="Вставить", command=self.paste_item, state=tk.DISABLED)  # Создание кнопки "Вставить"
        self.paste_button.pack(side=tk.LEFT)  # Размещение кнопки "Вставить" слева

        self.cut_item = None  # Инициализация переменной для перемещаемого элемента
        self.copied_item = None  # Инициализация переменной для копируемого элемента
        self.is_cut = False  # Флаг, указывающий на операцию перемещения

        # Обработчик двойного щелчка для перехода по каталогам
        self.tree.bind("<Double-1>", self.change_directory)  # Связывание двойного щелчка с функцией change_directory
        self.current_path = os.getcwd()  # Установка текущего пути
        self.refresh_tree()  # Обновление содержимого Treeview

    def refresh_tree(self):
        # Обновление содержимого Treeview
        for item in self.tree.get_children():  # Удаление всех элементов из Treeview
            self.tree.delete(item)

        # Добавление файлов и папок в Treeview
        for item in os.listdir(self.current_path):  # Проход по всем элементам текущего каталога
            full_path = os.path.join(self.current_path, item)  # Получение полного пути элемента
            if os.path.isdir(full_path):  # Проверка, является ли элемент папкой
                self.tree.insert("", "end", full_path, text=full_path, values=(item, "", time.ctime(os.path.getmtime(full_path))))  # Добавление папки в Treeview
            else:
                size = os.path.getsize(full_path)  # Получение размера файла
                self.tree.insert("", "end", full_path, text=full_path, values=(item, size, time.ctime(os.path.getmtime(full_path))))  # Добавление файла в Treeview

    def change_directory(self, event):
        # Переход в выбранный каталог
        selected_item = self.tree.selection()[0]  # Получение выбранного элемента
        if os.path.isdir(selected_item):  # Проверка, является ли элемент папкой
            self.current_path = selected_item  # Установка нового текущего пути
            self.refresh_tree()  # Обновление содержимого Treeview

    def go_up(self):
        # Переход на уровень вверх
        self.current_path = os.path.dirname(self.current_path)  # Получение родительского каталога
        self.refresh_tree()  # Обновление содержимого Treeview

    def create_directory(self):
        # Создание нового каталога
        new_dir_name = simpledialog.askstring("Новый каталог", "Введите имя нового каталога:")  # Запрос имени нового каталога
        if new_dir_name:  # Проверка, введено ли имя
            os.mkdir(os.path.join(self.current_path, new_dir_name))  # Создание нового каталога
            self.refresh_tree()  # Обновление содержимого Treeview

    def copy_item(self):
        # Копирование выбранного элемента
        selected_item = self.tree.selection()[0]  # Получение выбранного элемента
        self.copied_item = selected_item  # Сохранение пути копируемого элемента
        self.is_cut = False  # Сброс флага перемещения
        self.paste_button.config(state=tk.NORMAL)  # Активация кнопки "Вставить"

    def move_item(self):
        # Перемещение выбранного элемента
        selected_item = self.tree.selection()[0]  # Получение выбранного элемента
        self.cut_item = selected_item  # Сохранение пути перемещаемого элемента
        self.is_cut = True  # Установка флага перемещения
        self.paste_button.config(state=tk.NORMAL)  # Активация кнопки "Вставить"

    def paste_item(self):
        # Вставка скопированного или перемещенного элемента
        if self.is_cut:  # Проверка, выполняется ли операция перемещения
            if self.cut_item:  # Проверка, выбран ли элемент для перемещения
                destination = self.current_path  # Установка текущего пути как места назначения
                shutil.move(self.cut_item, destination)  # Перемещение элемента
                self.cut_item = None  # Сброс перемещаемого элемента
                self.is_cut = False  # Сброс флага перемещения
        else:
            if self.copied_item:  # Проверка, выбран ли элемент для копирования
                destination = self.current_path  # Установка текущего пути как места назначения
                if os.path.isdir(self.copied_item):  # Проверка, является ли элемент папкой
                    shutil.copytree(self.copied_item, os.path.join(destination, os.path.basename(self.copied_item)))  # Копирование папки
                else:
                    shutil.copy(self.copied_item, destination)  # Копирование файла
                self.copied_item = None  # Сброс копируемого элемента
        self.paste_button.config(state=tk.DISABLED)  # Деактивация кнопки "Вставить"
        self.refresh_tree()  # Обновление содержимого Treeview

    def delete_item(self):
        # Удаление выбранного элемента
        selected_item = self.tree.selection()[0]  # Получение выбранного элемента
        if os.path.isdir(selected_item):  # Проверка, является ли элемент папкой
            shutil.rmtree(selected_item)  # Удаление папки и всех ее содержимых
        else:
            os.remove(selected_item)  # Удаление файла
        self.refresh_tree()  # Обновление содержимого Treeview

    def show_properties(self):
        # Показ свойств выбранного элемента
        selected_item = self.tree.selection()[0]  # Получение выбранного элемента
        if os.path.isdir(selected_item):  # Проверка, является ли элемент папкой
            properties = f"Папка: {selected_item}\n"  # Формирование строки с информацией о папке
        else:
            size = os.path.getsize(selected_item)  # Получение размера файла
            properties = f"Файл: {selected_item}\nРазмер: {size} байт\n"  # Формирование строки с информацией о файле
        properties += f"Последнее изменение: {time.ctime(os.path.getmtime(selected_item))}"  # Добавление информации о последнем изменении
        messagebox.showinfo("Свойства", properties)  # Показ сообщения с информацией о свойствах

    def open_file(self):
        # Открытие файла с помощью программы по умолчанию
        selected_item = self.tree.selection()[0]  # Получение выбранного элемента
        try:
            os.startfile(selected_item)  # Открытие файла
        except Exception as e:
            messagebox.showerror("Ошибка", f"Не удалось открыть файл: {str(e)}")  # Показ сообщения об ошибке

    def create_archive(self):
        # Создание архива из выбранного элемента
        selected_item = self.tree.selection()[0]  # Получение выбранного элемента
        archive_name = simpledialog.askstring("Создать архив", "Введите имя архива (без расширения):")  # Запрос имени архива
        if archive_name:  # Проверка, введено ли имя архива
            try:
                shutil.make_archive(archive_name, 'zip', selected_item)  # Создание архива
                self.refresh_tree()  # Обновление содержимого Treeview
            except Exception as e:
                messagebox.showerror("Ошибка", f"Не удалось создать архив: {str(e)}")  # Показ сообщения об ошибке

    def extract_archive(self):
        # Распаковка архива
        archive_path = filedialog.askopenfilename(filetypes=[("ZIP files", "*.zip")])  # Запрос пути к архиву
        if archive_path:  # Проверка, выбран ли архив
            destination = filedialog.askdirectory()  # Запрос пути для распаковки
            if destination:  # Проверка, выбран ли путь для распаковки
                try:
                    with zipfile.ZipFile(archive_path, 'r') as zip_ref:  # Открытие архива
                        zip_ref.extractall(destination)  # Распаковка архива
                    self.refresh_tree()  # Обновление содержимого Treeview
                except Exception as e:
                    messagebox.showerror("Ошибка", f"Не удалось распаковать архив: {str(e)}")  # Показ сообщения об ошибке

if __name__ == "__main__":
    app = FileManager()  # Создание экземпляра FileManager
    app.mainloop()  # Запуск основного цикла программы


