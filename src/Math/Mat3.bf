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
	}
}
