set -e
python3 setup.py build_ext -i
python3 -m pytest __test__/ -s