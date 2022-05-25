class AtomicInt:
    def __init__(self, init_val: int, memoryview: memoryview = None) -> None: ...

    def load(self) -> int: ...

    def load_relaxed(self) -> int: ...
    
    def store(self, val: int) -> None: ...

    def store_relaxed(self, val: int) -> None: ...

    def preinc(self) -> int: ...
    
    def postin(self) -> int: ...
    
    def predec(self) -> int: ...
    
    def postdec(self) -> int: ...

    def compare_exchange_strong(self, expected: int, desired: int) -> bool: ...

    def compare_exchange_weak(self, expected: int, desired: int) -> bool: ...
    
    def free(self) -> None: ...

class AtomicUInt(AtomicInt): ...

class AtomicIntUnsafe(AtomicInt): ...

class AtomicUIntUnsafe(AtomicInt): ...