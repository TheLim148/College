
# -*- coding: utf-8 -*-
"""
Решения заданий из Practice_1.ipynb.
Ожидается наличие файла StudentsPerformance.csv в текущей директории.
Источник датасета (типовая структура):
    - gender (male/female)
    - race/ethnicity (group A..E)
    - parental level of education
    - lunch (standard/free/reduced)
    - test preparation course (none/completed)
    - math score, reading score, writing score (0..100)
"""

import pandas as pd
import numpy as np

def load_data(csv_path="StudentsPerformance.csv"):
    df = pd.read_csv(csv_path)
    # Нормализуем имена колонок под стандартный стиль, если требуется
    cols = {c:c.strip() for c in df.columns}
    df = df.rename(columns=cols)
    # Убедимся, что числовые колонки в верном типе
    for col in ["math score", "reading score", "writing score"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    return df

def task1_golden_five(df: pd.DataFrame) -> pd.DataFrame:
    """Задание 1. «Золотая пятёрка»:
    Найти учеников, у которых math, reading, writing >= 90.
    Добавить total_score = sum трех оценок.
    Вернуть таблицу с колонками: gender, math score, reading score, writing score, total_score.
    Также вывести количество таких учеников.
    """
    stars = df[
        (df["math score"] >= 90) &
        (df["reading score"] >= 90) &
        (df["writing score"] >= 90)
    ].copy()
    stars["total_score"] = stars["math score"] + stars["reading score"] + stars["writing score"]
    # Упорядочим по total_score убыв.
    stars = stars.sort_values("total_score", ascending=False)
    return stars

def task2_selection_transform(df: pd.DataFrame) -> pd.DataFrame:
    """Задание 2. Индексация/трансформация/фильтрация.
    1) Сформировать подтаблицу с нужными колонками
    2) Посчитать mean/median/std для math/reading/writing (как часть вывода)
    3) Добавить total_score и z-оценки для каждой оценки
    4) Отфильтровать total_score >= 240 (примерный порог — можно менять)
    5) Вывести первые 7 строк результата
    Возвращает финальный DataFrame (без усечения).
    """
    use_cols = ["gender", "race/ethnicity", "lunch", "test preparation course",
                "math score", "reading score", "writing score"]
    sub = df[use_cols].copy()

    # Статистики
    stats = sub[["math score", "reading score", "writing score"]].agg(["mean", "median", "std"])
    print("Статистики по оценкам:\n", stats, "\n")

    # total и z-scores
    sub["total_score"] = sub["math score"] + sub["reading score"] + sub["writing score"]
    for col in ["math score", "reading score", "writing score"]:
        mu = sub[col].mean()
        sd = sub[col].std(ddof=0)  # население или выборка — по желанию
        sub[col + "_z"] = (sub[col] - mu) / (sd if sd != 0 else 1.0)

    # Фильтр — здесь выставьте порог согласно условию вашей версии ТЗ
    filtered = sub[sub["total_score"] >= 240].copy()

    # Показать предпросмотр
    print("Первые 7 строк отфильтрованного результата:\n", filtered.head(7), "\n")
    return filtered

def task3_dates_groupby(df: pd.DataFrame) -> pd.DataFrame:
    """Задание 3. Работа с датами и группировкой.
    1) Создать календарь 2021-01-01..2021-12-31
    2) Извлечь год/месяц/день/название месяца/день недели
    3) Приписать случайную 'exam_date' к каждой строке df и признак 'passed' (>=70 total)
    4) Посчитать по месяцам: число экзаменов и долю passed
    5) Отсортировать по месяцу и полу (пример: сортировка итоговых таблиц)
    Возвращает аггрегированную таблицу по месяцам.
    """
    calendar = pd.date_range("2021-01-01", "2021-12-31", freq="D")
    cal = pd.DataFrame({"date": calendar})
    cal["year"] = cal["date"].dt.year
    cal["month"] = cal["date"].dt.month
    cal["day"] = cal["date"].dt.day
    cal["month_name"] = cal["date"].dt.month_name()
    cal["weekday"] = cal["date"].dt.day_name()

    # случайно назначим дату экзамена каждой записи
    rng = np.random.default_rng(42)
    exam_dates = rng.choice(calendar, size=len(df), replace=True)
    df2 = df.copy()
    df2["exam_date"] = pd.to_datetime(exam_dates)
    df2["total_score"] = df2["math score"] + df2["reading score"] + df2["writing score"]
    df2["passed"] = df2["total_score"] >= 210  # порог 70*3 = 210

    # Агрегирование по месяцам
    df2["exam_month"] = df2["exam_date"].dt.to_period("M").dt.to_timestamp()
    by_month = df2.groupby("exam_month").agg(
        exams=("passed", "size"),
        passed_rate=("passed", "mean")
    ).reset_index()

    # Для примера — разбить по полу
    by_month_gender = df2.groupby(["exam_month", "gender"]).agg(
        exams=("passed", "size"),
        passed_rate=("passed", "mean")
    ).reset_index().sort_values(["exam_month", "gender"])
    print("Агрегация по месяцам и полу:\n", by_month_gender.head(12), "\n")

    return by_month

def task4_distributions(df: pd.DataFrame):
    """Задание 4. Распределения и сравнения.
    - Гистограммы/ECDF для оценок
    - boxplot/violinplot по полю 'test preparation course' и/или по полу
    Только код построения (без показа графиков здесь).
    """
    import matplotlib.pyplot as plt
    import seaborn as sns

    scores = ["math score", "reading score", "writing score"]

    # Гистограммы
    for col in scores:
        plt.figure()
        plt.hist(df[col].dropna(), bins=20)
        plt.title(f"Histogram of {col}")

    # ECDF (эмпирическая функция распределения)
    for col in scores:
        x = np.sort(df[col].dropna().values)
        y = np.arange(1, len(x)+1) / len(x)
        plt.figure()
        plt.plot(x, y, marker=".", linestyle="none")
        plt.xlabel(col); plt.ylabel("ECDF")
        plt.title(f"ECDF of {col}")

    # Boxplot по подготовке
    if "test preparation course" in df.columns:
        plt.figure()
        sns.boxplot(x="test preparation course", y="math score", data=df)
        plt.title("Math by test preparation course")

    # Violin по полу
    if "gender" in df.columns:
        plt.figure()
        sns.violinplot(x="gender", y="reading score", data=df, inner="quartile")
        plt.title("Reading by gender")

def task5_correlations(df: pd.DataFrame) -> pd.DataFrame:
    """Задание 5. Связи и корреляции.
    - scatterplots парных связей
    - корреляционная матрица Пирсона
    Возвращает DataFrame корреляций.
    """
    import matplotlib.pyplot as plt
    import seaborn as sns

    num_cols = ["math score", "reading score", "writing score"]
    sub = df[num_cols].copy()

    # Scatter
    plt.figure()
    plt.scatter(sub["math score"], sub["reading score"], alpha=0.6)
    plt.xlabel("math score"); plt.ylabel("reading score"); plt.title("Math vs Reading")

    # Heatmap корреляций
    corr = sub.corr(method="pearson")
    plt.figure()
    sns.heatmap(corr, annot=True, fmt=".2f")
    plt.title("Correlation matrix (Pearson)")

    return corr

if __name__ == "__main__":
    df = load_data()
    print("Loaded rows:", len(df))

    print("\n=== Task 1 ===")
    stars = task1_golden_five(df)
    print("Количество «звездных» учеников:", len(stars))
    print(stars.head(10))

    print("\n=== Task 2 ===")
    filtered = task2_selection_transform(df)

    print("\n=== Task 3 ===")
    monthly = task3_dates_groupby(df)
    print(monthly.head(12))

    print("\n=== Task 4 ===")
    task4_distributions(df)
    print("Построены фигуры (отобразятся при plt.show()).")

    print("\n=== Task 5 ===")
    corr = task5_correlations(df)
    print(corr)
