# Readme.md

This project provides a simple shell script for measuring the  
and validating the correctness of C++ programs,
which is useful for competitive programming.

## Dependencies

- `g++` (GNU C++ compiler, version 8 or higher to support C++20)
- `python3` (Python 3)

## Usage

```bash
# flag -t for performance measurement, -v for validation
./validation.sh -t to start performance measurement.
./validation.sh -v to start validation.

# optional flags
./validation.sh -n [maxTestCase] to set the maximum number of test cases.
./validation.sh -s [std] to set the standard file name (cpp file name without extension).
./validation.sh -b [brute] to set the brute force file name (cpp file name without extension).
./validation.sh -g [generator] to set the generator file name (python file name without extension).
./validation.sh -h to show help.
```

## alias (optional)

If you want to use the script more conveniently, you can add alias to your `.bashrc` or `.zshrc` by run the following command.

```bash 
echo "alias val=\"sh $(pwd)/val.sh\"" >> ~/.bashrc&&source ~/.bashrc
```

Then you can use the script by running `val` in the terminal.

```
val -t -n 100 -s std -b brute -g gen
```

