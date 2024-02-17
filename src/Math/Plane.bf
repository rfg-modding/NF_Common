using System;
namespace Common.Math;

[Ordered, Reflect(.All)]
public struct Plane
{
    public Vec3 Position;
    public Vec3 Normal;

    public this(Vec3 position, Vec3 normal)
    {
        Position = position;
        Normal = normal;
    }

    public bool IntersectsLine(Ray line, ref Vec3 hit)
    {
        return IntersectsLine(line.Start, line.End, ref hit);
    }

    //Math based on this: https://lousodrome.net/blog/light/2020/07/03/intersection-of-a-ray-and-a-plane/
    public bool IntersectsLine(Vec3 lineStart, Vec3 lineEnd, ref Vec3 hit)
    {
        Vec3 rayDirection = (lineEnd - lineStart).Normalized();
        Vec3 difference = Position - lineStart;
        f32 product1 = difference.Dot(Normal);
        f32 product2 = rayDirection.Dot(Normal);
        if (Math.Abs(product2) == 0.0f) //Line is parallel with the plane
            return false;

        f32 distanceFromOriginToPlane = product1 / product2;
        hit = lineStart + (distanceFromOriginToPlane * rayDirection);
        return true;
    }
}