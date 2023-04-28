using Common;
using System;

namespace Common.Math
{
    [CRepr, Reflect(.All)] //Marked with this so it's compatible with bounding boxes embedded in RFG file formats
	public struct BoundingBox
	{
        public Vec3 Min = .Zero;
        public Vec3 Max = .Zero;

        public this(Vec3 min, Vec3 max)
        {
            Min = min;
            Max = max;
        }

        public Vec3 Center()
        {
            Vec3 bboxSize = Max - Min;
            return Min + (bboxSize / 2.0f);
        }
	}
}