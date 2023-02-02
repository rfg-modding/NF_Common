using System;

namespace Common.Math
{
	[Ordered][Union]
	public struct Mat3
	{
		public float[9] Array;
		public Vec3<f32>[3] Vectors;

        public static Mat3 Identity => .(.(1.0f, 0.0f, 0.0f), .(0.0f, 1.0f, 0.0f), .(0.0f, 0.0f, 1.0f));

        public this(Vec3<f32> rvec, Vec3<f32> uvec, Vec3<f32> fvec)
        {
            Vectors[0] = rvec;
            Vectors[1] = uvec;
            Vectors[2] = fvec;
        }
	}
}
