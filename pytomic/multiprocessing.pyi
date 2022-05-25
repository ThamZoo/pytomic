class AtomicInt:
    def __init__(self, init_val: int, memoryview: memoryview = None) -> None:
        ...
    
    def load(self) -> int:
        ...
    
    def store(self, val: int) -> None | OverflowError:
        ...

    def preinc(self) -> int | OverflowError:
        ...
    
    def postin(self) -> int | OverflowError:
        ...
    
    def predec(self) -> int | OverflowError:
        ...
    
    def postdec(self) -> int | OverflowError:
        ...
    
    def free(self) -> None:
        ...

class AtomicUInt(AtomicInt):
    ...

class AtomicIntUnsafe(AtomicInt):
    ...

class AtomicUIntUnsafe(AtomicInt):
    ...