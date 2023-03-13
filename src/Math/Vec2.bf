using System;

namespace Common.Math
{
	[Ordered]
	public struct Vec2
	{
		public f32 x;
		public f32 y;

		public this()
		{
			this = default;
		}

		public this(f32 x, f32 y)
		{
			this.x = x;
			this.y = y;
		}

		public f32 Length => (f32)Math.Sqrt(x*x + y*y);

		public f32 Distance(Vec2 b)
		{
			float x = b.x &- this.x;
			float y = b.y &- this.y;
			return Math.Sqrt(x*x + y*y);
		}

		public Vec2 Normalized()
		{
			if (Length == 0.0f)
				return .(this.x, this.y);
			else
				return this / Length;
		}

		public void Normalize() mut
		{
			if (Length > 0.0f)
				this /= Length;
		}

		public static Vec2 operator*(Vec2 a, f32 scalar)
		{
			return .(a.x * scalar, a.y * scalar);
		}

		public static Vec2 operator/(Vec2 a, f32 scalar)
		{
			return .(a.x / scalar, a.y / scalar);
		}

		public void operator+=(Vec2 rhs) mut
		{
			x += rhs.x;
			y += rhs.y;
		}

		public void operator-=(Vec2 rhs) mut
		{
			x &-= rhs.x;
			y &-= rhs.y;
		}

		public void operator*=(Vec2 rhs) mut
		{
			x *= rhs.x;
			y *= rhs.y;
		}

		public void operator/=(Vec2 rhs) mut
		{
			x /= rhs.x;
			y /= rhs.y;
		}

		public static Vec2 operator+(Vec2 lhs, Vec2 rhs)
		{
			return .(lhs.x + rhs.x, lhs.y + rhs.y);
		}

		public static Vec2 operator-(Vec2 lhs, Vec2 rhs)
		{
			return .(lhs.x &- rhs.x, lhs.y &- rhs.y);
		}

		public static Vec2 Zero => .((f32)0, (f32)0);

		public override void ToString(String strBuffer)
		{
			strBuffer.AppendF("{{{}, {}}}", x, y);
		}
	}
}
