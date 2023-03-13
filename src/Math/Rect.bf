using System;
using Common;

namespace Common.Math
{
	//Rectangle
	struct Rect
	{
		public Vec2 Min;
		public Vec2 Max;

		public this(Vec2 min, Vec2 max)
		{
			Min = min;
			Max = max;
		}

		//Returns true if the position is within the rectangle
		public bool IsPositionInRect(Vec2 pos)
		{
			return pos.x > Min.x && pos.x < Max.x && pos.y > Min.y && pos.y < Max.y;
		}

		//Returns true if the two rectangles overlap
		public bool DoRectsOverlap(Vec2 rectPos0, Vec2 rectSize0)
		{
			return rectPos0.x <= Max.x &&
				   rectPos0.y <= Max.y &&
				   Min.x <= rectPos0.x + rectSize0.x &&
				   Min.y <= rectPos0.y + rectSize0.y;
		}
	}
}