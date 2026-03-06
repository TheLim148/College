class Calculator {
    public static int add(int a, int b) {
        return a + b;
    }

    public static int substract(int a, int b) {
        return a - b;
    }

    public static int multiply(int a, int b) {
        return a * b;
    }

    public static boolean isEven(int number) {
        if(number % 2 == 0) {
            return true;
        }
        return false;
    }
}

class BankAccount {
    String accountNumber;
    String ownerName;
    double balance;

    public BankAccount(String accountNumber, String ownerName, double initialBalance) {
        this.accountNumber = accountNumber;
        this.ownerName = ownerName;
        this.balance = initialBalance;
    }
    public void deposit(double amount) {
        balance = balance + amount;
        System.out.println("Deposited: $" + amount + ". New balance $" + balance);
    }
    public void withdraw(double amount) {
        if (balance >= amount) {
            balance = balance - amount;
            System.out.println("Withdrawn: $" + amount + ". New balance: $" + balance);
        } else {
            System.out.println("Not enough money! Current balance: $" + balance);
        }
    }
    public void displayAccount() {
        System.out.println("Account: " + accountNumber + ", Owner: " + ownerName + ", Balance: " + balance);
    }
    public boolean hasEnoughMoney(double amount) {
        return balance >= amount;
    }
}

class TextAnalyzer {
    public static int countWords(String text) {
        if (text.isEmpty()) {
            return 0;
        }
        String[] words = text.split(" ");
        return words.length;
    }

    public static int countVowels(String text) {
        int count = 0;
        String vowels = "aeiouAEIOU";
        for (int i = 0; i < text.length(); i++) {
            char currentChar = text.charAt(i);
            if(vowels.indexOf(currentChar) != -1) {
                count++;
            }
        }
        return count;
    }

    public static String reverseText(String text) {
        String result = "";
        for (int i = text.length() - 1; i >= 0; i--) {
            result = result + text.charAt(i);
        }
        return result;
    }

    public static String findLongestWord(String text) {
        String[] words = text.split(" ");

        String longest = "";
        for (int i = 0; i < words.length; i++) {
            if (words[i].length() > longest.length()) {
                longest = words[i];
            }
        }

        return longest;
    }
}

class Main {
    public static void main(String[] args) {
        // 1.1
        int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8};

        // 1.2
        int sum = 0;
        for (int i = 0; i < numbers.length; i++) {
            sum = Calculator.add(sum, numbers[i]);
        }
        System.out.println("Sum: " + sum);

        // 1.3
        int multiply = 1;
        for (int i = 0; i < 3; i++) {
            multiply = Calculator.multiply(multiply, numbers[i]);
        }
        System.out.println("Multiply of first 3 numbers: " + multiply);

        // 1.4
        int evenNumbersCount = 0;
        for (int i = 0; i < numbers.length; i++) {
            if(Calculator.isEven(numbers[i])) {
                evenNumbersCount++;
            }
        }
        System.out.println("Amount even numbers in array: " + evenNumbersCount);

        System.out.println();

        // 2.1
        BankAccount account1 = new BankAccount("123", "John Wayne", 1000.0);
        BankAccount account2 = new BankAccount("456", "Vano", 1500.0);
        BankAccount account3 = new BankAccount("789", "Light", 2000.0);

        // 2.2
        account1.deposit(200.0);
        account2.deposit(1.0);
        account3.withdraw(1000.0);

        // 2.3
        BankAccount[] accounts = {account1, account2, account3};

        BankAccount maxAccount = accounts[0];
        for (int i = 1; i < accounts.length; i++) {
            if (accounts[i].balance > maxAccount.balance) {
                maxAccount = accounts[i];
            }
        }
        System.out.println("Account with max balance: ");
        maxAccount.displayAccount();

        // 2.4
        account1.withdraw(30000.0);

        System.out.println();

        // 3.1
        String[] texts = {"Hello World", "Java Programming", "OpenAI", "Online Compiler"};

        // 3.2
        for (int i = 0; i < texts.length; i++) {
            String current = texts[i];
            System.out.println("Text: " + current);
            System.out.println("Words: " + TextAnalyzer.countWords(current));
            System.out.println("Vowels: " + TextAnalyzer.countVowels(current));
            System.out.println("Reversed: " + TextAnalyzer.reverseText(current));
            System.out.println("Longest Word: " + TextAnalyzer.findLongestWord(current));
            System.out.println("---");
        }

        // 3.3
        String maxText = texts[0];
        int maxWords = TextAnalyzer.countWords(texts[0]);

        for (int i = 1; i < texts.length; i++) {
            int words = TextAnalyzer.countWords(texts[i]);
            if (words > maxWords) {
                maxWords = words;
                maxText = texts[i];
            }
        }

        System.out.println("String with max amount of words: " + maxText);
        System.out.println("Amount of words: " + maxWords);

        // 3.4
        int totalWords = 0;
        for (int i = 0; i < texts.length; i++) {
            totalWords += TextAnalyzer.countWords(texts[i]);
        }

        System.out.println("Total words: " + totalWords);
    }
}
