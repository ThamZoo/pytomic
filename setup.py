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
    version="0.1.0",
    packages=['pytomic'],
    ext_modules = cythonize(
        extensions, 
        language_level="3", 
        annotate=True, 
        # force=True,
        ),
    zip_safe=False,
)