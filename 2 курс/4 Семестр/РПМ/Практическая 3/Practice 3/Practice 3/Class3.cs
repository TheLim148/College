using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_3
{
    public class MyClass3
    {
        private int[] nums;
        public string content
        {
            get
            {
                if (nums == null) {
                    return "{}";
                }
                return "{" + string.Join(", ", nums) + "}";
            }
        }
        public int Element
        {
            set
            {
                if (nums == null)
                {
                    nums = new int[] { value };
                }
                else
                {
                    int[] n = new int[nums.Length + 1];
                    for (int i = 0; i < nums.Length; i++)
                    {
                        n[i] = nums[i];
                    }
                    n[n.Length - 1] = value;
                    nums = n;
                }
            }
        }
        public int[] Data
        {
            get => nums;
            set => nums = value;
        }
    }
}
