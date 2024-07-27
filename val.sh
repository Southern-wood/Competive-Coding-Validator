  #!/bin/bash

  # default value
  std="std"
  brute="brute"
  generator="generator"
  maxTestCase=10
  type=""

  # measure time
  timeMeasure(){
    # compile
    g++ "$std.cpp" -o "$std" -std=c++20 -O2

    if [ $? -ne 0 ]; then
      echo "Compile $std.cpp failed"
      exit 1
    fi

    echo "$std.cpp compiled successfully"
    cnt=0
    SumCost=0
    while [ $cnt -lt $maxTestCase ]; do
      python3 "$generator.py" > input.txt
      if [ $cnt -eq 0 ]; then
        echo "generator works"
      fi
      beginTime=$(date +%s%N)
      "./$std" < input.txt > output.txt
      if [ $? -ne 0 ]; then
        echo "Runtime error on test $cnt"
        exit 1
      fi
      endTime=$(date +%s%N)
      echo "Test $cnt cost $cnt: $(($((endTime - beginTime)) / 1000000)) ms"
      SumCost=$((SumCost + (endTime - beginTime)))
      cnt=$((cnt + 1))
      maxTime=$((maxTime > $((endTime - beginTime)) ? maxTime : $((endTime - beginTime))))
    done

    echo "Total test: $cnt"
    echo "Average cost: $(($((SumCost / cnt)) / 1000000)) ms"
    echo "Maxn cost: $((maxTime / 1000000)) ms"
  }

  # validate
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

    if [ $cnt -eq $maxTestCase ]; then
      echo "All test passed"
      echo "Total test: $cnt"
      echo "Average cost: $(($((SumCost / cnt)) / 1000000)) ms"
      echo "Maxn cost: $((maxTime / 1000000)) ms"
    else
      echo "Test $cnt: WA"
      echo "failed on test $cnt"
    fi
    echo "Total test: $cnt"
  }



  # -n 设置最大测试用例数，对 timeMeasure 的默认值是 10, validate 为 1000
  # -s 设置 std 的文件名，默认为 std
  # -b 设置 brute 的文件名，默认为 brute
  # -g 设置 generator 的文件名，默认为 generator
  # -t 开启 timeMeasure
  # -v 开启 validate
  # -h 显示帮助


  while getopts ":tvn:s:b:g:h" opt; do
    case $opt in
      t)
        echo "start timeMeasure"
        maxTestCase=10
        type="timeMeasure"
        ;;
      v)
        if [ "$type" -eq "timeMeasure" ]; then
          echo "can't specify -t and -v at the same time"
          exit 1
        fi
        echo "start validate"
        maxTestCase=1000
        type="validate"
        ;;
      n)
        echo "set maxTestCase to $OPTARG"
        maxTestCase=$OPTARG
        ;;
      s)
        echo "set std to $OPTARG.cpp"
        std=$OPTARG
        ;;
      b)
        echo "set brute to $OPTARG.cpp"
        brute=$OPTARG
        ;;
      g)
        echo "set generator to $OPTARG.py"
        generator=$OPTARG
        ;;
      h)
        echo "Usage: match.sh [-t] [-v] [-n maxTestCase] [-s std] [-b brute] [-g generator] [-h]"
        echo "Options:"
        echo "  -t start timeMeasure"
        echo "  -v start validate"
        echo "  -n set maxTestCase"
        echo "  -s set std"
        echo "  -b set brute"
        echo "  -g set generator"
        echo "  -h show help"
        exit 0
        ;;
      \?)
        echo "Invalid option: $OPTARG"
        exit 1
        ;;
    esac
  done

  if [ $OPTIND -eq 1 ]; then
    echo "Usage: match.sh [-t] [-v] [-n maxTestCase] [-s std] [-b brute] [-g generator] [-h]"
    echo "Options:"
    echo "  -t start timeMeasure"
    echo "  -v start validate"
    echo "  -n set maxTestCase"
    echo "  -s set std"
    echo "  -b set brute"
    echo "  -g set generator"
    echo "  -h show help"
    exit 1
  fi

  if [ "$type" = "timeMeasure" ]; then
    echo "$type start"
    echo "std: $std.cpp"
    echo "generator: $generator.py"
    echo "maxTestCase: $maxTestCase"
    timeMeasure
  elif [ "$type" = "validate" ]; then
    validate
  else 
    echo "need to specify -t or -v, use -h to show help"
    exit 1
  fi
