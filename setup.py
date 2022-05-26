from setuptools import Extension, setup
from Cython.Build import cythonize

def make_ext(package, *names):
    return [Extension(
        f"{package}.{name}",
        [f"{package}/{name}.pyx"]
        ) for name in names]

extensions = make_ext("pytomic", "__init__", "cpp_limits", "multithreading", "multiprocessing")

setup(
    name='pytomic',
    long_description="A thin wrapper of C++ `std::atomic` library for Python",
    version="0.2.2",
    packages=['pytomic'],
    package_dir={"pytomic": "pytomic"},
    ext_modules = cythonize(
        extensions, 
        language_level="3",
        ),
    package_data={
        "pytomic": ["*.pyi", "py.typed"]
    }
)