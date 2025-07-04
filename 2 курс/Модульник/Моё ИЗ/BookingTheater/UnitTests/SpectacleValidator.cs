using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnitTests
{
    public class SpectacleValidator
    {
        public static bool IsValid(Spectacle s)
        {
            if (s == null)
            {
                return false;
            }
            if (string.IsNullOrWhiteSpace(s.Title))
            {
                return false;
            }
            if (s.Duration <= 0)
            {
                return false;
            }

            return true;
        }
    }
}
