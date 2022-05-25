from threading import Thread
import pytest

from pytomic.multithreading import AtomicInt
from pytomic.cpp_limits import C_MAX_INT, C_MIN_INT

def test_atomic_int_load():
    atomic_int = AtomicInt(10)
    assert atomic_int.load() == 10

def test_atomic_int_store():
    atomic_int = AtomicInt(10)
    atomic_int.store(11)
    assert atomic_int.load() == 11

def test_atomic_int_preinc():
    atomic_int = AtomicInt(10)
    val = atomic_int.preinc()
    assert val == 11
    assert atomic_int.load() == 11

def test_atomic_int_postinc():
    atomic_int = AtomicInt(10)
    val = atomic_int.postinc()
    assert val == 10
    assert atomic_int.load() == 11
    
def test_atomic_int_predec():
    atomic_int = AtomicInt(10)
    val = atomic_int.predec()
    assert val == 9
    assert atomic_int.load() == 9

def test_atomic_int_postdec():
    atomic_int = AtomicInt(10)
    val = atomic_int.postdec()
    assert val == 10
    assert atomic_int.load() == 9

def test_atomic_int_out_of_lower_bound_postdec():
    atomic_int = AtomicInt(C_MIN_INT)
    with pytest.raises(OverflowError):
        val = atomic_int.postdec()
    
    assert atomic_int.load() == C_MIN_INT

def test_atomic_int_out_of_lower_bound_predec():
    atomic_int = AtomicInt(C_MIN_INT)
    with pytest.raises(OverflowError):
        val = atomic_int.predec()

    assert atomic_int.load() == C_MIN_INT

def test_atomic_int_out_of_lower_bound_init():
    with pytest.raises(OverflowError):
        AtomicInt(C_MIN_INT - 1)

def test_atomic_int_out_of_lower_bound_store():
    atomic_int = AtomicInt(C_MIN_INT)
    with pytest.raises(OverflowError):
        atomic_int.store(C_MIN_INT - 1)
    
    assert atomic_int.load() == C_MIN_INT

def test_atomic_int_out_of_upper_bound_postinc():
    atomic_int = AtomicInt(C_MAX_INT)
    with pytest.raises(OverflowError):
        val = atomic_int.postinc()
    
    assert atomic_int.load() == C_MAX_INT

def test_atomic_int_out_of_upper_bound_preinc():
    atomic_int = AtomicInt(C_MAX_INT)
    with pytest.raises(OverflowError):
        val = atomic_int.preinc()
    
    assert atomic_int.load() == C_MAX_INT

def test_atomic_int_out_of_upper_bound_init():
    with pytest.raises(OverflowError):
        AtomicInt(C_MAX_INT + 1)

def test_atomic_int_out_of_upper_bound_store():
    atomic_int = AtomicInt(C_MAX_INT)
    with pytest.raises(OverflowError):
        atomic_int.store(C_MAX_INT + 1)
    
    assert atomic_int.load() == C_MAX_INT

def test_atomic_with_multi_threading():
    atomic_int = AtomicInt(0)
    INC_NUM = int(1e6)
    NUM_THREAD = 6

    def inc():
        for i in range(INC_NUM):
            atomic_int.preinc()
    
    threads = []
    for i in range(NUM_THREAD):
        t = Thread(target=inc)
        t.start()
        threads.append(t)
    for t in threads:
        t.join()
    assert atomic_int.load() == INC_NUM * NUM_THREAD