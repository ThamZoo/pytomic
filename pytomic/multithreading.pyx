# distutils: language=c++
from cpython.mem cimport PyMem_Malloc, PyMem_Free
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

cdef class AtomicInt:
    cdef atomic[int64_t] *val
    
    def __cinit__(self, init_val):
        if init_val > INT64_MAX or init_val < INT64_MIN:
            raise OverflowError()

        cdef atomic[int64_t] *val = <atomic[int64_t]*> PyMem_Malloc(sizeof(int64_t))
        if not val:
            raise MemoryError()
        
        self.val = val
        # printf("Min: %ld \n", INT64_MIN)
        # printf("Max: %ld \n", INT64_MAX)
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

    cpdef void free(self):
        PyMem_Free(self.val)

    def __dealloc__(self):
        self.free()

cdef class AtomicUInt:
    cdef atomic[uint64_t] *val
    
    def __cinit__(self, init_val):
        if init_val > UINT64_MAX or init_val < 0:
            raise OverflowError()

        cdef atomic[uint64_t] *val = <atomic[uint64_t]*> PyMem_Malloc(sizeof(uint64_t))
        if not val:
            raise MemoryError()
        
        self.val = val
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

    cpdef void free(self):
        PyMem_Free(self.val)

    def __dealloc__(self):
        self.free()


cdef class AtomicIntUnsafe:
    cdef atomic[int64_t] *val
    
    def __cinit__(self, init_val):
        if init_val > INT64_MAX or init_val < INT64_MIN:
            raise OverflowError()

        cdef atomic[int64_t] *val = <atomic[int64_t]*> PyMem_Malloc(sizeof(int64_t))
        if not val:
            raise MemoryError()
        
        self.val = val
        # printf("Min: %ld \n", INT64_MIN)
        # printf("Max: %ld \n", INT64_MAX)
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

    cpdef void free(self):
        PyMem_Free(self.val)

    def __dealloc__(self):
        self.free()

cdef class AtomicUIntUnsafe:
    cdef atomic[uint64_t] *val
    
    def __cinit__(self, init_val):
        if init_val > UINT64_MAX or init_val < 0:
            raise OverflowError()

        cdef atomic[uint64_t] *val = <atomic[uint64_t]*> PyMem_Malloc(sizeof(uint64_t))
        if not val:
            raise MemoryError()
        
        self.val = val
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

    cpdef void free(self):
        PyMem_Free(self.val)

    def __dealloc__(self):
        self.free()