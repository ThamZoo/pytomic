# 0.2.0
 - Add `compare_exchange_weak` and `compare_exchange_strong` operation
 - Add `load_relaxed` and `store_relaxed` operation, implement `memory_order_relaxed` in C++
 - Add more complete type hint support `__init__.pyi` and `py.typed` file

# 0.1.0
 - Add basic support for `atomic`:
    - `preinc()`, `postinc()`, `predec()`, `postdec()`, `store()`, `load()`