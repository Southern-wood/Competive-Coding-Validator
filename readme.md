# Competitive Programming Validation

This project provides a simple shell script for measuring the runtime performance
and validating the correctness of C++ programs,
which is useful for competitive programming.

## Dependencies

- `g++` (GNU C++ compiler, version 8 or higher to support C++20)
- `python3` (Python 3)

## Usage

```bash
# flag -t for performance measurement, -v for validation
./validation.sh -t  # to start performance measurement.
./validation.sh -v  # to start validation.

# optional flags
./validation.sh -n [maxTestCase] # to set the maximum number of test cases.
./validation.sh -s [std] # to set the standard file name (cpp file name without extension).
./validation.sh -b [brute] # to set the brute force file name (cpp file name without extension).
./validation.sh -g [generator] # to set the generator file name (python file name without extension).
./validation.sh -h # to show help.
```

To measure the performance of the program, you need to provides your standard solution(C++ surpported only)
and generator(python3 surpported only) to generate test cases.

To validate the correctness of the program, you need to provides an extra brute force solution(C++ surpported only).

You can set the file name of the standard solution, brute force solution, and generator by using the `-s`, `-b`, and `-g` flags, respectively.
otherwise, the script will use the default file names `std`, `brute`, and `generator`.

You can also set the maximum number of test cases by using the `-n` flag, otherwise, the script will use the default value.
For the performance measurement, the default value is 10, and for the validation, the default value is 1000.

## extent to other languages

For now, the script only supports C++ and Python3. If you want to extent to other languages,
you can modify the script by adding the corresponding command to compile and run the code.

This is pretty simple, you can check these lines in the script and modify them according to your needs.
The same goes for the performance measurement aswell.


```bash
  validate(){
    g++ "$std.cpp" -o "$std" -std=c++20 -O2   
    if [ $? -ne 0 ]; then
      echo "Compile $std.cpp failed"
      exit 1
    fi
    g++ "$brute.cpp" -o "$brute" -std=c++20 -O2 

    if [ $? -ne 0 ]; then
      echo "Compile $brute.cpp failed"
      exit 1
    fi

    echo "$std.cpp and $brute.cpp compiled successfully"

    cnt=0
    while [ $cnt -lt $maxTestCase ]; do
      python3 "$generator.py" > input.txt 
      if [ $cnt -eq 0 ]; then
        echo "generator works"
      fi
      beginTime=$(date +%s%N)
      ./"$std" < input.txt > output.txt
      if [ $? -ne 0 ]; then
        echo "$std.cpp Runtime error on test $cnt"
        exit 1
      fi
      endTime=$(date +%s%N)
      SumCost=$((SumCost + (endTime - beginTime)))
      maxTime=$((maxTime > $((endTime - beginTime)) ? maxTime : $((endTime - beginTime))))
      ./"$brute" < input.txt > answer.txt
      if [ $? -ne 0 ]; then
        echo "$brute.cpp Runtime error on test $cnt"
        exit 1
      fi
      diff -w output.txt answer.txt || break
      echo "Test $cnt: AC  cost: $(($((endTime - beginTime)) / 1000000)) ms"
      cnt=$((cnt + 1))
    done
    #...
  }
```
## alias (optional)

If you want to use the script more conveniently, you can add alias to your `.bashrc` or `.zshrc` by run the following command.

```bash 
echo "alias val=\"sh $(pwd)/validation.sh\"" >> ~/.bashrc&&source ~/.bashrc
```

Then you can use the script by running `val` in the terminal.

```bash
val -t -n 100 -s std -b brute -g generator
```
