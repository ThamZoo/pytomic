from multiprocessing import Process, Value
from ctypes import c_ulonglong
import timeit

from pytomic.multiprocessing import AtomicUInt, AtomicUIntUnsafe

NUM_INC = int(1e5)
NUM_PROC = 4
REPEAT = 5

# Lock-based solution
counter = Value(c_ulonglong, 0, lock=True)
def lock_inc():
    global counter
    for i in range(NUM_INC):
        with counter.get_lock():
            counter.value += 1

# Atomic solution
atomic = AtomicUInt(0)
def atomic_inc():
    global atomic
    for i in range(NUM_INC):
        atomic.preinc()

# Unsafe atomic solution
atomic_unsafe = AtomicUIntUnsafe(0)
def atomic_unsafe_inc():
    global atomic_unsafe
    for i in range(NUM_INC):
        atomic_unsafe.preinc()


def run(target):
    procs = []
    for i in range(NUM_PROC):
        p = Process(target=target)
        p.start()
        procs.append(p)
    for p in procs:
        p.join()

def bench(fn_target):
    bench_time = timeit.timeit(f"run({fn_target.__name__})", number=REPEAT, globals=globals())
    print(f"{fn_target.__name__} solution | num_procs = {NUM_PROC} | inc_count = {NUM_INC :,} | repeat = {REPEAT} | done after {bench_time :.4f} | avg ops = {NUM_INC*NUM_PROC*REPEAT / bench_time :,.0f} ops/s")

bench(lock_inc)
bench(atomic_inc)
bench(atomic_unsafe_inc)