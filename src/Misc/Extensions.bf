using Common;
using System.Collections;

namespace System
{
    extension String
    {
        public void ToLower(String strLower)
		{
            strLower.Set("");
            strLower.Reserve(this.Length);
            for (char8 c in this.RawChars)
                strLower += c.ToLower;
        }	
    }

    extension StringView
    {
        public void ToLower(String strLower)
    	{
            strLower.Set("");
            strLower.Reserve(this.Length);
            for (char8 c in this.RawChars)
                strLower += c.ToLower;
        }

        public static bool Equals(StringView a, StringView b, bool ignoreCase = false)
        {
            return StringView.Compare(a, b, ignoreCase) == 0;
        }
    }

    extension Result<T>
    {
        public T GetValueOrDefault(T customDefault)
        {
        	if (this case .Ok(var val))
        		return val;

        	return customDefault;
        }
    }

    extension Result<T, TErr>
    {
        public T GetValueOrDefault(T customDefault)
        {
        	if (this case .Ok(var val))
        		return val;

        	return customDefault;
        }
    }

    extension Span<T>
    {
        public static Span<T> Empty = .(null, 0);
    }

    extension Array1<T>
    {
        public Span<u8> ToByteSpan()
        {
            return .((u8*)this.Ptr, sizeof(T) * this.Count);
        }
    }

    extension Type
    {
        public bool HasBaseType(Type baseType)
        {
            Type curType = this;
            while (curType != null)
            {
                if (curType.TypeId == baseType.TypeId)
                    return true;

                curType = curType.BaseType;
            }

            return false;
        }
    }

    namespace IO
    {
        extension FileFindEntry
        {
            public void GetExtension(String outExt)
            {
                String fileName = this.GetFileName(.. scope .());
                Path.GetExtension(fileName, outExt);
                return;
            }
        }

        extension Stream
        {
            //Read a list of strings separated by null terminators with limited size
            public void ReadSizedStringList(int64 sizeBytes, List<String> strings)
            {
                if (sizeBytes <= 0)
                    return;

                let startPos = Position;
                while (Position - startPos < sizeBytes)
                {
                    strings.Add(ReadStrC(.. new String()));

                    //Skip extra null terminators that are sometimes present in these lists in RFG formats
                    while (Position - startPos < sizeBytes)
                    {
                        if (Peek<char8>() == '\0')
                            Skip(1);
                        else
                            break;
                    }
                }
            }

            public Result<void> ReadFixedLengthString(u64 size, String output)
            {
            	for (u64 i = 0; i < size; i++)
            	{
            		char8 char;
            		char = Read<char8>();
            		output.Append(char);
            	}
            	return .Ok;
            }

            public void WriteNullBytes(u64 count)
            {
            	for(u64 i = 0; i < count; i++)
            		this.Write<u8>(0);
            }

            //Calculate amount of bytes needed to align current position with argument
            public u64 CalcAlignment(u64 alignmentValue)
            {
            	return CalcAlignment((u64)Position, alignmentValue);
            }

            public static u64 CalcAlignment(u64 position, u64 alignmentValue)
            {
            	u64 remainder = position % alignmentValue;
            	u64 paddingSize = remainder > 0 ? alignmentValue - remainder : 0;
            	return paddingSize;
            }

            //Separate Align implementation that only writes if the file access flags are set to write
            public u64 Align2(u64 alignmentValue)
            {
            	//If it's a file and we have write access use impl that can write null bytes to fulfill alignment. Otherwise don't.
            	if(this.GetType() == typeof(FileStream))
            	{
            		var file = (FileStream)this;
            		if(file.[Friend]mFileAccess & .Read != 0)
            			return AlignRead(alignmentValue);
            		else if(file.[Friend]mFileAccess & .Write != 0)
            			return AlignWrite(alignmentValue);

            		return 0;
            	}

            	return AlignRead(alignmentValue);
            }

            //Align position with target and write null bytes if necessary
            public u64 AlignWrite(u64 alignmentValue)
            {
            	u64 paddingSize = CalcAlignment(alignmentValue);
            	for(u64 i = 0; i < paddingSize; i++)
            		Write<u8>(0);

            	return paddingSize;
            }

            //Align position with target but don't write any null bytes
            public u64 AlignRead(u64 alignmentValue)
            {
            	u64 paddingSize = CalcAlignment(alignmentValue);
            	Seek(Position + (i64)paddingSize, .Absolute);

            	return paddingSize;
            }
        }
    }

    namespace Collections
    {
        extension List<T>
        {
            public void ShallowClone(List<T> newList)
            {
                for (ref T item in ref this)
                {
                    newList.Add(item);
                }
            }
        }
    }
}