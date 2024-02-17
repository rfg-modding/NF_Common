using System;

namespace Common.Math
{
	[Ordered, Union, Reflect(.All)]
	public struct Mat3
	{
		public float[9] Array;
		public Vec3[3] Vectors;

        public static Mat3 Identity => .(.(1.0f, 0.0f, 0.0f), .(0.0f, 1.0f, 0.0f), .(0.0f, 0.0f, 1.0f));

        public this(Vec3 rvec, Vec3 uvec, Vec3 fvec)
        {
            Vectors[0] = rvec;
            Vectors[1] = uvec;
            Vectors[2] = fvec;
        }

        public Vec3 RotatePoint(Vec3 pos)
        {
            Vec3 posFinal = pos;
            posFinal.x = (Vectors[0].x * pos.x) + (Vectors[1].x * pos.y) + (Vectors[2].x * pos.z);
            posFinal.y = (Vectors[0].y * pos.x) + (Vectors[1].y * pos.y) + (Vectors[2].y * pos.z);
            posFinal.z = (Vectors[0].z * pos.x) + (Vectors[1].z * pos.y) + (Vectors[2].z * pos.z);
            return posFinal;
        }

        //Based on https://github.com/CedricGuillemet/ImGuizmo/blob/ba662b119d64f9ab700bb2cd7b2781f9044f5565/ImGuizmo.cpp#L554
        public static Mat3 RotationAxis(Vec3 axis, f32 angle)
        {
            Mat3 result = .Identity;
            float length2 = Math.Pow(axis.Length, 2.0f);
            if (length2 < f32.Epsilon)
            {
               return result;
            }

            Vec3 n = axis * (1.f / Math.Sqrt(length2));
            float s = Math.Sin(angle);
            float c = Math.Cos(angle);
            float k = 1.f - c;

            float xx = n.x * n.x * k + c;
            float yy = n.y * n.y * k + c;
            float zz = n.z * n.z * k + c;
            float xy = n.x * n.y * k;
            float yz = n.y * n.z * k;
            float zx = n.z * n.x * k;
            float xs = n.x * s;
            float ys = n.y * s;
            float zs = n.z * s;

            result.Array[0] = xx;
            result.Array[1] = xy + zs;
            result.Array[2] = zx - ys;
            result.Array[3] = xy - zs;
            result.Array[4] = yy;
            result.Array[5] = yz + xs;
            result.Array[6] = zx + ys;
            result.Array[7] = yz - xs;
            result.Array[8] = zz;

            return result;
        }

        public void GetEulerAngles(ref f32 pitch, ref f32 yaw, ref f32 roll)
        {
            roll = Math.Atan2(this.Array[7], this.Array[8]);
            yaw = Math.Atan2(-1.0f * this.Array[6], Math.Sqrt(Math.Pow(this.Array[7], 2.0f) + Math.Pow(this.Array[8], 2.0f)));
            pitch = Math.Atan2(this.Array[3], this.Array[0]);
        }

        public static Mat3 operator*(Mat3 lhs, Mat3 rhs)
        {
            Mat3 result = .Identity;

            result.Array[0] = lhs.Array[0] * rhs.Array[0] + lhs.Array[1] * rhs.Array[3] + lhs.Array[2] * rhs.Array[6];
            result.Array[1] = lhs.Array[0] * rhs.Array[1] + lhs.Array[1] * rhs.Array[4] + lhs.Array[2] * rhs.Array[7];
            result.Array[2] = lhs.Array[0] * rhs.Array[2] + lhs.Array[1] * rhs.Array[5] + lhs.Array[2] * rhs.Array[8];

            result.Array[3] = lhs.Array[3] * rhs.Array[0] + lhs.Array[4] * rhs.Array[3] + lhs.Array[5] * rhs.Array[6];
            result.Array[4] = lhs.Array[3] * rhs.Array[1] + lhs.Array[4] * rhs.Array[4] + lhs.Array[5] * rhs.Array[7];
            result.Array[5] = lhs.Array[3] * rhs.Array[2] + lhs.Array[4] * rhs.Array[5] + lhs.Array[5] * rhs.Array[8];

            result.Array[6] = lhs.Array[6] * rhs.Array[0] + lhs.Array[7] * rhs.Array[3] + lhs.Array[8] * rhs.Array[6];
            result.Array[7] = lhs.Array[6] * rhs.Array[1] + lhs.Array[7] * rhs.Array[4] + lhs.Array[8] * rhs.Array[7];
            result.Array[8] = lhs.Array[6] * rhs.Array[2] + lhs.Array[7] * rhs.Array[5] + lhs.Array[8] * rhs.Array[8];

            return result;
        }
	}
}
