using System;

namespace Common
{
	typealias u8 = uint8;
	typealias u16 = uint16;
	typealias u32 = uint32;
	typealias u64 = uint64;

	typealias i8 = int8;
	typealias i16 = int16;
	typealias i32 = int32;
	typealias i64 = int64;

	typealias f32 = float;
	typealias f64 = double;
}

static
{
    //Ensure sized types are the expected size. If any of these fail you're either on a weird platform or there are serious problems
    [Comptime]
	static void ValidateCommonTypeSizes()
    {
        Compiler.Assert(sizeof(Common.u8) == 1);
        Compiler.Assert(sizeof(Common.u16) == 2);
        Compiler.Assert(sizeof(Common.u32) == 4);
        Compiler.Assert(sizeof(Common.u64) == 8);

        Compiler.Assert(sizeof(Common.i8) == 1);
        Compiler.Assert(sizeof(Common.i16) == 2);
        Compiler.Assert(sizeof(Common.i32) == 4);
        Compiler.Assert(sizeof(Common.i64) == 8);

        Compiler.Assert(sizeof(Common.f32) == 4);
        Compiler.Assert(sizeof(Common.f64) == 8);
    }
}
