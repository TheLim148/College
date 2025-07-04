using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace UnitTests
{
    public class UnitTest
    {
        [Fact]
        public void IsValid_ReturnsTrue_ForValidSpectacle()
        {
            var s = new Spectacle { Title = "Гамлет", Description = "Трагедия", Duration = 120 };
            Assert.True(SpectacleValidator.IsValid(s));
        }

        [Fact]
        public void IsValid_ReturnsFalse_IfTitleIsEmpty()
        {
            var s = new Spectacle { Title = "", Description = "Описание", Duration = 100 };
            Assert.False(SpectacleValidator.IsValid(s));
        }

        [Fact]
        public void IsValid_ReturnsFalse_IfTitleIsWhitespace()
        {
            var s = new Spectacle { Title = "   ", Description = "Описание", Duration = 90 };
            Assert.False(SpectacleValidator.IsValid(s));
        }

        [Fact]
        public void IsValid_ReturnsFalse_IfDurationIsZero()
        {
            var s = new Spectacle { Title = "Спектакль", Description = "Описание", Duration = 0 };
            Assert.False(SpectacleValidator.IsValid(s));
        }

        [Fact]
        public void IsValid_ReturnsFalse_IfDurationIsNegative()
        {
            var s = new Spectacle { Title = "Опера", Description = "Описание", Duration = -45 };
            Assert.False(SpectacleValidator.IsValid(s));
        }
    }
}
