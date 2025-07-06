using IncomesAndExpenses;
using System;
using System.Collections.Generic;
using Xunit;

namespace BudgetTests
{
    public class BudgetLogicTests
    {
        [Fact]
        public void GetTotal_ReturnsCorrectSum()
        {
            var list = new List<BudgetEntry>
            {
                new BudgetEntry { Date = new DateTime(2025, 6, 1), Amount = 1000 },
                new BudgetEntry { Date = new DateTime(2025, 6, 10), Amount = 2000 },
                new BudgetEntry { Date = new DateTime(2025, 7, 1), Amount = 3000 }
            };

            var sum = BudgetLogic.GetTotal(list, new DateTime(2025, 6, 1), new DateTime(2025, 6, 30));

            Assert.Equal(3000, sum);
        }

        [Fact]
        public void GetTotal_EmptyList_ReturnsZero()
        {
            var emptyList = new List<BudgetEntry>();

            var sum = BudgetLogic.GetTotal(emptyList, new DateTime(2025, 1, 1), new DateTime(2025, 12, 31));

            Assert.Equal(0, sum);
        }

        [Fact]
        public void GetTotal_AllEntriesOutsidePeriod_ReturnsZero()
        {
            var list = new List<BudgetEntry>
    {
        new BudgetEntry { Date = new DateTime(2024, 12, 31), Amount = 1000 },
        new BudgetEntry { Date = new DateTime(2025, 7, 1), Amount = 2000 }
    };

            var sum = BudgetLogic.GetTotal(list, new DateTime(2025, 6, 1), new DateTime(2025, 6, 30));

            Assert.Equal(0, sum);
        }

        [Fact]
        public void GetTotal_EntryExactlyOnBoundary_IsIncluded()
        {
            var list = new List<BudgetEntry>
            {
                new BudgetEntry { Date = new DateTime(2025, 6, 30), Amount = 500 }
            };

            var sum = BudgetLogic.GetTotal(list, new DateTime(2025, 6, 1), new DateTime(2025, 6, 30));

            Assert.Equal(500, sum);
        }

        [Fact]
        public void GetTotal_PartialInPeriod_ReturnsPartialSum()
        {
            var list = new List<BudgetEntry>
            {
                new BudgetEntry { Date = new DateTime(2025, 5, 31), Amount = 1000 },
                new BudgetEntry { Date = new DateTime(2025, 6, 5), Amount = 1500 },
                new BudgetEntry { Date = new DateTime(2025, 7, 1), Amount = 2000 }
            };

            var sum = BudgetLogic.GetTotal(list, new DateTime(2025, 6, 1), new DateTime(2025, 6, 30));

            Assert.Equal(1500, sum);
        }
    }
}
