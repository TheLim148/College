# 2. Импорт библиотек и проверка версий
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.linear_model import LinearRegression
import sys, sklearn

def print_versions():
    print("Python: " , sys.version.split()[0])
    print("Pandas: " , pd.__version__)
    print("Numpy: "  , np.__version__)
    print("Sklearn: ", sklearn.__version__)

def inspection(df):
    df.info()
    df.describe().T

def group(df):
    groped = df.groupby('species').agg({
        'sepal length (cm)': ['mean','std'],
        'sepal width (cm)':  ['mean','std'],
        'petal length (cm)': ['mean','std'],
        'petal width (cm)':  ['mean','std']
    })
    return groped

def save(grouped):
    grouped.to_csv("1.csv")

def combinations(df):
    df['sepal_area'] = df['sepal length (cm)'] * df['sepal width (cm)']
    df['petal_area'] = df['petal length (cm)'] * df['petal width (cm)']

def sepal_area(df):
    combinations(df)
    df['sepal_area'].hist(bins=15)
    plt.title('Распределение площади чашелистика (sepal_area)')
    plt.xlabel('Площадь, см²')
    plt.ylabel('Частота')
    plt.show()

def another_area(df):
    combinations(df)
    colors = {'setosa':'r','versicolor':'g','virginica':'b'}
    plt.scatter(df['sepal_area'], df['petal_area'],
                c=df['species'].map(colors), alpha=0.6)
    plt.xlabel('Sepal Area')
    plt.ylabel('Petal Area')
    plt.title('Зависимость Petal Area от Sepal Area')
    plt.show()

def linear_regression(df):
    combinations(df)
    X = df[['sepal_area']]
    y = df['petal_area']
    model = LinearRegression().fit(X, y)
    r2 = round(model.score(X, y), 2)
    print("Коэффициент детерминации R²:", r2)

    # Визуализация линии регрессии
    plt.scatter(X, y, alpha=0.5)
    plt.plot(X, model.predict(X), color='k', linewidth=2)
    plt.xlabel('Sepal Area')
    plt.ylabel('Petal Area')
    plt.title('Регрессия: Petal Area ~ Sepal Area')
    plt.show()

def main():
    # 3. Загрузка датасета Iris и создание DataFrame
    data = load_iris()
    df = pd.DataFrame(data.data, columns=data.feature_names)
    df['species'] = pd.Categorical.from_codes(data.target, data.target_names)

    # 4. Базовая инспекция DataFrame
    # inspection()

    # 5. Группировка и агрегирование
    # grouped = group(df)
    # print(grouped, end="\n\n")

    # 6. Сохранение результатов
    # save(group(df))
    
    # 7. Feature Engineering
    # combinations(df)
    # print(df.head(), end="\n\n")

    # 8. Визуализация данных
    # sepal_area(df)
    # another_area(df)

    # 9. Первая линейная регрессия
    linear_regression(df)


if __name__ == "__main__":
    main()