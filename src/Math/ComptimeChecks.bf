using System;

namespace Common.Math
{
    public static class MathComptimeChecks
    {
        [OnCompile(.TypeInit)]
        public static void ComptimeSizeCheck()
        {
            Runtime.Assert(sizeof(Mat3) == 36);
            Runtime.Assert(sizeof(Mat4) == 64);
            Runtime.Assert(sizeof(Vec2) == 8);
            Runtime.Assert(sizeof(Vec3) == 12);
            Runtime.Assert(sizeof(Vec4) == 16);
            Runtime.Assert(sizeof(BoundingBox) == 24);
            Runtime.Assert(sizeof(Rect) == 16);
        }
    }
}
