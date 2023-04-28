using System;

namespace Common.Math
{
	[Ordered, Reflect(.All)]
	public struct Vec4
	{
		public f32 x;
		public f32 y;
		public f32 z;
		public f32 w;

		public this()
		{
			this = default;
		}

		public this(f32 x, f32 y, f32 z, f32 w)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}

		public f32 Length => Math.Sqrt(x*x + y*y + z*z + w*w);
		public static Vec4 Zero => .(0.0f, 0.0f, 0.0f, 0.0f);
        public Vec3 xyz => .(x, y, z);

		public f32 Distance(Vec4 b)
		{
			float x = b.x - this.x;
			float y = b.y - this.y;
			float z = b.z - this.z;
			float w = b.w - this.w;
			return Math.Sqrt(x*x + y*y + z*z + w*w);
		}

		public Vec4 Normalized()
		{
			if (Length == 0.0f)
				return Vec4(this.x, this.y, this.z, this.w);
			else
				return this / Length;
		}

		public void Normalize() mut
		{
			if (Length > 0.0f)
				this /= Length;
		}

        public f32 Dot(Vec4 b)
        {
            return (x * b.x) + (y * b.y) + (z * b.z) + (w * b.w);
        }

        [Commutable]
		public static Vec4 operator*(Vec4 a, f32 scalar)
		{
			return .(a.x * scalar, a.y * scalar, a.z * scalar, a.w * scalar);
		}

		public static Vec4 operator/(Vec4 a, f32 scalar)
		{
			return .(a.x / scalar, a.y / scalar, a.z / scalar, a.w / scalar);
		}

        public static Vec4 operator*(Vec4 a, Vec4 b)
        {
        	return .(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w);
        }

		public void operator+=(Vec4 rhs) mut
		{
			x += rhs.x;
			y += rhs.y;
			z += rhs.z;
			w += rhs.w;
		}

		public void operator-=(Vec4 rhs) mut
		{
			x -= rhs.x;
			y -= rhs.y;
			z -= rhs.z;
			w -= rhs.w;
		}

		public void operator*=(Vec4 rhs) mut
		{
			x *= rhs.x;
			y *= rhs.y;
			z *= rhs.z;
			w *= rhs.w;
		}

		public void operator/=(Vec4 rhs) mut
		{
			x /= rhs.x;
			y /= rhs.y;
			z /= rhs.z;
			w /= rhs.w;
		}

		public static Vec4 operator+(Vec4 lhs, Vec4 rhs)
		{
			return .(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z, lhs.w + rhs.w);
		}

		public static Vec4 operator-(Vec4 lhs, Vec4 rhs)
		{
			return .(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z, lhs.w - rhs.w);
		}

		public override void ToString(String strBuffer)
		{
			strBuffer.AppendF("{{{}, {}, {}, {}}}", x, y, z, w);
		}
	}
}
