from threading import Thread, Lock
import timeit
from pytomic.multithreading import AtomicUInt, AtomicUIntUnsafe

NUM_INC = int(1e5)
NUM_THREAD = 4
REPEAT = 5

# Lock-based solution
counter = 0
lock = Lock()
def lock_inc():
    global counter, lock
    for i in range(NUM_INC):
        with lock:
            counter += 1

atomic = AtomicUInt(0)
def atomic_inc():
    global atomic
    for i in range(NUM_INC):
        atomic.preinc()

atomic_unsafe = AtomicUIntUnsafe(0)
def atomic_unsafe_inc():
    global atomic_unsafe
    for i in range(NUM_INC):
        atomic_unsafe.preinc()

def run(target):
    threads = []
    for i in range(NUM_THREAD):
        t = Thread(target=target)
        t.start()
        threads.append(t)
    for t in threads:
        t.join()

def bench(fn_target):
    bench_time = timeit.timeit(f"run({fn_target.__name__})", number=REPEAT, globals=globals())
    print(f"{fn_target.__name__} solution | num_threads = {NUM_THREAD} | inc_count = {NUM_INC :,} | repeat = {REPEAT} | done after {bench_time :.4f} | avg ops = {NUM_INC*NUM_THREAD*REPEAT / bench_time :,.0f} ops/s")

bench(lock_inc)
bench(atomic_inc)
bench(atomic_unsafe_inc)