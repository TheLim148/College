using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IncomesAndExpenses
{
    public class BudgetEntry
    {
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
    }
    public static class BudgetLogic
    {
        public static decimal GetTotal(IEnumerable<BudgetEntry> entries, DateTime from, DateTime to)
        {
            return entries
                .Where(e => e.Date >= from && e.Date <= to)
                .Sum(e => e.Amount);
        }
    }
}
