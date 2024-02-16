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

        public static BoundingBox operator+(BoundingBox bbox, Vec3 delta)
        {
            return .(bbox.Min + delta, bbox.Max + delta);
        }

        public bool IntersectsLine(Ray ray, ref Vec3 hit)
        {
            return IntersectsLine(ray.Start, ray.End, ref hit);
        }

        //Based on: https://stackoverflow.com/a/3235902
        public bool IntersectsLine(Vec3 lineStart, Vec3 lineEnd, ref Vec3 hit)
        {
            if (lineEnd.x < Min.x && lineStart.x < Min.x)
				return false;
            if (lineEnd.x > Max.x && lineStart.x > Max.x)
				return false;
            if (lineEnd.y < Min.y && lineStart.y < Min.y)
				return false;
            if (lineEnd.y > Max.y && lineStart.y > Max.y)
				return false;
            if (lineEnd.z < Min.z && lineStart.z < Min.z)
				return false;
            if (lineEnd.z > Max.z && lineStart.z > Max.z)
				return false;
            if (lineStart.x > Min.x && lineStart.x < Max.x &&
                lineStart.y > Min.y && lineStart.y < Max.y &&
                lineStart.z > Min.z && lineStart.z < Max.z)
            {
                hit = lineStart;
                return true;
            }

            if ((GetIntersection(lineStart.x - Min.x, lineEnd.x - Min.x, lineStart, lineEnd, ref hit) && InBox(hit, Min, Max, 1))
              || (GetIntersection(lineStart.y - Min.y, lineEnd.y - Min.y, lineStart, lineEnd, ref hit) && InBox(hit, Min, Max, 2))
              || (GetIntersection(lineStart.z - Min.z, lineEnd.z - Min.z, lineStart, lineEnd, ref hit) && InBox(hit, Min, Max, 3))
              || (GetIntersection(lineStart.x - Max.x, lineEnd.x - Max.x, lineStart, lineEnd, ref hit) && InBox(hit, Min, Max, 1))
              || (GetIntersection(lineStart.y - Max.y, lineEnd.y - Max.y, lineStart, lineEnd, ref hit) && InBox(hit, Min, Max, 2))
              || (GetIntersection(lineStart.z - Max.z, lineEnd.z - Max.z, lineStart, lineEnd, ref hit) && InBox(hit, Min, Max, 3)))
            {
                return true;
			}

            return false;
        }

        public bool GetIntersection(f32 dst1, f32 dst2, Vec3 p1, Vec3 p2, ref Vec3 hit)
		{
            if ((dst1 * dst2) >= 0.0f)
				return false;
            if (dst1 == dst2)
				return false;

            hit = p1 + (p2 - p1) * (-dst1 / (dst2 - dst1));
            return true;
        }

        public bool InBox(Vec3 hit, Vec3 b1, Vec3 b2, int axis)
        {
            if (axis == 1 && hit.z > b1.z && hit.z < b2.z && hit.y > b1.y && hit.y < b2.y)
				return true;
            if (axis == 2 && hit.z > b1.z && hit.z < b2.z && hit.x > b1.x && hit.x < b2.x)
				return true;
            if (axis == 3 && hit.x > b1.x && hit.x < b2.x && hit.y > b1.y && hit.y < b2.y)
				return true;

            return false;
        }
	}
}