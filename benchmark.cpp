#include <fstream>
#include <algorithm>
#include <iostream>

double mean(std::vector<float>& numbers) {
  std::sort(numbers.begin(), numbers.end(), [](int a, int b){return a < b;});
  return numbers[numbers.size()/2];
}


double avg(const std::vector<float>& numbers){
  double sum = 0.0;
  for (const auto& num : numbers) {
    sum += num;
  }
  return sum / numbers.size();
}

int main(){
  std::ifstream in_k("kernel_time");
  std::ifstream in_k_i("kernel_time_i");

  std::vector<float> k_t;
  std::vector<float> k_i_t;

  while(in_k && in_k_i){
    float i;
    in_k >> i;
    k_t.push_back(i);
    in_k_i >> i;
    k_i_t.push_back(i);
  }

  std::ofstream bm("benchmark.csv", std::ios::app);

  auto min_k = std::min_element(k_t.begin(), k_t.end());
  auto max_k = std::max_element(k_t.begin(), k_t.end());
  auto min_k_i = std::min_element(k_i_t.begin(), k_i_t.end());
  auto max_k_i = std::max_element(k_i_t.begin(), k_i_t.end());
  
  bm << *min_k << "," << *max_k << "," << mean(k_t) << "," << avg(k_t) << ","
     << *min_k_i << "," << *max_k_i << "," << mean(k_i_t) << "," << avg(k_i_t) << std::endl;

  return 0;
}