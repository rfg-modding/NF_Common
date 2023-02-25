using System;

static
{
    public static mixin ClearDictionaryAndDeleteValues(var container)
    {
        for (var kv in container)
            delete kv.value;

        container.Clear();
    }

    public static void ZeroMemory<T>(T* value) where T : struct
    {
        System.Internal.MemSet(value, 0, sizeof(T));
    }

    public static mixin ScopedLock(System.Threading.Monitor monitor)
    {
        monitor.Enter();
        defer:: monitor.Exit();
    }

    public static mixin DeleteIfSet(Object target)
    {
        if (target != null)
        {
            delete target;
        }
    }
}