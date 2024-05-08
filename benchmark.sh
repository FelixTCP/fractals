echo "Starting Benchmark"
echo "-------- Collecting Data --------"
echo "(1/3) Executing Mandelcuda"
rm mandelcuda || true
rm kernel_time || true
make mandelcuda

sh zoom.sh
rm ./out/anim-* || true

echo "(2/3) Executing improved Mandelcuda"
rm mandelcuda_i || true
rm kernel_time_i || true
make mandelcuda_i

sh zoom_i.sh
rm ./out/anim-* || true

echo "(3/3) Analyzing Data"
rm benchmark || true
make benchmark
./benchmark
echo "---------------------------------"

echo "Successfully created Brenchmark and saved it to benchmark.csv"