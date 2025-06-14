using Pr10;

try
{
    BankAccount bank = new(123, "1234", 1100);
    while (true)
    {
        Console.WriteLine("Choose operation: ");
        Console.WriteLine("1 - Withdraw, 2 - Print, 3 - exit");
        int choose = int.Parse(Console.ReadLine());
        
        switch (choose)
        {
            case 1:
                Console.WriteLine("Enter Pin Code: ");
                string pincode = Console.ReadLine();
                Console.WriteLine("Enter the amount you want to withdraw: ");
                int sum = int.Parse(Console.ReadLine());
                bank.Withdraw(pincode, sum);
                break;
            case 2:
                bank.Print();
                break;
            case 3:
                
                break;
            default:
                Console.WriteLine("Wrong operation");
                break;
        }
        if (choose == 3)
        {
            break;
        }
    }
}
catch (WithdrawException ex)
{
    Console.WriteLine(ex.Message);
}
catch (PINCodeException ex)
{
    Console.WriteLine(ex.Message);
}
catch (AccBalanceException ex)
{
    Console.WriteLine(ex.Message);
}
