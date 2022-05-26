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

from .cpp_atomic cimport atomic, memory_order_relaxed

from multiprocessing.sharedctypes import RawValue
from ctypes import c_uint64, c_int64, addressof

cdef class AtomicInt:
    cdef atomic[int64_t] *val
    cdef public object raw_val
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > INT64_MAX or init_val < INT64_MIN:
            raise OverflowError()
        
        self.raw_val = RawValue(c_int64, init_val)
        cdef size_t ptr = addressof(self.raw_val)
        self.val = <atomic[int64_t]*> ptr

    cpdef int64_t load(self):
        return deref(self.val).load()

    cpdef int64_t load_relaxed(self):
        return deref(self.val).load(memory_order_relaxed)
    
    cpdef void store(self, int64_t val):
        deref(self.val).store(val)

    cpdef void store_relaxed(self, int64_t val):
        deref(self.val).store(val, memory_order_relaxed)

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

    cpdef bint compare_exchange_strong(self, int64_t expected, int64_t desired):
        return deref(self.val).compare_exchange_strong(expected, desired)

    cpdef bint compare_exchange_weak(self, int64_t expected, int64_t desired):
        return deref(self.val).compare_exchange_weak(expected, desired)

cdef class AtomicUInt:
    cdef atomic[uint64_t] *val
    cdef public object raw_val
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > UINT64_MAX or init_val < 0:
            raise OverflowError()
        
        self.raw_val = RawValue(c_uint64, init_val)
        cdef size_t ptr = addressof(self.raw_val)
        self.val = <atomic[uint64_t]*> ptr

    cpdef uint64_t load(self):
        return deref(self.val).load()

    cpdef uint64_t load_relaxed(self):
        return deref(self.val).load(memory_order_relaxed)
    
    cpdef void store(self, uint64_t val):
        deref(self.val).store(val)

    cpdef void store_relaxed(self, uint64_t val):
        deref(self.val).store(val, memory_order_relaxed)

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

    cpdef bint compare_exchange_strong(self, uint64_t expected, uint64_t desired):
        return deref(self.val).compare_exchange_strong(expected, desired)

    cpdef bint compare_exchange_weak(self, uint64_t expected, uint64_t desired):
        return deref(self.val).compare_exchange_weak(expected, desired)

cdef class AtomicIntUnsafe:
    cdef atomic[int64_t] *val
    cdef public object raw_val
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > INT64_MAX or init_val < INT64_MIN:
            raise OverflowError()
        
        self.raw_val = RawValue(c_int64, init_val)
        cdef size_t ptr = addressof(self.raw_val)
        self.val = <atomic[int64_t]*> ptr

    cpdef int64_t load(self):
        return deref(self.val).load()

    cpdef int64_t load_relaxed(self):
        return deref(self.val).load(memory_order_relaxed)
    
    cpdef void store(self, int64_t val):
        deref(self.val).store(val)

    cpdef void store_relaxed(self, int64_t val):
        deref(self.val).store(val, memory_order_relaxed)

    cpdef int64_t preinc(self):
        return preinc(deref(self.val))

    cpdef int64_t postinc(self):
        return postinc(deref(self.val))
    
    cpdef int64_t predec(self):
        return predec(deref(self.val))
    
    cpdef int64_t postdec(self):
        return postdec(deref(self.val))

    cpdef bint compare_exchange_strong(self, int64_t expected, int64_t desired):
        return deref(self.val).compare_exchange_strong(expected, desired)

    cpdef bint compare_exchange_weak(self, int64_t expected, int64_t desired):
        return deref(self.val).compare_exchange_weak(expected, desired)

cdef class AtomicUIntUnsafe:
    cdef atomic[uint64_t] *val
    cdef public object raw_val
    
    def __cinit__(self, init_val, memory_view=None):
        if init_val > UINT64_MAX or init_val < 0:
            raise OverflowError()
        
        self.raw_val = RawValue(c_uint64, init_val)
        cdef size_t ptr = addressof(self.raw_val)
        self.val = <atomic[uint64_t]*> ptr

    cpdef uint64_t load(self):
        return deref(self.val).load()

    cpdef uint64_t load_relaxed(self):
        return deref(self.val).load(memory_order_relaxed)
    
    cpdef void store(self, uint64_t val):
        deref(self.val).store(val)

    cpdef void store_relaxed(self, uint64_t val):
        deref(self.val).store(val, memory_order_relaxed)

    cpdef uint64_t preinc(self):
        return preinc(deref(self.val))

    cpdef uint64_t postinc(self):
        return postinc(deref(self.val))
    
    cpdef uint64_t predec(self):
        return predec(deref(self.val))
    
    cpdef uint64_t postdec(self):
        return postdec(deref(self.val))

    cpdef bint compare_exchange_strong(self, uint64_t expected, uint64_t desired):
        return deref(self.val).compare_exchange_strong(expected, desired)

    cpdef bint compare_exchange_weak(self, uint64_t expected, uint64_t desired):
        return deref(self.val).compare_exchange_weak(expected, desired)