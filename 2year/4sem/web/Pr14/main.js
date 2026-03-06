class Geometry { //Создаю базовый класс геометрии
    constructor(radius, side1, side2, side3, major_SemiAxis, minor_SemiAxis) { //помещаю в конструктор все нужные переменные, возможно можно было сделать проще, но я не разобрался
        this.radius = radius;
        this.side1 = side1;
        this.side2 = side2;
        this.side3 = side3;
        this.major_SemiAxis = major_SemiAxis;
        this.minor_SemiAxis = minor_SemiAxis;
    }
    get area() { //Описываю геттер, который вызывает метод по вычислению площади фигуры
        return this.CalculateArea();
    }

    CalculateArea() { } //Сам метод
}

class Circle extends Geometry { //Создаю дочерний класс круга
    constructor(radius) { //В конструкторе передаю радиус
        super(radius);
    }

    CalculateArea() { //Переопределяю метод для вычисления площади круга
        return 'Area of a Circle: ' + (Math.pow(this.radius, 2) * Math.PI.toFixed(2)).toFixed(2);
    }

    draw() { //Создаю новый метод для вывода в консоль надписи
        console.log(`Drawing circle`);
    }
}

class Rectangle extends Geometry { //Создаю дочерний класс прямоугольника
    constructor(side1, side2) { //Передаю в конструктор две стороны
        super(side1, side1, side2);
    }

    CalculateArea() { //Переопределяю метод для вычисления площади прямоугольника
        return 'Area of a Rectangle: ' + this.side1 * this.side2;
    }

    draw() { //Создаю новый метод для вывода в консоль надписи
        console.log(`Drawing Rectangle`);
    }
}

class Square extends Rectangle { //Создаю дочерний класс квадрата
    constructor(side1) { //Передаю в конструктор сторону фигуры
        super(side1);
    }

    CalculateArea() { //Переопределяю метод для вычисления его площади
        return 'Area of Square: ' + Math.pow(this.side1, 2);
    }

    draw() { //Создаю новый метод для вывода в консоль надписи
        console.log('Drawing Square');
    }
}

class Triangle extends Geometry { //Создаю дочерний класс треугольника
    constructor(side1, side2, side3) { //Передаю в конструктор три стороны
        super(side1, side1, side2, side3);
    }

    CalculateArea() { //Переопределяю метод для вычисления площади треугольника
        if((this.side1 + this.side2) <= this.side3) { //Условие проверки существования треугольника
            console.log('Triangle does not exist');
        }
        else if((this.side1 + this.side3) <= this.side2) {
            console.log('Triangle does not exist');
        }
        else if((this.side2 + this.side3) <= this.side1) {
            console.log('Triangle does not exist');
        }
        else {
            let p = (this.side1 + this.side2 + this.side3)/2;
            return 'Area of Triangle: ' + (Math.sqrt(p * (p-this.side1) * (p-this.side2) * (p-this.side3))).toFixed(2);
        }
    }

    draw() { //Создаю новый метод для вывода в консоль надписи
        console.log('Drawing Triangle');
    }
}

class Ellipse extends Geometry { //Создаю дочерний класс эллипса
    constructor(major_SemiAxis, minor_SemiAxis) { //Передаю в конструктор большую и малую полуоси
        super(0, 0, 0, 0, major_SemiAxis, minor_SemiAxis)
    }

    CalculateArea() { //Переопределяю функцию для вычисления площади эллипса
        return 'Area of a Ellipse: ' + (Math.PI.toFixed(2) * this.major_SemiAxis * this.minor_SemiAxis).toFixed(2);
    }

    draw() { //Создаю новый метод для вывода в консоль надписи
        console.log('Drawing Ellipse');
    }
}

const circle = new Circle(5); //Создаю объект класса
circle.draw(); //Вызываю метод draw()
console.log(circle.area + '\n'); //Вывожу в консоль площадь фигуры через метод area

const rectangle = new Rectangle(5, 6); //Создаю объект класса
rectangle.draw(); //Вызываю метод draw()
console.log(rectangle.area + '\n'); //Вывожу в консоль площадь фигуры через метод area

const square = new Square(6); //Создаю объект класса
square.draw(); //Вызываю метод draw()
console.log(square.area + '\n'); //Вывожу в консоль площадь фигуры через метод area

const triangle = new Triangle(6, 6, 3); //Создаю объект класса
triangle.draw(); //Вызываю метод draw()
console.log(triangle.area + '\n'); //Вывожу в консоль площадь фигуры через метод area

const ellipse = new Ellipse(6, 3); //Создаю объект класса
ellipse.draw(); //Вызываю метод draw()
console.log(ellipse.area + '\n'); //Вывожу в консоль площадь фигуры через метод area