using System;
namespace Common.Math;

[Ordered, Reflect(.All)]
public struct Ray
{
    public Vec3 Start;
    public Vec3 End;

    public this(Vec3 start, Vec3 end)
    {
        Start = start;
        End = end;
    }
}