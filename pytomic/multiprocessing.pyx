# distutils: language=c++
from libc.stdio cimport printf
from libcpp.limits cimport numeric_limits
from libc.stdint cimport int64_t, uint64_t, INT64_MAX, INT64_MIN, UINT64_MAX

from cython.operator cimport (
    preincrement as preinc,
    predecrement as predec,
    postincrement as postinc,
    postdecrement as postdec,
    dereference as deref
)

from .cpp_atomic cimport atomic

from multiprocessing.managers import SharedMemoryManager

cdef class AtomicInt:
    cdef atomic[int64_t] *val
    cdef public object shm_manager
    cdef public object shm
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > INT64_MAX or init_val < INT64_MIN:
            raise OverflowError()
        self.shm_manager = None

        if not memory_view:
            self.shm_manager = SharedMemoryManager()
            self.shm_manager.start()
            self.shm = self.shm_manager.SharedMemory(size=sizeof(int64_t))
        
        cdef unsigned char[:] mem_view = memory_view or self.shm.buf
        self.val = <atomic[int64_t]*> &mem_view[0]
        deref(self.val).store(init_val)

    cpdef int64_t load(self):
        return deref(self.val).load()
    
    cpdef void store(self, int64_t val):
        deref(self.val).store(val)

    cpdef int64_t preinc(self) except *:
        if self.load() > INT64_MAX - 1:
            raise OverflowError()
        return preinc(deref(self.val))

    cpdef int64_t postinc(self) except *:
        if self.load() > INT64_MAX - 1:
            raise OverflowError()
        return postinc(deref(self.val))
    
    cpdef int64_t predec(self) except *:
        if self.load() < INT64_MIN + 1:
            raise OverflowError()
        return predec(deref(self.val))
    
    cpdef int64_t postdec(self) except *:
        if self.load() < INT64_MIN + 1:
            raise OverflowError()
        return postdec(deref(self.val))

    def __del__(self):
        if self.shm_manager:
            self.shm_manager.shutdown()


cdef class AtomicUInt:
    cdef atomic[uint64_t] *val
    cdef public object shm_manager
    cdef public object shm
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > UINT64_MAX or init_val < 0:
            raise OverflowError()
        self.shm_manager = None

        if not memory_view:
            self.shm_manager = SharedMemoryManager()
            self.shm_manager.start()
            self.shm = self.shm_manager.SharedMemory(size=sizeof(int64_t))
        
        cdef unsigned char[:] mem_view = memory_view or self.shm.buf
        self.val = <atomic[uint64_t]*> &mem_view[0]
        deref(self.val).store(init_val)

    cpdef uint64_t load(self):
        return deref(self.val).load()
    
    cpdef void store(self, uint64_t val):
        deref(self.val).store(val)

    cpdef uint64_t preinc(self) except *:
        if self.load() > UINT64_MAX - 1:
            raise OverflowError()
        return preinc(deref(self.val))

    cpdef uint64_t postinc(self) except *:
        if self.load() > UINT64_MAX - 1:
            raise OverflowError()
        return postinc(deref(self.val))
    
    cpdef uint64_t predec(self) except *:
        if self.load() < 1:
            raise OverflowError()
        return predec(deref(self.val))
    
    cpdef uint64_t postdec(self) except *:
        if self.load() < 1:
            raise OverflowError()
        return postdec(deref(self.val))

    def __del__(self):
        if self.shm_manager:
            self.shm_manager.shutdown()

cdef class AtomicIntUnsafe:
    cdef atomic[int64_t] *val
    cdef public object shm_manager
    cdef public object shm
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > INT64_MAX or init_val < INT64_MIN:
            raise OverflowError()
        self.shm_manager = None

        if not memory_view:
            self.shm_manager = SharedMemoryManager()
            self.shm_manager.start()
            self.shm = self.shm_manager.SharedMemory(size=sizeof(int64_t))
        
        cdef unsigned char[:] mem_view = memory_view or self.shm.buf
        self.val = <atomic[int64_t]*> &mem_view[0]
        deref(self.val).store(init_val)

    cpdef int64_t load(self):
        return deref(self.val).load()
    
    cpdef void store(self, int64_t val):
        deref(self.val).store(val)

    cpdef int64_t preinc(self):
        return preinc(deref(self.val))

    cpdef int64_t postinc(self):
        return postinc(deref(self.val))
    
    cpdef int64_t predec(self):
        return predec(deref(self.val))
    
    cpdef int64_t postdec(self):
        return postdec(deref(self.val))

    def __del__(self):
        if self.shm_manager:
            self.shm_manager.shutdown()

cdef class AtomicUIntUnsafe:
    cdef atomic[uint64_t] *val
    cdef public object shm_manager
    cdef public object shm
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > UINT64_MAX or init_val < 0:
            raise OverflowError()
        self.shm_manager = None

        if not memory_view:
            self.shm_manager = SharedMemoryManager()
            self.shm_manager.start()
            self.shm = self.shm_manager.SharedMemory(size=sizeof(int64_t))
        
        cdef unsigned char[:] mem_view = memory_view or self.shm.buf
        self.val = <atomic[uint64_t]*> &mem_view[0]
        deref(self.val).store(init_val)

    cpdef uint64_t load(self):
        return deref(self.val).load()
    
    cpdef void store(self, uint64_t val):
        deref(self.val).store(val)

    cpdef uint64_t preinc(self):
        return preinc(deref(self.val))

    cpdef uint64_t postinc(self):
        return postinc(deref(self.val))
    
    cpdef uint64_t predec(self):
        return predec(deref(self.val))
    
    cpdef uint64_t postdec(self):
        return postdec(deref(self.val))

    def __del__(self):
        if self.shm_manager:
            self.shm_manager.shutdown()