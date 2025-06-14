using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pr10
{
    public class BankAccount
    {
        public int Number { set; get; }

        public string PINCode { set; get; }

        private decimal _balance { set; get; }
        public decimal Balance 
        {
            get => _balance;
            set
            {
                if (value < 0)
                {
                    throw new AccBalanceException(value);
                }
                _balance = value;
            }
        }
        

        public BankAccount(int num, string PIN, decimal bal)
        {
            Number = num;
            PINCode = PIN;
            Balance = bal;
        }

        public void Print()
        {
            Console.WriteLine("Your  number: " + Number);
            Console.WriteLine("Your PIN Code: " + PINCode);
            Console.WriteLine("Your balance: " + Balance);
        } 

        public void Withdraw(string code, double amount)
        {
            if (code != PINCode)
            {
                throw new PINCodeException();
            }

            if (amount < 0)
            {
                throw new WithdrawException("Sum can't be negative");
            }

            if (amount > (double)Balance)
            {
                throw new WithdrawException(amount);
            }

            Balance -= (decimal)amount;
        }

    }
}
