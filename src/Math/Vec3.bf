using System;

namespace Common.Math
{
	[Ordered]
	public struct Vec3
	{
		public f32 x;
		public f32 y;
		public f32 z;

		public this()
		{
			this = default;
		}

		public this(f32 x, f32 y, f32 z)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public f32 Length => Math.Sqrt(x*x + y*y + z*z);
		public static Vec3 Zero => .(0.0f, 0.0f, 0.0f);

		public f32 Distance(Vec3 b)
		{
			float x = b.x - this.x;
			float y = b.y - this.y;
			float z = b.z - this.z;
			return Math.Sqrt(x*x + y*y + z*z);
		}

		public Vec3 Normalized()
		{
			if (Length == 0.0f)
				return Vec3(this.x, this.y, this.z);
			else
				return this / Length;
		}

		public void Normalize() mut
		{
			if (Length > 0.0f)
				this /= Length;
		}

        public f32 Dot(Vec3 b)
        {
            return (x * b.x) + (y * b.y) + (z * b.z);
        }

		public Vec3 Cross(Vec3 b)
		{
			return .(
					 (y * b.z) - (z * b.y),
					 (z * b.x) - (x * b.z),
					 (x * b.y) - (y * b.x)
					);
		}

        [Commutable]
		public static Vec3 operator*(Vec3 a, f32 scalar)
		{
			return .(a.x * scalar, a.y * scalar, a.z * scalar);
		}
        
		public static Vec3 operator/(Vec3 a, f32 scalar)
		{
			return .(a.x / scalar, a.y / scalar, a.z / scalar);
		}

        public static Vec3 operator*(Vec3 a, Vec3 b)
        {
        	return .(a.x * b.x, a.y * b.y, a.z * b.z);
        }

		public void operator+=(Vec3 rhs) mut
		{
			x += rhs.x;
			y += rhs.y;
			z += rhs.z;
		}

		public void operator-=(Vec3 rhs) mut
		{
			x -= rhs.x;
			y -= rhs.y;
			z -= rhs.z;
		}

		public void operator*=(Vec3 rhs) mut
		{
			x *= rhs.x;
			y *= rhs.y;
			z *= rhs.z;
		}

		public void operator/=(Vec3 rhs) mut
		{
			x /= rhs.x;
			y /= rhs.y;
			z /= rhs.z;
		}

		public static Vec3 operator+(Vec3 lhs, Vec3 rhs)
		{
			return .(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z);
		}

		public static Vec3 operator-(Vec3 lhs, Vec3 rhs)
		{
			return .(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z);
		}

		public override void ToString(String strBuffer)
		{
			strBuffer.AppendF("{{{}, {}, {}}}", x, y, z);
		}
	}
}
