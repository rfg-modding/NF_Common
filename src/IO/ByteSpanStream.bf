using System.IO;
using Common;
using System;

namespace Common.IO
{
    //Non owning version of System.IO.MemoryStream
    public class ByteSpanStream : Stream
    {
        Span<uint8> _data;
    	int _position = 0;

        public this(Span<uint8> span)
        {
            _data = span;
        }

        //Pointer to current memory position
        public u8* CurrentData => &_data[_position];

    	public override int64 Position
    	{
    		get
    		{
    			return _position;
    		}

    		set
    		{
    			_position = (.)value;
    		}
    	}

    	public override int64 Length
    	{
    		get
    		{
    			return _data.Length;
    		}
    	}

    	public override bool CanRead
    	{
    		get
    		{
    			return true;
    		}
    	}

    	public override bool CanWrite
    	{
    		get
    		{
    			return true;
    		}
    	}

        public override Result<int> TryWrite(Span<uint8> data)
        {
            //Not implemented
            return .Err;
        }

    	public override Result<int> TryRead(Span<uint8> data)
    	{
    		let count = data.Length;
    		if (count == 0)
    			return .Ok(0);
    		int readBytes = Math.Min(count, _data.Length - _position);
    		if (readBytes <= 0)
    			return .Ok(readBytes);

    		Internal.MemCpy(data.Ptr, &_data[_position], readBytes);
    		_position += readBytes;
    		return .Ok(readBytes);
    	}

        public new void Skip(int64 count)
        {
            _position = Math.Min(_position + count, _data.Length - 1);
        }

        //Get pointer to struct at current position and skip past that data
        public T* GetAndSkip<T>()
        {
            T* data = (T*)CurrentData;
            Skip(sizeof(T));
            return data;
        }

        //Same as GetAndSkip but for an array of T
        public Span<T> GetAndSkipSpan<T>(int count)
        {
            T* data = (T*)CurrentData;
            Skip(count * sizeof(T));
            return .(data, count);
        }

    	public override Result<void> Close()
    	{
    		return .Ok;
    	}
    }
}