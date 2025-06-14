let string = prompt("Enter number");

function FindAmountOfDigitsInNumber(n) {
    var c = 0;
    while(n.length > c) {c++};
    return c;
}

alert("Number of digits: " + FindAmountOfDigitsInNumber(string));

