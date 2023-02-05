using Common;
using System;

namespace Common.Math
{
    [CRepr] //Marked with this so it's compatible with bounding boxes embedded in RFG file formats
	public struct BoundingBox
	{
        public Vec3<f32> Min = .Zero;
        public Vec3<f32> Max = .Zero;

        public this(Vec3<f32> min, Vec3<f32> max)
        {
            Min = min;
            Max = max;
        }

        public Vec3<f32> Center()
        {
            Vec3<f32> bboxSize = Max - Min;
            return Min + (bboxSize / 2.0f);
        }
	}
}