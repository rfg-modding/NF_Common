using System;

namespace Common.Misc
{
    //Comptime size check. Used in RfgTools to verify that RFG structs are the expected size. They must be the correct size for many file operations to work, since RfgTools often maps structs to files loaded into memory.
    [AttributeUsage(.Types)]
    public struct RequiredSizeAttribute : Attribute, IOnTypeDone
    {
        public readonly int ExpectedSize;

        public this(int expectedSize)
        {
            ExpectedSize = expectedSize;
        }

        void IOnTypeDone.OnTypeDone(Type type, Self* prev)
        {
            Runtime.Assert(type.Size == ExpectedSize, scope $"Type size validation error! Expected {type.GetName(.. scope .())} to be {ExpectedSize} bytes. It's really {type.Size} bytes.");
        }
    }
}