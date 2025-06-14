using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pr10
{
    public class PINCodeException : Exception
    {
        public PINCodeException()
            : base($"Entered wrong PIN code") { }
    }

    public class WithdrawException : Exception
    {
        public WithdrawException(string message) : base(message) { }
        public WithdrawException(double amount)
            : base($"There are not enough funds in the account to withdraw the next amount: {amount}") { }
    }

    public class AccBalanceException : Exception
    {
        public AccBalanceException(decimal balance)
            : base($"Unable to create an account - the account balance value specified is incorrect: {balance}") { }
    }
}
