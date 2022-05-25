# Pytomic - Atomic solution for python
This library is a thin wrapper for `std::atomic` library in C++
## Why?
Lately we have worked with Python multithreading and multiprocessing a lot. As natural, synchronization is needed when doing some stuffs. However, Python only provides primitive technique like `Lock` to synchronize value, and `Lock`(s) are bad. 

Some may think it is ok to sacrify performance for locks. Howevers, when looking at other languages, such as `C++`, `Java`, we found that we can sacrify performance for synchronization, but do it efficiently with `atomic` operations.

Because of that, by simply binding `atomic` mechanism from C++ to Python using Cython, we can achieve efficient performance trade-off for synchronization. Just look at the [Performance benchmark](#performance-benchmark) for more insight.
# Installation:
## From PyPI:
Currently we only have Linux wheel, for other platform, better install it from source

`python3 -m pip install pytomic`

## From source:
 - Make sure you have `Cython >= 0.29.30`, if you dont, install it: `python3 -m pip install Cython=0.29.30`
 - Clone this repository: `git clone git@github.com:ThamZoo/pytomic.git`
 - Install the library: `cd pytomic && python3 -m pip install .`

# Usage:
## Basic usage:
`pytomic` comes with `multithreading` and `multiprocessing` variant, depends on your use case. `multiprocessing` variant can also be used in `multithreading` environment.

Basically, imported classes `Atomic[Int | UInt | IntUnsafe | UIntUnsafe]` have the same methods as list below:
 - `store(val: int) -> None`: atomically store the value
 - `load() -> int`: atomically read the value
 - `preinc() -> int`: same as `++atomic` in C++
 - `postinc() -> int`: same as `atomic++` in C++
 - `predec() -> int`: same as `--atomic` in C++
 - `postdec() -> int`: same as `atomic++` in C++
 - `store_relaxed(val: int) -> None`: `store` with `memory_order_relaxed`
 - `load_relaxed() -> int`: `load` with `memory_order_relaxed`
 - `compare_exchange_weak(expected: int, desired: int) -> bool`: same as `compare_exchange_weak(T&, T)` in C++
 - `compare_exchange_strong(expected: int, desired: int) -> bool`: same as `compare_exchange_strong(T&, T)` in C++

## Example code:
```python
from multiprocessing import Process
from pytomic.multiprocessing import AtomicUInt
# If you are using multithreading, import this instead
# from pytomic.multithreading import AtomicUInt

NUM_INC = int(1e5)
NUM_PROC = 4

atomic = AtomicUInt(0)
def atomic_inc():
    global atomic
    for i in range(NUM_INC):
        atomic.preinc()

def run(target):
    procs = []
    for i in range(NUM_PROC):
        p = Process(target=target)
        p.start()
        procs.append(p)
    for p in procs:
        p.join()

print("Value before run: ", atomic.load())
run(atomic_inc)
print("Value after run: ", atomic.load())
```

## Unsafe classes
If you are using safe classes `Atomic[Int | UInt]`, you will receive `OverflowError` exception when trying to do out-of-bound operations. This is likely a defensive mechanism to prevent errors that are really hard to debug. However, this comes with the cost of constantly checking if the value is out-of-bound.

If you want more speed, and ensure that the value will not out-of-bound, you can use unsafe classes `Atomic[Int | UInt]Unsafe`, those classes will not raise `OverflowError` except when you call `store()` method with out-of-bound value.

Maxium value constant can be imported from the library: `from pytomic.cpp_limits import C_MAX_INT, C_MIN_INT, C_MAX_UINT`
# Performance benchmark:
**Multithreading:**
```bash
$ python3 __bench__/bench_multithreading.py 
lock_inc solution | num_threads = 4 | inc_count = 100,000 | repeat = 5 | done after 65.2207 | avg ops = 30,665 ops/s
atomic_inc solution | num_threads = 4 | inc_count = 100,000 | repeat = 5 | done after 0.1490 | avg ops = 13,426,450 ops/s
atomic_unsafe_inc solution | num_threads = 4 | inc_count = 100,000 | repeat = 5 | done after 0.1367 | avg ops = 14,632,044 ops/s
```

**Multiprocessing:**
```bash
$ python3 __bench__/bench_multiprocessing.py 
lock_inc solution | num_procs = 4 | inc_count = 100,000 | repeat = 5 | done after 21.8647 | avg ops = 91,472 ops/s
atomic_inc solution | num_procs = 4 | inc_count = 100,000 | repeat = 5 | done after 0.1118 | avg ops = 17,893,905 ops/s
atomic_unsafe_inc solution | num_procs = 4 | inc_count = 100,000 | repeat = 5 | done after 0.0896 | avg ops = 22,326,437 ops/s
```

# Limitations and caveats
 - Currently, the library only provides atomicity for `int` type in Python. Support for `float`, `bool`, `char` can be added later.
 - Operations like `wait`, `notify` haven't ported to Python yet.

# Developer guide
## Project structure
For who are curious, please review the code using the folder structure as follow:
 - [pytomic](/pytomic/): Contains Cython binding for C++ `std::atomic`
 - [__test__](/__test__/): Test cases
 - [__bench__](/__bench__/): Benchmark code
 - [test.sh](test.sh) and [clean_ext.sh](clean_ext.sh): Utilities scripts to build extension inplace and test; clear extension builds

## Testing
We use `pipenv` to create virtual environment. Pull this repo and `python3 -m pipenv install --dev` to install all dependencies.

To test it: `./test.sh` or `python3 -m pytest __test__/`

To build the extension inplace: `python3 setup.py build_ext -i`