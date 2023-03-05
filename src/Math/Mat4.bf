using System;

namespace Common.Math
{
    //Nanoforge needed a replacement for XMMatrix from the Microsoft DirectXMath library, so much of the code is based on that.
	//The main diffence is that this code doesn't use any SSE intrinsics directly. They aren't fully implemented in beef at the time of writing
    //Some helper functions can be found in the DirectXMath static class.
    //DirectXMath is MIT licensed. The license can be viewed here: https://github.com/microsoft/DirectXMath/blob/bec07458c994bd7553638e4d499e17cfedd07831/LICENSE
	[Ordered][Union]
	public struct Mat4
	{
		public float[16] Array;
		public Vec4<f32>[4] Vectors;

        public static Mat4 Identity = .();

		//Set to identity matrix by default
		public this()
		{
			this.Array[0] = 1.0f;
			this.Array[1] = 0.0f;
			this.Array[2] = 0.0f;
			this.Array[3] = 0.0f;

			this.Array[4] = 0.0f;
			this.Array[5] = 1.0f;
			this.Array[6] = 0.0f;
			this.Array[7] = 0.0f;

			this.Array[8] = 0.0f;
			this.Array[9] = 0.0f;
			this.Array[10] = 1.0f;
			this.Array[11] = 0.0f;

			this.Array[12] = 0.0f;
			this.Array[13] = 0.0f;
			this.Array[14] = 0.0f;
			this.Array[15] = 1.0f;
		}

        public static Mat4 Transpose(Mat4 input)
        {
            Mat4 result = .Identity;
            result.Vectors[0].x = input.Vectors[0].x;
            result.Vectors[1].x = input.Vectors[0].y;
            result.Vectors[2].x = input.Vectors[0].z;
            result.Vectors[3].x = input.Vectors[0].w;

            result.Vectors[0].y = input.Vectors[1].x;
            result.Vectors[1].y = input.Vectors[1].y;
            result.Vectors[2].y = input.Vectors[1].z;
            result.Vectors[3].y = input.Vectors[1].w;

            result.Vectors[0].z = input.Vectors[2].x;
            result.Vectors[1].z = input.Vectors[2].y;
            result.Vectors[2].z = input.Vectors[2].z;
            result.Vectors[3].z = input.Vectors[2].w;

            result.Vectors[0].w = input.Vectors[3].x;
            result.Vectors[1].w = input.Vectors[3].y;
            result.Vectors[2].w = input.Vectors[3].z;
            result.Vectors[3].w = input.Vectors[3].w;

            return result;
        }

        public static Mat4 Translation(Vec3<f32> offset)
        {
            return Mat4.Translation(offset.x, offset.y, offset.z);
        }

        public static Mat4 Translation(f32 offsetX, f32 offsetY, f32 offsetZ)
        {
            Mat4 result = .Identity;
            result.Vectors[0].x = 1.0f;
            result.Vectors[0].y = 0.0f;
            result.Vectors[0].z = 0.0f;
            result.Vectors[0].w = 0.0f;

            result.Vectors[1].x = 0.0f;
            result.Vectors[1].y = 1.0f;
            result.Vectors[1].z = 0.0f;
            result.Vectors[1].w = 0.0f;

            result.Vectors[2].x = 0.0f;
            result.Vectors[2].y = 0.0f;
            result.Vectors[2].z = 1.0f;
            result.Vectors[2].w = 0.0f;

            result.Vectors[3].x = offsetX;
            result.Vectors[3].y = offsetY;
            result.Vectors[3].z = offsetZ;
            result.Vectors[3].w = 1.0f;

            return result;
        }

        
        public static Mat4 Scale(Vec3<f32> scale)
        {
            return Mat4.Scale(scale.x, scale.y, scale.z);
        }
        
        public static Mat4 Scale(f32 scaleX, f32 scaleY, f32 scaleZ)
        {
            Mat4 result = .Identity;
            result.Vectors[0].x = scaleX;
            result.Vectors[0].y = 0.0f;
            result.Vectors[0].z = 0.0f;
            result.Vectors[0].w = 0.0f;

            result.Vectors[1].x = 0.0f;
            result.Vectors[1].y = scaleY;
            result.Vectors[1].z = 0.0f;
            result.Vectors[1].w = 0.0f;

            result.Vectors[2].x = 0.0f;
            result.Vectors[2].y = 0.0f;
            result.Vectors[2].z = scaleZ;
            result.Vectors[2].w = 0.0f;

            result.Vectors[3].x = 0.0f;
            result.Vectors[3].y = 0.0f;
            result.Vectors[3].z = 0.0f;
            result.Vectors[3].w = 1.0f;

            return result;
        }

        public static Mat4 RotationPitchYawRoll(f32 pitchRadians, f32 yawRadians, f32 rollRadians)
        {
            f32 cosY = Math.Cos(yawRadians);
            f32 sinY = Math.Sin(yawRadians);

            f32 cosP = Math.Cos(pitchRadians);
            f32 sinP = Math.Sin(pitchRadians);

            f32 cosR = Math.Cos(rollRadians);
            f32 sinR = Math.Sin(rollRadians);

            Mat4 mat = .Identity;
            mat.Vectors[0].x = cosY * cosR + sinY * sinP * sinR;
            mat.Vectors[1].x = cosR * sinY - sinR * cosY;
            mat.Vectors[2].x = cosP * sinY;

            mat.Vectors[0].y = cosP * sinR;
            mat.Vectors[1].y = cosR * cosP;
            mat.Vectors[2].y = -sinP;

            mat.Vectors[0].z = sinR * cosY * sinP - sinY * cosR;
            mat.Vectors[1].z = sinY * sinR + cosR * cosY * sinP;
            mat.Vectors[2].z = cosP * cosY;

            return mat;
        }

        public static Mat4 PerspectiveFovLH(f32 fov, f32 aspectRatio, f32 nearPlane, f32 farPlane)
        {
            f32 sinFov = 0.0f;
            f32 cosFov = 0.0f;
            DirectXMath.XMScalarSinCos(&sinFov, &cosFov, 0.5f * fov);

            f32 height = cosFov / sinFov;
            f32 width = height / aspectRatio;
            f32 fRange = farPlane / (farPlane - nearPlane);

            Mat4 m = .Identity;
            m.Vectors[0].x = width;
            m.Vectors[0].y = 0.0f;
            m.Vectors[0].z = 0.0f;
            m.Vectors[0].w = 0.0f;

            m.Vectors[1].x = 0.0f;
            m.Vectors[1].y = height;
            m.Vectors[1].z = 0.0f;
            m.Vectors[1].w = 0.0f;

            m.Vectors[2].x = 0.0f;
            m.Vectors[2].y = 0.0f;
            m.Vectors[2].z = fRange;
            m.Vectors[2].w = 1.0f;

            m.Vectors[3].x = 0.0f;
            m.Vectors[3].y = 0.0f;
            m.Vectors[3].z = -fRange * nearPlane;
            m.Vectors[3].w = 0.0f;

            return m;
        }

        public static Mat4 LookAtLH(Vec3<f32> eyePos, Vec3<f32> focusPos, Vec3<f32> up)
        {
            Vec3<f32> zAxis = (focusPos - eyePos).Normalized();
            Vec3<f32> xAxis = up.Cross(zAxis).Normalized();
            Vec3<f32> yAxis = zAxis.Cross(xAxis);

            Mat4 m = .Identity;
            m.Vectors[0] = .(xAxis.x, yAxis.x, zAxis.x, 0.0f);
            m.Vectors[1] = .(xAxis.y, yAxis.y, zAxis.y, 0.0f);
            m.Vectors[2] = .(xAxis.z, yAxis.z, zAxis.z, 0.0f);
            m.Vectors[3] = .(-1.0f * (xAxis.Dot(eyePos)), -1.0f * (yAxis.Dot(eyePos)), -1.0f * (zAxis.Dot(eyePos)), 1.0f);
            return m;
        }

		public static Mat4 operator*(Mat4 lhs, Mat4 rhs)
		{
            Vec4<f32> row0L = lhs.Vectors[0];
            Vec4<f32> row1L = lhs.Vectors[1];
            Vec4<f32> row2L = lhs.Vectors[2];
            Vec4<f32> row3L = lhs.Vectors[3];

            Vec4<f32> row0R = rhs.Vectors[0];
            Vec4<f32> row1R = rhs.Vectors[1];
            Vec4<f32> row2R = rhs.Vectors[2];
            Vec4<f32> row3R = rhs.Vectors[3];

            Mat4 result;
            result.Vectors[0].x = row0L.x * row0R.x + row0L.y * row1R.x + row0L.z * row2R.x + row0L.w * row3R.x;
            result.Vectors[0].y = row0L.x * row0R.y + row0L.y * row1R.y + row0L.z * row2R.y + row0L.w * row3R.y;
            result.Vectors[0].z = row0L.x * row0R.z + row0L.y * row1R.z + row0L.z * row2R.z + row0L.w * row3R.z;
            result.Vectors[0].w = row0L.x * row0R.w + row0L.y * row1R.w + row0L.z * row2R.w + row0L.w * row3R.w;

            result.Vectors[1].x = row1L.x * row0R.x + row1L.y * row1R.x + row1L.z * row2R.x + row1L.w * row3R.x;
            result.Vectors[1].y = row1L.x * row0R.y + row1L.y * row1R.y + row1L.z * row2R.y + row1L.w * row3R.y;
            result.Vectors[1].z = row1L.x * row0R.z + row1L.y * row1R.z + row1L.z * row2R.z + row1L.w * row3R.z;
            result.Vectors[1].w = row1L.x * row0R.w + row1L.y * row1R.w + row1L.z * row2R.w + row1L.w * row3R.w;

            result.Vectors[2].x = row2L.x * row0R.x + row2L.y * row1R.x + row2L.z * row2R.x + row2L.w * row3R.x;
            result.Vectors[2].y = row2L.x * row0R.y + row2L.y * row1R.y + row2L.z * row2R.y + row2L.w * row3R.y;
            result.Vectors[2].z = row2L.x * row0R.z + row2L.y * row1R.z + row2L.z * row2R.z + row2L.w * row3R.z;
            result.Vectors[2].w = row2L.x * row0R.w + row2L.y * row1R.w + row2L.z * row2R.w + row2L.w * row3R.w;

            result.Vectors[3].x = row3L.x * row0R.x + row3L.y * row1R.x + row3L.z * row2R.x + row3L.w * row3R.x;
            result.Vectors[3].y = row3L.x * row0R.y + row3L.y * row1R.y + row3L.z * row2R.y + row3L.w * row3R.y;
            result.Vectors[3].z = row3L.x * row0R.z + row3L.y * row1R.z + row3L.z * row2R.z + row3L.w * row3R.z;
            result.Vectors[3].w = row3L.x * row0R.w + row3L.y * row1R.w + row3L.z * row2R.w + row3L.w * row3R.w;

            return result;
		}
	}
}
