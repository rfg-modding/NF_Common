using System;

namespace Common.Math
{
    //Based on Microsofts DirectXMath: https://github.com/microsoft/DirectXMath
    //Some code might be in other files like Mat4 being roughly equivalent to XMMatrix
    //I'm gradually converting the code to more standard beef-style code as needed.
    //Some code is hardly changed or missing since my primary focus getting the Nanoforge rewrite up to speed ASAP.
    //DirectXMath is MIT licensed. The license can be viewed here: https://github.com/microsoft/DirectXMath/blob/bec07458c994bd7553638e4d499e17cfedd07831/LICENSE
    public static class DirectXMath
    {
        const f32 XM_PI = 3.141592654f;
        const f32 XM_2PI = 6.283185307f;
        const f32 XM_1DIVPI = 0.318309886f;
        const f32 XM_1DIV2PI = 0.159154943f;
        const f32 XM_PIDIV2 = 1.570796327f;
        const f32 XM_PIDIV4 = 0.785398163f;

        public static void XMScalarSinCos(f32* pSin, f32* pCos, f32 Value)
        {
            Runtime.Assert(pSin != null);
            Runtime.Assert(pCos != null);

            // Map Value to y in [-pi,pi], x = 2*pi*quotient + remainder.
            float quotient = XM_1DIV2PI * Value;
            if (Value >= 0.0f)
            {
                quotient = (f32)((int)(quotient + 0.5f));
            }
            else
            {
                quotient = (f32)((int)(quotient - 0.5f));
            }
            float y = Value - XM_2PI * quotient;

            // Map y to [-pi/2,pi/2] with sin(y) = sin(Value).
            float sign;
            if (y > XM_PIDIV2)
            {
                y = XM_PI - y;
                sign = -1.0f;
            }
            else if (y < -XM_PIDIV2)
            {
                y = -XM_PI - y;
                sign = -1.0f;
            }
            else
            {
                sign = +1.0f;
            }

            float y2 = y * y;

            // 11-degree minimax approximation
            *pSin = (((((-2.3889859e-08f * y2 + 2.7525562e-06f) * y2 - 0.00019840874f) * y2 + 0.0083333310f) * y2 - 0.16666667f) * y2 + 1.0f) * y;

            // 10-degree minimax approximation
            float p = ((((-2.6051615e-07f * y2 + 2.4760495e-05f) * y2 - 0.0013888378f) * y2 + 0.041666638f) * y2 - 0.5f) * y2 + 1.0f;
            *pCos = sign * p;
        }

        public static Vec4 XMVectorSplatX(Vec4 v)
        {
            return .(v.x, v.x, v.x, v.x);
        }

        public static Vec4 XMVectorSplatY(Vec4 v)
        {
            return .(v.y, v.y, v.y, v.y);
        }

        public static Vec4 XMVectorSplatZ(Vec4 v)
        {
            return .(v.z, v.z, v.z, v.z);
        }

        public static Vec4 XMVectorSplatW(Vec4 v)
        {
            return .(v.w, v.w, v.w, v.w);
        }

        public static Vec4 XMVectorSelect(Vec4 v1, Vec4 v2, Vec4 control)
        {
            u32 x, y, z, w;
            x = ((u32)v1.x & ~(u32)control.x) | ((u32)v2.x & (u32)control.x);
            y = ((u32)v1.y & ~(u32)control.y) | ((u32)v2.y & (u32)control.y);
            z = ((u32)v1.z & ~(u32)control.z) | ((u32)v2.z & (u32)control.z);
            w = ((u32)v1.w & ~(u32)control.w) | ((u32)v2.w & (u32)control.w);

            return .Zero;
        }

        public static Vec3 Transform(Vec3 v, Mat4 transform)
        {
            Vec4 result = transform.Vectors[3] + (v.x * transform.Vectors[0]) + (v.y * transform.Vectors[1]) + (v.z * transform.Vectors[2]);
            result /= result.w;
            return result.xyz;
        }

        //Based on XMVector3TransformCoord in DirectXMath
        public static Vec3 Vec3TransformCoord(Vec3 v, Mat4 m)
        {
            Vec4 x = .(v.x, v.x, v.x, v.x);
            Vec4 y = .(v.y, v.y, v.y, v.y);
            Vec4 z = .(v.z, v.z, v.z, v.z);

            Vec4 result = Vec4MultiplyAdd(z, m.Vectors[2], m.Vectors[3]);
            result = Vec4MultiplyAdd(y, m.Vectors[1], result);
            result = Vec4MultiplyAdd(x, m.Vectors[0], result);

            result /= result.w;
            return Vec3(result.x, result.y, result.z);
        }

        //Based on XMVector3TransformNormal in DirectXMath
        public static Vec3 Vec3TransformNormal(Vec3 v, Mat4 m)
        {
            Vec4 x = .(v.x, v.x, v.x, v.x);
            Vec4 y = .(v.y, v.y, v.y, v.y);
            Vec4 z = .(v.z, v.z, v.z, v.z);

            Vec4 result = Vec4Multiply(z, m.Vectors[2]);
            result = Vec4MultiplyAdd(y, m.Vectors[1], result);
            result = Vec4MultiplyAdd(x, m.Vectors[0], result);

            return Vec3(result.x, result.y, result.z);
        }

        //Based on XMVectorMultiply in DirectXMath
        public static Vec4 Vec4Multiply(Vec4 v1, Vec4 v2)
        {
            return .(
                v1.x * v2.x,
                v1.y * v2.y,
                v1.z * v2.z,
                v1.w * v2.w
            );
        }

        //Based on XMVectorMultiplyAdd in DirectXMath
        public static Vec4 Vec4MultiplyAdd(Vec4 v1, Vec4 v2, Vec4 v3)
        {
            return .(
                v1.x * v2.x + v3.x,
                v1.y * v2.y + v3.y,
                v1.z * v2.z + v3.z,
                v1.w * v2.w + v3.w
            );
        }

        //Based on XMVectorDivide in DirectXMath
        public static Vec4 Vec4Divide(Vec4 v1, Vec4 v2)
        {
            return .(
                v1.x / v2.x,
                v1.y / v2.y,
                v1.z / v2.z,
                v1.w / v2.w
            );
        }
    }
}