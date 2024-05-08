CFLAGS += -std=c++20 $(shell libpng-config --cflags) -fopenmp
LDFLAGS += $(shell libpng-config --ldflags) -fopenmp

test: test.cu
	/usr/gralab/cuda/11.8.0/bin/nvcc test.cu -o test

rot: rot.cpp complex_number.cpp 
	$(CXX) $(CFLAGS) -o $@ $^ $(LDFLAGS)

mandelcuda: mandelbrot.cu color.cpp
	@/usr/gralab/cuda/11.8.0/bin/nvcc $(shell libpng-config --cflags) -o $@ $^ $(shell libpng-config --ldflags)

mandelcuda_i: mandelbrot_i.cu color.cpp
	@/usr/gralab/cuda/11.8.0/bin/nvcc $(shell libpng-config --cflags) -o $@ $^ $(shell libpng-config --ldflags)	

mandelbrot: mandelbrot.cpp complex_number.cpp color.cpp
	$(CXX) $(CFLAGS) -o $@ $^ $(LDFLAGS)

benchmark:
	@g++ benchmark.cpp -o benchmark

clean:
	rm mandelcuda || true
	rm mandelcuda_i || true
	rm ./out/anim-* || true
