using System;

namespace Common.Math
{
    //Nanoforge needed a replacement for XMMatrix from the Microsoft DirectXMath library, so much of the code is based on that.
	//The main diffence is that this code doesn't use any SSE intrinsics directly. They aren't fully implemented in beef at the time of writing
    //Some helper functions can be found in the DirectXMath static class.
    //DirectXMath is MIT licensed. The license can be viewed here: https://github.com/microsoft/DirectXMath/blob/bec07458c994bd7553638e4d499e17cfedd07831/LICENSE
	[Ordered, Union, Reflect(.All)]
	public struct Mat4
	{
		public float[16] Array;
		public Vec4[4] Vectors;

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

        public static Mat4 Inverse(Mat4 input)
        {
            f32 determinant = Mat4.Determinant(input);
            Mat4 adjugate = Mat4.Adjugate(input);
            Mat4 inverse = adjugate / determinant;
            return inverse;
        }

        public static f32 Determinant(Mat4 input)
        {
            f32 a11 = input.Array[0];
            f32 a12 = input.Array[1];
            f32 a13 = input.Array[2];
            f32 a14 = input.Array[3];
            f32 a21 = input.Array[4];
            f32 a22 = input.Array[5];
            f32 a23 = input.Array[6];
            f32 a24 = input.Array[7];
            f32 a31 = input.Array[8];
            f32 a32 = input.Array[9];
            f32 a33 = input.Array[10];
            f32 a34 = input.Array[11];
            f32 a41 = input.Array[12];
            f32 a42 = input.Array[13];
            f32 a43 = input.Array[14];
            f32 a44 = input.Array[15];

            f32 d0 = a11 * ((a22 * a33 * a44) + (a23 * a34 * a42) + (a24 * a32 * a43) - (a24 * a33 * a42) - (a23 * a32 * a44) - (a22 * a34 * a43));
            f32 d1 = -a21 * ((a12 * a33 * a44) + (a13 * a34 * a42) + (a14 * a32 * a43) - (a14 * a33 * a42) - (a13 * a32 * a44) - (a12 * a34 * a43));
            f32 d2 = a31 * ((a12 * a23 * a44) + (a13 * a24 * a42) + (a14 * a22 * a43) - (a14 * a23 * a42) - (a13 * a22 * a44) - (a12 * a24 * a43));
            f32 d3 = -a41 * ((a12 * a23 * a34) + (a13 * a24 * a32) + (a14 * a22 * a33) - (a14 * a23 * a32) - (a13 * a22 * a34) - (a12 * a24 * a33));
            return d0 + d1 + d2 + d3;
        }

        public static Mat4 Adjugate(Mat4 input)
        {
            f32 a11 = input.Array[0];
            f32 a12 = input.Array[1];
            f32 a13 = input.Array[2];
            f32 a14 = input.Array[3];
            f32 a21 = input.Array[4];
            f32 a22 = input.Array[5];
            f32 a23 = input.Array[6];
            f32 a24 = input.Array[7];
            f32 a31 = input.Array[8];
            f32 a32 = input.Array[9];
            f32 a33 = input.Array[10];
            f32 a34 = input.Array[11];
            f32 a41 = input.Array[12];
            f32 a42 = input.Array[13];
            f32 a43 = input.Array[14];
            f32 a44 = input.Array[15];

            Mat4 result = .Identity;
            result.Array[0] = (a22 * a33 * a44) + (a23 * a34 * a42) + (a24 * a32 * a43) - (a24 * a33 * a42) - (a23 * a32 * a44) - (a22 * a34 * a43);
            result.Array[1] = -(a12 * a33 * a44) - (a13 * a34 * a42) - (a14 * a32 * a43) + (a14 * a33 * a42) + (a13 * a32 * a44) + (a12 * a34 * a43);
            result.Array[2] = (a12 * a23 * a44) + (a13 * a24 * a42) + (a14 * a22 * a43) - (a14 * a23 * a42) - (a13 * a22 * a44) - (a12 * a24 * a43);
            result.Array[3] = -(a12 * a23 * a34) - (a13 * a24 * a32) - (a14 * a22 * a33) + (a14 * a23 * a32) + (a13 * a22 * a34) + (a12 * a24 * a33);

            result.Array[4] = -(a21 * a33 * a44) - (a23 * a34 * a41) - (a24 * a31 * a43) + (a24 * a33 * a41) + (a23 * a31 * a44) + (a21 * a34 * a43);
            result.Array[5] = (a11 * a33 * a44) + (a13 * a34 * a41) + (a14 * a31 * a43) - (a14 * a33 * a41) - (a13 * a31 * a44) - (a11 * a34 * a43);
            result.Array[6] = -(a11 * a23 * a44) - (a13 * a24 * a41) - (a14 * a21 * a43) + (a14 * a23 * a41) + (a13 * a21 * a44) + (a11 * a24 * a43);
            result.Array[7] = (a11 * a23 * a34) + (a13 * a24 * a31) + (a14 * a21 * a33) - (a14 * a23 * a31) - (a13 * a21 * a34) - (a11 * a24 * a33);

            result.Array[8] = (a21 * a32 * a44) + (a22 * a34 * a41) + (a24 * a31 * a42) - (a24 * a32 * a41) - (a22 * a31 * a44) - (a21 * a34 * a42);
            result.Array[9] = -(a11 * a32 * a44) - (a12 * a34 * a41) - (a14 * a31 * a42) + (a14 * a32 * a41) + (a12 * a31 * a44) + (a11 * a34 * a42);
            result.Array[10] = (a11 * a22 * a44) + (a12 * a24 * a41) + (a14 * a21 * a42) - (a14 * a22 * a41) - (a12 * a21 * a44) - (a11 * a24 * a42);
            result.Array[11] = -(a11 * a22 * a34) - (a12 * a24 * a31) - (a14 * a21 * a32) + (a14 * a22 * a31) + (a12 * a21 * a34) + (a11 * a24 * a32);

            result.Array[12] = -(a21 * a32 * a43) - (a22 * a33 * a41) - (a23 * a31 * a42) + (a23 * a32 * a41) + (a22 * a31 * a43) + (a21 * a33 * a42);
            result.Array[13] = (a11 * a32 * a43) + (a12 * a33 * a41) + (a13 * a31 * a42) - (a13 * a32 * a41) - (a12 * a31 * a43) - (a11 * a33 * a42);
            result.Array[14] = -(a11 * a22 * a43) - (a12 * a23 * a41) - (a13 * a21 * a42) + (a13 * a22 * a41) + (a12 * a21 * a43) + (a11 * a23 * a42);
            result.Array[15] = (a11 * a22 * a33) + (a12 * a23 * a31) + (a13 * a21 * a32) - (a13 * a22 * a31) - (a12 * a21 * a33) - (a11 * a23 * a32);

            return result;
        }

        public static Mat4 Translation(Vec3 offset)
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

        
        public static Mat4 Scale(Vec3 scale)
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

        public static Mat4 LookAtLH(Vec3 eyePos, Vec3 focusPos, Vec3 up)
        {
            Vec3 zAxis = (focusPos - eyePos).Normalized();
            Vec3 xAxis = up.Cross(zAxis).Normalized();
            Vec3 yAxis = zAxis.Cross(xAxis);

            Mat4 m = .Identity;
            m.Vectors[0] = .(xAxis.x, yAxis.x, zAxis.x, 0.0f);
            m.Vectors[1] = .(xAxis.y, yAxis.y, zAxis.y, 0.0f);
            m.Vectors[2] = .(xAxis.z, yAxis.z, zAxis.z, 0.0f);
            m.Vectors[3] = .(-1.0f * (xAxis.Dot(eyePos)), -1.0f * (yAxis.Dot(eyePos)), -1.0f * (zAxis.Dot(eyePos)), 1.0f);
            return m;
        }

		public static Mat4 operator*(Mat4 lhs, Mat4 rhs)
		{
            Vec4 row0L = lhs.Vectors[0];
            Vec4 row1L = lhs.Vectors[1];
            Vec4 row2L = lhs.Vectors[2];
            Vec4 row3L = lhs.Vectors[3];

            Vec4 row0R = rhs.Vectors[0];
            Vec4 row1R = rhs.Vectors[1];
            Vec4 row2R = rhs.Vectors[2];
            Vec4 row3R = rhs.Vectors[3];

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

        public static Mat4 operator/(Mat4 lhs, f32 divisor)
        {
            Mat4 result = lhs;
            result.Array[0] /= divisor;
            result.Array[1] /= divisor;
            result.Array[2] /= divisor;
            result.Array[3] /= divisor;
            result.Array[4] /= divisor;
            result.Array[5] /= divisor;
            result.Array[6] /= divisor;
            result.Array[7] /= divisor;
            result.Array[8] /= divisor;
            result.Array[9] /= divisor;
            result.Array[10] /= divisor;
            result.Array[11] /= divisor;
            result.Array[12] /= divisor;
            result.Array[13] /= divisor;
            result.Array[14] /= divisor;
            result.Array[15] /= divisor;

            return result;
        }
	}
}
