from threading import Thread
import pytest

from pytomic.multithreading import AtomicUInt
from pytomic.cpp_limits import C_MAX_UINT

def test_atomic_uint_load():
    atomic_uint = AtomicUInt(10)
    assert atomic_uint.load() == 10

def test_atomic_uint_store():
    atomic_uint = AtomicUInt(10)
    atomic_uint.store(11)
    assert atomic_uint.load() == 11

def test_atomic_uint_preinc():
    atomic_uint = AtomicUInt(10)
    val = atomic_uint.preinc()
    assert val == 11
    assert atomic_uint.load() == 11

def test_atomic_uint_postinc():
    atomic_uint = AtomicUInt(10)
    val = atomic_uint.postinc()
    assert val == 10
    assert atomic_uint.load() == 11
    
def test_atomic_uint_predec():
    atomic_uint = AtomicUInt(10)
    val = atomic_uint.predec()
    assert val == 9
    assert atomic_uint.load() == 9

def test_atomic_uint_postdec():
    atomic_uint = AtomicUInt(10)
    val = atomic_uint.postdec()
    assert val == 10
    assert atomic_uint.load() == 9

def test_atomic_uint_out_of_lower_bound_postdec():
    atomic_uint = AtomicUInt(0)
    with pytest.raises(OverflowError):
        val = atomic_uint.postdec()
    
    assert atomic_uint.load() == 0

def test_atomic_uint_out_of_lower_bound_predec():
    atomic_uint = AtomicUInt(0)
    with pytest.raises(OverflowError):
        val = atomic_uint.predec()

    assert atomic_uint.load() == 0

def test_atomic_uint_out_of_lower_bound_init():
    with pytest.raises(OverflowError):
        AtomicUInt(0 - 1)

def test_atomic_uint_out_of_lower_bound_store():
    atomic_uint = AtomicUInt(0)
    with pytest.raises(OverflowError):
        atomic_uint.store(0 - 1)
    
    assert atomic_uint.load() == 0

def test_atomic_uint_out_of_upper_bound_postinc():
    atomic_uint = AtomicUInt(C_MAX_UINT)
    with pytest.raises(OverflowError):
        val = atomic_uint.postinc()
    
    assert atomic_uint.load() == C_MAX_UINT

def test_atomic_uint_out_of_upper_bound_preinc():
    atomic_uint = AtomicUInt(C_MAX_UINT)
    with pytest.raises(OverflowError):
        val = atomic_uint.preinc()
    
    assert atomic_uint.load() == C_MAX_UINT

def test_atomic_uint_out_of_upper_bound_init():
    with pytest.raises(OverflowError):
        AtomicUInt(C_MAX_UINT + 1)

def test_atomic_uint_out_of_upper_bound_store():
    atomic_uint = AtomicUInt(C_MAX_UINT)
    with pytest.raises(OverflowError):
        atomic_uint.store(C_MAX_UINT + 1)
    
    assert atomic_uint.load() == C_MAX_UINT

def test_atomic_with_multi_threading():
    atomic_int1 = AtomicUInt(0)
    atomic_int2 = AtomicUInt(0)
    INC_NUM = int(1e6)
    NUM_THREAD = 6

    def inc():
        for i in range(INC_NUM):
            atomic_int1.preinc()
    
    threads = []
    for i in range(NUM_THREAD):
        t = Thread(target=inc)
        t.start()
        threads.append(t)
    for t in threads:
        t.join()
    assert atomic_int1.load() == INC_NUM * NUM_THREAD
    assert atomic_int2.load() == 0